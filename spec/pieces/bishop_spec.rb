# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative '../../lib/movements/bishop_movement'

RSpec.shared_examples 'a bishop' do
  describe '#search_legal_moves' do
    context 'when bishop is at c1' do
      context 'if a3 d2 e3 g5 h6 empty, same-color at b2 and opponent at f4' do
        it 'returns array of squares: d2, e3, f4' do
          current_square = 'c1'
          board = { 'b2' => double(color: color),
                    'a3' => ' ',
                    'd2' => ' ',
                    'e3' => ' ',
                    'f4' => double(color: opponent_color),
                    'g5' => ' ',
                    'h6' => ' ' }
          expected_array = %w[d2 e3 f4]

          bishop = described_class.new(color, current_square)
          legal_moves = bishop.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when bishop is at f1' do
      context 'if d3 b5 a6 empty, same-color at e2 g2 and opponent at h3 c4' do
        it 'returns an empty array' do
          current_square = 'f1'
          board = { 'g2' => double(color: color),
                    'h3' => double(color: opponent_color),
                    'e2' => double(color: color),
                    'd3' => ' ',
                    'c4' => double(color: opponent_color),
                    'b5' => ' ',
                    'a6' => ' ' }

          bishop = described_class.new(color, current_square)
          legal_moves = bishop.search_legal_moves(board)

          expect(legal_moves).to be_empty
        end
      end
    end

    context 'when bishop is at c8' do
      context 'if b7 a6 d7 e6 f5 g4 h3 empty' do
        it 'returns array of squares: b7, a6, d7, e6, f5, g4, h3' do
          current_square = 'c8'
          board = { 'b7' => ' ',
                    'a6' => ' ',
                    'd7' => ' ',
                    'e6' => ' ',
                    'f5' => ' ',
                    'g4' => ' ',
                    'h3' => ' ' }
          expected_array = %w[b7 a6 d7 e6 f5 g4 h3]

          bishop = described_class.new(color, current_square)
          legal_moves = bishop.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when bishop is at f8' do
      context 'if e7 h6 d6 c5 a3 empty, same-color at b4 and opponent at g7' do
        it 'returns array of squares: g7, e7, d6, c5' do
          current_square = 'f8'
          board = { 'g7' => double(color: opponent_color),
                    'h6' => ' ',
                    'e7' => ' ',
                    'd6' => ' ',
                    'c5' => ' ',
                    'b4' => double(color: color),
                    'a3' => ' ' }
          expected_array = %w[g7 e7 d6 c5]

          bishop = described_class.new(color, current_square)
          legal_moves = bishop.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when bishop is at e4' do
      context 'if f3 c2 h7 d5 c6 empty, same-color at g2 h1 b1 f5
          and opponent at d3 g6 b7 a8' do
        it 'returns array of squares: f3, d3, d5, c6, b7' do
          current_square = 'e4'
          board = { 'f3' => ' ',
                    'g2' => double(color: color),
                    'h1' => double(color: color),
                    'd3' => double(color: opponent_color),
                    'c2' => ' ',
                    'b1' => double(color: color),
                    'f5' => double(color: color),
                    'g6' => double(color: opponent_color),
                    'h7' => ' ',
                    'd5' => ' ',
                    'c6' => ' ',
                    'b7' => double(color: opponent_color),
                    'a8' => double(color: opponent_color) }
          expected_array = %w[f3 d3 d5 c6 b7]

          bishop = described_class.new(color, current_square)
          legal_moves = bishop.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    context 'when bishop is at b5' do
      let(:current_square) { 'b5' }

      context 'when legal moves are [a6, c4, d3, c6, d7]' do
        let(:legal_moves) { %w[a6 c4 d3 c6 d7] }

        context 'if king is in check at f5 by opponent bishop at d3' do
          it 'returns array of squares: d3' do
            bishop = described_class.new(color, current_square)

            opponent = described_class.new(opponent_color, 'd3')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d3'))

            board = { 'd3' => opponent,
                      'f5' => instance_double('King', current_square: 'f5',
                                                      color: color,
                                                      is_a?: true),
                      'a6' => double(color: opponent_color, gives_check?: false),
                      'c4' => ' ',
                      'e4' => ' ',
                      'd7' => double(color: opponent_color, gives_check?: false),
                      'c6' => ' ',
                      'e2' => double(color: color),
                      'f1' => ' ',
                      'b5' => bishop }

            expected_array = %w[d3]

            selected_legal_moves = bishop.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at e6 by opponent bishop at c8' do
          it 'returns array of squares: d7' do
            bishop = described_class.new(color, current_square)

            opponent = described_class.new(opponent_color, 'c8')
            opponent.instance_variable_set(:@moves, opponent.moves_from('c8'))

            board = { 'c8' => opponent,
                      'e6' => instance_double('King', current_square: 'e6',
                                                      color: color,
                                                      is_a?: true),
                      'a6' => double(color: opponent_color, gives_check?: false),
                      'c4' => ' ',
                      'd7' => ' ',
                      'd3' => ' ',
                      'c6' => ' ',
                      'e2' => double(color: color),
                      'f1' => ' ',
                      'b5' => bishop }

            expected_array = %w[d7]

            selected_legal_moves = bishop.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at e6 by opponent bishop at g8' do
          it 'returns an empty array' do
            bishop = described_class.new(color, current_square)

            opponent = described_class.new(opponent_color, 'g8')
            opponent.instance_variable_set(:@moves, opponent.moves_from('g8'))

            board = { 'f7' => ' ',
                      'g8' => opponent,
                      'e6' => instance_double('King', current_square: 'e6',
                                                      color: color,
                                                      is_a?: true),
                      'a6' => double(color: opponent_color, gives_check?: false),
                      'c4' => ' ',
                      'd7' => double(color: opponent_color, gives_check?: false),
                      'c6' => ' ',
                      'e2' => double(color: color),
                      'f1' => ' ',
                      'd3' => ' ',
                      'b5' => bishop }

            selected_legal_moves = bishop.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end

        context 'if king is not in check at e6 by opponent bishop at g8' do
          it 'returns array of squares: a6, c4, c6, d3, d7' do
            bishop = described_class.new(color, current_square)

            opponent = described_class.new(opponent_color, 'g8')
            opponent.instance_variable_set(:@moves, opponent.moves_from('g8'))

            board = { 'd3' => ' ',
                      'g8' => opponent,
                      'e6' => instance_double('King', current_square: 'e6',
                                                      color: color,
                                                      is_a?: true),
                      'a6' => double(color: opponent_color, gives_check?: false),
                      'c4' => ' ',
                      'd7' => double(color: opponent_color, gives_check?: false),
                      'c6' => ' ',
                      'e2' => double(color: color),
                      'f7' => double(color: color),
                      'f1' => ' ',
                      'b5' => bishop }

            expected_array = legal_moves

            selected_legal_moves = bishop.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end
  end
end

describe Bishop do
  let!(:setup) { BishopMovement.set_up }

  context 'with white bishops' do
    it_behaves_like 'a bishop' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }
    end
  end

  context 'with black bishops' do
    it_behaves_like 'a bishop' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }
    end
  end
end
