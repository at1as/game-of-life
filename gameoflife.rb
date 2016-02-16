class BoardPrinter
  @@count = 0
  
  def self.print_board(full_board)
    puts "t=#{@@count}"
    full_board.each { |row| puts row.join('  ') }
    @@count += 1
  end
end

class Board
  attr_accessor :board

  def initialize(board = nil)
    if board.nil?
      @board = []
      0.upto(8) do
        @board << ['.'] * 9
      end
    else
      @board = board
    end
    @row_limit = @board.length - 1
    @col_limit = @board.first.length - 1
  end

  def revive(row:, col:)
    @board[row][col] = 'o'
  end

  def kill(row:, col:)
    @board[row][col] = '.'
  end

  def cell(row:, col:)
    @board[row][col]
  end

  def get_neighbor_count(row, col)
    #  Neighbors
    #  X  X  X          X    row-1    X
    #  X     X   =>   col-1         col+1
    #  X  X  X          X    row+1    X
    count = 0
    if row > 0
      count += 1 if @board[row - 1][col] == 'o'
    end
    if row > 0 && col > 0
      count += 1 if @board[row - 1][col - 1] == 'o'
    end
    if row > 0 && col < @col_limit
      count += 1 if @board[row - 1][col + 1] == 'o'
    end
    if row < @row_limit
      count += 1 if @board[row + 1][col] == 'o'
    end
    if row < @row_limit && col > 0
      count += 1 if @board[row + 1][col - 1] == 'o'
    end
    if row < @row_limit && col < @col_limit
      count += 1 if @board[row + 1][col + 1] == 'o'
    end
    if col > 0
      count += 1 if @board[row][col - 1] == 'o'
    end
    if col < @col_limit
      count += 1 if @board[row][col + 1] == 'o'
    end
    count
  end
end

board = Board.new
next_board = nil

# GLIDER
board.revive(row: 1, col: 2)
board.revive(row: 2, col: 3)
board.revive(row: 3, col: 1)
board.revive(row: 3, col: 2)
board.revive(row: 3, col: 3)

loop do
  begin
    board = next_board.clone
  rescue
  end
  next_board = Board.new

  BoardPrinter.print_board(board.board)

  board.board.each_with_index do |row, row_idx|
    board.board.each_with_index do |col, col_idx|
      neighbors = board.get_neighbor_count(row_idx, col_idx)
      dead_cell = (board.cell(row: row_idx, col: col_idx) == '.')
      
      if neighbors < 2 && !dead_cell
        next_board.kill(row: row_idx, col: col_idx)
      elsif (neighbors == 2 || neighbors == 3) && !dead_cell
        next_board.revive(row: row_idx, col: col_idx)
      elsif neighbors > 3 && !dead_cell
        next_board.kill(row: row_idx, col: col_idx)
      elsif neighbors == 3 && dead_cell
        next_board.revive(row: row_idx, col: col_idx)
      else
        next_board.kill(row: row_idx, col: col_idx)
      end
    end
  end

  BoardPrinter.print_board(next_board.board)
  sleep 1
end

