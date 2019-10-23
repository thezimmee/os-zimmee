# Starter Repo

> Instructions for creating a new repo.

## Create local repo to track initial changes

1.  Create project directory with `mkdir <path>`.
2.  If you haven't already, configure default NPM fields with `npm config edit`.
3.  Initialize a new NPM Project with `npmproject`. This script runs the following:
    ```sh
    # Initialize git local repo.
    git init
    # Create license.
    npx license $(npm get init.license) -o "$(npm get init.author.name)" > LICENSE.md
    # Create .gitignore.
    npx gitignore node
    # Create a Contributor Covenant (see https://www.contributor-covenant.org/).
    npx covgen "$(npm get init.author.email)"
    # Create package.json.
    npm init -y
    ```
4.  Modify `package.json` as needed:
    -   Repo/URLs: `name`, `homepage`, `repository`, `bugs`.
    -   `description` and `keywords`.
    -   File paths: `bin`, `main`, `module`, `browser`, `umd`, `directories`, `files`.
    -   Dependencies: `devDependencies`, `dependencies`.
    -   `scripts`.

## Set up git hooks

1.  Install with `npm i @brikcss/git-hooks -D`.
2.  Configure linting (or other tasks) which run on staged files in `.lintstagedrc.js`:
    ```js
    module.exports = {
        "*.js": "standard",
        "*.css": "prettier && stylelint --stylish"
        // Add other linters / file filters here.
    };
    ```

Optionally:

1.  Configure git hooks in `.huskyrc.js`:
    ```js
    module.exports = {
        hooks: {
            "pre-commit": "lint-staged",
            "commit-msg":
                "commitlint -e $HUSKY_GIT_PARAMS && . ./node_modules/.bin/commit-msg-stamp-branch ${HUSKY_GIT_PARAMS}",
            "pre-push":
                '. ./node_modules/.bin/pre-push-check-stage && echo "\n[ok] Pushing code..."'
        }
    };
    ```
2.  Configure git commit linter in `.commitlintrc.js` (see example in starter-module repo).
3.  Configure `.prettierrc.js` (see example in starter-module repo).

## Set up a JS Project (Node, ESM, UMD and/or Browser)

### To output code as an ES Module, browser global (IIFE), or a UMD, set up JS bundles with RollupJS (ESM, UMD, Browser)

1.  Install with `npm i rollup rollup-plugin-commonjs rollup-plugin-node-resolve rollup-plugin-terser @brikcss/merge -D`.
2.  Add bundles to the NPM build script: `"build": "rollup --config=.rolluprc.js"`
3.  Configure in `.rolluprc.js` (see starter-module or dsui-library-site repo for config example).

_Note: As an alternative to RollupJS you may use Webpack or Parcel._

### To transpile JS to a different format, set up Babel transpiling (ESM, UMD, Browser)

1.  Install babel dependencies:
    -   If _not_ using RollupJS: `npm i babel -D`.
    -   If using RollupJS: `npm i rollup-plugin-babel @babel/core @babel/preset-env babel-core babel-jest -D`.
2.  Configure in `.babelrc` (see example in starter-module repo).
3.  If not using RollupJS, add NPM Script to build: `"build": "babel *.js"`.

### Set up a Node binary / executable script (Node)

1.  Create `/bin/<library-name>-cli.js`
2.  In `package.json`:
    -   Add executable path to `bin` field.
    -   Add binary directory to `files` field.

### Set up JS linter and formatter (All)

1.  Install with `npm i @brikcss/git-hooks -D`.
2.  _(Optional)_ Add NPM Script: `"test": "standard"`

_Note: You may alternately use ESLint and Prettier instead of Standard._

### Set up JS unit testing and code coverage (All)

1.  If using Jest:
    1.  Install with `npm i jest coveralls codacy-coverage -D`.
    2.  Add to NPM Scripts:
        -   `"watch": "jest --watch"`
        -   `"test": "jest --coverage && cat coverage/lcov.info | coveralls && cat coverage/lcov.info | codacy-coverage"`
        -   `"unit": "jest"`
    3.  Configure with `.jestrc.js`
2.  If using MochaJS:
    1.  Install with `npm i mocha mocha-better-spec-reporter nyc coveralls codacy-coverage -D`.
    2.  Add to NPM Scripts:
        -   `"watch": "mocha *.spec.js --reporter=mocha-better-spec-reporter --colors"`
        -   `"test": "nyc --reporter=lcov --reporter=text mocha \"*.spec.js\" --recursive"`

## Set up CSS (PostCSS)

### Set up PostCSS

1.  Install `npm i postcss autoprefixer postcss-csso @brikcss/stakcss @brikcss/stakcss-bundler-postcss -D`.
2.  _(Optional)_ Install `npm i colorguard css-mqpacker focus-within postcss-reporter`.
3.  Configure with `.postcssrc.js` (see example in starter-module repo).
4.  Configure `css` property in `.stakcssrc.js`.
5.  Add to NPM Scripts: `"build": "stak --config=.stakcssrc.js:all"`

### Set up CSS linter and formatter

1.  Install with `npm i @brikcss/git-hooks @brikcss/stylelint-config-css -D`.
2.  Configure `.stylelintrc.js` (see example in starter-module repo).
3.  Configure `.prettierrc.js` (see example in starter-module repo).
4.  Configure tasks in `.lintstagedrc.js`.
5.  _(Optional)_ Add NPM Scripts: `"test": "stylelint *.css --format=stylish"`
6.  _(Optional)_ Ignore files in `.stylelintignore` and `.prettierignore`

## Set up HTML

### Set up EJS templating

1.  Install with `npm i @brikcss/stakcss @brikcss/stakcss-bundler-ejs -D`.
2.  Add to NPM Scripts: `"build": "stak --config=.stakcssrc.js:all"`.
3.  Configure `html` property in `.stakcssrc.js` (see example in starter-module repo).

## Set up Image / Asset bundles

1.  Install with `npm i @brikcss/stakcss @brikcss/stakcss-bundler-copy -D`.
2.  Add to NPM Scripts: `"build": "stak --config=.stakcssrc.js:all"`.
3.  Configure `assets` property in `.stakcssrc.js` (see example in starter-module repo).

## Set up svg processing

1.  Install with `npm i @brikcss/stakcss @brikcss/stakcss-bundler-svg -D`.
2.  Add to NPM Scripts: `"build": "stak --config=.stakcssrc.js:all"`.
3.  Configure `svg` property in `.stakcssrc.js` (see example in starter-module repo).

## Set up local development server

1.  Install with `npm i browser-sync -D`.
2.  Configure in `.browsersync.js` (see example in starter-module repo).
3.  Add to NPM Scripts: `"start": "browser-sync start --config ./.browsersyncrc.js"`

## Add UI regression testing

1.  Install with `npm i @brikcss/shots -D`.
2.  Configure in `.shotsrc.js`.
3.  Add to NPM Scripts: `"test": "npx shots",`.

## Set up auto release with optional Continuous Integration and code quality suites

1.  Install with `npm i semantic-release -D`.
2.  Configure semantic-release in `.releaserc.js`.
3.  Configure `puglishConfig` field in `package.json`:
    ```json
    "publishConfig": {
        "tag": "dev",
        "access": "public"
    }
    ```
4.  Configure TravisCI in `.travis.yml` (see example in starter-repo).
5.  _(Optional)_ Add files that NPM should not publish to `.npmignore`

## Add documentation

-   readme.md
    -   Description
    -   Badges
    -   Browser Compatibility
    -   Link to a demo
    -   Installation
    -   Getting Started
        -   How to add any required JS/CSS
        -   Required markup structure
        -   Instantiation steps
    -   Working with source files (for people who want to use the uncompiled code)
    -   Configuration Options
    -   License
    -   See [simple readme example for a web component](https://github.com/Festify/ken-burns-carousel).

## Set up online suites

1.  Set up code QA and test coverage suites:
    -   [codacy](https://www.codacy.com/)
    -   [coveralls](https://coveralls.io/)
    -   [codeclimate](https://codeclimate.com/)
2.  Set up Travis CI:
    -   Add `NPM_TOKEN`
    -   Add `GH_TOKEN`
    -   Add `CODACY_PROJECT_TOKEN`
    -   Add `COVERALLS_REPO_TOKEN`
    -   Update codacy badge ID in README.md (different from the token).
    -   Turn the repo on in Travis if you want it to build on the next commit.

## Push initial changes to start a new build

```sh
git add <files>
git commit
git remote add origin git@github.com:<userid>/<repo>.git
git push -u origin master
```
