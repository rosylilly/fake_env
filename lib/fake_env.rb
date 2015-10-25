require 'thread'
require 'fake_env/version'

module FakeEnv
  class << self
    attr_reader :actual

    def activate!
      @actual = ENV.to_h
    end

    def deactivate!
      ENV.replace(@actual)
    end

    def within
      activate!
      yield if block_given?
    ensure
      deactivate!
    end
  end
end
