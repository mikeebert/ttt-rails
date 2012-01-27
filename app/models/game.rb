class Game < ActiveRecord::Base
  
  serialize :grid
    
  def player_move(y,x)
    self.grid[y][x] = "X"
    self.save
  end

  def opening_computer_move 
    if grid[1][1].present? && grid[0][0].empty?
      grid[0][0] = "O"
      self.save
    else
      grid[1][1] = "O" 
      self.save
    end
  end
    
  def computer_move
    #opening move or even the first two moves    
    if grid[1][1].present? && grid[0][0] != "X"
      grid[0][0] = "O"
      self.save
    # elsif grid[0][0] == grid[2][2] || grid[0][2] == grid[2][0]
    #   if grid[0][1] != "" && grid[0][1] != "X"
    #     grid[0][1] = "O"
    #     self.save
    #   elsif grid[1][0] != "" || grid[1][0] != "X"
    #     grid[1][0] = "O"
    #     self.save
    #   end
    else
      grid[1][1] = "O" 
      self.save
    end
    
    defensive_move
    
    #need to add in to make move for for edge play
      #could be final statement in elsif for defense?
    
  end
  
  def check_for_win_or_tie(competitor)    
    values = 0,1,2
    values.each do |x|
      if grid[0][x] == grid[1][x] && grid[0][x] == grid[2][x]
        if grid[0][x] != ""          
          self.winner = "#{competitor.upcase} WINS!"
        end
      end
    end
   
    values.each do |y|
      if grid[y][0] == grid[y][1] && grid[y][0] == grid[y][2]
        if grid[y][0] != ""
          self.winner = "#{competitor.upcase} WINS!"
        end
      end
    end              
    
    if grid[0][2] == grid[1][1] && grid[0][2] == grid[2][0]
      if grid[0][2] != ""
        self.winner = "#{competitor.upcase} WINS!"
      end
    end
    
    if grid[0][0] == grid[1][1] && grid[0][0] == grid[2][2]
      if grid[0][0].present?
        self.winner = "#{competitor.upcase} WINS!"
      end
    end
    
    count = 0
    self.grid.each do |y|
      y.each do |x|
        if x.present?
          count += 1
        end
      end
    end
    if count == 9 
      self.winner = "Tie Game!"
    end
  end
  
  def defensive_move
    values = 0,1,2
     
    values.each do |x|
      if grid[0][x] == grid[1][x] && grid[0][x] == "X"
        grid[2][x] = "O" if grid[2][x].empty?
      elsif grid[0][x] == grid[2][x] && grid[0][x] == "X"
        grid[1][x] = "O"if grid[1][x].empty?
      elsif grid[1][x] == grid[2][x] && grid[1][x] == "X"
        grid[0][x] = "O"if grid[0][x].empty?
      end
      self.save
    end
    
    values.each do |y|
      if grid[y][0] == grid[y][1] && grid[y][0] == "X"
        grid[y][2] = "O" if grid[y][2].empty?
      elsif grid[y][0] == grid[y][2] && grid[y][0] == "X"
        grid[y][1] = "O"if grid[y][1].empty?
      elsif grid[y][1] == grid[y][2] && grid[y][1] == "X"
        grid[y][0] = "O"if grid[y][0].empty?
      end
      self.save
    end
    
    #backslash
    if grid[0][2] == grid[1][1] && grid[0][2] == "X"
      grid[2][0] = "O" if grid[2][0].empty?
      self.save
    elsif grid[0][2] == grid[2][0]
      grid[1][1] = "O" if grid[1][1].empty?
      self.save
    elsif grid[2][0] == grid[1][1] && grid[2][0] == "X"
      grid[0][2] = "O" if grid[0][2].empty?
      self.save
    end
  end
  
  def move_count
    count = 0
    self.grid.each do |y|
      y.each do |x|
        if x.present?
          count += 1
        end
      end
    end
    if count == 9 
      self.winner = "Tie Game!"
    end
    return count
  end
end
