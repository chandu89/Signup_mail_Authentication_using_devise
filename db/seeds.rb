# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

5.times do |ind|
	user = User.create! :first_name => "Choubey #{ind}", :last_name => "Choubey #{ind}",:username => "avi#{ind}",  :email => "avi#{ind}@gmail.com", :password => "topsecret#{ind}", :password_confirmation => "topsecret#{ind}"
	20.times do |ind1|
		user.posts.create! :post_name=> "Post #{ind1}", :description=> "Post description #{ind1}"
	end
end