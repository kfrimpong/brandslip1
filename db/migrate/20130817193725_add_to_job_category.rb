class AddToJobCategory < ActiveRecord::Migration
  def up
        config = Rails.configuration.database_configuration[Rails.env]
        system("mysql -u#{config['username']} -p#{config['password']} -h#{config['host']} #{config['database']} < #{Rails.root}/db/jobcategorymasters.sql")
  end

  def down
  end
end
