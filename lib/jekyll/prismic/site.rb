module Jekyll
  # Add helper methods for dealing with Prismic to the Site class
  class Site
    def prismic
      Jekyll::Prismic::PrismicHelper.api
    end

    def prismic_collections
      if @config['prismic'] != nil and @config['prismic']['collections'] != nil
        @prismic_collections ||= Hash[@config['prismic']['collections'].map { |name, config| [name, Prismic::PrismicCollection.new(self, name, config)] }]
      else
        []
      end
    end

    def prismic_ref
      Jekyll::Prismic::PrismicHelper.ref
    end

    def prismic_link_resolver
      @prismic_link_resolver ||= ::Prismic.link_resolver prismic_ref do |link|
        if @config['prismic'] != nil and @config['prismic']['links'] != nil
          url = nil

          @config['prismic']['links'].each do |type, link_config|
            if (link.is_a? ::Prismic::Fragments::DocumentLink or link.is_a? ::Prismic::Document) and type == link.type
              url = Jekyll::URL.new(:template => link_config['permalink'], :placeholders => {
                :id => link.id,
                :uid => link.uid,
                :slug => link.slug,
                :type => link.type
              })
            end
          end

          url.to_s
        end
      end
    end

    def prismic_collection(collection_name)
      prismic_collections[collection_name]
    end
  end
end
