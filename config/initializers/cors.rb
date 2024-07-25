Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:3000", "https://checkout.stripe.com/"
    resource "*", headers: :any, methods: [:get, :post, :put, :patch, :delete, :options], credentials: true
  end
end
