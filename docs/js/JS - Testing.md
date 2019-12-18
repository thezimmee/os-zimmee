# Testing JavaScript

1.  Install and configure eslint.

    Recommended config:

    ```json
    {
        "parser": "babel-eslint",
        "parserOptions": {
            "ecmaVersion": "2018"
        },
        "extends": ["eslint:recommended", "eslint-config-prettier"],
        "env": {
            "browser": true,
            "node": true
        }
    }
    ```

2.  Install and configure prettier.

    Recommended config:

    ```json
    {
        "arrowParens": "always",
        "bracketSpacing": true,
        "jsxBracketSameLine": false,
        "printWidth": 100,
        "semi": true,
        "singleQuote": true,
        "tabs": false,
        "tabWidth": 2,
        "trailingComma": "all",
        "useTabs": false
    }
    ```

3.  Install and configure Flow (`flow-bin`).

4.  Install and configure `lint-staged`.

    ```json
    {
        "linters": {
            "*.js": ["eslint"],
            "**/*.+(js|jsx|json|yml|yaml|css|less|scss|ts|tsx|md|graphql|mdx)": [
                "prettier --write",
                "git add"
            ]
        }
    }
    ```

5.  Add NPM Scripts.

    ```json
    {
        "scripts": {
            "test": "jest",
            "dev": "webpack-serve",
            "build": "webpack --mode=production",
            "postbuild": "cp ./public/index.html ./dist/index.html",
            "start": "serve --no-clipboard --listen 8080 dist",
            "lint": "eslint .",
            "format": "prettier \"**/*.js\" --write",
            "validate": "npm run lint && npm run test && npm run build",
            "setup": "npm run setup && npm run validate"
        }
    }
    ```
