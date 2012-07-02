ActionView::Helpers::CacheHelper.module_eval do
  private

  # TODO: Create an object that has caching read/write on it
  def fragment_for(name = {}, options = nil, &block) #:nodoc:
    if (fragment = controller.read_fragment(name, options, &block))
      fragment
    else
      # VIEW TODO: Make #capture usable outside of ERB
      # This dance is needed because Builder can't use capture
      pos = output_buffer.length
      yield
      output_safe = output_buffer.html_safe?
      fragment = output_buffer.slice!(pos..-1)
      if output_safe
        self.output_buffer = output_buffer.class.new(output_buffer)
      end
      controller.write_fragment(name, fragment, options)
    end
  end
end

ActionController::Caching::Fragments.module_eval do
  # Reads a cached fragment from the location signified by <tt>key</tt>
  # (see <tt>expire_fragment</tt> for acceptable formats).
  def read_fragment(key, options = nil, &block)
    return unless cache_configured?

    key = fragment_cache_key(key)
    instrument_fragment_cache :read_fragment, key do
      result = cache_store.read(key, options, &block)
      result.respond_to?(:html_safe) ? result.html_safe : result
    end
  end
end
