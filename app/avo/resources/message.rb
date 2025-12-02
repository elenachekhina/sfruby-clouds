class Avo::Resources::Message < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :participant, as: :belongs_to, searchable: true, readonly: true
    field :delivery, as: :has_one
    field :message_campaign, as: :belongs_to, searchable: true, readonly: true
    field :status, as: :select, enum: ::Delivery.statuses, sortable: true, readonly: true
    field :bounce_type
    field :created_at, as: :date_time, readonly: true, sortable: true
    field :opened_at, as: :date_time, readonly: true, sortable: true
    field :bounced_at, as: :date_time, readonly: true, sortable: true
  end
end
