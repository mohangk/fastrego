# FastRego

FastRego is a an Rails application that helps you run your debate tournamentregistration. To find out more details about its feature checkout the [FastRego facebook page](http://www.facebook.com/fastrego).

If you would like to use FastRego but not go through the process of setting up, get in touch with us via our [enquiry form](http://fastrego.herokuapp.com/enquiry) and we will set up an account for you.

## Installation

1. Prerequisites on Ubuntu
  * Git
  * curl
  * postgresql (9.1)
  * postgresql-contrib (9.1)
  * build-essentials
  * libxml2-dev
  * libxslt1-dev
  * libq-dev
  * nodejs

2. Ensure that you have a working Ruby running on your machine, ideally setup via RVM. On Mac OS X or Linux, the following should set you up fine

    cd ~
    curl -L https://get.rvm.io | bash -s stable

For more information on setting up RVM, please refer to the [RVM install guide](https://rvm.io//rvm/install/) and follow the steps for the single use installation.

3. Clone this repository

    git clone git://github.com/mohangk/fastrego.git

4. Install the required gems

    bundle install

5. Setup the database. Make changes to config/databases.yml to reflect your local postgres authorization setup.

    rake db:create
    rake fastrego:add_hstore
    rake db:schema:load 
    rake db:seed

6. Start the app

    rails s
