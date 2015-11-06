module Jekyll
  module Prismic
    # Prismic Document access in Liquid
    class PrismicDocumentDrop < Liquid::Drop
        attr_accessor :document

        def initialize(document, link_resolver)
            @document = document
            @link_resolver = link_resolver
        end

        def id
            @document.id
        end

        def type
            @document.type
        end

        def uid
            @document.uid
        end

        def slug
            @document.slug
        end

        def slugs
            @document.slugs
        end

        def tags
            @document.tags
        end

        def href
            @document.href
        end

        def fragments
            PrismicFragmentsDrop.new(@document.fragments, @link_resolver)
        end
    end

    class PrismicFragmentsDrop < Liquid::Drop
        def initialize(fragments, link_resolver)
            @fragments = fragments
            @link_resolver = link_resolver
        end

        def [](fragment_id)
            fragment = @fragments[fragment_id]

            case fragment
            when Prismic::Fragments::DocumentLink then
                PrismicDocumentLinkFragmentDrop.new(fragment, @link_resolver)
            when Prismic::Fragments::Link then
                PrismicLinkFragmentDrop.new(fragment, @link_resolver)
            when Prismic::Fragments::Group then
                PrismicGroupFragmentDrop.new(fragment, @link_resolver)
            when Prismic::Fragments::GroupDocument then
                PrismicGroupDocumentFragmentDrop.new(fragment, @link_resolver)
            when Prismic::Fragments::Multiple then
                PrismicMultipleFragmentDrop.new(fragment, @link_resolver)
            when Prismic::Fragments::Color then
                PrismicColorFragmentDrop.new(fragment, @link_resolver)
            when Prismic::Fragments::StructuredText then
                PrismicStructuredTextFragmentDrop.new(fragment, @link_resolver)
            else
                PrismicFragmentDrop.new(fragment, @link_resolver)
            end
        end
    end

    class PrismicFragmentDrop < Liquid::Drop
        def initialize(fragment, link_resolver)
            @fragment = fragment
            @link_resolver = link_resolver
        end

        def [](attribute)
            case attribute
            when "html" then
                @fragment.as_html(@link_resolver)
            when "text" then
                @fragment.as_text
            else
                @fragment.send(attribute.to_sym)
            end
        end
    end

    class PrismicGroupFragmentDrop < PrismicFragmentDrop
        def [](attribute)
            case attribute
            when "group_documents" then
                docs = []
                @fragment.each do |group_document|
                    docs << PrismicGroupDocumentFragmentDrop.new(group_document, @link_resolver)
                end
                docs
            else
                super
            end
        end
    end

    class PrismicGroupDocumentFragmentDrop < PrismicFragmentDrop
        def to_liquid
            {
                "fragments" => PrismicFragmentsDrop.new(@fragment.fragments, @link_resolver)
            }
        end
    end

    class PrismicMultipleFragmentDrop < PrismicFragmentDrop
        def to_liquid
            {
                "fragments" => PrismicFragmentsDrop.new(@fragment.fragments, @link_resolver)
            }
        end
    end

    class PrismicLinkFragmentDrop < PrismicFragmentDrop
        def [](attribute)
            case attribute
            when "start_html" then
                @fragment.start_html(@link_resolver)
            when "url" then
                @fragment.url(@link_resolver)
            else
                super
            end
        end

        def url
            @fragment.url(@link_resolver)
        end
    end

    class PrismicDocumentLinkFragmentDrop < PrismicLinkFragmentDrop
        def [](attribute)
            case attribute
            when "fragments" then
                PrismicFragmentsDrop.new(@fragment.fragments, @link_resolver)
            else
                super
            end
        end
    end

    class PrismicColorFragmentDrop < PrismicFragmentDrop
        def [](attribute)
            case attribute
            when "rgb" then
                @fragment.asRGB
            else
                super
            end
        end
    end

    class PrismicStructuredTextFragmentDrop < PrismicFragmentDrop
    end

    # Handles a single Prismic collection in Liquid
    class PrismicCollectionDrop < Liquid::Drop
        def initialize(collection, link_resolver)
            @collection = collection
            @link_resolver = link_resolver
        end

        def to_liquid
            results = []
            @collection.each { |result| results << PrismicDocumentDrop.new(result, @link_resolver) }
            results
        end
    end

    # Handles Prismic collections in Liquid, and creates the collection on demand
    class PrismicCollectionsDrop < Liquid::Drop
        def initialize(collections, link_resolver)
            @collections = collections
            @link_resolver = link_resolver
        end

        def [](collection_name)
            PrismicCollectionDrop.new(@collections[collection_name], @link_resolver)
        end
    end

    # Main Liquid Drop, handles lazy loading of collections, tags, and bookmarks
    # and conversion to drops
    class PrismicDrop < Liquid::Drop
        def initialize(site)
            @site = site
        end

        def collections
            @collections ||= PrismicCollectionsDrop.new(@site.prismic_collections, @site.prismic_link_resolver)
        end

        def tags
            @tags ||= @site.prismic.tags
        end

        def bookmarks
            @bookmarks ||= PrismicBookmarksDrop.new(@site, @site.prismic.bookmarks)
        end
    end

    # Handles Prismic bookmarks in Liquid, and fetches the documents on demand
    class PrismicBookmarksDrop < Liquid::Drop
        def initialize(site, bookmarks)
            @cache = {}
            @site = site
            @bookmarks = bookmarks
        end

        def [](bookmark)
            unless @cache.key? bookmark
                @cache[bookmark] = PrismicDocumentDrop.new(PrismicHelper.find_document(@bookmarks[bookmark]), @site.prismic_link_resolver)
            end
            @cache[bookmark]
        end
    end
  end
end
