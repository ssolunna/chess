# frozen_string_literal: true

require_relative '../scoped_matchers_spec'

RSpec.shared_examples ".lay_out method" do
  include MyHelpers

  it 'returns a hash of 64 movements (hash keys)' do
    expect(described_class.lay_out).to be_a_hash_of_size(64)
  end

  it 'expects all keys and values to be between the ranges a-h and 1-8' do
    pattern = /^[a-h][1-8]$/

    expect(described_class.lay_out).to all match(
      a_collection_containing_exactly(
        match(pattern),
        (be_an(Array).and all match(pattern))
      )
    )
  end
end
