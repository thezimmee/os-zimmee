# Marketing Sites Knowledge Transfer

-   Initial Set Up of WP (Jeff)
-   Replication Plugin (Jeff)
-   Updating WP (Jeff)
-   Updating environments (Jeff)
-   Any processes in place (Jeff and Brett)
-   Dev Story and Request Boards and Priority (Brett)
-   Other?

## Design Phase

1.  Brett: Creates TP ticket and attaches PSD.
2.  Freelancer: Creates HTML/CSS files from PSD and passes off to India Developers. Also creates "unique tags".
3.  India: Spins up a generic WordPress site with the replication plugin to push to dev. Once they have a client ID they can easily set up dev/stage environments.
    -   Set up WP database. All databases are housed together.
    -   Files such as `.htaccess` and `wp-config.php` has client-specific code/configurations that need to be created for each client. Brijesh has the list and scripts necessary to make an environment specific for each client.
    -   Brijesh is working on a kubernetes solution which would allow us to easily deploy from environment to environment, to scale, and would hopefully negate the need to copy db from environment to environment.
4.  India: Puts HTML/CSS files into WordPress custom theme files.
5.  ??? When do we create live environment ???
    -   SSL Certificate.
    -   Live domain.

CHALLENGES / PROBLEMS that need to be solved:

-   **Deployment**: Jeff said WP has no simple way of publishing from dev -> stage -> live.
    -   **Is this true? It would be worth looking into the multi-environment deployment process.**
    -   Currently DB is copied from environment to environment on each deployment. For each deployment, when the new DB is overwritten, there are references that the DB creates that need to be replaced. For example, dev creates dev URLS, stage creates stage URLs, etc., and on each new deployment the references need to be replaced back to their original values (i.e., from clientsitedev.com to clientsite.com).
-   **WP Visual Editor**: Jeff talked about frustrations with people editing code in the WP Visual Editor. It unnecessarily adds tags (`<p/>`, `<br/>`) that then break the site.

PLUGINS we use:

-   Replication

Questions for the future:

-   "Short Codes": India created short codes so they wouldn't have to inject PHP to get a user name, for example. _Why is injecting PHP a problem? Doesn't WP expect this?_

TODO:

-   WP VISUAL EDITOR BUG:
    -   Login to a page (Vasayo dev) with "text and an image".
    -   Go to edit the page in WP Admin.
    -   Go to "Design" tab of Visual Editor. Then go back to "Text" tab of Visual Editor. The Visual Editor will have inserted a bunch of divs.
    -   Click on save and it will break the page.
