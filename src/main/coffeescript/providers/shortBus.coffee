#defined as a provider so that it can be configured prior to injection
define [
  'shortBusModule'
  'shortBus'
],
(shortBusModule, ShortBus)->
  'use strict'
  shortBusModule.provider 'shortBus', ->
    exchangeProviderHostname: null
    exchangeProviderPort: null
    routingInfoHostname: null
    routingInfoPort: null
    authenticationProviderHostname: null
    authenticationProviderPort: null
    fallbackTopoExchangeHostname: null
    fallbackTopoExchangePort: null
    busType: null

    $get: ->
      ShortBus.getBus
        exchangeProviderHostname: @exchangeProviderHostname
        exchangeProviderPort: @exchangeProviderPort
        routingInfoHostname: @routingInfoHostname
        routingInfoPort:@routingInfoPort
        authenticationProviderHostname:@authenticationProviderHostname
        authenticationProviderPort: @authenticationProviderPort
        fallbackTopoExchangeHostname: @fallbackTopoExchangeHostname
        fallbackTopoExchangePort: @fallbackTopoExchangePort
        busType: @busType
