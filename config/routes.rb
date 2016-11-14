Rails.application.routes.draw do
  get 'game', to: 'interface#game'

  get 'score', to: 'interface#score'

  root 'interface#game'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
