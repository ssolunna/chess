# frozen_string_literal: true

require_relative './shared_examples_movements_spec'
require_relative '../../lib/movements/queen_movement'

describe QueenMovement do
  describe '.set_up' do
    include_examples '.set_up method'
  end

  describe '#from' do
    let(:queen) { Class.new { extend QueenMovement } }

    context 'when current square is d1' do
      it 'returns an array of moves: e2, f3, g4, h5, d2, d3, d4, d5, d6, d7,
      d8, c2, b3, a4, a1, b1, c1, e1, f1, g1, h1' do
        current_square = 'd1'
        expected_moves = %w[e2 f3 g4 h5 d2 d3 d4 d5 d6 d7 d8 c2 b3 a4 a1 b1 c1 e1 f1 g1 h1]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is d8' do
      it 'returns an array of moves: e7, f6, g5, h4, d7, d6, d5, d4, d3, d2,
      d1, c7, b6, a5, a8, b8, c8, e8, f8, g8, h8' do
        current_square = 'd8'
        expected_moves = %w[e7 f6 g5 h4 d7 d6 d5 d4 d3 d2 d1 c7 b6 a5 a8 b8 c8 e8 f8 g8 h8]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h5' do
      it 'returns an array of moves: g6, f7, e8, g4, f3, e2, d1, g5, f5, e5,
      d5, c5, b5, a5, h6, h7, h8, h4, h3, h2, h1' do
        current_square = 'h5'
        expected_moves = %w[g6 f7 e8 g4 f3 e2 d1 g5 f5 e5 d5 c5 b5 a5 h6 h7 h8 h4 h3 h2 h1]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is a5' do
      it 'returns an array of moves: b6, c7, d8, b4, c3, d2, e1, b5, c5, d5,
      e5, f5, g5, h5, a6, a7, a8, a4, a3, a2, a1' do
        current_square = 'a5'
        expected_moves = %w[b6 c7 d8 b4 c3 d2 e1 b5 c5 d5 e5 f5 g5 h5 a6 a7 a8 a4 a3 a2 a1]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is d5' do
      it 'returns an array of moves: d6, d7, d8, d4, d3, d2, d1, e5, f5, g5,
      h5, c5, b5, a5, e6, f7, g8, e4, f3, g2, h1, c6, b7, a8, c4, b3, a2' do
        current_square = 'd5'
        expected_moves = %w[d6 d7 d8 d4 d3 d2 d1 e5 f5 g5 h5 c5 b5 a5 e6 f7 g8 e4 f3 g2 h1 c6 b7 a8 c4 b3 a2]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h8' do
      it 'returns an array of moves: h7, h6, h5, h4, h3, h2, h1, g8, f8, e8,
      d8, c8, b8, a8, g7, f6, e5, d4, c3, b2, a1' do
        current_square = 'h8'
        expected_moves = %w[h7 h6 h5 h4 h3 h2 h1 g8 f8 e8 d8 c8 b8 a8 g7 f6 e5 d4 c3 b2 a1]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is a1' do
      it 'returns an array of moves: b1, c1, d1, e1, f1, g1, h1, a2, a3, a4,
      a5, a6, a7, a8, b2, c3, d4, e5, f6, g7, h8' do
        current_square = 'a1'
        expected_moves = %w[b1 c1 d1 e1 f1 g1 h1 a2 a3 a4 a5 a6 a7 a8 b2 c3 d4 e5 f6 g7 h8]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end
  end
end
