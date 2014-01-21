#defined as a provider so that it can be configured prior to injection
define [
  'shortBus'
  'ngAmpjsModule'

],
(ShortBus, ngAmpjsModule)->
  'use strict'
  ngAmpjsModule.provider 'shortBus', ->
    $get: ->
      ShortBus.getBus @

