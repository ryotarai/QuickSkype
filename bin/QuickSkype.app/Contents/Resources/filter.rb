def exit_with_accept
  print "accept"
  exit 0
end

def exit_with_reject
  print "reject"
  exit 1
end

class Chat
  attr_accessor :name
  attr_accessor :friendly_name
end

class Message
  attr_accessor :chat
  attr_accessor :body
  attr_accessor :from_handle
  attr_accessor :from_display_name
end

class MessageFilter
  def initialize(message)
    @message = message
  end
  
  def reject!
    exit_with_reject
  end
  
  def accept!
    exit_with_accept
  end
end

if __FILE__ == $0
  message = Message.new
  message.chat = Chat.new
  
  rule_path,
  message.body,
  message.from_handle,
  message.from_display_name,
  message.chat.name,
  message.chat.friendly_name = ARGV

  rules = open(rule_path, &:read)

  message_filter = MessageFilter.new(message)
  message_filter.instance_eval rules

  exit_with_accept
end
