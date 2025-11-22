# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/player'

describe Pawn do
  describe '#search_legal_moves' do
    context 'with white pawns' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }

      context 'when current square is a8' do
        current_square = 'a8'

        context 'if b8 empty' do
          it 'returns an empty array' do
            board = { 'b8' => ' ' }

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end

        context 'if black at b8' do
          it 'returns an empty array' do
            board = { 'b8' => double(color: opponent_color) }

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end
      end

      context 'when current square is b3' do
        context 'if b4, b5 empty and black at a4, c4' do
          it 'returns array of squares: a4, b4, c4' do
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
      end

      context 'when current square is f3' do
        context 'if f4, f4, g4 empty and black at e4' do
          it 'returns array of squares: f4, e4' do
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
      end

      context 'when current square is c5' do
        context 'if c6, c7, b6 empty and black at d6' do
          it 'returns array of squares: c6, d6' do
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
      end

      context 'when current square is d7' do
        context 'if black at d8, c8, e8' do
          it 'returns array of squares: c8, e8' do
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
      end

      context 'when current square is g7' do
        context 'if same-color pieces at g8, f8, h8' do
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
      end

      context 'when current square is f5' do
        context 'if f6, f7, e6, g6 empty' do
          it 'returns array of squares: f6' do
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
      # Only available when Pawn has not moved yet
      # It is at its initial square
      context 'when current square is b2' do
        context 'if b3, b4 empty and black at a3, c3' do
          it 'returns array of squares: a3, b3, c3, b4' do
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
      end

      context 'when current square is e2' do
        context 'if e4 empty and black at e3, d3, f3' do
          it 'returns array of squares: d3, f3' do
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
      end

      context 'when current square is c2' do
        context 'if c3, c4, d3 empty and black at b3' do
          it 'returns array of squares: b3, c3, c4' do
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
      end

      context 'when current square is a2' do
        context 'if a3 empty, black at b3 and same-color piece at a4' do
          it 'returns array of squares: a3, b3' do
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
      end

      context 'when current square is d2' do
        context 'if black at d3, d4, c3, e3' do
          it 'returns array of squares: c3, e3' do
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
      end

      context 'when current square is f2' do
        context 'if same-color pieces at f3, f4, e3, g3' do
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
      end

      context 'when current square is g2' do
        context 'if g3, g4, f3, h3 empty' do
          it 'returns array of squares: g3, g4' do
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

      context 'when current square is h2' do
        context 'if h3 empty, black at h4 and same-color piece at g3' do
          it 'returns array of squares: h3' do
            current_square = 'h2'
            board = { 'h3' => ' ',
                      'h4' => double(color: opponent_color),
                      'g3' => double(color: color) }
            expected_array = %w[h3]

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      # Special movement: taking en-passant
      context 'when current square is e5' do
        current_square = 'e5'

        context 'if black pawn is at d5 after double stepping' do
          square_passed_over = 'd6'

          it 'returns an array including d6' do
            board = { 'd5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[d7 d5],
                                                      current_square: 'd5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end

          context 'if black pawn was not the last piece moved by its player' do
            it 'should not include d6' do
              board = { 'd5' => instance_double('Pawn', color: opponent_color,
                                                        moves_log: %w[d7 d5],
                                                        current_square: 'd5',
                                                        is_a?: true,
                                                        player: instance_double('Player', last_touched_piece?: false)) }

              white_pawn = described_class.new(color, current_square)
              legal_moves = white_pawn.search_legal_moves(board)

              expect(legal_moves).not_to include(square_passed_over)
            end
          end
        end
      end

      context 'when current square if f5' do
        current_square = 'f5'

        context 'if black pawn is at g5 after double stepping' do
          square_passed_over = 'g6'

          it 'returns an array including g6' do
            board = { 'g5' => instance_double('Pawn', color: opponent_color,
                                                      moves_log: %w[g7 g5],
                                                      current_square: 'g5',
                                                      is_a?: true,
                                                      player: instance_double('Player', last_touched_piece?: true)) }

            white_pawn = described_class.new(color, current_square)
            legal_moves = white_pawn.search_legal_moves(board)

            expect(legal_moves).to include(square_passed_over)
          end

          context 'if black pawn was not the last piece moved by its player' do
            it 'should not include g6' do
              board = { 'g5' => instance_double('Pawn', color: opponent_color,
                                                        moves_log: %w[g7 g5],
                                                        current_square: 'g5',
                                                        is_a?: true,
                                                        player: instance_double('Player', last_touched_piece?: false)) }

              white_pawn = described_class.new(color, current_square)
              legal_moves = white_pawn.search_legal_moves(board)

              expect(legal_moves).not_to include(square_passed_over)
            end
          end
        end
      end

      context 'when current square is b5' do
        current_square = 'b5'

        context 'when black pawns are at a5 and c5 after double stepping' do
          context 'if black pawn at c5 was the last piece moved by its player' do
            square_passed_over = 'c6'

            it 'returns an array including c6' do
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

              white_pawn = described_class.new(color, current_square)
              legal_moves = white_pawn.search_legal_moves(board)

              expect(legal_moves).to include(square_passed_over)
            end
          end

          context 'if black pawn at a5 was the last piece moved by its player' do
            square_passed_over = 'a6'

            it 'returns an array including a6' do
              board = { 'a5' => instance_double('Pawn', color: opponent_color,
                                                        moves_log: %w[a7 a5],
                                                        current_square: 'a5',
                                                        is_a?: true,
                                                        player: instance_double('Player', last_touched_piece?: true)),
                        'c5' => instance_double('Pawn', color: opponent_color,
                                                        moves_log: %w[c7 c5],
                                                        current_square: 'c5',
                                                        is_a?: true,
                                                        player: instance_double('Player', last_touched_piece?: false)) }

              white_pawn = described_class.new(color, current_square)
              legal_moves = white_pawn.search_legal_moves(board)

              expect(legal_moves).to include(square_passed_over)
            end
          end
        end
      end
    end

    context 'with black pawns' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }

      context 'when current square is a1' do
        current_square = 'a1'

        context 'if b1 empty' do
          it 'returns an empty array' do
            board = { 'b1' => ' ' }

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end

        context 'if white at b1' do
          it 'returns an empty array' do
            board = { 'b1' => double(color: opponent_color) }

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end
      end

      context 'when current square is b6' do
        context 'if b4, b5 empty and white at a5, c5' do
          it 'returns array of squares: a4, b5, c4' do
            current_square = 'b6'
            board = { 'a5' => double(color: opponent_color),
                      'b5' => ' ',
                      'b4' => ' ',
                      'c5' => double(color: opponent_color) }
            expected_array = %w[a5 b5 c5]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      context 'when current square is f6' do
        context 'if f4, f5, g5 empty and white at e5' do
          it 'returns array of squares: f5, e5' do
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
      end

      context 'when current square is c4' do
        context 'if c3, c2, b3 empty and white at d3' do
          it 'returns array of squares: c3, d3' do
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
      end

      context 'when current square is d2' do
        context 'if white at d1, c1, e1' do
          it 'returns array of squares: c1, e1' do
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
      end

      context 'when current square is g2' do
        context 'if same-color pieces at g1, f1, h1' do
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
      end

      context 'when current square is f4' do
        context 'if f3, f2, e3, g3 empty' do
          it 'returns array of squares: f3' do
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
      # Only available when Pawn has not moved yet
      # It is at its initial square
      context 'when current square is b7' do
        context 'if b6, b5 empty and white at a6, c6' do
          it 'returns array of squares: a6, b6, c6, b5' do
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
      end

      context 'when current square is e7' do
        context 'if e5 empty and white at e6, d6, f6' do
          it 'returns array of squares: d6, f6' do
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
      end

      context 'when current square is c7' do
        context 'if c6, c5, d6 empty and white at b6' do
          it 'returns array of squares: b6, c6, c5' do
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
      end

      context 'when current square is a7' do
        context 'if a6 empty, white at b6 and same-color piece at a5' do
          it 'returns array of squares: a6, b6' do
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
      end

      context 'when current square is d7' do
        context 'if white at d6, d5, c6, e6' do
          it 'returns array of squares: c6, e6' do
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
      end

      context 'when current square is f7' do
        context 'if same-color pieces at f6, f5, e6, g6' do
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
      end

      context 'when current square is g7' do
        context 'if g6, g5, f6, h6 empty' do
          it 'returns array of squares: g6, g5' do
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

      context 'when current square is h7' do
        context 'if h6 empty, white at h5 and same-color piece at g6' do
          it 'returns array of squares: h6' do
            current_square = 'h7'
            board = { 'h6' => ' ',
                      'h5' => double(color: opponent_color),
                      'g6' => double(color: color) }
            expected_array = %w[h6]

            black_pawn = described_class.new(color, current_square)
            legal_moves = black_pawn.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      # Special movement: taking en-passant
      context 'when current square is e4' do
        current_square = 'e4'

        context 'if white pawn is at d4 after double stepping' do
          it 'returns an array including d3' do
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

          context 'if white pawn was not the last piece moved by its player' do
            it 'should not include d3' do
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
      end

      context 'when current square is f4' do
        current_square = 'f4'

        context 'if white pawn is at g4 after double stepping' do
          it 'returns an array including g3' do
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

          context 'if white pawn was not the last piece moved by its player' do
            it 'should not include g3' do
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
      end

      context 'when current square is b4' do
        current_square = 'b4'

        context 'when white pawns are at a4 and c4 after double stepping' do
          context 'if white pawn at c4 was the last piece moved by its player' do
            square_passed_over = 'c3'

            it 'returns an array including c3' do
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

              black_pawn = described_class.new(color, current_square)
              legal_moves = black_pawn.search_legal_moves(board)

              expect(legal_moves).to include(square_passed_over)
            end
          end

          context 'if white pawn at a4 was the last piece moved by its player' do
            square_passed_over = 'a3'

            it 'returns an array including a3' do
              board = { 'a4' => instance_double('Pawn', color: opponent_color,
                                                        moves_log: %w[a2 a4],
                                                        current_square: 'a4',
                                                        is_a?: true,
                                                        player: instance_double('Player', last_touched_piece?: true)),
                        'c4' => instance_double('Pawn', color: opponent_color,
                                                        moves_log: %w[c2 c4],
                                                        current_square: 'c4',
                                                        is_a?: true,
                                                        player: instance_double('Player', last_touched_piece?: false)) }

              black_pawn = described_class.new(color, current_square)
              legal_moves = black_pawn.search_legal_moves(board)

              expect(legal_moves).to include(square_passed_over)
            end
          end
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    let(:player) { Player.new(color, {}) }
    let(:opponent_player) { Player.new(opponent_color, {}) }

    context 'with white pawns' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }

      context 'when current square is d2' do
        let(:current_square) { 'd2' }

        context 'when legal moves are [d3, d4, e3, c3]' do
          let(:legal_moves) { %w[d3 d4 e3 c3] }

          context 'if king is in check at f2 by opponent pawn at e3' do
            it 'returns array of squares: e3' do
              white_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'e3')

              board = { 'd2' => white_pawn,
                        'd3' => ' ',
                        'd4' => ' ',
                        'e3' => opponent,
                        'f2' => King.new(color, 'f2'),
                        'c3' => Pawn.new(opponent_color, 'c3') }

              expected_array = %w[e3]

              selected_legal_moves = white_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to match_array(expected_array)
            end
          end

          context 'if king is not in check at e2 by opponent pawn at e3' do
            it 'returns array of squares: d3, d4, e3, c3' do
              white_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'e3')

              board = { 'd2' => white_pawn,
                        'd3' => ' ',
                        'd4' => ' ',
                        'e3' => opponent,
                        'e2' => King.new(color, 'e2'),
                        'c3' => Pawn.new(opponent_color, 'c3') }

              expected_array = legal_moves

              selected_legal_moves = white_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to match_array(expected_array)
            end
          end

          context 'if king is in check at f2 by opponent pawn at g3' do
            it 'returns an empty array' do
              white_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'g3')

              board = { 'd2' => white_pawn,
                        'd3' => ' ',
                        'd4' => ' ',
                        'e3' => Pawn.new(opponent_color, 'e3'),
                        'g3' => opponent,
                        'f2' => King.new(color, 'f2'),
                        'c3' => Pawn.new(opponent_color, 'c3') }

              selected_legal_moves = white_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to be_empty
            end
          end
        end
      end

      context 'when current square is f5' do
        let(:current_square) { 'f5' }

        context 'when legal moves are [f6, e6, g6]' do
          let(:legal_moves) { %w[f6 e6 g6] }

          context 'if king is in check at f4 by opponent pawn at e5' do
            it 'returns array of squares: e6' do
              white_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'e5', opponent_player)

              board = { 'f5' => white_pawn,
                        'f6' => ' ',
                        'e6' => ' ',
                        'e5' => opponent,
                        'f4' => King.new(color, 'f4'),
                        'g6' => Pawn.new(opponent_color, 'g6') }

              expected_array = %w[e6]

              selected_legal_moves = white_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to match_array(expected_array)
            end
          end
        end
      end
    end

    context 'with black pawns' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }

      context 'when current square is d7' do
        let(:current_square) { 'd7' }

        context 'when legal moves are [d6, d5, e6, c6]' do
          let(:legal_moves) { %w[d6 d5 e6 c6] }

          context 'if king is in check at f7 by opponent pawn at e6' do
            it 'returns array of squares: e6' do
              black_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'e6')

              board = { 'd7' => black_pawn,
                        'd6' => ' ',
                        'd5' => ' ',
                        'e6' => opponent,
                        'f7' => King.new(color, 'f7'),
                        'c6' => Pawn.new(opponent_color, 'c6') }

              expected_array = %w[e6]

              selected_legal_moves = black_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to match_array(expected_array)
            end
          end

          context 'if king is not in check at e7 by opponent pawn at e6' do
            it 'returns array of squares: d6, d5, e6, c6' do
              black_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'e6')

              board = { 'd7' => black_pawn,
                        'd6' => ' ',
                        'd5' => ' ',
                        'e6' => opponent,
                        'e7' => King.new(color, 'e7'),
                        'c6' => Pawn.new(opponent_color, 'c6') }

              expected_array = legal_moves

              selected_legal_moves = black_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to match_array(expected_array)
            end
          end

          context 'if king is in check at f7 by opponent pawn at g6' do
            it 'returns an empty array' do
              black_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'g6')

              board = { 'd7' => black_pawn,
                        'd6' => ' ',
                        'd5' => ' ',
                        'e6' => Pawn.new(opponent_color, 'e6'),
                        'g6' => opponent,
                        'f7' => King.new(color, 'f7'),
                        'c6' => Pawn.new(opponent_color, 'c6') }

              selected_legal_moves = black_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to be_empty
            end
          end
        end
      end

      context 'when current square is f4' do
        let(:current_square) { 'f4' }

        context 'when legal moves are [f3, e3, g3]' do
          let(:legal_moves) { %w[f3 e3 g3] }

          context 'if king is in check at f5 by opponent pawn at e4' do
            it 'returns array of squares: e3' do
              black_pawn = described_class.new(color, current_square, player)

              opponent = described_class.new(opponent_color, 'e4', opponent_player)

              board = { 'f4' => black_pawn,
                        'f3' => ' ',
                        'e3' => ' ',
                        'e4' => opponent,
                        'f5' => King.new(color, 'f5'),
                        'e6' => Pawn.new(opponent_color, 'e6'),
                        'g3' => Pawn.new(opponent_color, 'g3') }

              expected_array = %w[e3]

              selected_legal_moves = black_pawn.screen_legal_moves(legal_moves, board)

              expect(selected_legal_moves).to match_array(expected_array)
            end
          end
        end
      end
    end
  end
end
