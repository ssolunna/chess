# frozen_string_literal: true

require_relative './shared_examples_movements_spec'
require_relative '../../lib/movements/queen_movement'

describe QueenMovement do
  describe '.lay_out' do
    include_examples '.lay_out method'
  end

  describe '#from' do
    let(:queen) { Class.new { extend QueenMovement } }
    let!(:setup) { described_class.set_up }

    context 'when current square is d1' do
      it 'returns an array of moves: e2, f3, g4, h5, d2, d3, d4, d5, d6, d7, d8, c2, b3, a4, a1, b1, c1, e1, f1, g1, h1' do
        current_square = 'd1'
        expected_moves = %w[e2 f3 g4 h5 d2 d3 d4 d5 d6 d7 d8 c2 b3 a4 a1 b1 c1 e1 f1 g1 h1]
        moves = queen.moves_from(current_square)
        expect(moves).to match_array(expected_moves)
      end
    end
  end
end
