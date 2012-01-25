class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :set_game
  
  def set_game
    @game = Game.find_by_id(session[:game_id])
  end
  
end
