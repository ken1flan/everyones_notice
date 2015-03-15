Rails.application.routes.draw do

  resources :notices do
    member do
      get "opened"
      get "not_opened"
      post "add_tag"
    end
    collection do
      get "todays"
      get "unread"
      get "draft"
      get "watched"
      get "searched_by_word"
    end
    resources :replies
  end

  resources :tags, only: [:index, :show]
  resources :activities, only: [:index] do
    collection do
      get "all"
    end
  end

  resource :reputation, only: [] do
    get 'notice/:id/:up_down' => 'reputation#notice'
    get 'reply/:id/:up_down' => 'reputation#reply'
  end

  resources :post_images, except: [:edit, :update] do
    collection do
      get "all"
    end
  end

  resources :advertisements

  root "top#index"
  get "current_user_activities", to: "top#current_user_activities"
  get "current_club_activities", to: "top#current_club_activities"

  resource :login, only: [:show]
  resources :users do
    member do
      get 'notices'
      get 'replies'
      get 'activities'
    end
  end
  resources :invitations, except: [:edit, :update]
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signout", to: "sessions#destroy", as: :signout

  resources :feedbacks, only: [:index, :show, :create]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
