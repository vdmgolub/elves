web: bundle exec thin -R config.ru -a 0.0.0.0 -p 8000 start
worker: bundle exec rake resque:work TERM_CHILD=1
