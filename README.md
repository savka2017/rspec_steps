# RspecSteps

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rspec_steps`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_steps', git: 'https://github.com/savka2017/rspec_steps'
```

And then execute:

    $ bundle

Run:

    $ rails g rspec_steps:install
    
    
to setup some initial values for gem.    
## Usage

**Write some spec:**

given_i_am_logged_as_admin  
when_i_click_button('Create order')  
and_i_fill_all_requisites  
then_i_should_see_confirmation('Order created succesfully')  
and_new_record_should_be_added_to_db

**Run:**

    $ rails g rspec_steps spec/path_to_this_spec/this_spec.rb
   
In spec/rspec_steps/path_to_this_spec/this_helper.rb you receive method-definitions for all methods from this_spec.rb.  
As following:

`def i_am_logged_as_admin`  
`end`

`def i_click_button(arg1)`  
`end`

`def i_fill_all_requisites`  
`end`

`def i_should_see_confirmation(arg1)`  
`end`

`def new_record_should_be_added_to_db`  
`end`

**Important: All methods in helper should be without prefixes.**

Definitions are build only for methods that start with:  
 *given_, when_, then_, and_*  
 All other methods will be ignored by gem.
 
 If some method already defined in this or another helper, 
 its definition do not creates. 
 Instead, to the end of line will be add comment with file location.  
  E.g.:  
  `when_i_log_out # spec/support/another_helper.rb`

You can use each method in spec several times whith different prefixes. 

Finally, you can write some turnip-acceptance test.
 Use defined methods to build turnip-steps:

`step 'I am logged as admin' do`  
`i_am_logged_as_admin`  
`end`

`step 'I create new order' do`  
`i_click_button('Create order')`  
`and_i_fill_all_requisites`  
`end`

`step 'New order are successfully created' do`  
`i_should_see_confirmation('Order created succesfully')`  
`and_new_record_should_be_added_to_db`  
`end`

If you are too lazy to write turnip step-definition by hand,
run:

    $ rails g rspec_steps spec/path_to_this_feature/some_steps.feature

Gem will build all new step-definition for you.

In step definition you can use methods with or without prefixes.  
Group them accordingly to logic of step description.  
Main creteria: readability.

Correct config/initializers/rspec_steps.rb if you want to 
change default working and destination dirs, 
allow or forbid comments, change prefixes.

### What can you change?
 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec_steps. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RspecSteps project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rspec_steps/blob/master/CODE_OF_CONDUCT.md).
