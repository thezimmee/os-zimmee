# DirectScale Front End Standards Cheatsheet

> Outlines front end standards for DirectScale to help bring all teams closer together.

<!-- MarkdownTOC depth=2 -->

1. [CSS](#css)
	1. [CSS Linting](#css-linting)
1. [JavaScript](#javascript)
	1. [JS Linting](#js-linting)
1. [FAQ](#faq)
	1. [Why is it okay to call a function before it is defined?](#why-is-it-okay-to-call-a-function-before-it-is-defined)
	1. [How do you pass data to a page or route?](#how-do-you-pass-data-to-a-page-or-route)

<!-- /MarkdownTOC -->

<a name="css"></a>
## CSS

- Do not use `id`s in CSS selectors.
- Do not apply inline `<style>` tags.
- Do not apply global styles. Make sure CSS selectors are isolated to the component you are styling.
- Do not duplicate styles. If you are copying and pasting styles, you can probably do it a better way by creating a component.
- Do not add vendor prefixes. All you need is the non-prefixed property. Prefixes are automatically added during the build process.

<a name="css-linting"></a>
### CSS Linting

- **Errors**:
	- _Use tabbed indentation_. This allows user to customize indentation size with their editor.
	- _Add `@charset 'utf-8' to top of each stylesheet_. This avoids potential issues with character encoding.
	- _Explain magic numbers_. Add a comment to explain any "[magic number](https://css-tricks.com/magic-numbers-in-css/)".
	- _Prefer HSL or RGB colors to Hex notation_.
	- _One selector per line_.
	- _One rule per line_.
	- _For utility classes (single responsibility / one rule per selector), it is acceptable to write selector and single rule on a single line._
- **Warnings** (warn in development, error in production):
	- _Single quotes for strings._ For example, `url('/my/image.png')`.
	- _Leading zero for decimal values_. For example, `0.5rem`.
	- _Unitless zeros_. For example, `border: 0;`; not `border: 0px;`.
	- _Sort properties according to CSSComb [type ordering](https://github.com/csscomb/csscomb.js/blob/master/config/csscomb.json)_.

#### Preprocessor linting

- **Errors**:
	- _Store all colors, numbers as a variable when used more than once_.
	- _Wrap SASS lists in parenthesis and comma separate items in the list_.
	- _Write SASS maps as you would write JSON_. For example:
		```sass
		$breakpoints: (
			small: 480px,
			medium: 768px,
			large: 990px,
			xlarge: 1200px
		);
		```
	- _Include mixins first in any ruleset_.
		```sass
		.foo {
			@include my-mixin();
			display: block;
		}
		```
	- _Declare variables at top of ruleset (or stylesheet), separated by a line._
		```sass
		.foo {
			$length: 42rem;

			display: block;
		}
		```
	- _Avoid nesting selectors more than 3 levels deep_.
- **Warnings** (warn in development, error in production):

<a name="javascript"></a>
## JavaScript

- Do not attach data to `$rootScope`. Also, do not share data globally. If you need to share data between controllers and directives, create an Angular service.
- Do not duplicate markup for mobile and desktop screens.

<a name="js-linting"></a>
### JS Linting

<a name="faq"></a>
## FAQ

<a name="why-is-it-okay-to-call-a-function-before-it-is-defined"></a>
### Why is it okay to call a function before it is defined?

In other words, why does this example work?

```js
// Call function before it is defined.
myFunction();

// Function definition after it is called.
function myFunction() {
	// function goes here.
}
```

A. JavaScript has a feature called _"hoisting"_, which means JavaScript's interpreter moves variable and function declarations to the top of the current scope. _Only declarations are moved to the top, not assignments._ What this means is it is okay to call a function before it is defined, as long as it is defined in the current scope.

In practice, it is often preferable to make _function calls_ at the top of a scope, and place _function definitions_ at the bottom. This helps other developers more easily understand what is going. However, it is considered a best practice to define _variables_ at the top of the scope.

Example of best practice:

```js
// It is good practice to place definitions at top of a scope.
var myVar = true;
var another = 'string';

// As well as to place function calls at top of its scope.
myFunction();

// Whereas function definitions go below their calls.
function myFunction() {...}
```

<a name="how-do-you-pass-data-to-a-page-or-route"></a>
### How do you pass data to a page or route?

A. It is a common need to pass data to a page or view controller as soon as it loads. There are many ways to do this, such as with an Angular service. However, for simple use cases, using features already baked into Angular `ui-router` will suffice. Here is an example which shows a few different ways to pass data to a route / page / view controller:

JS:

```js
angular.module('myModule', []).config([
	'$stateProvider', function ($stateProvider) {
		$stateProvider.state('MyPage',
		{
			url: '/MyPage/:tab',
			views: {
				"main": {
					controller: 'myCtrl',
					templateUrl: 'MyPage.tpl.html'
				}
			},
			// The `resolve` property can provide a controller with custom data.
			resolve: {
				myResolvedData: function () {
					// This can be a promise. If a promise is returned, they will be resolved **before** the controller is instantiated.
					return {myObj: true};
				}
			},
			// The `params` parameter sets default parameters which are passed to $stateParams. URL parameters (such as :tab in this case) do not need to be set here.
			params: {
				myData: null,
				moreData: null
			},
			// The `data` property is best for passing static data.
			data: {
				staticData: 'myStaticData'
			}
		});
	}
]).controller('myCtrl', function ($state, $stateParams, myResolvedData) {
	// Use data from `resolve` by passing it to the controller.
	console.log(myResolvedData); // This should equal {myObj: true}.
	// Use `$state.current.data` to access data in `data`.
	console.log($state.current.data); // This will equal {staticData: 'myStaticData'}.
	// Use `$stateParams` to access data in `params`.
	console.log($stateParams); // This will equal {myData: null, moreData: null} OR whatever params you pass to this state using `$state.go` or the `ui-sref` directive.
});
```

HTML:

```html
<!-- This will attach {tab: 'myTab', myData: 'myData', moreData: 'one'} to $stateParams in the controller above. -->
<a ui-sref="MyPage({tab: 'myTab', myData: 'myData', moreData: 'one'})">My Link</a>
```

_For more details, see [this StackOverflow question/answer](https://stackoverflow.com/questions/25647454/how-to-pass-parameters-using-ui-sref-in-ui-router-to-controller#answer-25647714)._
