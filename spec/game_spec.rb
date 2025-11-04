# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:empty_square) { ' ' }
  let(:filename) { 'saved_game.json' }

  let(:chessgame) { described_class.new }
  let(:board) { chessgame.instance_variable_get(:@board) }

  let(:white_player) { chessgame.instance_variable_get(:@white_player) }
  let(:black_player) { chessgame.instance_variable_get(:@black_player) }
  let(:player_in_turn) { chessgame.instance_variable_get(:@player_in_turn) }

  let(:first_pawn) { Pawn.new(player_in_turn.color, 'a2', player_in_turn) }
  let(:second_pawn) { Pawn.new(player_in_turn.color, 'd2', player_in_turn) }
  let(:rook) { Rook.new(player_in_turn.color, 'h1', player_in_turn) }
  let(:second_rook) { Rook.new('black', 'h8', black_player) }

  before do
    allow(chessgame).to receive(:gets) { '' }
    allow(first_pawn).to receive(:screen_legal_moves) { %w[a3 a4] }
    allow(second_pawn).to receive(:screen_legal_moves) { [] }
    allow(rook).to receive(:screen_legal_moves) { ['h2'] }
  end

  describe '#play' do
    it 'sends messages to set up all 6 pieces movements' do
      allow(chessgame).to receive(:set_pieces)
      allow(chessgame).to receive(:player_turns)

      expect(PawnMovement).to receive(:set_up)
      expect(RookMovement).to receive(:set_up)
      expect(KnightMovement).to receive(:set_up)
      expect(BishopMovement).to receive(:set_up)
      expect(QueenMovement).to receive(:set_up)
      expect(KingMovement).to receive(:set_up)

      chessgame.play
    end

    it 'saves an initial FEN record of the game' do
      allow(chessgame).to receive(:set_up_pieces_movements)
      allow(chessgame).to receive(:player_turns)

      initial_fen_record = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

      chessgame.play

      fen_record = chessgame.instance_variable_get(:@fen_log).first

      expect(fen_record).to eql(initial_fen_record)
    end

    context 'when there is no saved game file' do
      before do
        allow(chessgame).to receive(:set_up_pieces_movements)
        allow(chessgame).to receive(:player_turns)
      end

      context 'position new white pieces on board' do
        let(:color) { 'white' }

        %w[a2 b2 c2 d2 e2 f2 g2 h2].each do |square|
          it "places white pawn on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Pawn) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: white_player))
          end
        end

        %w[a1 h1].each do |square|
          it "places white rook on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Rook) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: white_player))
          end
        end

        %w[b1 g1].each do |square|
          it "places white knight on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Knight) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: white_player))
          end
        end

        %w[c1 f1].each do |square|
          it "places white bishop on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Bishop) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: white_player))
          end
        end

        it 'places white queen on d1 square' do
          square = 'd1'

          expect { chessgame.play }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Queen) &
                have_attributes(color: color,
                                current_square: square,
                                player: white_player))
        end

        it 'places white king on e1 square' do
          square = 'e1'

          expect { chessgame.play }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(King) &
                have_attributes(color: color,
                                current_square: square,
                                player: white_player))
        end
      end

      context 'position new black pieces on board' do
        let(:color) { 'black' }

        %w[a7 b7 c7 d7 e7 f7 g7 h7].each do |square|
          it "places black pawn on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Pawn) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: black_player))
          end
        end

        %w[a8 h8].each do |square|
          it "places black rook on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Rook) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: black_player))
          end
        end

        %w[b8 g8].each do |square|
          it "places black knight on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Knight) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: black_player))
          end
        end

        %w[c8 f8].each do |square|
          it "places black bishop on #{square} square" do
            expect { chessgame.play }
              .to change { board.chessboard[square] }
              .from(empty_square)
              .to(be_a(Bishop) &
                  have_attributes(color: color,
                                  current_square: square,
                                  player: black_player))
          end
        end

        it 'places black queen on d8 square' do
          square = 'd8'

          expect { chessgame.play }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Queen) &
                have_attributes(color: color,
                                current_square: square,
                                player: black_player))
        end

        it 'places black king on e8 square' do
          square = 'e8'

          expect { chessgame.play }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(King) &
                have_attributes(color: color,
                                current_square: square,
                                player: black_player))
        end
      end
    end

    context 'when a saved game file exists' do
      let(:resumed_game) { described_class.new }

      before do
        allow(chessgame).to receive(:set_pieces)
        allow(chessgame).to receive(:set_up_pieces_movements)

        board.chessboard[first_pawn.current_square] = first_pawn
        board.chessboard[second_pawn.current_square] = second_pawn
        board.chessboard[rook.current_square] = rook

        board.chessboard[second_rook.current_square] = second_rook
      end

      it 'does not set new pieces' do
        allow(chessgame).to receive(:player_turns)
        allow(File).to receive(:exist?).with(filename) { true }

        expect(chessgame).not_to receive(:set_pieces)

        chessgame.play
      end

      it 'loads saved game with same variables' do
        allow(second_rook).to receive(:screen_legal_moves) { %w[h7] }
        allow(resumed_game).to receive(:search_moveable_pieces).and_return([])

        allow(white_player).to receive(:player_input)
          .and_return(first_pawn.current_square, 'a3', 'save')

        allow(black_player).to receive(:player_input)
          .and_return(second_rook.current_square, 'h7')

        chessgame.play

        resumed_game.play

        expect(resumed_game).eql?(chessgame)
      end
    end

    context 'if player in turn has moveable pieces' do
      before do
        allow(chessgame).to receive(:set_pieces)
        allow(chessgame).to receive(:set_up_pieces_movements)
      end

      it 'prompts player to choose piece and square to move from legal moves' do
        expect(player_in_turn).to receive(:player_input)
          .with([first_pawn.current_square, rook.current_square], any_args)
          .and_return(first_pawn.current_square)

        expect(player_in_turn).to receive(:player_input)
          .with(%w[a3 a4]) { 'a3' }

        chessgame.play
      end

      context 'when player choose a piece to move' do
        it 'moves chosen piece to chosen square' do
          chosen_piece = rook
          chosen_square = 'h2'

          allow(player_in_turn).to receive(:gets)
            .and_return(chosen_piece.current_square, chosen_square)

          expect(player_in_turn).to receive(:move!).with(chosen_piece, chosen_square)

          chessgame.play
        end

        context 'keeps track of movements clocks' do
          it 'increments fullmove number by one when black moves' do
            allow(second_rook).to receive(:screen_legal_moves) { %w[h7] }

            allow(white_player).to receive(:gets)
              .and_return(first_pawn.current_square, 'a3', 'resign')

            allow(black_player).to receive(:gets)
              .and_return(second_rook.current_square, 'h7')

            expect { chessgame.play }
              .to change { chessgame.fullmove_number }
              .from(1)
              .to(2)
          end

          it 'increments halfmove clock by one if player
            does not capture or advance pawn' do
            allow(second_rook).to receive(:screen_legal_moves) { %w[h7] }

            allow(white_player).to receive(:gets)
              .and_return(rook.current_square, 'h2', 'resign')

            allow(black_player).to receive(:gets)
              .and_return(second_rook.current_square, 'h7')

            expect { chessgame.play }
              .to change { chessgame.halfmove_clock }
              .from(0)
              .to(2)
          end

          it 'restarts halfmove clock to 0 if player advances a pawn' do
            third_pawn = Pawn.new('black', 'a7', black_player)

            allow(third_pawn).to receive(:screen_legal_moves) { %w[a6] }
            allow(second_rook).to receive(:screen_legal_moves) { %w[h7] }

            allow(white_player).to receive(:gets)
              .and_return(rook.current_square, 'h2', 'resign')

            allow(black_player).to receive(:gets)
              .and_return(third_pawn.current_square, 'a6')

            chessgame.play

            halfmove_clock = chessgame.instance_variable_get(:@halfmove_clock)

            expect(halfmove_clock).to eq(0)
          end

          it 'restarts halfmove clock to 0 if player captures' do
            allow(second_rook).to receive(:screen_legal_moves) { %w[h2] }

            allow(white_player).to receive(:gets)
              .and_return(rook.current_square, 'h2', 'resign')

            allow(black_player).to receive(:gets)
              .and_return(second_rook.current_square, 'h2')

            chessgame.play

            halfmove_clock = chessgame.instance_variable_get(:@halfmove_clock)

            expect(halfmove_clock).to eq(0)
          end
        end

        it 'saves a FEN record of the move in a log variable' do
          allow(chessgame).to receive(:set_pieces).and_call_original

          allow(chessgame).to receive(:gets)
            .and_return('draw', 'draw')

          allow(white_player).to receive(:gets)
            .and_return(first_pawn.current_square, 'a4', 'draw')

          expected_fen_record = 'rnbqkbnr/pppppppp/8/8/P7/8/1PPPPPPP/RNBQKBNR b KQkq a3 0 1'

          chessgame.play

          fen_log = chessgame.instance_variable_get(:@fen_log)

          expect(fen_log.last).to eql(expected_fen_record)
        end

        context 'when player proposes a draw' do
          before do
            allow(second_rook).to receive(:screen_legal_moves) { %w[h7] }

            allow(player_in_turn).to receive(:gets)
              .and_return(first_pawn.current_square, 'a3', 'resign')

            allow(black_player).to receive(:gets)
              .and_return(second_rook.current_square, 'h7')
          end

          context 'if opponents agrees' do
            before do
              allow(chessgame).to receive(:gets)
                .and_return('draw', 'draw')
            end

            it 'ends the game' do
              expect(black_player).not_to receive(:move!)

              chessgame.play
            end

            it 'declares draw' do
              expect { chessgame.play }
                .to change { chessgame.draw_agreed }
                .from(false)
                .to(true)
            end
          end

          context 'if opponent refuses' do
            it 'continue playing' do
              allow(chessgame).to receive(:gets)
                .and_return('draw', 'refuse')

              expect(black_player).to receive(:move!)

              chessgame.play
            end
          end
        end

        context 'if white player is in turn' do
          let(:player_in_turn) { white_player }

          it 'switches turn to black player' do
            allow(player_in_turn).to receive(:gets)
              .and_return(first_pawn.current_square, 'a3')

            expect { chessgame.play }
              .to change(chessgame, :player_in_turn)
              .from(white_player)
              .to(black_player)
          end
        end

        context 'if black player is in turn' do
          let(:player_in_turn) { black_player }

          it 'switches turn to white player' do
            chessgame.instance_variable_set(:@player_in_turn, player_in_turn)

            allow(player_in_turn).to receive(:gets)
              .and_return(first_pawn.current_square, 'a3')

            expect { chessgame.play }
              .to change(chessgame, :player_in_turn)
              .from(black_player)
              .to(white_player)
          end
        end
      end

      context 'when player chooses to save the game' do
        before do
          allow(File).to receive(:open)

          allow(player_in_turn).to receive(:gets)
            .and_return('save')
        end

        it 'saves current game in a JSON file' do
          expect(File).to receive(:open)
            .with(filename, 'w')

          chessgame.play
        end

        it 'exits the game' do
          expect(player_in_turn).not_to receive(:move!)

          expect { chessgame.play }
            .not_to change(chessgame, :player_in_turn)
        end
      end

      context 'when player chooses to resign' do
        before do
          allow(player_in_turn).to receive(:gets)
            .and_return('resign')
        end

        it 'ends the game' do
          expect(player_in_turn).not_to receive(:move!)

          chessgame.play
        end

        it 'declares the opponent the winner by resignation' do
          expect { chessgame.play }
            .to change { chessgame.winner }
            .from(nil)
            .to(black_player)
            .and change { chessgame.resign }
            .from(false)
            .to(true)
        end
      end
    end

    context 'if player in turn does not have moveable pieces' do
      before do
        allow(chessgame).to receive(:set_pieces)
        allow(chessgame).to receive(:set_up_pieces_movements)
        allow(chessgame).to receive(:search_moveable_pieces)
          .and_return([])
      end

      it 'does not prompt player to choose piece and square to move' do
        expect(player_in_turn).not_to receive(:gets)

        chessgame.play
      end

      context 'when player is checkmated' do
        context 'if white king is in check' do
          let(:w_king) { King.new('white', 'a1', white_player) }
          let(:b_rook) { Rook.new('black', 'a4', black_player) }

          it 'declares black player the winner' do
            board.chessboard[w_king.current_square] = w_king
            board.chessboard[b_rook.current_square] = b_rook

            expect { chessgame.play }
              .to change { chessgame.winner }
              .from(nil)
              .to(black_player)
          end
        end

        context 'if black king is in check' do
          let(:b_king) { King.new('black', 'a8', black_player) }
          let(:w_rook) { Rook.new('white', 'a5', white_player) }

          it 'declares white player the winner' do
            chessgame.instance_variable_set(:@player_in_turn, black_player)

            board.chessboard[b_king.current_square] = b_king
            board.chessboard[w_rook.current_square] = w_rook

            expect { chessgame.play }
              .to change { chessgame.winner }
              .from(nil)
              .to(white_player)
          end
        end
      end

      context 'when player is stalemated' do
        context 'if white king is not in check' do
          let(:w_king) { King.new('white', 'a1', white_player) }
          let(:b_rook) { Rook.new('black', 'b4', black_player) }

          it 'declares a draw by stalemate' do
            board.chessboard[w_king.current_square] = w_king
            board.chessboard[b_rook.current_square] = b_rook

            expect { chessgame.play }
              .to change { chessgame.stalemate }
              .from(false)
              .to(true)
          end
        end

        context 'if black king is not in check' do
          let(:b_king) { King.new('black', 'a8', black_player) }
          let(:w_rook) { Rook.new('white', 'b5', white_player) }

          it 'declares a draw by stalemate' do
            chessgame.instance_variable_set(:@player_in_turn, black_player)

            board.chessboard[b_king.current_square] = b_king
            board.chessboard[w_rook.current_square] = w_rook

            expect { chessgame.play }
              .to change { chessgame.stalemate }
              .from(false)
              .to(true)
          end
        end
      end
    end

    context 'when halfmove clock reaches 100 (50 consecutive moves rule happens)' do
      before do
        allow(chessgame).to receive(:set_pieces)
        allow(chessgame).to receive(:set_up_pieces_movements)
      end

      it 'automatically ends the game' do
        chessgame.instance_variable_set(:@halfmove_clock, 98)

        allow(second_rook).to receive(:screen_legal_moves) { %w[h7] }

        allow(white_player).to receive(:gets)
          .and_return(rook.current_square, 'h2')

        allow(black_player).to receive(:gets)
          .and_return(second_rook.current_square, 'h7')

        expect(white_player).to receive(:move!).once.and_call_original

        chessgame.play
      end
    end

    context 'when a threefold repetition is reached (3 repeated moves rule happens)' do
      before do
        allow(chessgame).to receive(:set_pieces)
        allow(chessgame).to receive(:set_up_pieces_movements)
      end

      it 'automatically ends the game' do
        allow(chessgame).to receive(:save_fen_record)

        fen_records = [
          '1kr5/Bb3R2/4p3/4PN1p/R7/2P3p1/1KP4r/8 b - - 1 20',
          'k1r5/Bb3R2/4p3/4PN1p/R7/2P3p1/1KP4r/8 w - - 2 21',
          'k1r5/1b3R2/4p3/4PN1p/R7/2P3p1/1KP4r/6B1 b - - 3 21',
          '1kr5/1b3R2/4p3/4PN1p/R7/2P3p1/1KP4r/6B1 w - - 4 22',
          '1kr5/Bb3R2/4p3/4PN1p/R7/2P3p1/1KP4r/8 b - - 5 22',
          'k1r5/Bb3R2/4p3/4PN1p/R7/2P3p1/1KP4r/8 w - - 6 23',
          'k1r5/1b3R2/4p3/4PN1p/R7/2P3p1/1KP2B1r/8 b - - 7 23',
          '1kr5/1b3R2/4p3/4PN1p/R7/2P3p1/1KP2B1r/8 w - - 8 24',
          '1kr5/Bb3R2/4p3/4PN1p/R7/2P3p1/1KP4r/8 b - - 9 24'
        ]

        chessgame.instance_variable_set(:@fen_log, fen_records)

        expect(white_player).not_to receive(:move!)

        chessgame.play
      end
    end
  end
end
