# Everett
[![Gem Version](https://badge.fury.io/rb/everett.svg)](http://badge.fury.io/rb/everett)
[![Build Status](https://travis-ci.org/yasaichi/everett.svg?branch=master)](https://travis-ci.org/yasaichi/everett)
[![Code Climate](https://codeclimate.com/github/yasaichi/everett/badges/gpa.svg)](https://codeclimate.com/github/yasaichi/everett)
[![Test Coverage](https://codeclimate.com/github/yasaichi/everett/badges/coverage.svg)](https://codeclimate.com/github/yasaichi/everett/coverage)

Everett is a substitute for `ActiveRecord::Observer` on Rails 5.

## Installation
Put this in your Gemfile:

```ruby
gem 'everett'
```

Run the installation generator with:

```sh
$ rails g everett:install
```

They will install the initializer into `config/initializers/everett.rb`.

## Usage
### Overview
Observers allow you to implement trigger-like behavior outside the original classes.  
You can put them anywhere, for example `app/observers/contact_observer.rb`:

```ruby
class ContactObserver < Everett::Observer
  def after_create(contact)
    Rails.logger.info('New contact added!')
  end

  def after_destroy(contact)
    Rails.logger.info("Contact with an id of #{contact.id} was destroyed!")
  end
end
```

This observer prints a log message when specific callbacks are triggered.

Just like `ActiveRecord::Observer`, the convention is to name observers after the class they observe.  
If you need to change this, or want to use one observer for several classes, use `observe`:

```ruby
class NotificationsObserver < Everett::Observer
  observe :comment, :like

  def after_create(record)
    # notifiy users of new comment or like
  end
end
```

Note that you must register observers first to activate them.  
This can be done by adding the following line into `config/initializers/everett.rb`:

```ruby
config.observers = :contact_observer, :notifications_observer
```

### after\_{create,update,destroy}\_commit
Since `after_create_commit`, `after_update_commit` and `after_destroy_commit` were introduced in Rails 5,
you can also use them in observers:

```ruby
class CommentObserver < Everett::Observer
  def after_create_commit(comment)
    CommentMailer.notification(comment).deliver_now
  end
end
```

This observer sends an email after a record has been created.

## Contributing
You should follow the steps below.

1. [Fork the repository](https://help.github.com/articles/fork-a-repo/)
2. Create a feature branch: `git checkout -b add-new-feature`
3. Commit your changes: `git commit -am 'add new feature'`
4. Push the branch: `git push origin add-new-feature`
4. [Send us a pull request](https://help.github.com/articles/about-pull-requests/)

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
