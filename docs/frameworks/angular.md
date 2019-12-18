# Angular

> All things Angular, including AngularJS and Angular 2+.

## AngularJS vs Angular 2+

- _What are the main differences between AngularJS and Angular 2+?_

	- _AngularJS_:
		- MVC framework.
			- Model = Data.
			- View = Output. UI. What the user sees.
			- Controller = Behavior. Interactions between Model and View.
		- Controllers centric.
		- Services are complex. Constant, value, provider, service, factory?
		- Not mobile friendly.
		- Client side only.
		- Initialized with `ng-app`.
	- _Angular 2+_:
		- Completely rewritten.
		- Newer, more modern. Closer to native ES specs. Designed to be more performant.
		- Embraces Typescript.
		- Components replace controllers. No more `$scope`.
		- Services are simplified with classes.
		- Designed to be mobile friendly.
		- Client and server friendly.
		- Initialized with the bootstrap module function.
		- Comes with CLI tools.

- _What are the differences between data binding and promises?_

	- Data binding: Represents communication between a component and the DOM. There are four types of data binding:
		1. Interpolation (component to DOM): `{{ user.name }}`.
		2. Property binding (component to DOM): `<input [value]="user.name">`.
		3. Event binding (DOM to the component): `<button (click)="cookBacon()"></button>`.
		4. Two way binding (both ways): `<input [(ngModel)]="user.name">`.
	- Promises: Represent a "promise" to asynchronously return data. Promises can be bound to the DOM using the `async` pipe (`{{ user.name | async }}` or `{{ (user | async).name }}`).

- _What are observables in Angular? In general, when and where would you use observables?_

	Observable provides a way to communicate asynchronously in a publish/subscribe pattern. You define a function to publish data. A consumer can subscribe to receive data at the prescribed time or event. In Angular, there are a variety of common operations which use observables:

	1. The `EventEmitter` is used to publish component values with the `@Output()` decorator. It is useful to notify other parts of the app of an event.
	2. The `async` pipe subscribes to an observable or promise and returns the latest value.
	3. `Router.events` provides events as observables.

- _In Angular 2+, where would you use a directive vs a component? What's the difference between directives and components? (attribute directive vs structural directive)?_

	Use a directive to add behavior to an existing DOM element or component instance. Use a component to create a completely new hierarchy of DOM elements with its attached behavior.

	Structural directives start with an asterisk and are responsible for HTML layout. They shape or reshape the DOM's structure.

	Attribute directives change the appearance or behavior of a DOM element.

- <mark>**How does dependency injection work in Angular?**</mark>

	In AngularJS, dependencies can be injected in directive definitions, controllers, services, etc. Module methods are also injectable with dependencies. To prevent minification errors, use Array syntax, with the last item of the Array being the directive/controller/service function. Alternatively you may use the `$inject` property to inject an Array of dependencies.

	In Angular 2+, dependencies can be injected into constructors and/or with providers. You can configure injectors with providers with the `@Injectable`, `@NgModule`, or `@Component` decorators. The `@Injectable` decorator has the `providedIn` metadata option, while `@NgModule` and `@Component` both have the `providers` metadata option.

- How does change management work in Angular?

- <mark>**What's the difference between contentChildren and viewChildren? (viewChild vs. contentChild)**</mark>

	- contentChildren: Returns specified elements or directives from the content DOM as `QueryList`. **Only** includes elements that exist within `ng-content`.
	- viewChildren: Returns specified elements or directives from the view DOM as `QueryList`, which is an object that stores a list of items. **Does not** include elements that exist within `ng-content`.

- _How does view encapsulation work?_
- _Have you done automated testing?  What's the difference between unit tests vs integration tests?_
- _Are you working full-stack?_
- _How does CI/CD work?  What AWS tools are you using?_
- _How long have you been working with Angular?_
- _What's the difference between observables and promises? What’s the benefit of using observables?  How would you link various observables?_
- _Have you used Angular components?_
- <mark>**What's the [lifecycle of an Angular component](https://angular.io/guide/lifecycle-hooks)?**</mark>

	1. `ngOnChanges()`: Called before `ngOnInit()`, and then whenever one or more data-bound input properties change.
	2. `ngOnInit()`: Called once, after the first `ngOnChanges()`. This is different from the constructor in that it is called after Angular first displays data-bound properties and sets the directive/component's input properties.
	3. `ngDoCheck()`: Called during every change detection run, immediately after `ngOnChanges()` and `ngOnInit()`.
	4. `ngAfterContentInit()`: Called once after the first `ngDoCheck()`.
	5. `ngAfterContentChecked()`: Called after the `ngAfterContentInit()` and every subsequent `ngDoCheck()`.
	6. `ngAfterViewInit()`: Called once after the first `ngAfterContentChecked()`.
	7. `ngAfterViewChecked()`: Called after the `ngAfterViewInit()` and every subsequent `ngAfterContentChecked()`.
	8. `ngOnDestroy()`: Called just before Angular destroys the directive/component.

- _How does destroy happen in Angular?  What would you do to speed it up?_
- _Have you used CDK or Angular Material?  Have you done any custom material?_
- _How do you manage application state?  What would be the benefit of keeping it in memory?_
- _Are you familiar with 2-way data binding?_
- <mark>**How does content projection work?**</mark>

	This is a much improved equivalent of transclusion in AngularJS, or the equivalent of `slots` in native JS Web Components. The `ng-content` tag (with the optional `select` attribute) enables the passing of outer content to components.

- _What kind of testing has been written in your apps?_
- _Where do you check your errors?_
- <mark>**What's the difference between unit test vs integration tests?**</mark>

	A unit test checks a smaller unit or piece of code for the desired behavior or result. Unit tests should be narrow in scope, and if successful, should prevent bugs.

	An integration test checks that various parts of a larger system are working properly together. A larger system can be an entire application.

- _What can you tell me about your current role? (i.e. what products have you been building?; what technologies have you been using?)_
- _How much work have you done on the front-end?_
- _How would you measure performance on your Angular app? _
- _How does change detection work in Angular? How does change detection work on a nested object? _
- _Have you run into memory leaks in your Angular apps?  How would you handle them?_
- _What are the design patterns that you use in Angular? _
- _If you have 50+ resources – each with thousands and thousands of records, how do you manage such large data sets in Angular?_
- _How do you manage your bundle size?_
- _How does an ng-template work?_
- _Have you ever used Protractor or Karma to automate your tests?_

<style type="text/css">
	.markdown-body mark {
		font-style: normal;
		font-weight: normal;
	}
</style>