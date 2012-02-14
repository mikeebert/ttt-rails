module GamesHelper

  def cell_value(y,x)
    if @game.grid[y][x] == ""
      button_to("play", make_move_url(:x => x, :y => y), method: :put)
    else
      @game.grid[y][x]
    end
  end
  
  
end


