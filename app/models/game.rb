class Game < ActiveRecord::Base

  serialize :grid
  
  def player_move(y,x)
    self.grid[y][x] = "X"
    self.save
  end

  def check_for_win(competitor)
    #check for vertical win
    values = 0,1,2
    values.each do |x|
      if grid[0][x] == grid[1][x] && grid[0][x] == grid[2][x]
        if grid[0][x] != ""          
          self.winner = "#{competitor.upcase}"
        end
      end
    end
    #check for horizontal win
    values.each do |y|
      if grid[y][0] == grid[y][1] && grid[y][0] == grid[y][2]
        if grid[y][0] != ""
          self.winner = "#{competitor.upcase}"
        end
      end
    end              
    #check for forward slash win
    if grid[0][0] == grid[1][1] && grid[0][0] == grid[2][2]
      if grid[0][0] != ""
        self.winner = "#{competitor.upcase}"
      end
    end
    #check for backslash win 
    if grid[0][2] == grid[1][1] && grid[0][2] == grid[2][0]
      if grid[0][2] != ""
        self.winner = "#{competitor.upcase}"
      end
    end
  end

  def computer_move
    # opening move
    if self.grid[1][1] != ""
      self.grid[0][0] = "O"
      self.save
    else
      self.grid[1][1] = "O"
      self.save
    end
    #defense
    check_for_two_adjacent_or_diagonal_symbols
    def check_for_two_adjacent_symbols
      
    end
  end

end
