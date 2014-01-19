# FastRego

FastRego is a web application that helps you run your debate tournament registration. To find out more details about its feature checkout the [FastRego facebook page](http://www.facebook.com/fastrego).

If you would like to use FastRego but not go through the process of setting it up, get in touch with us via our [enquiry form](http://fastrego.herokuapp.com/enquiry) and we will set up an account for you.

## Installation

1. Prerequisites on Ubuntu
  * Git
  * curl
  * postgresql (9.1)
  * postgresql-contrib (9.1)
  * build-essentials
  * libxml2-dev
  * libxslt1-dev
  * libpq-dev
  * nodejs
  * phantomjs - Refer to [poltergeist Github page](https://github.com/jonleighton/poltergeist#installing-phantomjs) for installation instructions.

2. Ensure that you have a working Ruby running on your machine, ideally setup via chruby. For chruby/Ruby setup instructions,
    ## Ubuntu

        wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
        tar -xzvf chruby-0.3.8.tar.gz
        cd chruby-0.3.8/
        sudo make install

    ## Mac:

        brew install chruby

For more information on how to setup chruby and Ruby, please refer to [chruby setup guide](https://github.com/postmodern/chruby).

3. Clone this repository

    git clone git://github.com/mohangk/fastrego.git

4. Install the required gems

    bundle install

5. Create a config/database.yml from config/database.yml.sample and make changes to config/database.yml to reflect your local postgres authorization setup.

   cp config/database.yml.sample config/database.yml

6. Setup the database. 

    rake db:create

    rake fastrego:add_hstore
        If you get the following error:
          PG::UndefinedFile: ERROR:  could not open extension control file "/usr/share/postgresql/9.3/extension/hstore.control": No such file or directory : CREATE EXTENSION hstore

        Try running this first because it might not be installed on your system:
          sudo apt-get install postgresql-contrib-x.x (please change x.x to the version of postgres that you're running. This can be checked by doing 'SELECT VERSION();" in psql)

    rake db:schema:load 

    rake db:seed

7. Start the app

    rails s

## Frequently Asked Questions

1. I'm having some problem getting specs up and running. It is complaining about uninitliazed constants. What do I do?

   Try including the following lines before 'Dir[Rails....].each { |f| require f }'
     require Rails.root.join("spec/support/page.rb")
     require Rails.root.join('spec/support/pages/admin_page.rb')

   This is because a different OS might have a different way of handling this and page.rb/admin_page.rb is a pre-requisite for some of the files.

## License

   Copyright 2012, 2014 Mohan Krishnan & Logan Balavijendran

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
