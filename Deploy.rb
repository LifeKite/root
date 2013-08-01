#namespace :deploy do
  #desc 'Deploy LifeKite'
  #task :production do
    app = "growing-river-6245"
    remote = "git@heroku.com:#{app}.git"

    system "heroku maintenance:on --app #{app}"
    system "git push #{remote} master"
    system "heroku run rake db:migrate --app #{app}"
    system "heroku maintenance:off --app #{app}"
  #end
#end