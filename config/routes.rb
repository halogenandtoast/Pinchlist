Pinchlist::Application.routes.draw do
  devise_for :users
  root :to => "home#index"
  match 'dashboard', :to => 'dashboards#show', :as => :dashboard
  resources :lists, :only => [:create, :destroy] do
    resources :tasks, :only => [:create, :update], :shallow => true
  end
end
