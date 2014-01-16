define [
  'jquery'
  'underscore'
  'util/_deep'
],
($,_)->
  class AmpEntity
    constructor: (data,messageBus, scope)->
      for key, value of data
        @[key] = value

      #close over the scope and bus so they don't look like response properties
      @getScope = -> scope
      @getMessageBus = -> messageBus

    _sendRpcMessage: (action, args={})->
      if _.isFunction @getScope()[action].outboundTransform
        request = @getScope()[action].outboundTransform(@,args)
      else
        request = @
      promise = @getMessageBus().getResponseTo
        request: request
        timeout: 10000
        outboundTopic: @getScope()[action].outbound
        inboundTopic: @getScope()[action].inbound

      #apply any mapping that's necessary
      promise = promise.then($.proxy(@getScope()[action].inboundTransform,@getScope())) if _.isFunction @getScope()[action].inboundTransform
      return promise

    _sendPubSubMessage: (action, args={})->
      if _.isFunction @getScope()[action].outboundTransform
        request = @getScope()[action].outboundTransform(@,args)
      else
        request = @

      deferred = $.Deferred()
      if _.isString @getScope()[action].inbound
        subscribePromise = @getMessageBus().subscribe
          getEventType: =>
            @getScope()[action].inbound

          handle: (payload, headers)=>
            #deferred for response
            deferred.resolve(payload)

            #apply any mapping that's necessary
            if _.isFunction @getScope()[action].inboundTransform
              deferred = deferred.then($.proxy(@getScope()[action].inboundTransform,@getScope()))

          handleFailed: (payload, headers)->
            console.log "AmpEntity:_sendPubSubMessage>> failure received"

      #send the event over the wire
      @getMessageBus().publish(request, @getScope()[action].outbound)

      return deferred.promise()

    _messagingPicker: (action, args) ->
      if _.deep(@getScope(), "#{action}.type") == "PUBSUB"
        @_sendPubSubMessage(action, args)
      else
        @_sendRpcMessage(action, args)

    save: (args={})->
      @_messagingPicker('save', args)
    delete: (args={})->
      @_messagingPicker('delete', args)
    update: (args={})->
      @_messagingPicker('update', args)