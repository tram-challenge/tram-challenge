source "https://rubygems.org"


gem "rails", ">= 5.0.0.rc1", "< 5.1"

gem "pg", "~> 0.18"

gem "puma", "~> 3.0"

gem "slim-rails"

gem "sass-rails", "~> 5.0"
gem "bootswatch-sass", "~> 3.3.0"

gem "uglifier", ">= 1.3.0"

gem "coffee-rails", "~> 4.1.0"

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

gem "jquery-rails"
gem "turbolinks", "~> 5.x"

gem "http"

gem "geocoder"

source "https://rails-assets.org" do
  # Asset gems
end

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"
# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

gem "dotenv-rails"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platform: :mri
  gem "pry-rails"

  gem "rspec-rails", "~> 3.5.x"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console"
  gem "listen", "~> 3.0.5"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "shoulda-matchers", "~> 3.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
