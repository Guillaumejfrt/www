Rails.application.routes.draw do

  # config/static_routes.yml
  STATIC_ROUTES.each do |template, locale_paths|
    locale_paths.each do |locale, page|
      get page => "pages#show", template: template, locale: locale, as: "#{template}_#{locale}".to_sym
    end
  end

  root to: "pages#show", template: "home"

  scope "(:locale)", locale: /fr|en/ do
    get "faq", to: "pages#show", template: "faq", as: :faq
    get "jobs", to: "pages#show", template: "jobs", as: :jobs
    get "tv", to: "pages#tv", template: "tv", as: :tv
    get "alumni" => "students#index", as: :alumni
    get ":city" => "cities#show", city: /#{CITIES.join("|")}|/, as: :city
    resources :projects, only: [:show]
    resources :students, only: [:show]
    get "blog", to: 'posts#index'
    get "blog/:slug", to: 'posts#show'
  end

  # Blog (TODO)

end

# Create helper for static_routes
Rails.application.routes.url_helpers.module_eval do
  STATIC_ROUTES.each do |route, _|
    define_method "#{route}_path".to_sym do |args = {}|
      locale = args[:locale] || :fr
      self.send(:"#{route}_#{locale}_path")
    end

    define_method "#{route}_url".to_sym do |args = {}|
      locale = args[:locale] || :fr
      self.send(:"#{route}_#{locale}_url")
    end
  end
end
