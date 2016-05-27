# Tram Challenge

Inspired by the [London Tube Challenge][], we present the **Helsinki Tram Challenge**.

To paraphrase Wikipedia, the goal is to visit all the tram stops on the system, not necessarily all the lines; participants may connect between stops on foot, or by using other forms of public transport.

[London Tube Challenge]: https://en.wikipedia.org/wiki/Tube_Challenge

## System requirements

* Ruby 2.3.x
* PostgreSQL 9.4 or above
* Redis 2.8 or above

## Development set-up

1. Clone the repo

  ```sh
  git clone git@github.com:tram-challenge/tram-challenge.git
  cd tram-challenge
  ```

2. Install the dependencies

  ```sh
  bundle install
  ```

3. Set-up the database

  ```sh
  ./bin/rails db:setup
  ```

4. Start the development server

  ```sh
  ./bin/rails s
  ```
