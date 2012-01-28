module GamesHelper


  def opening_cells(y,x)
    button_to("play", start_game_url(:x => x, :y => y), method: :post)
  end

  
  def cell_value(y,x)
    if @game.grid[y][x] == ""
      button_to("play", make_move_url(:x => x, :y => y), method: :put)
    else
      @game.grid[y][x]
    end
  end
  
  
end


