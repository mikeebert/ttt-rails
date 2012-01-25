class Game < ActiveRecord::Base

  serialize :grid
  
  def player_move(y,x)
    self.grid[y][x] = "X"
    self.save
  end
  
  def check_for_win(competitor)
    values = 0,1,2
    values.each do |x|
      if grid[0][x] == grid[1][x] && grid[0][x] == grid [2][x]
        return "#{competitor.upcase} WINS!" unless grid[0][x] == ""
      end
    end
    
    values.each do |y|
      if grid[y][0] == grid[y][1] && grid[y][0] == grid[y][2]
        return "#{comptitor.upcase} WINS!" unless grid[y][0] == ""
      end
    end              
    
  end
  
  def computer_move(y,x)
    self.grid[y][x] = "O"
    self.save
  end

end
