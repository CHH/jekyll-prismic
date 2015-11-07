# jekyll-prismic

## Install

Add the "jekyll-prismic" gem to your Gemfile:

```
gem "jekyll-prismic"
```

Then add "jekyll-prismic" to your gems in `_config.yml`:

```
gems:
    - jekyll-prismic
```

## Configuration

```yaml
prismic:
    # Your repository endpoint
    endpoint: https://lesbonneschoses.prismic.io/api
    access_token: 'Your access token if the repo is private'
    # Link resolving, key should match a document type in your repo
    links:
        post:
            permalink: /posts/:slug-:id/
    # Collections, key is used to access in the site.prismic.collections
    # template variable
    collections:
        # Example for a "posts" collection
        posts:
            # Query the documents by type (optional)
            type: post
            # Collection name (optional)
            form: posts
            # Layout file for this collection
            layout: prismic_post.html
            # Additional queries (optional)
            query:
                - ["missing", "my.post.allow_comments"]
            # Order posts in the collection by a fragment (optional)
            orderings: '[my.post.date desc]'
            # Generate output files or not (default: false)
            output: true
            # Limit output to a number of files, useful for large collections
            # (optional)
            output_limit: nil
```

## Usage

This plugin provides the `site.prismic` template variable. This template provides access to tags, bookmarks, and the collections defined in the configuration.

### Using Collections

Collections are accessed by their name in `site.prismic.collections`. The `posts` collections is available at `site.prismic.collections.posts`.

To list all documents of the collection:

```
{% for post in site.prismic.collection.posts %}
<article>
    <header>
        {{ post.fragments.title.html }}
    </header>
    <div class="body"
        {{ post.fragments.body.html }}
    </div>
</article>
{% endfor %}
```

### Using bookmarks

Prismic’s bookmarks are a handy way to load documents for things like error pages or site configuration. Bookmarks can be accessed with the `site.prismic.bookmarks` object. Each bookmark is returned as document, fetched from the API.

Suppose, we have an error document `404.html` and a bookmark named `errorpage` in Prismic, our template would look this way:

```html
---
---
{% assign document = site.prismic.bookmarks.errorpage %}

<header>{{ document.fragments.title.html }}</header>
<main>
    {{ document.fragments.body.html }}
</main>
```
