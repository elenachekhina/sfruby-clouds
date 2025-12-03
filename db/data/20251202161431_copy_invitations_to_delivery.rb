# frozen_string_literal: true
# claude
class CopyInvitationsToDelivery < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      INSERT INTO deliveries (participant_id, deliverable_type, deliverable_id, status, opened_at, bounce_type, bounced_at, created_at, updated_at)
      SELECT participant_id, 'Invitation', id, status, opened_at, bounce_type, bounced_at, created_at, updated_at
      FROM invitations
    SQL
  end

  def down
    execute <<~SQL
      UPDATE invitations
      SET participant_id = deliveries.participant_id,
          status = deliveries.status,
          opened_at = deliveries.opened_at,
          bounce_type = deliveries.bounce_type,
          bounced_at = deliveries.bounced_at
      FROM deliveries
      WHERE deliveries.deliverable_type = 'Invitation'
        AND deliveries.deliverable_id = invitations.id
    SQL

    execute <<~SQL
      DELETE FROM deliveries WHERE deliverable_type = 'Invitation'
    SQL
  end
end
