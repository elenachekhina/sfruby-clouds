class Avo::Actions::ImportParticipants < Avo::BaseAction
  self.name = "Import Attendees from CSV"
  self.message = "Upload a CSV file from your ticketing software. Only approved attendees will be imported."
  self.standalone = true
  self.visible = -> { true }

  def fields
    field :csv_file, as: :file, help: "CSV must include: first_name, last_name, email, approval_status, ticket_name"
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    csv_file = fields[:csv_file]

    csv_content = csv_file.read.force_encoding("UTF-8")

    participants_to_invite = []

    skipped = {
      not_approved: 0,
      no_email: 0,
      no_name: 0
    }

    CSV.parse(csv_content, headers: true, header_converters: :symbol) do |row|
      next skipped[:not_approved] += 1 if row[:approval_status]&.downcase&.strip != "approved"

      email = row[:email]&.strip&.downcase
      next skipped[:no_email] += 1 if email.blank?

      first_name = row[:first_name]&.strip
      last_name = row[:last_name]&.strip

      full_name = [first_name, last_name].compact.join(" ").presence
      next skipped[:no_name] += 1 if full_name.blank?

      ticket_type = row[:ticket_name]&.strip

      participants_to_invite << {
        email:,
        full_name:,
        ticket_type:
      }
    end

    created_count = 0
    participants_to_invite.each do |attrs|
      participant = Participant.create_with(attrs).find_or_create_by(email: attrs[:email])
      created_count += 1 if participant.persisted?
    end

    succeed "Successfully imported attendees!\n" \
            "Newly created: #{created_count}\n" \
            "Already existed: #{participants_to_invite.size - created_count}\n" \
            "Skipped (not approved): #{skipped[:not_approved]}\n" \
            "Skipped (no email): #{skipped[:no_email]}\n" \
            "Skipped (no name): #{skipped[:no_name]}"
  end
end
