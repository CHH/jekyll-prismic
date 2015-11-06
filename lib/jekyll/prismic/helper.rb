module Jekyll
  module Prismic
    class PrismicHelper
      def self.config
        @@config ||= Jekyll.configuration()['prismic']
      end

      def self.api
        return if config == nil

        @@api ||= ::Prismic.api(config['endpoint'], config['access_token'])
      end

      def self.ref
        @@ref ||= api.refs[config['ref']] || api.master_ref
      end

      def self.find_document(id)
        @@document_cache ||= {}

        if @@document_cache.key? id
          return @@document_cache[id]
        end

        begin
          response = api.form('everything')
              .query(::Prismic::Predicates::at('document.id', id))
              .submit(ref)

          @@document_cache[id] = response.results.first
        rescue ::Prismic::SearchForm::FormSearchException
          nil
        end
      end
    end
  end
end
