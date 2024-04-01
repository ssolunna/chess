# frozen_string_literal: true

require_relative './shared_examples_movements_spec'
require_relative '../../lib/movements/bishop_movement'

describe BishopMovement do
  describe '.lay_out' do
    include_examples '.lay_out method'
  end

  describe '#from' do
    let(:bishop) { Class.new { extend BishopMovement } }
    let!(:setup) { described_class.set_up }

    context 'when current square is a1' do
      it 'returns an array of moves: b2, c3, d4, e5, f6, g7, h8' do
        current_square = 'a1'
        expected_moves = %w[b2 c3 d4 e5 f6 g7 h8]
        moves = bishop.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h1' do
      it 'returns an array of moves: g2, f3, e4, d5, c6, b7, a8' do
        current_square = 'h1'
        expected_moves = %w[g2 f3 e4 d5 c6 b7 a8]
        moves = bishop.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is d4' do
      it 'returns an array of moves: c5, b6, a7, e5, f6, g7, h8, c3, b2, a1, e3, f2, g1' do
        current_square = 'd4'
        expected_moves = %w[c5 b6 a7 e5 f6 g7 h8 c3 b2 a1 e3 f2 g1]
        moves = bishop.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h8' do
      it 'returns an array of moves: g7, f6, e5, d4, c3, b2, a1' do
        current_square = 'h8'
        expected_moves = %w[g7 f6 e5 d4 c3 b2 a1]
        moves = bishop.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is a8' do
      it 'returns an array of moves: b7, c6, d5, e4, f3, g2, h1' do
        current_square = 'a8'
        expected_moves = %w[b7 c6 d5 e4 f3 g2 h1]
        moves = bishop.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end
  end
end
