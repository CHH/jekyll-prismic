module Jekyll
  module Prismic
    class PrismicCollection
      attr_accessor :collection_name, :config

      def initialize(site, collection_name, config)
        @cache = []
        @site = site
        @collection_name = collection_name
        @config = config
        @config['output_dir'] = collection_name unless config.key? 'output_dir'
      end

      def generate?
        @config['output'] || false
      end

      def each
        if @cache.length > 0
          @cache.each { |v| yield v }
          return
        end

        queries = []
        queries << ::Prismic::Predicates::at('document.type', @config['type']) if @config['type']

        form = PrismicHelper.api.form(@config['form'] || "everything").ref(PrismicHelper.ref)

        if @config['query'] != nil and @config['query'].length > 0
          @config['query'].each do |query|
            queries << query
          end
        end

        form.query(*queries)

        if @config['orderings'] != nil
          form.orderings(@config['orderings'])
        end

        begin
          response = form.submit()

          begin
            response.results.each do |result|
              @cache << result
              yield result
            end
            response = form.page(response.next_page).submit() if response.next_page != nil
          end while response.next_page != nil
        rescue ::Prismic::SearchForm::FormSearchException => error
          Jekyll.logger.warn "prismic:collection:#{@collection_name}", "Not found"
        end
      end
    end
  end
end
