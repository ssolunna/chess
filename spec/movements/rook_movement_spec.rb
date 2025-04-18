# frozen_string_literal: true

require_relative './shared_examples_movements_spec'
require_relative '../../lib/movements/rook_movement'

describe RookMovement do
  describe '.lay_out' do
    include_examples '.lay_out method'
  end

  describe '#from' do
    let(:rook) { Class.new { extend RookMovement } }
    let!(:setup) { described_class.set_up }

    context 'when current square is a8' do
      it 'returns an array of moves: a7, a6, a5, a4, a3, a2, a1, b8, c8, d8, e8, f8, g8, h8' do
        current_square = 'a8'
        expected_moves = %w[a7 a6 a5 a4 a3 a2 a1 b8 c8 d8 e8 f8 g8 h8]
        moves = rook.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h1' do
      it 'returns an array of moves: h2, h3, h4, h5, h6, h7, h8, g1, f1, e1, d1, c1, b1, a1' do
        current_square = 'h1'
        expected_moves = %w[h2 h3 h4 h5 h6 h7 h8 g1 f1 e1 d1 c1 b1 a1]
        moves = rook.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is d4' do
      it 'returns an array of moves: d5, d6, d7, d8, d3, d2, d1, c4, b4, a4, e4, f4, g4, h4' do
        current_square = 'd4'
        expected_moves = %w[d5 d6 d7 d8 d3 d2 d1 c4 b4 a4 e4 f4 g4 h4]
        moves = rook.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h5' do
      it 'returns an array of moves: h6, h7, h8, h4, h3, h2, h1, g5, f5, e5, d5, c5, b5, a5' do
        current_square = 'h5'
        expected_moves = %w[h6 h7 h8 h4 h3 h2 h1 g5 f5 e5 d5 c5 b5 a5]
        moves = rook.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is a7' do
      it 'returns an array of moves: a8, a6, a5, a4, a3, a2, a1, b7, c7, d7, e7, f7, g7, h7' do
        current_square = 'a7'
        expected_moves = %w[a8 a6 a5 a4 a3 a2 a1 b7 c7 d7 e7 f7 g7 h7]
        moves = rook.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end
  end
end
