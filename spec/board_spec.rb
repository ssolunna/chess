# frozen_string_literal: true

require_relative '../lib/board'
require_relative './scoped_matchers_spec'

describe Board do
  let(:empty_square) { ' ' }

  describe '#initialize' do
    it 'creates the chessboard layout' do
      pattern = /^[a-h][1-8]$/

      expect(subject.chessboard)
        .to (be_a_hash_of_size(64)) &
            (all match(a_collection_containing_exactly(match(pattern), empty_square)))
    end
  end
end
