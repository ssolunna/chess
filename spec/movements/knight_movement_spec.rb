# frozen_string_literal: true

require_relative './shared_examples_movements_spec'
require_relative '../../lib/movements/knight_movement'

describe KnightMovement do
  describe '.lay_out' do
    include_examples '.lay_out method'
  end

  describe '#moves_from' do
    let(:knight) { Class.new { extend KnightMovement } }
    let!(:setup) { described_class.set_up }

    context 'when current square is b1' do
      it 'returns an array of moves: a3, c3, d2' do
        current_square = 'b1'
        expected_moves = %w[a3 c3 d2]
        moves = knight.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is g8' do
      it 'returns an array of moves: f6, h6, e7' do
        current_square = 'g8'
        expected_moves = %w[f6 h6 e7]
        moves = knight.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is d5' do
      it 'returns an array of moves: c7, e7, c3, e3, f6, f4, b6, b4' do
        current_square = 'd5'
        expected_moves = %w[c7 e7 c3 e3 f6 f4 b6 b4]
        moves = knight.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h4' do
      it 'returns an array of moves: g6, g2, f5, f3' do
        current_square = 'h4'
        expected_moves = %w[g6 g2 f5 f3]
        moves = knight.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is a5' do
      it 'returns an array of moves: b7, b3, c6, c4' do
        current_square = 'a5'
        expected_moves = %w[b7 b3 c6 c4]
        moves = knight.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is a8' do
      it 'returns an array of moves: c7, b6' do
        current_square = 'a8'
        expected_moves = %w[c7 b6]
        moves = knight.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'when current square is h1' do
      it 'returns an array of moves: g3, f2' do
        current_square = 'h1'
        expected_moves = %w[g3 f2]
        moves = knight.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end
  end
end
