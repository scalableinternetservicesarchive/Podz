module RentalsHelper

  def display_renter_title(rental)
    @renter_name = User.find_by(id: rental.user_id).display_name
  end
end
