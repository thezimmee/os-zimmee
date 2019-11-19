# Web Typography

## Rhythm in Typography

-   [Rhythm in Typography](https://betterwebtype.com/rhythm-in-web-typography)
-   [Responsive vertical rhythm](https://zellwk.com/blog/responsive-vertical-rhythm/?ck_subscriber_id=132572845)
-   [Rhythm with CSS Grid](https://rsms.me/fun/css-grid/)

## Responsive Typography

1. Use relative units (i.e., em, rem, %, vw, or vh). _Notes:_

    - Percentage (`%`) units in `font-size` are relative to the browser's base font size.
    - Em (`em`) units are relative to the current font size.
    - Rem (`rem`) units are relative to the root element's (`html`) `font-size` value.
    - Viewport units (`vh` and `vw`) are relative to the viewport.

2. Various approaches[^1]:

    1. Traditional media queries.
    2. Fluid typography: `font-size: calc(1.3rem + 3.6vw);`.
    3. Fluid typography with "locks": `font-size: calc( min font-size + ((current vw - minimum vw) / (max vw - min vw)) * (max font-size - min font-size) );`

[^1]: See [elements of responsive typography](https://blog.logrocket.com/the-elements-of-responsive-typography).
