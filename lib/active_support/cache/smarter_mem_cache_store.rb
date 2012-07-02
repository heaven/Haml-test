require "cache_patch"

module ActiveSupport
  module Cache
    class SmarterMemCacheStore < MemCacheStore

      alias_method :orig_read, :read
      alias_method :orig_write, :write

      def read(key, options = nil, &block)
        data, expires_at = orig_read(key, options)
        return nil if data.nil?

        if Time.now > expires_at and not exist?("lock_#{key}")
          return nil unless block_given?

          orig_write("lock_#{key}", true)

          Thread.new do
            begin
              context = eval("self", block.binding)
              value = context.capture(&block)
              write(key, value, options)
            rescue
              debugger
              nil

              # $! => NoMethodError: undefined method `capture_position=' for nil:NilClass
              # But work ok outside of a new thread
              # Try to comment "Thread.new" do and "end", it works, but then it's not async
            ensure
              delete("lock_#{key}")
            end
          end
        end

        data
      end

      def write(key, value, options = nil)
        expires_delta = options.delete(:expires_delta) if !options.nil?
        expires_delta ||= 60

        package = [value, Time.now + expires_delta]
        orig_write(key, package, options)
        delete("lock_#{key}")
      end
    end
  end
end
