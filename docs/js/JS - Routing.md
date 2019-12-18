# Routing

## Creating a router

In order to create a router you need to:

1. Configure server to point back to root index.html file, unless using hash based routing. For example, in `.htaccess`:
    ```
    <ifModule mod_rewrite.c>
      Options +FollowSymLinks
      IndexIgnore */*
      RewriteEngine On
      RewriteCond %{REQUEST_FILENAME} !-f
      RewriteCond %{REQUEST_FILENAME} !-d
      RewriteRule (.*) index.html
    </ifModule>
    ```
2. Suppress default link behavior when someone clicks link to another page.
3. Use history pushstate API to update the URL without triggering a page reload.
4. Match the URL against map of routes and serve the correct content.
5. Parse data out if the URL, if the variable has data.
6. Detect browser "back" and "forward" events and update UI accordingly.

According to Chris Ferdinandi:

Many of these things are things can be done with native browser features/APIs. Why, then, do we break native features to re-invent the wheel and put these features into the browser when many of them already exist?

The problem with this is that:

1. You must one page for each route (which may or not be an issue, and may or may not perform better than a true single page app);
2. You must rely on query parameters to pass data to pages, which is ugly.

## Navigo

[Navigo](https://github.com/krasimir/navigo) is a router recommended by Chris Fredinandi if you don't want to use multiple pages and/or query parameters.
