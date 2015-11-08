module Jekyll
  module Prismic
    # Add Prismic Liquid variables to all templates
    Jekyll::Hooks.register :site, :pre_render do |site, payload|
      payload['site']['prismic'] = PrismicDrop.new(site)
    end

    Jekyll::Hooks.register :site, :after_reset do |site|
      #site.prismic.cache.invalidate_all!
    end
  end
end
