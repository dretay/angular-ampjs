define [
  'angular'
  'underscore'
  './AmpEntity'
  'jquery'
  'ngAmpjsModule'
  'util/_deep'
  'p/shortBus'

],
(angular, _, AmpEntity, $, ngAmpjsModule) ->
  'use strict'
  ngAmpjsModule.factory 'ampResource', ['$rootScope', 'shortBus', ($rootScope, shortBus)->
    class AmpResource
      queryIsArray: true
      type: "RPC"
      constructor: (config={})->
        {@get,@save,@delete,@update, @queryIsArray, @type} = config


      _pubSubQuery: (query={}, isArray=true)->
        data = if isArray then [] else {}

        #setup the listener for the reply if one is necessary


        if _.isString @get.inbound
          subscribePromise = shortBus.subscribe
            getEventType: =>
              @get.inbound
            handle: (payload, headers)=>
              deferred = $.Deferred().resolve(payload)

              #apply any mapping that's necessary
              if _.isFunction @get.inboundTransform
                deferred = deferred.then(@get.inboundTransform)

              #map the raw data into a Response
              createEntity = (rawData)=>
                if _.isArray rawData
                  _.map rawData, (element)=> new AmpEntity(element,shortBus,@)
                else
                  new AmpEntity(rawData,shortBus,@)
              deferred = deferred.then createEntity

              #replace the stub with the real response
              replaceStub = (temp)->
                angular.copy(temp, data)
                $rootScope.$apply()
              deferred.then replaceStub

            handleFailed: (payload, headers)=>
              console.log "PubSubResource:query>> failure received"

        #make the request
        makeRequest = =>
          #apply any mapping to the request that's necessary
          query = @get.outboundTransform(@, query) if _.isFunction @get.outboundTransform

          #send the event over the wire
          shortBus.publish(query, @get.outbound)
        if _.isString @get.inbound
          subscribePromise = subscribePromise.then makeRequest
        else
          makeRequest()

        return data
      _rpcQuery: (query={}, isArray=true)->
        data = if isArray then [] else {}

        query = @get.outboundTransform(@, query) if _.isFunction @get.outboundTransform

        #make the request
        promise = shortBus.getResponseTo(
          request: query
          timeout: 100
          outboundTopic: @get.outbound
          inboundTopic: @get.inbound
        )

        #apply any mapping that's necessary
        promise = promise.then(@get.inboundTransform) if _.isFunction @get.inboundTransform

        #map the raw data into a Response
        promise = promise.then (rawData)=>
          if _.isArray rawData
            _.map rawData, (element)=> new AmpEntity(element,shortBus,@)
          else
            new AmpEntity(rawData,shortBus,@)

        #replace the stub with the real response
        promise.then (temp)->angular.copy(temp, data);$rootScope.$apply();


        return data
      query: (args={})->
        #query, isArray, type
        if @get.type == "PUBSUB"
          @_pubSubQuery(args, @get.queryIsArray)
        else
          @_rpcQuery(args, @get.queryIsArray)

      create: (data)->
        new AmpEntity(data,shortBus,@)
    ]
