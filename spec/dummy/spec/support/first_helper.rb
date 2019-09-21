module FirstHelper
  def i_am_logged_as_admin
    sign_in admin
  end

  def i_visit_order_page
    visit order_page
  end
end
