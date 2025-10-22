class Avo::Resources::Invitation < Avo::BaseResource
  self.includes = [:participant]

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

    field :participant, as: :belongs_to, searchable: true

    field :status, as: :select, enum: ::Invitation.statuses, sortable: true, readonly: true

    field :bounce_type

    field :created_at, as: :date_time, readonly: true, sortable: true
    field :opened_at, as: :date_time, readonly: true, sortable: true
    field :bounced_at, as: :date_time, readonly: true, sortable: true
  end
end
