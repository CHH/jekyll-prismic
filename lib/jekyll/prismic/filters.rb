module Jekyll
  module Prismic
    module PrismicFilter
      def prismic_document(input)
        document = PrismicHelper.find_document(input)
        PrismicDocumentDrop.new(document, @context.registers[:site].prismic_link_resolver)
      end

      # Uses the link resolver to link to a document
      def prismic_link_to(input)
        site = @context.registers[:site]

        if input.is_a? PrismicDocumentDrop
            return site.prismic_link_resolver.link_to(input.document)
        end

        input.url if input.respond_to? :url
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Prismic::PrismicFilter)
