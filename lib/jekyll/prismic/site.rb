module Jekyll
  # Add helper methods for dealing with Prismic to the Site class
  class Site
    def prismic
      return nil unless has_prismic?

      @prismic_api ||= ::Prismic.api(@config['prismic']['endpoint'], {
        :access_token => @config['prismic']['access_token'],
        :cache => ::Prismic::BasicNullCache.new
      })
    end

    def prismic_collections
      return Array.new unless has_prismic_collections?
      @prismic_collections ||= Hash[@config['prismic']['collections'].map { |name, config| [name, Prismic::PrismicCollection.new(self, name, config)] }]
    end

    def has_prismic?
      @config['prismic'] != nil
    end

    def has_prismic_collections?
      has_prismic? and @config['prismic']['collections'] != nil
    end

    def prismic_ref
      @prismic_ref ||= prismic.refs[@config['prismic']['ref']] || prismic.master_ref
    end

    def prismic_document(id)
      begin
        response = prismic.form('everything')
          .query(::Prismic::Predicates::at('document.id', id))
          .submit(prismic_ref)

        response.results.first
      rescue ::Prismic::SearchForm::FormSearchException
        nil
      end
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
