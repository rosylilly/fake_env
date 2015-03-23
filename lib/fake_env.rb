require 'fake_env/version'

module FakeEnv
  class << self
    attr_reader :actual, :fake, :actual_get_method, :actual_set_method

    def activate!
      @actual = ENV.clone
      @fake = Hash.new do |fake, key|
        val = @actual[key]

        fake[key] = val ? val : val.clone
      end

      @actual_get_method ||= ENV.method(:[])
      @actual_set_method ||= ENV.method(:[]=)

      class << ENV
        def [](key)
          FakeEnv.fake[key]
        end

        def []=(key, val)
          FakeEnv.fake[key] = val.freeze
        end
      end
    end

    def deactivate!
      class << ENV
        define_method(:[], FakeEnv.actual_get_method)
        define_method(:[]=, FakeEnv.actual_set_method)
      end
    end

    def within
      activate!
      yield if block_given?
    ensure
      deactivate!
    end
  end
end
