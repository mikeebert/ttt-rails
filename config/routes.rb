Ttt::Application.routes.draw do

  put "games/:id", controller: 'games', action: 'update', as: :make_move
  resources :games
  
  root to: "games#index"

  
end
