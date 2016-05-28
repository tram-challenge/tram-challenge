Rails.application.routes.draw do
  namespace :api do
    resource :player, only: %i(show update)
  end

  root "pages#home"
end
