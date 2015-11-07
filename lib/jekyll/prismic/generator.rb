module Jekyll
  module Prismic
    # Generates pages for all collections with have the "generate" option set to True
    class PrismicGenerator < Generator
      safe true

      def generate(site)
        site.prismic_collections.each do |collection_name, collection|
          if collection.generate?
            count = 0
            collection.each do |document|
              site.pages << PrismicPage.new(site, site.source, document, collection.config)
              count += 1
              break if count >= collection.config['output_limit']
            end
          end
        end
      end
    end

    class PrismicPage < Page
      def initialize(site, base, document, config)
        @site = site
        @base = base
        @dir = config['output_dir']
        # Default file name, can be overwritten by permalink frontmatter setting
        @name = "#{document.slug}-#{document.id}.html"
        @document = document

        self.process(@name)
        self.read_yaml(File.join(base, "_layouts"), config['layout'])
        # Use the permalink collection setting if it is set
        self.data['permalink'] = config['permalink'] if config.key? 'permalink'
        self.data['document'] = document
      end

      def url_placeholders
        Utils.deep_merge_hashes({
          :slug => @document.slug,
          :id => @document.id,
          :uid => @document.uid,
          :type => @document.type
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
