Rails.application.routes.draw do
 
  # devise_for :users
    devise_for :users, controllers: {
      sessions:      'users/sessions',
      passwords:     'users/passwords',
      registrations: 'users/registrations'
    }

    #クエッションのアクションのルーティング
    get 'questions/index' => 'questions#index'
    resources :questions do
      resources :comments, only: [:create]
      resources :likes, only: [:create, :destroy]
    end
    get 'hello/privacy' => 'hello#privacy'
    resources :comments, only: [:destroy]
    get 'rooms/index' => 'rooms#index'
    resources :users, only: [:show, :index]
    resources :rooms, :only => [:create, :show]
    resources :messages, only: [:create]
    resources :relationships, only: [:create, :destroy]
    
    root 'hello#index' 

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
