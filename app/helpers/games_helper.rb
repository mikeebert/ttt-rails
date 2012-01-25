module GamesHelper

  def cell_value(y,x)
    if @game.grid[y][x] == ""
      button_to("play", make_move_url(:x => x, :y => y), method: :put)
    else
      @game.grid[y][x]
    end
  end
  

  
end


# <%= button_to('Destroy', 'http://www.example.com', :confirm => 'Are you sure?',:method => "delete", :remote => true, :disable_with => 'loading...')