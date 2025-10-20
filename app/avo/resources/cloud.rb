class Avo::Resources::Cloud < Avo::BaseResource
  self.includes = [:participant, :image_attachment, :generated_image_attachment]

  self.search = {
    query: -> {
      query.ransack(
        participant_full_name_cont: params[:q],
        participant_email_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    }
  }

  def fields
    field :id, as: :id, link_to_record: true

    field :participant, as: :belongs_to, searchable: true, sortable: true

    field :picked, as: :boolean, sortable: true

    field :image, as: :file, is_image: true, display_filename: true
    field :generated_image, as: :file, is_image: true, display_filename: true

    field :state, as: :badge, sortable: true do
      case record.state
      when "generated"
        "Generated"
      when "nsfw_checked"
        "NSFW Checked"
      when "uploaded"
        "Uploaded"
      when "failed"
        "Failed"
      else
        record.status.titleize
      end
    end

    field :created_at, as: :date_time, readonly: true, sortable: true
    field :updated_at, as: :date_time, readonly: true, sortable: true
  end
end
