class AddAttachmentProfilePictureToParticipants < ActiveRecord::Migration
  def change
    add_attachment :participants, :profile_picture
  end
end
