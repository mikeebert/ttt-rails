class GamesController < ApplicationController

  before_filter :set_game, only: [:edit, :update]

  def index
  end
  
  def new
    new_game
  end

  def create
    new_game
    @game.save
    session[:game_id] = @game.id
    redirect_to edit_game_url(@game)
  end

  def edit
  end

  def update    
    @game.player_move(params[:y].to_i,params[:x].to_i) # define in model depending on the play button they post
    @game.check_for_win("player")
    @game.computer_move
    # @game.check_for_win("computer") #need to rewrite this so that it knows who wins.
    if @game.winner.present?
      redirect_to games_url, notice: "#{@game.winner} WINS!"
    else
      redirect_to edit_game_url(@game)
    end
  end

  private
  
  def new_game
    @game = Game.new(grid: [["","",""],["","",""],["","",""]])
  end
  
end
