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
    # #check for forward slash win - WILL DELETE BECAUSE THE OPENING MOVE SHOULD ALWAYS PREVENT THIS
    # if grid[0][0] == grid[1][1] && grid[0][0] == grid[2][2]
    #   if grid[0][0] != ""
    #     self.winner = "#{competitor.upcase}"
    #   end
    # end
    
    #check for backslash win 
    if grid[0][2] == grid[1][1] && grid[0][2] == grid[2][0]
      if grid[0][2] != ""
        self.winner = "#{competitor.upcase}"
      end
    end
  end

  def computer_move
    #opening move or even the first two moves
    if grid[1][1].present? && grid[0][0] != "X"
      grid[0][0] = "O"
      self.save
    else
      grid[1][1] = "O"
      self.save
    end
    
    check_for_possible_win
    
    #need to add in to make move for for edge play
      #could be final statement in elsif for defense?
    
  end

  def check_for_possible_win
    values = 0,1,2
     
    #vertical
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
    
    #horizontal
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
  
end
