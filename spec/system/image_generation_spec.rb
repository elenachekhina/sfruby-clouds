require "system_helper"

describe "Image generation flow" do
  let_it_be(:participant) { create(:participant, full_name: "Vova", email: "vova@sf.test") }

  it "participant can access an image form from the email" do
    participant.invitations.create!

    perform_enqueued_jobs

    expect(all_emails).not_to be_empty
    open_email("vova@sf.test")

    current_email.click_link "Create My Cloud Card"

    expect(page).to have_text "Let's create your Cloud Card"
  end
end
