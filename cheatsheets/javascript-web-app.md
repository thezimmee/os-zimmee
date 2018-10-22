# JavaScript Web Apps

## Directory Structure

```bash
my-app/
|—— dist/
|   |—— css/
|   |   |—— main.css
|   |   |—— main.min.css
|   |—— images/
|   |   |—— # image files
|   |—— js/
|   |   |—— someStandaloneScript.js
|   |   |—— someStandaloneScript.min.js
|   |   |—— main.js
|   |   |—— main.min.js
|   |—— svg/
|   |   |—— icons.svg
|   |—— assets/
|   |   |—— # other static assets
|—— src/
|   |—— js/
|   |   |—— someStandaloneScript.js
|   |   |—— main/
|   |   |   |—— atomic.js
|   |   |   |—— smooth-scroll.js
|   |   |   |—— fluid-vids.js
|   |   |   |—— app.js
|   |   |   |—— zzz_inits.js
|   |—— css/
|   |   |—— _config.css
|   |   |—— mixins/
|   |   |   |—— _mixins.css
|   |   |—— components/
|   |   |   |—— _normalize.css
|   |   |   |—— _grid.css
|   |   |   |—— _typography.css
|   |   |   |—— _overrides.css
|   |   |—— main.css # imports config.css, mixins.css, and components
|   |—— images/
|   |   |—— # image files
|   |—— svg/
|   |   |—— # svgs
|   |—— # other static files and folders
|—— .travis.yml
|—— package.json
|—— README.md
```