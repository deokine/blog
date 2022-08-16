Rails.application.routes.draw do
  resources :likes
  resources :comments
  devise_for :users, controllers: {registrations: 'users/registrations'} do
    collection do
      get ''
    end
  end
  resources :articles
  resources :scaffolds
  root "home#index"
  resources :users
  get '/:id', to: 'articles#show', as: 'show_article'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
