#
# Load an individual message
#
# @author Seth Vargo
#
class MessageWorker
  include Sidekiq::Worker

  # Find or update the given message
  #
  # @param [Integer] mailbox_id the mailbox_id to find the message in
  # @param [Binary] message Marshall dump of the message
  def perform(mailbox_id)
    @mailbox = Mailbox.find(mailbox_id)
    @account = @mailbox.account
    @imap = Envelope::IMAP.new(@account)

    # RFC-4549 recommends the following commands:
    #   tag1 UID FETCH <last_seen_uid+1>:* <descriptors>
    #   tag2 UID FETCH 1:<last_seen_uid> FLAGS
    #
    # tag2 is handled by Envelope::MessageUpdateWorker
    #
    # Fetch all messages from the last_seen_uid+1 to the end, iterate,
    # and mass-import the messages.
    messages = @imap.uid_fetch(@mailbox, [@mailbox.last_seen_uid+1...-1], ['RFC822', 'FLAGS'])

    # Ruby's Net::IMAP.uid_fetch includes the last fetched UID (because of -1),
    # so we need to delete that message from the Hash.
    # messages.delete(@mailbox.last_seen_uid)
    existing_uids = @mailbox.messages.collect(&:uid)
    messages.delete_if{ |k,v| existing_uids.include?(k) }

    messages.values.each do |message|
      @mailbox.messages.create!(
        mailbox_id: @mailbox.id,
        uid: message.uid,
        message_id: message.message_id,
        subject: message.subject,
        timestamp: message.timestamp,
        read: message.read?,
        flags: message.flags,
        flagged: message.flagged?,
        # full_text_part: message.full_text_part,
        text_part: message.text_part,
        # full_html_part: message.full_html_part,
        html_part: message.html_part,
        sanitized_html: message.sanitized_html,
        raw: message.raw_source,
        participants_attributes: message.participants
      )
    end

    # # Create an Array of messages to mass-insert into Mongo.
    # hash = messages.values.collect do |message|
    #   {
    #     mailbox_id: @mailbox.id,
    #     uid: message.uid,
    #     message_id: message.message_id,
    #     subject: message.subject,
    #     timestamp: message.timestamp,
    #     read: message.read?,
    #     flags: message.flags,
    #     flagged: message.flagged?,
    #     # full_text_part: message.full_text_part,
    #     text_part: message.text_part,
    #     # full_html_part: message.full_html_part,
    #     html_part: message.html_part,
    #     sanitized_html: message.sanitized_html,
    #     raw: message.raw_source,
    #     participants_attributes: message.participants
    #   }
    # end

    # # Mongo places a limit on the size of a document that can be inserted
    # # at one time, so let's move in batches of 2500.
    # hash.each_slice(2500) do |batch|
    #   Message.collection.insert(batch)
    # end
  end
end
