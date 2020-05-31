class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
    username.downcase.gsub(" ","-")
  end
  #this formats the slug so that we can make urls out of it 
  #ie if a user's username was chris metzger, then we could use chris.slug to make chris-metzger
  #we can now use that string to make the route /users/chris-metzger
  #why anyone would allow users to make usernames with spaces is beyond me  
  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
  end
  #we can use this in our controller to find users by the slugs that are in the :slug key in params
end
