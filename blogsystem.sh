#!/bin/sh

raw='raw/'
articles='art/'
blogname="Wink's Blog"
authorname="Wink'"

[ ! -d "$raw" ] && echo "$raw does not exist, creating folder" && mkdir "$raw"
[ ! -d "$articles" ] && echo "$articles does not exist, creating folder" && mkdir "$articles"
[ -z $EDITOR ] && EDITOR='vim'

# htmlopen - generates the beginning of an html document
htmlopen() {
cat << EOF
<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
	<title>${1}</title>
	<link rel="stylesheet" href="/style.css" />
</head>
<body>
	<header>
		<h1 class="sitename">$blogname</h1>
	</header>
	<main>
EOF
}

# htmlclose - generates the end of an html document
htmlclose() {
cat << EOF
	</main>
</body>
</html>
EOF
}

# arttitle - gets the title of an article
arttitle() {
	src=${1}
	h1=$(grep '<h1>' < $src)
	char=$(echo $h1 | wc -c)
	echo $h1 | colrm $((char - 5)) | colrm 1 4
}

# artdiv - generates html article element
artdiv() {
	src=${1}
	ref=$(basename "$src")
	echo "<article id=\"$ref\">"
	cat $src
	echo "<span class=\"artinfo\">By $authorname on $(stat -c %w $src | colrm 17) - <a href=\"#$ref\">Link</a> - <a href=\"$articles$ref\">Standalone</a></span>"
	echo "</article>"
}

# artpub - publishes an article
artpub() {
	src=${1}
	title=$(arttitle "$src")
	htmlopen "$title - $blogname"
	artdiv $src
	htmlclose
}

# rolling - generates the rolling blog index
rolling() {
	htmlopen "$blogname"

	for art in $(ls -t "$raw")
	do
		if [ -e $articles$art ]
		then
			artdiv "$raw$art"
		fi
	done

	now=$(date "+%b %d, %Y")
	echo "<footer>Generated by <a href=\"https://github.com/yoannlr/blogsystem\">Wink's Blog System</a> on $now</footer>"
	htmlclose
}

# artlist - generates an html page with link to all articles
artlist() {
	htmlopen "All articles - $blogname"
	echo "<ul>"

	for art in $(ls $articles)
	do
		echo "<li><a href=$articles$art>$(arttitle $raw$art)</a></li>"
	done

	echo "</ul>"
}

# newart - creates a new article
newart() {
	title="${@}"
	file=$raw$(echo "$title" | tr -d '[:punct:]' | tr ' ' '_' | tr '[:upper:]' '[:lower:]')'.html'
	echo "<h1>$title</h1>" > $file
	echo "<!-- content here -->" >> $file
	$EDITOR $file
}

# main code
[ ${#} -lt 1 ] && echo "No command specified, exiting" && exit 0
cmd=${1}
shift 1
case $cmd in
	'publish')
		artpub ${1} > "$articles$(basename ${1})" && rolling > index.html && artlist > list.html && echo "Done. Rolling page and list updated." && exit 0
		echo "An error occured."
	;;
	'update')
		rolling > index.html && artlist > list.html && echo "Rolling page and list updated." && exit 0
		echo "An error occured."
	;;
	'new')
		newart ${@}
	;;
	*)
		echo "$cmd is not a valid command."
	;;
esac
