# frozen_string_literal: true

require_relative '../scoped_matchers_spec'

RSpec.shared_examples '.set_up method' do
  include MyHelpers

  setup = described_class.set_up

  it 'return a hash of 64 movements (keys)' do
    expect(setup).to be_a_hash_of_size(64)
  end

  it 'expect all keys and values in the hash to be in the ranges a-h and 1-8' do
    pattern = /^[a-h][1-8]$/

    expect(setup).to all match(
      a_collection_containing_exactly(
        match(pattern),
        (be_an(Array).and all match(pattern))
      )
    )
  end

  it 'change movements class variable to the hash' do
    movements = described_class.class_variable_get(:@@movements)

    expect(movements).to eq(setup)
  end
end
