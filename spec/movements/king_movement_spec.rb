# frozen_string_literal: true

require_relative '../scoped_matchers_spec'
require_relative './shared_examples_movements_spec'
require_relative '../../lib/movements/king_movement'

describe KingMovement do
  include MyHelpers

  describe '.lay_out' do
    let(:movements) { described_class.class_variable_get(:@@movements) }

    it 'returns a hash containing 64 king movements' do
      expect(described_class.lay_out).to be_a_hash_of_size(64)
    end

    it 'expects all movements to be between the ranges a-h and 1-8' do
      pattern = /^[a-h][1-8]$/

      expect(described_class.lay_out).to all match(
        a_collection_containing_exactly(
          match(pattern),
          (be_an(Array).and all match(pattern))
        )
      )
    end

    include_examples 'saves layout', {}
  end

  describe '#from' do
    let(:king) { Class.new { extend KingMovement } }
    let!(:layout) { described_class.lay_out }

    context 'when current square is e8' do
      it 'returns an array of moves: e7, d7, f7, d8, f8' do
        current_square = 'e8'
        expected_moves = %w[e7 d7 f7 d8 f8]
        moves = king.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is e1' do
      it 'returns an array of moves: e2, d2, f2, d1, f1' do
        current_square = 'e1'
        expected_moves = %w[e2 d2 f2 d1 f1]
        moves = king.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is d4' do
      it 'returns an array of moves: d5, c5, e5, d3, c3, e3, c4, e4' do
        current_square = 'd4'
        expected_moves = %w[d5 c5 e5 d3 c3 e3 c4 e4]
        moves = king.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is a8' do
      it 'returns an array of moves: a7, b7, b8' do
        current_square = 'a8'
        expected_moves = %w[a7 b7 b8]
        moves = king.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h1' do
      it 'returns an array of moves: h2, g2, g1' do
        current_square = 'h1'
        expected_moves = %w[h2 g2 g1]
        moves = king.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end
  end
end
