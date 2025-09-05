# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/movements/king_movement'

RSpec.shared_examples 'a king' do
  describe '#search_legal_moves' do
    context 'when king is at e1' do
      context 'if d2 empty, same-color at d1, e2, f1 and opponent at f2' do
        it 'returns array of squares: d2, f2' do
          current_square = 'e1'
          board = { 'd2' => ' ',
                    'e2' => double(color: color),
                    'f2' => double(color: opponent_color),
                    'd1' => double(color: color),
                    'f1' => double(color: color) }
          expected_array = %w[d2 f2]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when king is at e8' do
      context 'if d7, f7 empty, same-color piece at e7 and opponent at d8, f8' do
        it 'returns array of squares: d7, f7, d8, f8' do
          current_square = 'e8'
          board = { 'e7' => double(color: color),
                    'd7' => ' ',
                    'f7' => ' ',
                    'd8' => double(color: opponent_color),
                    'f8' => double(color: opponent_color) }
          expected_array = %w[d7 f7 d8 f8]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when king is at a8' do
      context 'if b8 empty, same-color at b7 and opponent at a7' do
        it 'returns array of squares: b8, a7' do
          current_square = 'a8'
          board = { 'b7' => double(color: color),
                    'b8' => ' ',
                    'a7' => double(color: opponent_color) }
          expected_array = %w[b8 a7]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when king is at h1' do
      context 'if same-color pieces at g1, g2, h2' do
        it 'returns an empty array' do
          current_square = 'h1'
          board = { 'g1' => double(color: color),
                    'g2' => double(color: color),
                    'h2' => double(color: color) }

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to be_empty
        end
      end
    end

    context 'when king is at e5' do
      context 'if e6, f5, f4, d6 empty, same-color at d5, f6
          and opponent at e4, d4' do
        it 'returns array of squares: e6, f5, f4, d6, e4, d4' do
          current_square = 'e5'
          board = { 'd6' => ' ',
                    'e6' => ' ',
                    'f6' => double(color: color),
                    'f5' => ' ',
                    'f4' => ' ',
                    'e4' => double(color: opponent_color),
                    'd4' => double(color: opponent_color),
                    'd5' => double(color: color) }
          expected_array = %w[e6 f5 f4 d6 e4 d4]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end
  end
end

describe King do
  let!(:setup) { KingMovement.set_up }

  context 'with white kings' do
    it_behaves_like 'a king' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }
    end
  end

  context 'with black kings' do
    it_behaves_like 'a king' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }
    end
  end
end
