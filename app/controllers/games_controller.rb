class GamesController < ApplicationController

  before_filter :set_game, only: [:edit, :update]

  def index
  end
  
  def new
    new_game
  end

  def create
    new_game
    @game.player_move(params[:y].to_i,params[:x].to_i)
    @game.opening_computer_move
    session[:game_id] = @game.id
    redirect_to edit_game_url(@game)
  end

  def edit
  end

  def update    
    @game.player_move(params[:y].to_i,params[:x].to_i) 
    @game.check_for_win_or_tie("player")
    
    if @game.winner.present?
      redirect_to edit_game_url(@game), notice: "#{@game.winner}"
    else
      @game.computer_move
      @game.check_for_win_or_tie("computer")      
      if @game.winner.present?
        redirect_to edit_game_url(@game), notice: "#{@game.winner}"
      else
        redirect_to edit_game_url(@game)
      end
    end
    
  end

  private
  
  def new_game
    @game = Game.new(grid: [["","",""],["","",""],["","",""]])
  end
  
  
end
