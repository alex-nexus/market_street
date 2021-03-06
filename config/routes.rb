require 'sidekiq/web'

MarketStreet::Application.routes.draw do
  root :to => "home#index"
  
  #login
  get 'login' => 'customer/user_sessions#new'
  delete 'logout' => 'customer/user_sessions#destroy'
  get 'signup' => 'customer/registrations#new'
  get 'admin' => 'admin/reports#dashboard'

  #static
  get 'about' => 'home#about', as: :about_home
  get 'faq' => 'home#faq', as: :faq_home
  get 'terms' => 'home#terms', as: :terms_home
  get 'subscription' => 'home#subscription', as: :subscription_home
  
  #comments
  resource :comment, :only => [:create, :destroy]

  #CUSTOMER
  namespace :customer do
    resources :registrations,   :only => [:index, :new, :create] do 
      member do 
        get :activate
      end
    end

    resources :user_sessions, :only => [:new, :create, :destroy]
    resource  :password_reset,  :only => [:new, :create, :edit, :update]
    resource  :activation,      :only => [:show]

    resource  :overview, :only => [:show, :edit, :update]
    resources :orders, :only => [:index, :show]
    resources :addresses
    resources :credit_cards
    resources :referrals, :only => [:index, :create, :update]
    resource  :store_credit, :only => [:show]    
  end

  namespace :catalog do
    resources :products, :only => [:index, :show, :create]
  end

  #SHOPPING
  namespace :shopping do
    resource :carts, :only => [:update]
    get 'cart' => 'carts#index', as: :cart
    get 'cart/review' => 'carts#review', as: :cart_review    
    post 'cart/add_coupon' => 'carts#add_coupon', as: :cart_add_coupon    
    post 'cart/checkout' => 'carts#checkout', as: :cart_checkout
    
    resources :cart_items, :only => [:update, :create, :destroy] 
    resources :wish_items, :only => [:index, :create, :destroy]    
    resource  :coupon, :only => [:show, :create]
    
    #toberemoved
    resources  :addresses 
    resources  :billing_addresses

    resources  :orders do
      member do
        get :confirmation
      end
    end    
  end
  
  #ADMIN
  namespace :admin do
    mount Sidekiq::Web => '/jobs'
    mount RailsAdmin::Engine => '/super', :as => 'super'
  
    namespace :customer do
      resources :users do
        resource :store_credits, :only => [:show, :edit, :update]
        resources :addresses
        resources :comments
      end

      resources :referrals do
        member do
          post :apply
        end
      end      
    end

    namespace :fulfillment do
      resources  :orders do
        resources  :addresses, :controller => 'order_addresses', :except => [:destroy]
        member do
          put :create_shipment
        end
        resources  :comments
        resources  :return_authorizations do
          member do
            put :complete
          end
        end
      end

      namespace :partial do
        resources  :orders do
          resources :shipments, :only => [ :create, :new, :update ]
        end
      end

      resources  :shipments do
        member do
          put :ship
        end
        resources  :addresses , :only => [:edit, :update]
      end
      
      resources :invoices      
    end
    
    namespace :config do
      resources :countries, :only => [:index, :update, :destroy]
      resources :shipping_rates
      resources :shipping_methods
      resources :shipping_zones
      resources :tax_rates
      resources :tax_categories
    end

    namespace :offer do
      resources :coupons
      resources :deals
      resources :sales
    end
    namespace :inventory do
      resources :suppliers
      resources :overviews
      resources :purchase_orders
      resources :receivings
      resources :adjustments
    end

    namespace :catalog do
      namespace :images do
        resources :products
      end
      resources :properties
      resources :prototypes
      resources :brands
      resources :product_types
      resources :prototype_properties

      namespace :changes do
        resources :products do
          resource :property,          :only => [:edit, :update]
        end
      end

      namespace :wizards do
        resources :brands,              :only => [:index, :create, :update]
        resources :products,            :only => [:new, :create]
        resources :properties,          :only => [:index, :create, :update]
        resources :prototypes,          :only => [:update]
        resources :tax_categories,        :only => [:index, :create, :update]
        resources :product_types,       :only => [:index, :create, :update]
      end

      namespace :multi do
        resources :products do
          resource :variant,      :only => [:edit, :update]
        end
      end
      resources :products do
        member do
          get :add_properties
          put :activate
        end
        resources :variants
      end
      namespace :products do
        resources :descriptions, :only => [:edit, :update]
      end
    end    

    get 'onboard' => 'onboard#index', as: :onboard         
    get 'dashboard' => 'reports#dashboard', as: :dashboard          
  end
end
