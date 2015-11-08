module Jekyll
  module Prismic
    # Generates pages for all collections with have the "generate" option set to True
    class PrismicGenerator < Generator
      safe true

      def generate(site)
        site.prismic_collections.each do |collection_name, collection|
          if collection.generate?
            collection.each do |document|
              site.pages << PrismicPage.new(site, site.source, document, collection)
            end
          end
        end
      end
    end

    class PrismicPage < Page
      def initialize(site, base, document, collection)
        @site = site
        @base = base
        @collection = collection
        @document = document

        @dir = @collection.config['output_dir'] || collection.collection_name
        # Default file name, can be overwritten by permalink frontmatter setting
        @name = "#{document.slug}-#{document.id}.html"

        self.process(@name)
        self.read_yaml(File.join(base, "_layouts"), @collection.config['layout'])

        # Use the permalink collection setting if it is set
        if @collection.config.key? 'permalink'
          self.data['permalink'] = @collection.config['permalink']
        end

        self.data['document'] = document
      end

      def url_placeholders
        Utils.deep_merge_hashes({
          :slug => @document.slug,
          :id => @document.id,
          :uid => @document.uid,
          :type => @document.type,
          :collection => @collection.collection_name
        }, super)
      end

      def render(layouts, site_payload)
        payload = Utils.deep_merge_hashes({
          "document" => PrismicDocumentDrop.new(@document, @site.prismic_link_resolver),
          "page" => self.to_liquid
        }, site_payload)

        do_layout(payload, layouts)
      end
    end
  end
end
