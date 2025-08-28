# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'

describe Pawn do
  describe '#search_legal_moves' do
    context 'with white pawns' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }

      context 'when white pawn is not at its initial square' do
        context 'when front empty, black on the left and on the right' do
          it 'returns an array of in front, up-left and up-right squares' do
            current_square = 'b3'
            board = { 'a4' => double(color: opponent_color),
                      'b5' => ' ',
                      'b4' => ' ',
                      'c4' => double(color: opponent_color) }
            expected_array = %w[a4 b4 c4]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when front empty and black on the left' do
          it 'returns an array of in front and up-left squares' do
            current_square = 'f3'
            board = { 'e4' => double(color: opponent_color),
                      'f5' => ' ',
                      'f4' => ' ',
                      'g4' => ' ' }
            expected_array = %w[f4 e4]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when front empty and black on the right' do
          it 'returns an array of in front and up-right squares' do
            current_square = 'c5'
            board = { 'b6' => ' ',
                      'c7' => ' ',
                      'c6' => ' ',
                      'd6' => double(color: opponent_color) }
            expected_array = %w[c6 d6]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when black in front, on the right and on the left' do
          it 'returns an array of up-right and up-left squares' do
            current_square = 'd7'
            board = { 'c8' => double(color: opponent_color),
                      'd8' => double(color: opponent_color),
                      'e8' => double(color: opponent_color) }
            expected_array = %w[c8 e8]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when same-color piece is in front, on the right and on the left' do
          it 'returns an empty array' do
            current_square = 'g7'
            board = { 'f8' => double(color: color),
                      'g8' => double(color: color),
                      'h8' => double(color: color) }

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end

        context 'when front and diagonal squares are empty' do
          it 'returns an array with only the square in font' do
            current_square = 'f5'
            board = { 'f6' => ' ',
                      'f7' => ' ',
                      'e6' => ' ',
                      'g6' => ' ' }
            expected_array = %w[f6]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      # Special movement: 2 steps forward
      # Pawn has not yet made a move
      context 'when white pawn is at its initial square' do
        context 'when front empty, black on the left and on the right' do
          it 'returns an array of up-left, up-right and first two in front squares' do
            current_square = 'b2'
            board = { 'b3' => ' ',
                      'b4' => ' ',
                      'a3' => double(color: opponent_color),
                      'c3' => double(color: opponent_color) }
            expected_array = %w[a3 b3 c3 b4]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when second in front square empty, black in front, on the left and on the right' do
          it 'returns an array of up-left and up-right squares' do
            current_square = 'e2'
            board = { 'e3' => double(color: opponent_color),
                      'e4' => ' ',
                      'd3' => double(color: opponent_color),
                      'f3' => double(color: opponent_color) }
            expected_array = %w[d3 f3]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when front empty and black on the left' do
          it 'returns an array of in front and up-left squares' do
            current_square = 'c2'
            board = { 'c3' => ' ',
                      'c4' => ' ',
                      'b3' => double(color: opponent_color),
                      'd3' => ' ' }
            expected_array = %w[b3 c3 c4]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when only first square in front empty and black on the right' do
          it 'returns an array of first square in front and on the up-right' do
            current_square = 'a2'
            board = { 'a3' => ' ',
                      'a4' => double(color: color),
                      'b3' => double(color: opponent_color) }
            expected_array = %w[a3 b3]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when black is at first two squares in front, on the right and on the left' do
          it 'returns an array of up-right, up-left squares' do
            current_square = 'd2'
            board = { 'd3' => double(color: opponent_color),
                      'd4' => double(color: opponent_color),
                      'c3' => double(color: opponent_color),
                      'e3' => double(color: opponent_color) }
            expected_array = %w[c3 e3]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when same-color piece is at first two squares in front, on the right and on the left' do
          it 'returns an empty array' do
            current_square = 'f2'
            board = { 'f3' => double(color: color),
                      'f4' => double(color: color),
                      'e3' => double(color: color),
                      'g3' => double(color: color) }

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end

        context 'when front and diagonal squares are empty' do
          it 'returns an array of the first two squares in font' do
            current_square = 'g2'
            board = { 'g3' => ' ',
                      'g4' => ' ',
                      'f3' => ' ',
                      'h3' => ' ' }
            expected_array = %w[g3 g4]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      # Special movement: taking en-passant
      context 'when black pawn does double steps to the left' do
        context 'if black pawn was the last piece moved by its player' do
          it 'returns an array including the passed over square on the left' do
            current_square = 'e5'
            board = { 'd5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[d7 d5],
                                                      current_square: 'd5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }

            square_passed_over = 'd6'

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end

        context 'if black made another move after its pawn' do
          it 'returns an array not including the passed over square on the left' do
            current_square = 'e5'
            board = { 'd5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[d7 d5],
                                                      current_square: 'd5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)) }
            square_passed_over = 'd6'

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).not_to include(square_passed_over)
          end
        end
      end

      context 'when black pawn does double steps to the right' do
        context 'if black pawn was the last piece moved its player' do
          it 'returns an array including the passed over square on the right' do
            current_square = 'f5'
            board = { 'g5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[g7 g5],
                                                      current_square: 'g5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }
            square_passed_over = 'g6'

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end

        context 'if black made another move after its pawn' do
          it 'returns an array not including the passed over square on the left' do
            current_square = 'f5'
            board = { 'g5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[g7 g5],
                                                      current_square: 'g5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)) }
            square_passed_over = 'g6'

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).not_to include(square_passed_over)
          end
        end
      end

      context 'when black pawns made double steps to the right and left' do
        context 'if black pawn on the right was the last piece moved by its player' do
          it 'returns an array including the passed over square on the right' do
            current_square = 'b5'
            board = { 'a5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[a7 a5],
                                                      current_square: 'a5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)),
                      'c5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[c7 c5],
                                                      current_square: 'c5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }
            square_passed_over = 'c6'

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end

        context 'if black pawn on the left was the last piece moved by its player' do
          it 'returns an array including the passed over square on the left' do
            current_square = 'd5'
            board = { 'c5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[a7 a5],
                                                      current_square: 'a5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)),
                      'e5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[c7 c5],
                                                      current_square: 'c5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)) }

            square_passed_over = 'c6'

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end
      end
    end

    context 'with black pawns' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }

      context 'when black pawn is not at its initial square' do
        context 'when front empty, white on the left and on the right' do
          it 'returns an array of in front, up-left and up-right squares' do
            current_square = 'b6'
            board = { 'a5' => double(color: opponent_color),
                      'b4' => ' ',
                      'b5' => ' ',
                      'c5' => double(color: opponent_color) }
            expected_array = %w[a5 b5 c5]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when front empty and white on the left' do
          it 'returns an array of in front and up-left squares' do
            current_square = 'f6'
            board = { 'e5' => double(color: opponent_color),
                      'f4' => ' ',
                      'f5' => ' ',
                      'g5' => ' ' }
            expected_array = %w[f5 e5]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when front empty and white on the right' do
          it 'returns an array of in front and up-right squares' do
            current_square = 'c4'
            board = { 'b3' => ' ',
                      'c2' => ' ',
                      'c3' => ' ',
                      'd3' => double(color: opponent_color) }
            expected_array = %w[c3 d3]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when white in front, on the right and on the left' do
          it 'returns an array of up-right and up-left squares' do
            current_square = 'd2'
            board = { 'c1' => double(color: opponent_color),
                      'd1' => double(color: opponent_color),
                      'e1' => double(color: opponent_color) }
            expected_array = %w[c1 e1]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when same-color piece is in front, on the right and on the left' do
          it 'returns an empty array' do
            current_square = 'g2'
            board = { 'f1' => double(color: color),
                      'g1' => double(color: color),
                      'h1' => double(color: color) }

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end

        context 'when front and diagonal squares are empty' do
          it 'returns an array with only the square in font' do
            current_square = 'f4'
            board = { 'f3' => ' ',
                      'f2' => ' ',
                      'e3' => ' ',
                      'g3' => ' ' }
            expected_array = %w[f3]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      # Special movement: 2 steps forward
      # Pawn has not yet made a move
      context 'when black pawn is at its initial square' do
        context 'when front empty, white on the left and on the right' do
          it 'returns an array of up-left, up-right and first two in front squares' do
            current_square = 'b7'
            board = { 'b6' => ' ',
                      'b5' => ' ',
                      'a6' => double(color: opponent_color),
                      'c6' => double(color: opponent_color) }
            expected_array = %w[a6 b6 c6 b5]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when second in front square empty, white in front, on the left and on the right' do
          it 'returns an array of up-left and up-right squares' do
            current_square = 'e7'
            board = { 'e6' => double(color: opponent_color),
                      'e5' => ' ',
                      'd6' => double(color: opponent_color),
                      'f6' => double(color: opponent_color) }
            expected_array = %w[d6 f6]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when front empty and white on the left' do
          it 'returns an array of in front and up-left squares' do
            current_square = 'c7'
            board = { 'c6' => ' ',
                      'c5' => ' ',
                      'b6' => double(color: opponent_color),
                      'd6' => ' ' }
            expected_array = %w[b6 c6 c5]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when only first square in front empty and white on the right' do
          it 'returns an array of first square in front and on the up-right' do
            current_square = 'a7'
            board = { 'a6' => ' ',
                      'a5' => double(color: color),
                      'b6' => double(color: opponent_color) }
            expected_array = %w[a6 b6]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when white is at first two squares in front, on the right and on the left' do
          it 'returns an array of up-right, up-left squares' do
            current_square = 'd7'
            board = { 'd6' => double(color: opponent_color),
                      'd5' => double(color: opponent_color),
                      'c6' => double(color: opponent_color),
                      'e6' => double(color: opponent_color) }
            expected_array = %w[c6 e6]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end

        context 'when same-color piece is at first two squares in front, on the right and on the left' do
          it 'returns an empty array' do
            current_square = 'f7'
            board = { 'f6' => double(color: color),
                      'f5' => double(color: color),
                      'e6' => double(color: color),
                      'g6' => double(color: color) }

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end

        context 'when front and diagonal squares are empty' do
          it 'returns an array of the first two squares in font' do
            current_square = 'g7'
            board = { 'g6' => ' ',
                      'g5' => ' ',
                      'f6' => ' ',
                      'h6' => ' ' }
            expected_array = %w[g6 g5]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      # Special movement: taking en-passant
      context 'when white pawn does double steps to the left' do
        context 'if white pawn was the last piece moved by its player' do
          it 'returns an array including the passed over square on the left' do
            current_square = 'e4'
            board = { 'd4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[d2 d4],
                                                      current_square: 'd4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }

            square_passed_over = 'd3'

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end

        context 'if white made another move after its pawn' do
          it 'returns an array not including the passed over square on the left' do
            current_square = 'e4'
            board = { 'd4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[d2 d4],
                                                      current_square: 'd4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)) }
            square_passed_over = 'd3'

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).not_to include(square_passed_over)
          end
        end
      end

      context 'when white pawn does double steps to the right' do
        context 'if white pawn was the last piece moved its player' do
          it 'returns an array including the passed over square on the right' do
            current_square = 'f4'
            board = { 'g4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[g2 g4],
                                                      current_square: 'g4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }
            square_passed_over = 'g3'

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end

        context 'if white made another move after its pawn' do
          it 'returns an array not including the passed over square on the left' do
            current_square = 'f4'
            board = { 'g4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[g2 g4],
                                                      current_square: 'g4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)) }
            square_passed_over = 'g3'

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).not_to include(square_passed_over)
          end
        end
      end

      context 'when white pawns made double steps to the right and left' do
        context 'if white pawn on the right was the last piece moved by its player' do
          it 'returns an array including the passed over square on the right' do
            current_square = 'b4'
            board = { 'a4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[a2 a4],
                                                      current_square: 'a4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)),
                      'c4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[c2 c4],
                                                      current_square: 'c4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }
            square_passed_over = 'c3'

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end

        context 'if white pawn on the left was the last piece moved by its player' do
          it 'returns an array including the passed over square on the left' do
            current_square = 'd4'
            board = { 'c4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[a2 a4],
                                                      current_square: 'a4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)),
                      'e4' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[c2 c4],
                                                      current_square: 'c4',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: false)) }

            square_passed_over = 'c3'

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end
        end
      end
    end
  end
end
