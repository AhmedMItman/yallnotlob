App.notify = App.cable.subscriptions.create "NotifyChannel",
  connected: ->
    console.log "Hello"
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log data['typ']
    if data['typ'] == "finished"
      takeIDFromNotification(data['orderId'],"finished")

    if data['typ'] == "cancel"
      takeIDFromNotification(data['orderId'],"cancel")

    setNotification data['typ'], data['message'] , data['orderId'], data['created_at']




  invite: ->
    @perform 'invite'
