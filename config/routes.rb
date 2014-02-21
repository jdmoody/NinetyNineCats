NinetyNineCats::Application.routes.draw do

  resources :cats do
    resources :cat_rental_requests, only: :index
  end

  resources :users, only: [:new, :create, :show]

  resource :session, only: [:new, :create, :destroy]

  resources :cat_rental_requests, except: :index do
    post 'approve', :to => 'cat_rental_requests#approve'
    post 'deny', :to => 'cat_rental_requests#deny'
  end
end