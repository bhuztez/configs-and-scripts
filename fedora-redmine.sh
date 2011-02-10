#!/usr/bin/env bash

wget http://rubyforge.org/frs/download.php/74128/redmine-1.1.1.tar.gz
tar xzf redmine-1.1.1.tar.gz
mv redmine-1.1.1 redmine

wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz
tar xzf rubygems-1.3.5.tgz

export GEM_HOME="$(pwd)/redmine/gem_env"
export RUBYLIB="${GEM_HOME}/lib/ruby/site_ruby:${GEM_HOME}/lib"
mkdir -p "${GEM_HOME}/bin"
export PATH="${GEM_HOME}/bin:${PATH}"

wget http://r-labs.googlecode.com/files/redmine_code_review-0.3.1.zip
unzip redmine_code_review-0.3.1.zip
mv redmine_code_review redmine/vendor/plugins

cd rubygems-1.3.5
ruby setup.rb --prefix="${GEM_HOME}"
cd ..

cat > "${GEM_HOME}/bin/activate" << EOF 
#!/usr/bin/env bash

export GEM_HOME="${GEM_HOME}"
export PATH="${GEM_HOME}/bin:\${PATH}"
export RUBYLIB="${GEM_HOME}/lib/ruby/site_ruby:\${RUBYLIB}"
EOF

chmod u+x "${GEM_HOME}/bin/activate"

gem install rake
gem install rack -v=1.0.1
gem install i18n -v=0.4.2
gem install sqlite3

cd redmine

cat > "config/database.yml" << EOF
production:
  adapter: sqlite3
  dbfile: db/redmine.db
EOF

rake generate_session_store
rake db:migrate RAILS_ENV=production
rake redmine:load_default_data RAILS_ENV=production

# ruby script/plugin install git://github.com/AdamLantos/redmine_http_auth.git
rake db:migrate_plugins RAILS_ENV=production

cd ..
rm -rf i18n-0.4.2.gem redmine-1.1.1.tar.gz redmine_code_review-0.3.1.zip rubygems-1.3.5.tgz rubygems-1.3.5

