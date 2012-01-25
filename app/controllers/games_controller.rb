class GamesController < ApplicationController

  before_filter :set_game, only: [:edit, :update]
  
  def new
    new_game_grid
  end

  def create
    new_game_grid
    @game.save
    session[:game_id] = @game.id
    redirect_to edit_game_url(@game)
  end

  def edit
  end

  def update
    # raise params[:y].to_i.inspect    
    @game.player_move(params[:y].to_i,params[:x].to_i) # define in model depending on the play button they post
    @game.check_for_win(player)
    # @game.computer_move
    # @game.check_for_win(computer)
    # computer_move (define in "game" model? )
    # check_for_win
    redirect_to edit_game_url(@game)
  end

  private
  
  def new_game_grid
    @game = Game.create 
    @game.grid = [["","",""],["","",""],["","",""]]
  end

end
