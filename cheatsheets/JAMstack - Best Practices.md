# [JAMstack](https://jamstack.org)

## JAMstack versus Legacy web stacks

### Problems in Legacy web stacks

- _Flexibility_.
    - Code is so interconnected that fixing a bug, updating a library, or changing a framework can break other parts of the app. **The whack a mole effect**.
- _Performance_.
    - One study concluded a second delay in load time can hurt conversion of an ecommerce site by 7%.
    - Monolithic/server heavy apps need to generate and deliver HTML every request.
    - Code is so interconnected that fixing a bug, updating a library, or changing a framework can break other parts of the app. **The whack a mole effect**.
    - Caching is difficult. Same URL might return different content depending on various parameters.
- _Scaling_.
    - Because the page view is generated for every visitor/request, infrastructure needs to be scaled in anticipation of site traffic.
    - This is expensive and difficult to get right.
    - It's not possible to decouple these facilities in order to scale and protect each piece of the infrastructure according to its needs.
- _Security_.
    - Monolithic apps like Wordpress, Drupal, and Joomla combine all components of an app's architecture into a single codebase. In turn, it creates a massive surface area for malware to penetrate.
    - Not only is the attack surface area extremely large, it's also exposed every single time the site is built because any plug-in the site uses must execute each time the page loads for a new site visitor, magnifying the risk.
    - In many monolithic apps, plug-ins are tied directly to the core framework, risking breakage if core is updated.

### Advantages of the JAMstack

- Simplification.
    - Better comprehension and mental agility.
    - You don't need to be an expert at everything.
    - Reduce moving parts at runtime.
- Reduction in Costs.
    - Financial cost. Far simpler architecture comes with simplified infrastucture, which comes with a dramatic reduction in financial cost.
    - Time/team efficiency.
        - The size and complexity of a project's architecture is directly proportional to the quantity of people and range of skills required to operate it. A simplified architecture with fewer servers requires fewer people and far less specialization.
        - Complex DevOps tasks are largely removed from projects with simpler environments.
        - What were once time-consuming, expensive, and critical procedures—like provisioning new environments and configuring them to faithfully replicate one another—are replaced with maintenance of only the local development environments (required with a traditional approach, anyway) and the deployment pipeline to a productized static hosting service or CDN.
        - This shift places far more power and control in the hands of developers, who are in possession of an increasingly widespread set of web development skills. This reduces the cost of staffing a web development project (through a reduced demand for some of the more exotic or historically expensive skills) and increases the productivity of the developers employed
        - By having working knowledge of a larger portion of the stack and fewer discipline boundaries to cross, each developer's mental model of the project can be more complete and, as a result, each individual can be more confident in their actions and be more productive.
    - Innovation.
        - JAMstack creates "small pieces, loosely joined".
        - High level of confidence of knowing how a change might affect other parts.
        - Gives development teams freedom to refactor and develop the particular parts of the site that they control, safe in the knowledge that as long as they honor the structure of the interfaces between different parts of the site, they will not compromise the wider project.
- Scale.
    - CDN serves up content and easily/automatically scales with traffic.
    - CDN typically has nodes distributed globally, so user gets closest server.
    - Resiliency, redundancy, and capacity. With CDN, no single point of failure that could prevent visitor from reaching the site. If a node within a global CDN fails, traffic is satisfied by another node elswhere in the network.
- Performance.
    - [Less distance and fewer stops to destination](./assets/jamstack-versus-legacy-stack.png). Legacy web stack requests go to/from the browser, web server, application server, and database. JAMstack requests only travel to/from browser and CDN.
    - The significantly shorter request/response stack is possible because pages are not being assembled "on the fly", per request. CDN has precompiled assets, ready to go.
- Security.
    - Reduced surface area (amount of code/infrastructure). Less infrastructure means fewer things to attack.
    - Read-only requests (no logical code executed on servers at request time) mean less risk of attack.
- Developer experience (an important part of success).
    - JAMstack can deliver an architecture and an approach to development that somehow satisfies both user problems and developer problems.
    - Simplification does not come at the cost of clarity. JAMstack employs tools, conventions, and approaches that are both popular and increasingly available among web developers. It embraces development workflows designed to enhance a developer's ability to be effective and to build things in familiar but powerful environments. It creates strong logical boundaries between systems and services, creating clear areas of focus and ownership.

## Planning for JAMstack

When creating a JAMstack app, decisions you need to make include:

- How you'll manage the project/code.
    - _Best to set up a hosted git repo._
    - Project typically includes:
        - Source folder.
        - Folder for layouts and templates.
        - Build process configuration file.
        - Static site generator (usually a dependency).
        - Destination folder for final output.
- Where you'll store your content.
    - _Text files_.
        - HTML files.
        - Markdown, optionally with YAML.
    - _Git-based CMS_. Provides a familiar admin interface to edit content and preview and save changes. This allows non-developers to easily contribute content. Behind the scenes, saved changes in the CMS are source controlled in the same git repo which hosts the app's codebase. So developers and editors are working in the same git-based workflow (though non-developers may not even realize it).
        - [NetflifyCMS](https://netflifycms.org)
        - [Forestry](https://forestry.io)
    - _Headless CMS_. Provides online admin interface for managing and editing content. "Headless" means they only manage the content, leaving it up to the developer how to consume that content. APIs are provided for data/content created, which developers can use to pull the most recent content during the build/precompile step.
    - _Self-Hosted CMS_. Traditional CMSs like WordPress and Drupal can also be used, since recent versions have added APIs to access content they contain. These would work similarly to _Headless CMSs_, and the WordPress/Drupal CMS would not need to be public facing.
- What software will build your site.
    - [StaticGen](https://staticgen.com) is a community directory of static site generators that can build your site (most free and open source). In choosing the best tool for the job, check out sample projects generated by the tool, and consider the following:
        - _Type of website_: blog, web app, etc.
        - _Programming language_ used by the tool. With some tools, you may not need to know the underlying language; with others, it may be useful to have familiarity with the generator's language.
        - _Template syntax_. A majority of JAMstack development is creating and modifying HTML templates, CSS and JS. So care should be given to templating languages your tool supports.
        - _Speed_. How fast will the tool output each page? This becomes more important the more your content grows.
        - _Developer tooling_. Often these tools can compile other production assets, such as images, svg, etc., or provide other features such as code linting.
- How your build process will be automated.
    - Git, GitLab, and Bitbucket all support _webhooks_, which is a simple way to trigger an HTTP POST to an external URL with JSON information about the event. The receiving server can use that to determine what to do next, which most commonly is to trigger a new build after code is checked in.
    - Ideally, your automated build process will:
        1. Listen for notifications of changes to your git repo (i.e., webhooks).
        2. Prepare the build environment and fetch dependencies.
        3. Fetch remote data from APIs as needed.
        4. Build the site and prepare assets.
        5. Publish the final site to a CDN.
    - _GitHub Pages and GitLab Pages_ each provide lightweight options to publish your site to, along with custom domains.
    - You may also set up _your own infrastructure_. There are many tools from CI/CD that you can apply to automating the JAMstack.
    - _Hosted deployment services_. To ease the process of setting up a robust and resilient build system, a new category of service has emerged: hosted build services/ continuous integration. These services often have apps available for GitHub and GitLab, making the integration with your repository fairly painless. You want a build service that's secure and customizable. Most build services will commonly create a temporary container, set up your environment, grab any needed dependencies, run the build, deploy the results, and then dispose of the container. It's important that the build service is aware of and supports your site generator, language environment, and other tooling involved in building your website. You'll want to keep dependency settings files like Gemfile, package.json, and composer.php accurate and up to date.
- Where your site will be published.
    - The JAMstack approach of publishing directly to CDNs helps solve for the two oldest foes of the internet: _time and space_. First, the time required to start serving content is greatly improved by prerendering all the markup, as we discussed earlier. And second, the amount of physical distance (and network hops) that content must travel on the way to users is also reduced, thanks to the geographically distributed nature of CDNs.
    - Considerations for choosing a CDN:
        - _Edge locations_. Publishing to a CDN usually means your site content becomes available to a minimum of 10 or 15 locations worldwide. You'll want a CDN with edge locations close to your audience, so if you have users in Tokyo, they experience your website served from Tokyo.
        - _Instant updates_. Modern CDNs now allow instant invalidation, replacing files in milliseconds and blurring the lines between static content and dynamic updates. If a near-instant update to CDN cache can be guaranteed each time the site is deployed, TTLs and stale content are no longer a concern.
        - _Multiple providers_. Some CDNs locate their edge servers with multiple cloud providers, increasing the durability of your application. Even though a complete datacenter outage is rare, they do happen. It's also not uncommon for a provider to experience a Distributed Denial-of-Service (DDoS) attack toward a particular facility or network. Ensure that your CDN provider is not only distributed across the globe but also across providers. Hosting on such a provider gives you the power of a "cloud of clouds" for the most resilient setup possible.
- What services and APIs your live site will use.
    - It wasn't too long ago that authentication, payment processing, and commerce were all concerns that you needed to host and manage yourself. But today, each of those (and many more features) are now consumable as APIs. But how expensive will it be? What if the service goes down? How difficult would it be to rip out and replace? These questions are common when evaluating any hosted service, and it can feel daunting to trust critical services to a third party. But consider that all the questions above will also inevitably arise for teams that build or manage technologies in-house. It all comes down to choice and flexibility, and the move toward decoupled, API-driven architectures (and away from monolithic apps) offers teams the flexibility to decide what to consume and what to build. Each layer of the stack -- from content, to commerce, to the frontend -- can now be vetted and chosen independently.
    - Consider the dynamic needs of an ecommerce store, which needs the ability to manage products, manage inventory, power search, and allow customers to make purchases. Here's an example of how JAMstack can manage these dynamic needs:
        - Content/data (products, etc.) is managed in a hosted CMS service, such as Contentful.
        - Store owners and editors use the CMS interface to manage store listings and upload photos.
        - Saving new content in the CMS triggers a new build of the website using, for example, Netlify's build auomation.
        - During the build step, the build process fetches the most recent store data from the CMS by calling the API.
        - That data is fed into a site generator, such as Gatsby, to render each of the pages.
        - The build process also uses APIs to send data to Algolia, the search provider, so the search index can be updated as the product catalog changes.
        - As visitors browse the site, prerendered pages are pulled directly from a CDN. No running server processes are anywhere to be found.
        - Any interactivity in the site is create with JavaScript to call APIs from directly within the browser.
        - For example, when a shopper searches for something, the search term is fed to Algolia via JS/Ajax, and Algolia returns JSON search results. JS is used to display those results however we like.
        - When a shopper clicks a buy button, the intent to purchase is sent to a provider such as CommerceLayer or Shopify, which powers the shopping cart and checkout experience. This happens with JS calling APIs.
        - And tada! An entire ecommerce experience built with interconnecting modular components via API calls. With no backend infrastructure to set up or manage, our time and focus can be spent creating the front end app.
        - Because everything in this example is using a hosted service, the initial prototype can be created in a few days or less! This is why JAMstack providers "superpower" for front end teams.

## JAMstack best practices

1. _Get to the CDN._

2. _Design for immutability and atomic deployments._ An atomic deployment is an all-or-nothing approach to releasing new deployments into the wild. As each file is uploaded to its hosting infrastructure, it is not made available publicly until every single file that is a member of that deployment is uploaded and a new, immutable build instance is ready to be served. Most good CDN providers offer this service.

3. _Employ end-to-end version control_.

4. _Ease the build and deployment process through automation and tooling_. A powerful site-generation pattern might look like this:

    1. Gather external data and content from a variety of APIs.

    2. Normalize the structure external content and stash it in a format suitable for consumption by a static site generator.

    3. Run the static site generator to output a deployable site.

    4. Perform optimization tasks to improve the performance of the generated assets.

    5. Run the test suite.

    6. Deploy output assets to the hosting infrastructure or CDN.
    
    Additionally, webhooks allow you to do any combination of the following:

    - Trigger a build in a CI system.
    - Trigger an interactive message in a messaging platform such as Slack.
    - Notify a service that content has been updated in a headless CMS such as Contentful.
    - Execute a function in a Functions as a Service (FaaS) provider such as Amazon Web Services (AWS) Lambda, Google Cloud Functions, or Microsoft Azure Cloud Functions.

    Automation is not purely about doing repeatable tasks quickly. It turns out that humans are pretty bad at doing the same task over and over again without making mistakes. Removing ourselves from the build and deployment process is a good way to reduce errors.

    It’s very common to plan for a time late in a project to do this kind of automation, but we recommend doing it early. This will do the following:

    - Create basic documentation of your processes by codifying them.
    - Introduce version control into your deployment process itself.
    - Reduce the risk of human error for every time you deploy.
    - Begin to instill a project culture in which deployments are not heralded as rare, complex, and risky operations.

5. _Embrace the ecosystem_.

6. _Bridge the last gaps with functions as a service_. We have an expanding set of tools and services available to us. We don’t need to reinvent or reimplement each of them in order to add their capabilities to our sites. Search, user-generated content, notifications, and much more are available to us without the need to own the code for each. But not every one of these services can be integrated into our sites without some logic living somewhere.

    Functions as a Service (FaaS; often called serverless functions) can be the ideal solution to this and can be the glue layer that binds many other services together.