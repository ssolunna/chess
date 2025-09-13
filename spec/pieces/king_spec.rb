# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/queen'
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

  describe '#screen_legal_moves' do
    context 'when king is at f4' do
      let(:current_square) { 'f4' }

      context 'when legal moves are [e5, f5, g5, g4, g3, f3, e3, e4]' do
        let(:legal_moves) { %w[e5 f5 g5 g4 g3 f3 e3 e4] }

        context 'if king is in check at f4 by opponent queen at d6' do
          it 'returns array of squares: f5, g5, g4, f3, e3, e4' do
            king = described_class.new(color, current_square)

            opponent = Queen.new(opponent_color, 'd6')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d6'))

            board = { 'd6' => opponent,
                      'f4' => king,
                      'e5' => ' ',
                      'f5' => ' ',
                      'g5' => ' ',
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[f5 g5 g4 f3 e3 e4]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at f4 by opponent queen at f5' do
          it 'returns array of squares: f5 e3 g3' do
            king = described_class.new(color, current_square)

            opponent = Queen.new(opponent_color, 'f5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('f5'))

            board = { 'f4' => king,
                      'e5' => ' ',
                      'f5' => opponent,
                      'g5' => ' ',
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[f5 e3 g3]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is not in check at f4 by opponent queens at d5 and g6' do
          it 'returns array of squares: e3' do
            king = described_class.new(color, current_square)

            opponent = Queen.new(opponent_color, 'd5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d5'))

            opponent_two = Queen.new(opponent_color, 'g6')
            opponent_two.instance_variable_set(:@moves, opponent_two.moves_from('g6'))

            board = { 'd5' => opponent,
                      'g6' => opponent_two,
                      'f4' => king,
                      'e5' => ' ',
                      'f5' => ' ',
                      'g5' => ' ',
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[e3]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end

      context 'when legal moves are [e5, g5, g4, g3, f3, e3, e4]' do
        let(:legal_moves) { %w[e5 g5 g4 g3 f3 e3 e4] }

        context 'if king is in check at f4 by opponent queen at g5' do
          it 'returns array of squares: e5, g5, f3, e4' do
            king = described_class.new(color, current_square)

            opponent = Queen.new(opponent_color, 'g5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('g5'))

            board = { 'f4' => king,
                      'e5' => ' ',
                      'f5' => double(color: color),
                      'g5' => opponent,
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[e5 g5 f3 e4]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end

    context 'when king is at a1' do
      let(:current_square) { 'a1' }

      context 'when legal moves are [a2, b2, b1]' do
        let(:legal_moves) { %w[a2 b2 b1] }

        context 'if king is in check at a1 by opponent queen at c2
            but not in check by another opponent queen at b4' do
          it 'returns an empty array' do
            king = described_class.new(color, current_square)

            opponent = Queen.new(opponent_color, 'c2')
            opponent.instance_variable_set(:@moves, opponent.moves_from('c2'))

            opponent_two = Queen.new(opponent_color, 'b4')
            opponent_two.instance_variable_set(:@moves, opponent_two.moves_from('b4'))

            board = { 'c2' => opponent,
                      'b4' => opponent_two,
                      'a1' => king,
                      'a2' => ' ',
                      'a3' => ' ',
                      'b2' => ' ',
                      'b1' => ' ' }

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end
      end

      context 'when legal moves are [b1]' do
        let(:legal_moves) { %w[b1] }

        context 'if king is not in check at a1 by opponent queen at c2' do
          it 'returns an empty array' do
            king = described_class.new(color, current_square)

            opponent = Queen.new(opponent_color, 'c2')
            opponent.instance_variable_set(:@moves, opponent.moves_from('c2'))

            board = { 'c2' => opponent,
                      'a1' => king,
                      'a2' => double(color: color),
                      'a3' => ' ',
                      'b2' => double(color: color),
                      'c1' => double(color: color),
                      'b1' => ' ' }

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end
      end
    end
  end
end

describe King do
  let!(:setup) { KingMovement.set_up }
  let!(:setup_queen) { QueenMovement.set_up }

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
