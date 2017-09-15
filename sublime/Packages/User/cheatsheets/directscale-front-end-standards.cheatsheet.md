# DirectScale Front End Standards Cheatsheet

> Outlines front end standards for DirectScale to help bring all teams closer together.

<!-- MarkdownTOC depth=2 -->

1. [CSS](#css)
1. [JavaScript](#javascript)

<!-- /MarkdownTOC -->

<a name="css"></a>
## CSS

- Do not use `id`s in CSS selectors.
- Do not apply inline `<style>` tags.
- Do not apply global styles. Make sure CSS selectors are isolated to the component you are styling.
- Do not duplicate styles. If you are copying and pasting styles, you can probably do it a better way by creating a component.
- Do not add vendor prefixes. All you need is the non-prefixed property. Prefixes are automatically added during the build process.

<a name="javascript"></a>
## JavaScript

- Do not attach data to `$rootScope`. Also, do not share data globally. If you need to share data between controllers and directives, create an Angular service.
- Do not duplicate markup for mobile and desktop screens.
