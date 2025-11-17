class Avo::Resources::Message < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :recipient, as: :belongs_to, searchable: true, readonly: true
    field :message_campaign, as: :belongs_to, searchable: true, readonly: true
    field :status, as: :select, enum: ::Message.statuses, sortable: true, readonly: true
  end
end
