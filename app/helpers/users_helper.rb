module UsersHelper

  # Returns the top n users based on ratings
  def get_top_users(n: 10)
    users = User.all.sort_by do |user|
      user.items.sum do |item|
        item.reviews.sum do |review|
          review.rating
        end
      end
    end
    users[0..n]
  end

end
