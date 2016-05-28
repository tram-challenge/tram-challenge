Rails.application.routes.draw do
  namespace :api do
    resource :player, only: %i(show update)
    resources :stops, only: %i(show index)
    resources :attempts, only: %i(index show create update) do
      resources :attempt_stops, only: %i(index show update)
    end
  end

  root "pages#home"

  get "map" => "pages#map"
end
