Ttt::Application.routes.draw do

  resources :games

  put "games/:id", controller: 'games', action: 'update', as: :make_move
  
end
