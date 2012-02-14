class Game < ActiveRecord::Base
  
  serialize :grid
  before_create :new_game
    
  def player_move(y,x)
    grid[y][x] = "X"
    self.save
  end
    
  def computer_move
    
    if move_count == 1
      first_computer_move
    end
        
    if move_count == 3
      second_computer_move
    end
          
    if move_count == 5
      third_computer_move
    end
    
    if move_count == 7
      fourth_computer_move
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
  
  def first_computer_move 
    if grid[1][1].present? && grid[0][0].empty?
      grid[0][0] = "O"
      self.save
    else
      grid[1][1] = "O" 
      self.save
    end
  end  
  
  def second_computer_move
    #first check for diaganol setup 
    if grid[0][0] == "X" && grid[0][0] == grid[2][2]          
      self.grid[0][1] = "O"
    elsif grid[0][2] == "X" && grid[0][2] == grid[2][0]
      self.grid[0][1] = "O"
    #then check for 2 versions of the "knight or L" setup
    elsif grid[0][0] == "X" && grid[0][0] == grid[2][1]
      self.grid[2][0] = "O"
    elsif grid[1][2] == "X" && grid[1][2] == grid[2][0]
      self.grid[2][2] = "O"
    else
      if defensive_move == 0
        #protect against double egde setup
        if grid[1][2] == "X" && grid[2][1] == "X" 
          grid[2][2] = "O"
        #protect against a knight setup
        elsif grid[0][2] == "X" && grid[2][1] == "X"
          grid[2][2] = "O"
        elsif grid[0][0] != "X" && grid[0][0].empty? # covers the other 2 rotations of the "knight" setup, but a "dumb" move if player plays [0][1] & [2][2]
          grid[0][0] = "O"
        elsif grid[0][2].empty?
          grid[0][2] = "O"
        end
      else
        defensive_move
      end
    end
    self.save
  end
  
  def third_computer_move
    offensive_move
    check_for_win_or_tie("computer")
    if winner.nil?        
      if defensive_move == 0
        first_available_space_move
      else
        defensive_move
      end
    end     
  end
  
  def fourth_computer_move
    offensive_move
    check_for_win_or_tie("computer")
    if self.winner.nil?
      if defensive_move == 0
        first_available_space_move
      else
        defensive_move
      end          
    end    
  end
  
  def check_for_win_or_tie(competitor)    
    values = 0,1,2
    values.each do |x|
      if grid[0][x] == grid[1][x] && grid[0][x] == grid[2][x]
        if grid[0][x] != ""          
          self.winner = "#{competitor.upcase} WINS!"
          self.save
        end
      end
    end
   
    values.each do |y|
      if grid[y][0] == grid[y][1] && grid[y][0] == grid[y][2]
        if grid[y][0] != ""
          self.winner = "#{competitor.upcase} WINS!"
          self.save
        end
      end
    end              
    
    if grid[0][2] == grid[1][1] && grid[0][2] == grid[2][0]
      if grid[0][2] != ""
        self.winner = "#{competitor.upcase} WINS!"
        self.save
      end
    end
    
    if grid[0][0] == grid[1][1] && grid[0][0] == grid[2][2]
      if grid[0][0].present?
        self.winner = "#{competitor.upcase} WINS!"
        self.save
      end
    end    
    move_count    
  end
  
  def offensive_move
    values = 0,1,2

    #offensive_vertical
    values.each do |x|
      if grid[0][x] == grid[1][x] && grid[0][x] == "O"
        grid[2][x] = "O" if grid[2][x].empty?
      elsif grid[0][x] == grid[2][x] && grid[0][x] == "O"
        grid[1][x] = "O"if grid[1][x].empty?
      elsif grid[1][x] == grid[2][x] && grid[1][x] == "O"
        grid[0][x] = "O"if grid[0][x].empty?
      end
      self.save
      check_for_win_or_tie("computer")
    end
    #offensive_horizontal
    if self.winner.nil?
      values.each do |y|
        if grid[y][0] == grid[y][1] && grid[y][0] == "O"
          grid[y][2] = "O" if grid[y][2].empty?
        elsif grid[y][0] == grid[y][2] && grid[y][0] == "O"
          grid[y][1] = "O"if grid[y][1].empty?
        elsif grid[y][1] == grid[y][2] && grid[y][1] == "O"
          grid[y][0] = "O"if grid[y][0].empty?
        end
        self.save
        check_for_win_or_tie("computer")
      end
    end

    #offensive_backslash
    if self.winner.nil?
      if grid[0][2] == grid[1][1] && grid[0][2] == "O"
        grid[2][0] = "O" if grid[2][0].empty?
        self.save
      elsif grid[0][2] == grid[2][0]
        grid[1][1] = "O" if grid[1][1].empty?
        self.save
      elsif grid[2][0] == grid[1][1] && grid[2][0] == "O"
        grid[0][2] = "O" if grid[0][2].empty?
        self.save
        check_for_win_or_tie("computer")
      end
    end
    
    #offensive_forward-slash
    if self.winner.nil?
      if grid[0][0] == grid[1][1] && grid[0][0] == "O"
        grid[2][2] = "O" if grid[2][2].empty?
        self.save
      end
    end
  end
  
  def defensive_move
    move = 0
    values = 0,1,2

    # vertical
    values.each do |x|
      if grid[0][x] == grid[1][x] && grid[0][x] == "X"
        if grid[2][x].empty?
          grid[2][x] = "O" 
          move += 1
        end
      elsif grid[0][x] == grid[2][x] && grid[0][x] == "X"
        if grid[1][x].empty?
          grid[1][x] = "O"
          move += 1
        end
      elsif grid[1][x] == grid[2][x] && grid[1][x] == "X"
        if grid[0][x].empty?
          grid[0][x] = "O"
          move += 1
        end
      end
      self.save
    end

    #horizontal
    if move == 0
      values.each do |y|
        if grid[y][0] == grid[y][1] && grid[y][0] == "X"
          if grid[y][2].empty?
            grid[y][2] = "O" 
            move += 1
          end
        elsif grid[y][0] == grid[y][2] && grid[y][0] == "X"
          if grid[y][1].empty?
            grid[y][1] = "O"
            move += 1
          end
        elsif grid[y][1] == grid[y][2] && grid[y][1] == "X"
          if grid[y][0].empty?
            grid[y][0] = "O"
            move += 1
          end
        end
        self.save
      end
    end
    #backslash
    if move == 0
      if grid[0][2] == grid[1][1] && grid[0][2] == "X"
        if grid[2][0].empty?
          grid[2][0] = "O" 
          move += 1
        end
      elsif grid[0][2] == grid[2][0]
        if grid[1][1].empty?
          grid[1][1] = "O" 
          move += 1
        end
      elsif grid[2][0] == grid[1][1] && grid[2][0] == "X"
        if grid[0][2].empty?
          grid[0][2] = "O" 
          move += 1
        end
      end
      self.save
    end
    return move
  end
  
  def first_available_space_move
    values = 0,1,2
    count = 0
    values.each do |y|
      values.each do |x|      
        if self.grid[y][x].empty? && count == 0
          self.grid[y][x] = "O"
          count += 1
          self.save
        end
      end
    end
  end
  
  def new_game
    self.grid = [["","",""],["","",""],["","",""]]
  end
  
end
