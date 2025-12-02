class Avo::Resources::Invitation < Avo::BaseResource
  self.includes = [:participant]

  self.search = {
    query: -> {
      query.joins(:participant)
        .merge(Participant.search(params[:q]))
    },
    item: -> do
      {
        title: "#{record.id} (#{record.participant.full_name} — #{record.participant.email})"
      }
    end
  }

  def fields
    field :id, as: :id, link_to_record: true

    field :participant, as: :belongs_to, searchable: true
    field :delivery, as: :has_one

    field :status, as: :select, enum: ::Delivery.statuses, sortable: true, readonly: true

    field :bounce_type

    field :created_at, as: :date_time, readonly: true, sortable: true
    field :opened_at, as: :date_time, readonly: true, sortable: true
    field :bounced_at, as: :date_time, readonly: true, sortable: true
  end
end
