# frozen_string_literal: true

require_relative '../../lib/pieces/knight'
require_relative '../../lib/player'

RSpec.shared_examples 'a knight' do
  describe '#search_legal_moves' do
    context 'when knight is at b1' do
      context 'if d2 empty and opponent at a3 c3' do
        it 'returns array of squares: d2, a3, c3' do
          current_square = 'b1'
          board = { 'd2' => ' ',
                    'a3' => double(color: opponent_color),
                    'c3' => double(color: opponent_color) }
          expected_array = %w[d2 a3 c3]

          knight = described_class.new(color, current_square)
          knight.instance_variable_set(:@moves, knight.moves_from(current_square))
          legal_moves = knight.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when knight is at g1' do
      context 'if f3, h3 empty and same-color piece at e2' do
        it 'returns array of squares: f3, h3' do
          current_square = 'g1'
          board = { 'e2' => double(color: color),
                    'f3' => ' ',
                    'h3' => ' ' }
          expected_array = %w[f3 h3]

          knight = described_class.new(color, current_square)
          knight.instance_variable_set(:@moves, knight.moves_from(current_square))
          legal_moves = knight.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when knight is at b8' do
      context 'if c6 empty, opponent at a6 and same-color piece at d7' do
        it 'returns array of squares: a6, c6' do
          current_square = 'b8'
          board = { 'd7' => double(color: color),
                    'c6' => ' ',
                    'a6' => double(color: opponent_color) }
          expected_array = %w[a6 c6]

          knight = described_class.new(color, current_square)
          knight.instance_variable_set(:@moves, knight.moves_from(current_square))
          legal_moves = knight.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when knight is at g8' do
      context 'if same-color pieces at h6, f6, e7' do
        it 'returns an empty array' do
          current_square = 'g8'
          board = { 'e7' => double(color: color),
                    'h6' => double(color: color),
                    'f6' => double(color: color) }

          knight = described_class.new(color, current_square)
          knight.instance_variable_set(:@moves, knight.moves_from(current_square))
          legal_moves = knight.search_legal_moves(board)

          expect(legal_moves).to be_empty
        end
      end
    end

    context 'when knight is at e5' do
      context 'if e6, f5, c4, c6 empty, opponent at d5, f7, f3, d3
          and same-color at e4, d7, g6, g4' do
        it 'returns array of squares: f7, f3, d3, c4, c6' do
          current_square = 'e5'
          board = { 'e6' => ' ',
                    'f5' => ' ',
                    'e4' => double(color: color),
                    'd5' => double(color: opponent_color),
                    'd7' => double(color: color),
                    'f7' => double(color: opponent_color),
                    'g6' => double(color: color),
                    'g4' => double(color: color),
                    'f3' => double(color: opponent_color),
                    'd3' => double(color: opponent_color),
                    'c4' => ' ',
                    'c6' => ' ' }
          expected_array = %w[f7 f3 d3 c4 c6]

          knight = described_class.new(color, current_square)
          knight.instance_variable_set(:@moves, knight.moves_from(current_square))
          legal_moves = knight.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when knight is at a3' do
      context 'if b2 empty, opponent at c3, c4, b5 and same-color at b4, b1, c2' do
        it 'returns array of squares: c4, b5' do
          current_square = 'a3'
          board = { 'b2' => ' ',
                    'c3' => double(color: opponent_color),
                    'b4' => double(color: color),
                    'b1' => double(color: color),
                    'c2' => double(color: color),
                    'c4' => double(color: opponent_color),
                    'b5' => double(color: opponent_color) }
          expected_array = %w[c4 b5]

          knight = described_class.new(color, current_square)
          knight.instance_variable_set(:@moves, knight.moves_from(current_square))
          legal_moves = knight.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when knight is at h6' do
      context 'if g7, f6, g5, g8, f7 empty, opponent at f5, g8 and same-color g4' do
        it 'returns array of squares: g8, f7, f5' do
          current_square = 'h6'
          board = { 'g7' => ' ',
                    'f6' => ' ',
                    'g5' => ' ',
                    'g8' => double(color: opponent_color),
                    'f7' => ' ',
                    'f5' => double(color: opponent_color),
                    'g4' => double(color: color) }
          expected_array = %w[g8 f7 f5]

          knight = described_class.new(color, current_square)
          knight.instance_variable_set(:@moves, knight.moves_from(current_square))
          legal_moves = knight.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    context 'when knight is at e5' do
      let(:current_square) { 'e5' }

      context 'when legal moves are [d7, g6, g4, f3, c6]' do
        let(:legal_moves) { %w[d7 g6 g4 f3 c6] }

        context 'if king is in check at f8 by opponent night at d7' do
          it 'returns array of squares: d7' do
            knight = described_class.new(color, current_square, player)

            opponent = described_class.new(opponent_color, 'd7')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d7'))

            board = { 'd7' => opponent,
                      'f7' => ' ',
                      'f8' => instance_double('King', current_square: 'f8',
                                                      color: color,
                                                      is_a?: true),
                      'g6' => double(color: opponent_color, gives_check?: false),
                      'g4' => ' ',
                      'f3' => double(color: opponent_color, gives_check?: false),
                      'd3' => double(color: color),
                      'c4' => double(color: color),
                      'c6' => ' ',
                      'e5' => knight }

            expected_array = %w[d7]

            selected_legal_moves = knight.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at h3 by opponent knight at f4' do
          it 'returns empty array' do
            knight = described_class.new(color, current_square, player)

            opponent = described_class.new(opponent_color, 'f4')
            opponent.instance_variable_set(:@moves, opponent.moves_from('f4'))

            board = { 'f4' => opponent,
                      'h3' => instance_double('King', current_square: 'h3',
                                                      color: color,
                                                      is_a?: true),
                      'g6' => double(color: opponent_color, gives_check?: false),
                      'd7' => ' ',
                      'g4' => ' ',
                      'f3' => double(color: opponent_color, gives_check?: false),
                      'd3' => double(color: color),
                      'c4' => double(color: color),
                      'f7' => double(color: color),
                      'c6' => ' ',
                      'e5' => knight }

            selected_legal_moves = knight.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end

        context 'if king is not in check at h3 by opponent knight at h5' do
          it 'returns array of squares: d7 g6 g4 f3 c6' do
            knight = described_class.new(color, current_square, player)

            opponent = described_class.new(opponent_color, 'h5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('h5'))

            board = { 'h5' => opponent,
                      'h3' => instance_double('King', current_square: 'h3',
                                                      color: color,
                                                      is_a?: true),
                      'g6' => double(color: opponent_color, gives_check?: false),
                      'd7' => ' ',
                      'g4' => ' ',
                      'f3' => double(color: opponent_color, gives_check?: false),
                      'd3' => double(color: color),
                      'c4' => double(color: color),
                      'f7' => double(color: color),
                      'c6' => ' ',
                      'e5' => knight }

            expected_array = legal_moves

            selected_legal_moves = knight.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end
  end
end

describe Knight do
  KnightMovement.set_up

  let(:player) { Player.new('color', {}) }

  context 'with white knights' do
    it_behaves_like 'a knight' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }
    end
  end

  context 'with black knights' do
    it_behaves_like 'a knight' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }
    end
  end
end
