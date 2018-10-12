Rails.application.routes.draw do
  resources :reviews
  resources :categories
  resources :items
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get  '/new_review', to: 'reviews#new'
  get  '/reviews', to: 'reviews#index'
  get  '/about',   to: 'static_pages#about'
  get  '/new',   to: 'items#new'
  get  '/items',   to: 'items#index'
  get  'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
