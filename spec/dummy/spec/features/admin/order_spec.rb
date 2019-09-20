RSpec.describe 'Sample' do
  it 'allow admin to create new order' do
    given_i_am_logged_as_admin
    when_i_visit_orders_page
  end
end
