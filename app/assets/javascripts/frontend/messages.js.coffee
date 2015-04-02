$(document).on 'page:reloaded', ->
  if Jianggaowang.messages
    for type, message of Jianggaowang.messages
      noty
        text: message
        type: type
