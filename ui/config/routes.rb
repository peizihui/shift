Rails.application.routes.draw do
  get 'migrations/index'

  get '/_status', to: 'health#status'
  resources :migrations, :only => [:show, :index, :new, :create, :destroy, :update]
  resources :migrations do
    member do
      post 'next_step'
      post 'cancel'
      post 'approve'
      post 'unapprove'
      post 'start'
      post 'pause'
      post 'rename'
      post 'resume'
      post 'dequeue'
      get 'refresh_detail'
    end
  end
  get '/ptosc_log_file/:id', to: 'log#ptosc_log_file'
  get '/databases', to: 'database#fetch'
  post '/parser', to: 'parser#parse'
  get '/status_image/:id', to: 'migrations#status_image'

  resources :meta_requests, :only => [:show, :index, :new, :create, :update]
  resources :meta_requests do
    member do
      post 'bulk_action'
    end
  end

  resources :comments, :only => [:create, :destroy]

  # TODO: set default path (or remove it, this is only here because acceptance specs
  # require a root)
  root to: 'migrations#index'

  namespace :api do
    namespace :v1 do
      resources :migrations do
        collection do
          get 'staged'
          post 'unstage'
          post 'next_step'
          post 'complete'
          post 'cancel'
          post 'fail'
          post 'error'
        end
      end
      resources :migrations, :only => [:show, :update]
    end
  end

  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]
end
