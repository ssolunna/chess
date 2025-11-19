# frozen_string_literal: true

require_relative '../../lib/pieces/queen'
require_relative '../../lib/player'

RSpec.shared_examples 'a queen' do
  describe '#search_legal_moves' do
    context 'when queen is at d1' do
      context 'if d2-d6, f3, g4, b3, e1 empty, same-color at e2, f1-h1, a1-c1
          and opponent at d7-d8, h5, c2, a4 ' do
        it 'returns array of squares: d2 to d7, c2' do
          current_square = 'd1'
          board = { 'd2' => ' ',
                    'd3' => ' ',
                    'd4' => ' ',
                    'd5' => ' ',
                    'd6' => ' ',
                    'd7' => double(color: opponent_color),
                    'd8' => double(color: opponent_color),
                    'e1' => ' ',
                    'f1' => double(color: color),
                    'g1' => double(color: color),
                    'h1' => double(color: color),
                    'a1' => double(color: color),
                    'b1' => double(color: color),
                    'c1' => double(color: color),
                    'e2' => double(color: color),
                    'f3' => ' ',
                    'g4' => ' ',
                    'h5' => double(color: opponent_color),
                    'c2' => double(color: opponent_color),
                    'b3' => ' ',
                    'a4' => double(color: opponent_color) }
          expected_array = %w[e1 d2 d3 d4 d5 d6 d7 c2]

          queen = described_class.new(color, current_square)
          legal_moves = queen.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when queen is at d8' do
      context 'if a8, b8, f8, b6, a5, f6, g5 empty, same-color at c8, e8, c7-e7
          and opponent at g8 h8, d6-d1, h4' do
        it 'returns an empty array' do
          current_square = 'd8'
          board = { 'a8' => ' ',
                    'b8' => ' ',
                    'c8' => double(color: color),
                    'e8' => double(color: color),
                    'f8' => ' ',
                    'g8' => double(color: opponent_color),
                    'h8' => double(color: opponent_color),
                    'e7' => double(color: color),
                    'f6' => ' ',
                    'g5' => ' ',
                    'h4' => double(color: opponent_color),
                    'c7' => double(color: color),
                    'b6' => ' ',
                    'a5' => ' ',
                    'd7' => double(color: color),
                    'd6' => double(color: opponent_color),
                    'd5' => double(color: opponent_color),
                    'd4' => double(color: opponent_color),
                    'd3' => double(color: opponent_color),
                    'd2' => double(color: opponent_color),
                    'd1' => double(color: opponent_color) }

          queen = described_class.new(color, current_square)
          legal_moves = queen.search_legal_moves(board)

          expect(legal_moves).to be_empty
        end
      end
    end

    context 'when queen is at d4' do
      context 'if d5-d8 e4 d3 c4 b4 f6 g1 empty, same-color at c5 e5 a7 d2-d1 f2
          and opponent at c3 e3 f4-h4 a4 b6 g7 h8 b2 a1' do
        it 'returns array of squares: d5-d8, e4, f4, e3, d3, c4, b4, a4, c3' do
          current_square = 'd4'
          board = { 'd5' => ' ',
                    'd6' => ' ',
                    'f3' => ' ',
                    'd7' => ' ',
                    'd8' => ' ',
                    'e5' => double(color: color),
                    'f6' => ' ',
                    'g7' => double(color: opponent_color),
                    'h8' => double(color: opponent_color),
                    'e4' => ' ',
                    'f4' => double(color: opponent_color),
                    'g4' => double(color: opponent_color),
                    'h4' => double(color: opponent_color),
                    'e3' => double(color: opponent_color),
                    'f2' => double(color: color),
                    'g1' => ' ',
                    'd3' => ' ',
                    'd2' => double(color: color),
                    'd1' => double(color: color),
                    'c3' => double(color: opponent_color),
                    'b2' => double(color: opponent_color),
                    'a1' => double(color: opponent_color),
                    'c4' => ' ',
                    'b4' => ' ',
                    'a4' => double(color: opponent_color),
                    'c5' => double(color: color),
                    'b6' => double(color: opponent_color),
                    'a7' => double(color: color) }
          expected_array = %w[d5 d6 d7 d8 e4 f4 e3 d3 c4 b4 a4 c3]

          queen = described_class.new(color, current_square)
          legal_moves = queen.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    context 'when queen is at f6' do
      let(:current_square) { 'f6' }

      context 'when legal moves are [g6, g7, e6, e5, d4, g5]' do
        let(:legal_moves) { %w[g6 g7 e6 e5 d4 g5] }

        context 'if king is in check at f7 by opponent queen at g6' do
          it 'returns array of squares: g6' do
            queen = described_class.new(color, current_square, player)

            opponent = described_class.new(opponent_color, 'g6')
            opponent.instance_variable_set(:@moves, opponent.moves_from('g6'))

            board = { 'g6' => opponent,
                      'f7' => instance_double('King', current_square: 'f7',
                                                      color: color,
                                                      is_a?: true),
                      'h6' => ' ',
                      'g7' => double(color: opponent_color, gives_check?: false),
                      'e7' => double(color: color),
                      'e6' => ' ',
                      'e5' => ' ',
                      'd4' => double(color: opponent_color, gives_check?: false),
                      'g5' => double(color: opponent_color, gives_check?: false),
                      'f5' => double(color: color),
                      'f6' => queen }

            expected_array = %w[g6]

            selected_legal_moves = queen.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at f7 by opponent queen at d5' do
          it 'returns array of squares: e6' do
            queen = described_class.new(color, current_square, player)

            opponent = described_class.new(opponent_color, 'd5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d5'))

            board = { 'd5' => opponent,
                      'f7' => instance_double('King', current_square: 'f7',
                                                      color: color,
                                                      is_a?: true),
                      'h6' => ' ',
                      'g7' => double(color: opponent_color, gives_check?: false),
                      'e7' => double(color: color),
                      'e6' => ' ',
                      'e5' => ' ',
                      'd4' => double(color: opponent_color, gives_check?: false),
                      'g5' => double(color: opponent_color, gives_check?: false),
                      'f5' => double(color: color),
                      'f6' => queen }

            expected_array = %w[e6]

            selected_legal_moves = queen.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at f7 by opponent queen at e8' do
          it 'returns an empty array' do
            queen = described_class.new(color, current_square, player)

            opponent = described_class.new(opponent_color, 'e8')
            opponent.instance_variable_set(:@moves, opponent.moves_from('e8'))

            board = { 'e8' => opponent,
                      'f7' => instance_double('King', current_square: 'f7',
                                                      color: color,
                                                      is_a?: true),
                      'h6' => ' ',
                      'g7' => double(color: opponent_color, gives_check?: false),
                      'e7' => double(color: color),
                      'e6' => ' ',
                      'e5' => ' ',
                      'd4' => double(color: opponent_color, gives_check?: false),
                      'g5' => double(color: opponent_color, gives_check?: false),
                      'f5' => double(color: color),
                      'f6' => queen }

            selected_legal_moves = queen.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end

        context 'if king is not in check at f7 by opponent queen at d7' do
          it 'returns array of squares: g6, g7, e6, e5, d4, g5' do
            queen = described_class.new(color, current_square, player)

            opponent = described_class.new(opponent_color, 'd7')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d7'))

            board = { 'd7' => opponent,
                      'f7' => instance_double('King', current_square: 'f7',
                                                      color: color,
                                                      is_a?: true),
                      'h6' => ' ',
                      'g7' => double(color: opponent_color, gives_check?: false),
                      'e7' => double(color: color),
                      'e6' => ' ',
                      'e5' => ' ',
                      'd4' => double(color: opponent_color, gives_check?: false),
                      'g5' => double(color: opponent_color, gives_check?: false),
                      'f5' => double(color: color),
                      'f6' => queen }

            expected_array = legal_moves

            selected_legal_moves = queen.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end
  end
end

describe Queen do
  QueenMovement.set_up

  let(:player) { Player.new('color', {}) }

  context 'with white queens' do
    it_behaves_like 'a queen' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }
    end
  end

  context 'with black queens' do
    it_behaves_like 'a queen' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }
    end
  end
end
