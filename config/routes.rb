Ttt::Application.routes.draw do

  put "games/:id", controller: 'games', action: 'update', as: :make_move
  post "games", controller: 'games', action: 'create', as: :start_game
  resources :games
  
  root to: "games#index"

  
end
