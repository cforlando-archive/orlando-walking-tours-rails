# Orlando Walking Tours Rails

## Setup

### Dependencies

- [Homebrew](http://brew.sh/)

- [Postgres SQL](http://www.postgresql.org/download/)

  ```
  brew install postgresql
  ```

- Ruby 2.20 (rbenv recommended)

  ```
  brew update
  brew install ruby-build
  rbenv install 2.2.0
  ```

### Installation

1. Install bundler

  ```
  gem install bundler
  ```

2. Run bundler in the project directory

  ```
  bundle install
  ```

3. Set up your database configuration

  ```
  cp database.example.yml database.yml
  ```

  Enter the username and password of your local database

4. Run `rake db:setup`

5. Run `rails s` to start the application server locally


