Rails.application.routes.draw do
  resource :email_confirmation, only: [:show, :create]
  resource :membership, only: [:create, :destroy]
  resources :passwords, only: [:create, :new]
  resource :profile, only: [:edit, :update, :show] do
    resource :password, only: [:edit, :update]
  end
  resource :session, only: :create
  resources :users, only: [:create, :show]

  get "/sign_up" => "users#new", as: "sign_up"
  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"

  get '/forum', to: redirect('https://forum.ruby.org.au'),
    as: :forum
  get '/roro', to: redirect('https://groups.google.com/forum/#!forum/rails-oceania'),
    as: :roro_mailing_list
  get '/slack', to: redirect('https://ruby-au-join.herokuapp.com/'),
    as: :slack
  get '/videos', to: redirect('https://www.youtube.com/channel/UCr38SHAvOKMDyX3-8lhvJHA'),
    as: :videos

  get "/events/rubyconf_au_2020" => "events#rubyconf_au_2020"

  root to: 'pages#show', defaults: { id: 'welcome' }

  get "/*id" => 'pages#show', as: :page, format: false,
    constraints: RootRouteConstraints
end
