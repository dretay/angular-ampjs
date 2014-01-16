###
  Main configures requirejs and begins the application load

  The application startup flow is like this main -> app -> bootstrap
    main configures requirejs and requires (among other things)
###
window.loggingLevel = 'all'
requirejs.config
  #append timestamp to resource requests to prevent caching
  # urlArgs: "b=#{(new Date()).getTime()}"

  #define shortcuts to various modules
  paths:
    p:"providers"
    r:"resources"

    angular: 'vendor/managed/angular/angular'
    angularMocks: 'vendor/managed/angular-mocks/angular-mocks'

    shortBus: 'vendor/managed/ampjs/ShortBus.min'
    domReady: 'vendor/managed/requirejs-domready/domReady'
    underscore: 'vendor/managed/underscore-amd/underscore'
    stomp: 'vendor/managed/stomp-websocket/stomp'
    flog: 'vendor/managed/flog/flog'
    uuid: 'vendor/managed/node-uuid/uuid'
    sockjs: 'vendor/managed/sockjs/sockjs'
    jquery: 'vendor/managed/jquery/jquery'
    LRUCache: 'vendor/managed/node-lru-cache/lru-cache'

  #Non-compliant AMD modules are explicitly defined here along with their dependencies
  shim:
    'angular':
      exports: 'angular'
      deps: ['jquery']

  priority: ["angular"]

requirejs [
  'shortBusModule'
],
(shortBusModule) ->
  shortBusModule