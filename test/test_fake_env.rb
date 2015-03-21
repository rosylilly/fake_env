require 'minitest_helper'

class TestFakeEnv < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FakeEnv::VERSION
  end

  def test_fake_env
    old_env = ENV['RAILS_ENV']

    FakeEnv.activate!

    ENV['RAILS_ENV'] = 'development'
    assert_equal 'development', ENV['RAILS_ENV']

    FakeEnv.deactivate!

    assert_equal old_env, ENV['RAILS_ENV']
  end

  def test_within_and_append
    ENV['TEST_STRING'] = 'hello'

    FakeEnv.within do
      ENV['TEST_STRING'] += ', world'

      assert_equal 'hello, world', ENV['TEST_STRING']
    end

    assert_equal 'hello', ENV['TEST_STRING']
  end
end
