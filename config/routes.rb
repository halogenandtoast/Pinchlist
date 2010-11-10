Pinchlist::Application.routes.draw do
  get "pages/about"

  get "pages/legal"

  get "pages/help"

  devise_for :users
  root :to => "home#index"
  match 'dashboard', :to => 'dashboards#show', :as => :dashboard
  resources :lists, :only => [:create, :update, :destroy] do
    resources :tasks, :only => [:create, :update], :shallow => true
  end

  resources :tasks, :only => [:update]
end
