# WordPress Cheatsheet

## Local Developer Environment

For the easiest local dev environment setup, download [Local by Flywheel](https://local.getflywheel.com/).

### Best Development Practices

- Avoid caching CSS and JS during development.

    ```php
    <?php
    // Cached.
    wp_enqueue_script('my-script.js', get_theme_file_uri('/js/my-script.js'), NULL, microtime(), true);
    // Not cached. IMPORTANT: Make sure to cache resources in production.
    wp_enqueue_script('my-script.js', get_theme_file_uri('/js/my-script.js'), NULL, '1.0', true);
    ?>
    ```

## Header and Footer

The _global header_ and _global footer_ is `header.php` and `footer.php`. These are what is used for the global page header and footer. Consume the global header or footer as follows:

```php
<?php
get_header();
// Other content...
get_footer();
?>
```

## The Famous WordPress Loop

```php
<?php
while(have_posts()) {
    the_post(); ?>
    <h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
    <?php the_content(); ?>
    <hr>
<?php } ?>
```

## Pages

A _page template_ is what is provided to a WordPress admin to create new _page posts_.