# Sample Rule File

###############
# @message
###############
# @message.body
#   => body of the message
# @message.from_handle
#   => skypename of the originator of the message
# @message.from_display_name
#   => display name of the originator of the message

###############
# Example
###############
# if @message.body.include?("hello")
#   accept!
# end
# if @message.from_handle == "someone"
#   reject!
# end
# if @message.from_display_name == "someone"
#   reject!
# end
# accept!
