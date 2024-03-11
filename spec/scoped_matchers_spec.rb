module MyHelpers
  extend RSpec::Matchers::DSL

  RSpec::Matchers.define :be_a_hash_of_size do |expected|
    match do |hash|
      hash.is_a?(Hash) && hash.size == expected
    end
  end
end
