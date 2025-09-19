# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/movements/rook_movement'
require_relative '../../lib/player'

RSpec.shared_examples 'a rook' do
  describe '#search_legal_moves' do
    context 'when rook is at a1' do
      context 'if a2-a6 empty, same-color at b1-h1 and opponent at a7 a8' do
        it 'returns array of squares: a2 to a7' do
          current_square = 'a1'
          board = { 'b1' => double(color: color),
                    'c1' => double(color: color),
                    'd1' => double(color: color),
                    'e1' => double(color: color),
                    'f1' => double(color: color),
                    'g1' => double(color: color),
                    'h1' => double(color: color),
                    'a2' => ' ',
                    'a3' => ' ',
                    'a4' => ' ',
                    'a5' => ' ',
                    'a6' => ' ',
                    'a7' => double(color: opponent_color),
                    'a8' => double(color: opponent_color) }
          expected_array = %w[a2 a3 a4 a5 a6 a7]

          rook = described_class.new(color, current_square)
          legal_moves = rook.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when rook is at h1' do
      context 'if h2-h6 empty, same-color at b1-h1, h2 and opponent at h7 h8' do
        it 'returns an empty array' do
          current_square = 'a1'
          board = { 'b1' => double(color: color),
                    'c1' => double(color: color),
                    'd1' => double(color: color),
                    'e1' => double(color: color),
                    'f1' => double(color: color),
                    'g1' => double(color: color),
                    'a1' => double(color: color),
                    'h2' => double(color: color),
                    'h3' => ' ',
                    'h4' => ' ',
                    'h5' => ' ',
                    'h6' => ' ',
                    'h7' => double(color: opponent_color),
                    'h8' => double(color: opponent_color) }

          rook = described_class.new(color, current_square)
          legal_moves = rook.search_legal_moves(board)

          expect(legal_moves).to be_empty
        end
      end
    end

    context 'when rook is at a8' do
      context 'if b2-h8, a7 a6 empty, same-color at a5 and opponent at a2 a1' do
        it 'returns array of squares: b8, c8, d8, e8, f8, g8, h8, a7, a6' do
          current_square = 'a8'
          board = { 'b8' => ' ',
                    'c8' => ' ',
                    'd8' => ' ',
                    'e8' => ' ',
                    'f8' => ' ',
                    'g8' => ' ',
                    'h8' => ' ',
                    'a7' => ' ',
                    'a6' => ' ',
                    'a5' => double(color: color),
                    'a4' => ' ',
                    'a3' => ' ',
                    'a2' => double(color: opponent_color),
                    'a1' => double(color: opponent_color) }
          expected_array = %w[b8 c8 d8 e8 f8 g8 h8 a7 a6]

          rook = described_class.new(color, current_square)
          legal_moves = rook.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when rook is at h8' do
      context 'if a2-g8, h7 h6 empty, same-color at h2 h1 and opponent at h5' do
        it 'returns array of squares: b8, c8, d8, e8, f8,
            g8, h7, h6, h5, h4, h3' do
          current_square = 'h8'
          board = { 'b8' => ' ',
                    'c8' => ' ',
                    'd8' => ' ',
                    'e8' => ' ',
                    'f8' => ' ',
                    'g8' => ' ',
                    'a8' => ' ',
                    'h7' => ' ',
                    'h6' => ' ',
                    'h5' => double(color: opponent_color),
                    'h4' => ' ',
                    'h3' => ' ',
                    'h2' => double(color: color),
                    'h1' => double(color: color) }
          expected_array = %w[a8 b8 c8 d8 e8 f8 g8 h7 h6 h5]

          rook = described_class.new(color, current_square)
          legal_moves = rook.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when rook is at d5' do
      context 'if d1-d2 d6-d8 h5 e5 b5 empty, same-color at d3 c5 a5
          and opponent at d4 f5 g5' do
        it 'returns array of squares: d6, d7, d8, e5 f5, d4' do
          current_square = 'd5'
          board = { 'd6' => ' ',
                    'd7' => ' ',
                    'd8' => ' ',
                    'e5' => ' ',
                    'f5' => double(color: opponent_color),
                    'g5' => double(color: opponent_color),
                    'h5' => ' ',
                    'd4' => double(color: opponent_color),
                    'd3' => double(color: color),
                    'd2' => ' ',
                    'd1' => ' ',
                    'c5' => double(color: color),
                    'b5' => ' ',
                    'a5' => double(color: color) }
          expected_array = %w[d6 d7 d8 e5 f5 d4]

          rook = described_class.new(color, current_square)
          legal_moves = rook.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    context 'when rook is at d5' do
      let(:current_square) { 'd5' }

      context 'when legal moves are [d6, d7, e5, d4, d3]' do
        let(:legal_moves) { %w[d6 d7 e5 d4 d3] }

        context 'if king is in check at f7 by opponent rook at d7' do
          it 'returns array of squares: d7' do
            rook = described_class.new(color, current_square)
            rook.instance_variable_set(:@player, player)

            opponent = described_class.new(opponent_color, 'd7')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d7'))

            board = { 'd7' => opponent,
                      'd6' => ' ',
                      'f7' => instance_double('King', current_square: 'f7',
                                                      color: color,
                                                      is_a?: true),
                      'd4' => ' ',
                      'd3' => double(color: opponent_color, gives_check?: false),
                      'e5' => double(color: opponent_color, gives_check?: false),
                      'c5' => double(color: color),
                      'e7' => ' ',
                      'd5' => rook }

            expected_array = %w[d7]

            selected_legal_moves = rook.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at f7 by opponent rook at c7' do
          it 'returns array of squares: d7' do
            rook = described_class.new(color, current_square)
            rook.instance_variable_set(:@player, player)

            opponent = described_class.new(opponent_color, 'c7')
            opponent.instance_variable_set(:@moves, opponent.moves_from('c7'))

            board = { 'c7' => opponent,
                      'd7' => ' ',
                      'd6' => ' ',
                      'f7' => instance_double('King', current_square: 'f7',
                                                      color: color,
                                                      is_a?: true),
                      'd4' => ' ',
                      'd3' => double(color: opponent_color, gives_check?: false),
                      'e5' => double(color: opponent_color, gives_check?: false),
                      'c5' => double(color: color),
                      'e7' => ' ',
                      'd5' => rook }

            expected_array = %w[d7]

            selected_legal_moves = rook.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at e6 by opponent rook at e8' do
          it 'returns an empty array' do
            rook = described_class.new(color, current_square)
            rook.instance_variable_set(:@player, player)

            opponent = described_class.new(opponent_color, 'e8')
            opponent.instance_variable_set(:@moves, opponent.moves_from('e8'))

            board = { 'e8' => opponent,
                      'e7' => ' ',
                      'd7' => ' ',
                      'd6' => ' ',
                      'e6' => instance_double('King', current_square: 'e6',
                                                      color: color,
                                                      is_a?: true),
                      'd4' => ' ',
                      'd3' => double(color: opponent_color, gives_check?: false),
                      'e5' => double(color: opponent_color, gives_check?: false),
                      'c5' => double(color: color),
                      'd5' => rook }

            selected_legal_moves = rook.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end

        context 'if king is not in check at e6 by opponent rook at e8' do
          it 'returns array of squares: d6, d7, e5, d4, d3' do
            rook = described_class.new(color, current_square)
            rook.instance_variable_set(:@player, player)

            opponent = described_class.new(opponent_color, 'e8')
            opponent.instance_variable_set(:@moves, opponent.moves_from('e8'))

            board = { 'e8' => opponent,
                      'e7' => double(color: color),
                      'd7' => ' ',
                      'd6' => ' ',
                      'e6' => instance_double('King', current_square: 'e6',
                                                      color: color,
                                                      is_a?: true),
                      'd4' => ' ',
                      'd3' => double(color: opponent_color, gives_check?: false),
                      'e5' => double(color: opponent_color, gives_check?: false),
                      'c5' => double(color: color),
                      'd5' => rook }

            expected_array = legal_moves

            selected_legal_moves = rook.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end
  end
end

describe Rook do
  let!(:setup) { RookMovement.set_up }
  let!(:player) { Player.new('color', {}) }

  context 'with white rooks' do
    it_behaves_like 'a rook' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }
    end
  end

  context 'with black rooks' do
    it_behaves_like 'a rook' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }
    end
  end
end
