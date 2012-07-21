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
  * libpq-dev
  * nodejs
  * phantomjs - Refer to [poltergeist Github page](https://github.com/jonleighton/poltergeist#installing-phantomjs) for installation instructions.

2. Ensure that you have a working Ruby running on your machine, ideally setup via RVM. On Mac OS X or Linux, the following should set you up fine

    cd ~
    curl -L https://get.rvm.io | bash -s stable

For more information on setting up RVM, please refer to the [RVM install guide](https://rvm.io//rvm/install/) and follow the steps for the single use installation.

3. Clone this repository

    git clone git://github.com/mohangk/fastrego.git

4. Install the required gems

    bundle install

5. Create a config/database.yml from config/databases.yml.sample and make changes to config/databases.yml to reflect your local postgres authorization setup.

   cp config/databases.yml.sample config/databases.yml

6. Setup the database. 

    rake db:create

    rake fastrego:add_hstore

    rake db:schema:load 

    rake db:seed

7. Start the app

    rails s

## License

   Copyright 2012 Mohan Krishnan & Logan Balavijendran

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
