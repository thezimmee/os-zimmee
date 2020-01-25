# FDS UI Architecture

## Next steps

Identify work to be completed, and WHO is in charge of completing it:

- What infrastructure needs to be set up for FDS?
    - Code repo: Should we live in AMC monorepo? Or not?
    - Dev/stage/live environments.
    - Deployment infrastructure.
    - FDS router.
    - Module to manage FDS app data. May or may not be a shared AMC module.
    - Build system:
        - Possible options:
            - create-react-app?
            - Custom Webpack/Rollup/Parcel build?
            - Something else? Preact with Preact CLI? Svelte?
        - Features needed:
            - JS bundling.
            - Code splitting.
            - CSS modules?
- Create list of AMC work:
    - What AMC work is required for FDS to move forward?
        - Move nav component to a shared package.
        - Move page layout components to shared package(s).
        - Move "top-level route authorization" module to a shared package.
        - What data must be shared between AMC <--> FDS?
    - What AMC work would be "nice to have" (but not required) for FDS?
        - A way to share/cache AMC's core assets when user goes from AMC to FDS (in between page refreshes).
            - CDN for cached global bundle?
            - SSR with Node?
            - Other ways?
- Should FDS use AMC's GraphQL service to communicate with FDS API? If we don't, what additional infrastructure would we need to build?
    - I'm interested to know Colin's opinion. In my limited perspective, I lean towards using it to start so we can avoid the additional infrastructure. We can always change our mind down the road and swap it out with something else.

## Considerations

- What are policies for keeping things in sync after significant updates to shared AMC packages?
    - My thought is, for minor updates or feature additions, leave it to teams to prioritize. For major or breaking updates, AMC should provide a deprecate date for all teams to update to the new version by.