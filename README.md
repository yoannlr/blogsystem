# bs - Blog (System|Script)

There are plenty of solutions to maintain a blog, here is one more (at least, the beginning)!
This one is based on simple mechanics (UNIX shell streams) and aims to be pretty lightweight.

## How to use

### Files and directories

* `/raw` - this is where you write your raw HTML articles using the 'new' command.
* `/art` - where the standalone article pages will be stored after they have been generated with the 'publish' command.
* `/index.html` - the rolling blog index (with the articles sorted by most recent and full articles content).
* `/list.html` - the list of all the articles (without their content, and sorted alphabetically).
* `/style.css` - this is an example CSS file.

You probably figured it out, but articles have two possible states: raw and published.
An article is 'raw' when you just wrote it but it hasn't yet been published.

### Commands

Commands are always the first argument you give to the script (ie. you call `./blogsystem.sh <command> [command arguments]`).

Available commands are:

* `new <Title of the article>` - creates a new article and open it in your editor (`$EDITOR`, or vim if `$EDITOR` is empty).
* `publish raw/<name_of_a_raw_article>` - publishes an article (ie. creates a full html document in `/art`) and updates the rolling index and list file.
   After you published an article, you can remove the raw file, but I would recommend to keep it if you later choose to make changes in the default html document structure.
* `update` - updates the rolling blog index and list file.

## Can I use it?

Sure.
However, I would not recommend using it for now, as it's still in early development and must contain a lot of bugs.

You can do whatever you want with this code, no need to ask or to credit.
