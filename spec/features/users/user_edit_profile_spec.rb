require 'rails_helper'

describe 'as a user when I visit my profile' do
  it 'there is a link to edit my profile' do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path

    click_link "Edit Profile"
      expect(current_path).to eq(profile_edit_path)

    visit profile_path
  end

  it 'I can set my dietary preferences and they will stay checked when I revisit' do
    user = create(:user)
    user.restrictions.create(name: 'vegetarian')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_edit_path

    expect(page).to have_content user.name

    expect(page).to have_content user.email

    check 'vegetarian'
    check 'gluten_free'

    click_button "Update Profile"

    expect(current_path).to eq profile_path
    expect(page).to have_content("vegetarian")
    expect(page).to have_content("gluten free")

    visit profile_edit_path

    expect(page).to have_field(:vegetarian, checked: true)
    expect(page).to have_field(:gluten_free, checked: true)
    expect(page).to have_field(:dairy_free, checked: false)
    expect(page).to have_field(:keto, checked: false)
  end
end
