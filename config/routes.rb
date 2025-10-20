Rails.application.routes.draw do
  mount Avo::Engine, at: Avo.configuration.root_path

  namespace :dev do
    if Rails.application.config.action_mailer.delivery_method == :letter_opener_web
      mount LetterOpenerWeb::Engine, at: "/letters"
    end

    if Rails.application.config.lookbook_enabled
      mount Lookbook::Engine, at: "/lookbook"
    end
  end

  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :clouds, only: [:index, :show]

  scope "/c/:access_token" do
    resource :participant

    get "/", to: "participant#show", as: :participant_cloud
  end

  # Defines the root path route ("/")
  root "clouds#index"
end
