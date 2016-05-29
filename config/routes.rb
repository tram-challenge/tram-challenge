Rails.application.routes.draw do
  namespace :api do
    resource :player, only: %i(show update)
    resources :stops, only: %i(show index)
    put "stops/:id" => "attempt_stops#update", as: :update_attempt_stop
    resources :attempts, only: %i(index show create update)

    resource :leaderboard, only: %i(show)
  end

  resources :tram_routes, path: "routes", only: %i(index show)

  resource :leaderboard, only: %i(show)

  root "pages#home"

  get "map" => "pages#map"
  get "rules" => "pages#rules"
end
