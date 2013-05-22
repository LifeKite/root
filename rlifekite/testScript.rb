## The quick-and-nasty CVE-2013-0156 Heroku inspector!
## Originally brought to you by @elliottkember with changes by @markpundsack @ Heroku
## Download and run using:
## ruby heroku-CVE-2013-0156.rb
 
`heroku list`.split("\n").each do |app|
  app = app.strip
  
  # Some "heroku apps" lines have === formatting for grouping. They're not apps.
  next if app[0..2] == "==="
  
  # Some are appended by owner emails
  app = app.split(" ")[0].to_s.strip
  
  # Blank lines can be ommitted.
  next if app == ""
  
  rails_path = `heroku run bundle show rails --app #{app}`.split("\n")[-1]
  rails_version_number = rails_path.split("rails-")[1]
  rails_version_number = rails_version_number.strip unless rails_version_number.nil?
  
  unless ["3.2.11", "3.1.10", "3.0.19", "2.3.15"].include?(rails_version_number) or rails_version_number.nil?
    puts "Uh oh! #{app} has #{rails_version_number}."
  else
    puts "..."
  end
  
end