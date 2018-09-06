require 'simplecov'            # These two lines must go first
SimpleCov.start do
  add_filter "/test/"
end

                               # You could require other shared gems here, too
                               # Sets up minitest

require 'minitest/autorun'
require 'minitest/pride'
