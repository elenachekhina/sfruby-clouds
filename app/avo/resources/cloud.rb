class Avo::Resources::Cloud < Avo::BaseResource
  self.includes = [:participant, {image_attachment: :blob, generated_image_attachment: :blob}]

  self.search = {
    query: -> {
      query.ransack(
        participant_full_name_cont: params[:q],
        participant_email_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    }
  }

  class BulkDelete < Avo::BaseAction
    self.name = "Delete Cards"
    self.no_confirmation = false

    def handle(query:, fields:, current_user:, resource:, **args)
      clouds = Array(resource.record || query.to_a)

      clouds.each(&:destroy!)

      succeed "Done!"
    end
  end

  def fields
    field :id, as: :id, link_to_record: true

    field :participant, as: :belongs_to, searchable: true

    field :picked, as: :boolean, sortable: true

    field :image, as: :file, is_image: true, display_filename: true
    field :generated_image, as: :file, is_image: true, display_filename: true

    field :state, as: :select, enum: ::Cloud.states
    field :failure_reason

    field :created_at, as: :date_time, readonly: true, sortable: true
    field :updated_at, as: :date_time, readonly: true, sortable: true
  end

  def actions
    action BulkDelete
  end
end
