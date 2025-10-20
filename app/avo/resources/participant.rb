class Avo::Resources::Participant < Avo::BaseResource
  self.title = :full_name
  self.includes = [:picked_cloud]

  self.search = {
    query: -> {
      query.ransack(
        full_name_cont: params[:q],
        email_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    }
  }

  class QuickFilter < Avo::Filters::SelectFilter
    self.name = "Quick Filters"

    def apply(request, query, value)
      query.public_send(value)
    end

    def options = {
      without_invitations: "Not invited",
      without_picked_cloud: "W/o generated cards"
    }
  end

  class SendInvitation < Avo::BaseAction
    self.name = "Send Invitations"
    self.no_confirmation = false

    def fields
      field :resend, as: :boolean, help: "Check this to resend invitations even if already sent"
    end

    def handle(query:, fields:, current_user:, resource:, **args)
      resend = fields[:resend]
      participants = Array(resource.record || query.all.to_a)

      total_sent = 0

      participants.each do |participant|
        next if !participant.email_notifications_enabled? ||
          (!resend && participant.invitations_count > 0)

        total_sent += 1

        participant.invitations.create!
      end

      succeed "Done! #{total_sent} invitations sent"
    end
  end

  def fields
    field :id, as: :id, link_to_record: true

    field :full_name, as: :text, required: true, sortable: true
    field :email, as: :text, required: true, sortable: true
    field :ticket_type, as: :text, sortable: true

    field :public_url, as: :text, readonly: true, copy_on_click: true do
      "#{request.base_url}/c/#{record.access_token}" if record.access_token
    end

    field :blocked, as: :boolean, sortable: true
    field :cloud_generations_count, as: :number, sortable: true

    field :last_invitation_sent_at, as: :date_time do
      record.invitations.last&.created_at
    end

    field :picked_cloud_image, as: :file, is_image: true do
      record.picked_cloud&.generated_image
    end
  end

  def filters
    filter QuickFilter
  end

  def actions
    action SendInvitation
    action Avo::Actions::ImportParticipants
  end
end
