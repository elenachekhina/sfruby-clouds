class Avo::Resources::Delivery < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :participant, as: :belongs_to, searchable: true
    field :deliverable, as: :belongs_to, polymorphic_as: :deliverable, types: %w[Avo::Resources::Message Avo::Resources::Invitation]
    field :status, as: :select, enum: ::Delivery.statuses, readonly: true, sortable: true
    field :bounce_type
    field :created_at, as: :date_time, readonly: true, sortable: true
    field :opened_at, as: :date_time, readonly: true, sortable: true
    field :bounced_at, as: :date_time, readonly: true, sortable: true
  end
end
