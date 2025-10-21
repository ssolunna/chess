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

  before do
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
      let(:second_rook) { Rook.new('black', 'h8', black_player) }
      before do
        allow(chessgame).to receive(:set_pieces)
        allow(chessgame).to receive(:set_up_pieces_movements)

        board.chessboard[first_pawn.current_square] = first_pawn
        board.chessboard[second_pawn.current_square] = second_pawn
        board.chessboard[rook.current_square] = rook
      end

      it 'does not set new pieces' do
        allow(chessgame).to receive(:player_turns)
        allow(File).to receive(:exist?).with(filename) { true }

        expect(chessgame).not_to receive(:set_pieces)

        chessgame.play
      end

      it 'loads saved game with same variables' do
        board.chessboard[second_rook.current_square] = second_rook

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
          .with([first_pawn.current_square, rook.current_square], 'save')
          .and_return(first_pawn.current_square)

        expect(player_in_turn).to receive(:player_input)
          .with(%w[a3 a4]) { 'a3' }

        chessgame.play
      end

      context 'when player choose a piece' do
        it 'moves chosen piece to chosen square' do
          chosen_piece = rook
          chosen_square = 'h2'

          allow(player_in_turn).to receive(:player_input)
            .and_return(chosen_piece.current_square, chosen_square)

          expect(player_in_turn).to receive(:move!).with(chosen_piece, chosen_square)

          chessgame.play
        end

        context 'if white player in turn' do
          let(:player_in_turn) { white_player }

          it 'switches turn to black player' do
            allow(player_in_turn).to receive(:player_input)
              .and_return(first_pawn.current_square, 'a3')

            expect { chessgame.play }
              .to change(chessgame, :player_in_turn)
              .from(white_player)
              .to(black_player)
          end
        end

        context 'if black player in turn' do
          let(:player_in_turn) { black_player }

          it 'switches turn to white player' do
            chessgame.instance_variable_set(:@player_in_turn, player_in_turn)

            allow(player_in_turn).to receive(:player_input)
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

          allow(player_in_turn).to receive(:player_input)
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
    end
  end
end
