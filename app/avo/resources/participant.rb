class Avo::Resources::Participant < Avo::BaseResource
  self.title = :full_name

  self.search = {
    query: -> {
      query.ransack(
        full_name_cont: params[:q],
        email_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    field :full_name, as: :text, required: true, sortable: true
    field :email, as: :text, required: true, sortable: true
    field :ticket_type, as: :text, sortable: true

    field :public_url, as: :text, readonly: true, copy_on_click: true do
      "#{request.base_url}/c/#{record.access_token}" if record.access_token
    end

    # field :image_generated, as: :boolean, sortable: true
    field :blocked, as: :boolean, sortable: true
    field :cloud_generations_count, as: :number, sortable: true

    # field :invitation_sent_at, as: :date_time, sortable: true
    # field :invitation_email_opened_at, as: :date_time
    # field :email_bounced, as: :boolean, sortable: true

    # field :generated_image, as: :has_one
  end
end
