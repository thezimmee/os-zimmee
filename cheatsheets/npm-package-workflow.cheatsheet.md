# Workflow for publishing NPM packages

> Cheatsheet for workflow steps for building and publishing NPM packages.

<!-- MarkdownTOC depth=2 -->

1. [Build and create a package](#build-and-create-a-package)
	1. [Create a package](#create-a-package)
	1. [Create a scoped package](#create-a-scoped-package)
	1. [Saving a scope locally](#saving-a-scope-locally)
	1. [Build a package](#build-a-package)
	1. [Test packages locally](#test-packages-locally)
1. [Prep your NPM package to publish](#prep-your-npm-package-to-publish)
	1. [Check if your NPM credentials are stored locally](#check-if-your-npm-credentials-are-stored-locally)
	1. [Set up NPM locally](#set-up-npm-locally)
	1. [Create an NPM user](#create-an-npm-user)
	1. [Log in as a current NPM user](#log-in-as-a-current-npm-user)
	1. [Exclude / ignore files](#exclude--ignore-files)
1. [Publish a package](#publish-a-package)
	1. [NPM publish](#npm-publish)
	1. [Publish a scoped package](#publish-a-scoped-package)
	1. [Verify your package](#verify-your-package)
1. [Update / bump a package version](#update--bump-a-package-version)
	1. [Semantic versioning rules](#semantic-versioning-rules)
	1. [View a package version](#view-a-package-version)
	1. [View / inspect a package dependency versions](#view--inspect-a-package-dependency-versions)
	1. [Update / bump a package version](#update--bump-a-package-version-1)
1. [Remove / unpublish a package](#remove--unpublish-a-package)

<!-- /MarkdownTOC -->

<a name="build-and-create-a-package"></a>
## Build and create a package

<a name="create-a-package"></a>
### Create a package

```shell
# The -y or --yes flag answers "yes" to every question.
npm init -y
```

**Important: Make sure the `main` field in `package.json` is populated with the entry point for your main script.**

<a name="create-a-scoped-package"></a>
### Create a scoped package

```shell
npm init --scope=<username>
```

<a name="saving-a-scope-locally"></a>
### Saving a scope locally

If you use the same scope all the time, you can set this option in `.npmrc`:

```shell
npm config set scope <username>
```

<a name="build-a-package"></a>
### Build a package

NPM packages must follow the CommonJS module spec:

```js
// Import other packages.
var myCoolModule = require('my-cool-module');
// Export your package.
module.exports = function() {
	console.log(myCoolModule.doSomething());
};
```

<a name="test-packages-locally"></a>
### Test packages locally

```shell
npm link
```

`npm link` is a handy way of linking and testing packages locally before publishing. To test your NPM package from another local project, you must do two things:

1. Link the local package folder to the global `node_modules` directory:
	```shell
	cd <npm package folder>
	npm link
	```
2. Link the other local project to your NPM package:
	```shell
	cd <project folder>
	npm link <npm package name>
	```

<a name="prep-your-npm-package-to-publish"></a>
## Prep your NPM package to publish

<a name="check-if-your-npm-credentials-are-stored-locally"></a>
### Check if your NPM credentials are stored locally

```shell
npm whoami
```

<a name="set-up-npm-locally"></a>
### Set up NPM locally

Set up your NPM author info:

```shell
npm set init.author.name "<name>"
npm set init.author.email "<email>"
npm set init.author.url "<url>"
```

<a name="create-an-npm-user"></a>
### Create an NPM user

To add your NPM credentials to `~/.npmrc`:

```shell
npm adduser
```

or

```shell
npm site
```

<a name="log-in-as-a-current-npm-user"></a>
### Log in as a current NPM user

```shell
npm login
```

<a name="exclude--ignore-files"></a>
### Exclude / ignore files

Use `.npmignore` to ignore files from your NPM repo.

<a name="publish-a-package"></a>
## Publish a package

<a name="npm-publish"></a>
### NPM publish

```shell
npm publish ./
```

To publish a package as beta (which will not be installed by default):

```shell
npm publish ./ --tag beta
```

<a name="publish-a-scoped-package"></a>
### Publish a scoped package

Scoped packages are private by default (which is a paid feature). To publish a public scoped package, pass the public flag:

```shell
npm publish --access=public
```

<a name="verify-your-package"></a>
### Verify your package

Visit `https://npmjs.com/package/<package>` to verify your package was published.

<a name="update--bump-a-package-version"></a>
## Update / bump a package version

<a name="semantic-versioning-rules"></a>
### Semantic versioning rules

When you make changes to your code, update its version based on [semantic versioning rules](http://semver.org/) rules:

1. MAJOR: Breaking changes.
2. MINOR: Add backwards compatible functionality.
3. PATCH: Make backwards compatible bug fixes.

<a name="view-a-package-version"></a>
### View a package version

```shell
npm view  <package name> version
```

<a name="view--inspect-a-package-dependency-versions"></a>
### View / inspect a package dependency versions

```shell
cd <package directory>
npm ls
```

<a name="update--bump-a-package-version-1"></a>
### Update / bump a package version

```shell
npm version <major|minor|patch|premajor|preminor|prepatch|prerelease|from-git>
```

**Options:**

|       Command       |                                      Description                                      |
|---------------------|---------------------------------------------------------------------------------------|
| n/a                 | When bumping a version from a git repo, it will also create a version commit and tag. |
| `-m` or `--message` | Add a git commit message. Type `%s` to insert the version in the git message.         |

_See [other options](https://docs.npmjs.com/cli/version) in the full documentation._

<a name="remove--unpublish-a-package"></a>
## Remove / unpublish a package

```shell
npm unpublish ./
```
