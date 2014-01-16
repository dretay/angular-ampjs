exports.config =
  minMimosaVersion:"1.0.1"
  modules: [
    'require'
    'minify'
    'bower'
    'require-lint'
    'mimosa-jshint'
    'mimosa-csslint'
    'mimosa-karma-enterprise'
    'require-library-package'
  ]
  karma:
    configFile: 'src/test/karma-unit.conf.js'
    externalConfig: true
  minify:
    exclude:[/\.min\./, "coffeescript/main.js"]
  watch:
    sourceDir: 'src/main'
    javascriptDir: 'coffeescript'
    # compiledDir: 'build'
  vendor:
    javascripts: "coffeescript/vendor"
  csslint:
    compiled: false
    copied: false
    vendor: false

  libraryPackage:
    packaging:
      shimmedWithDependencies:false
      noShimNoDependencies:true
      noShimWithDependencies:false
    overrides:
      shimmedWithDependencies: {}
      noShimNoDependencies: {}
      noShimWithDependencies: {}
    outFolder: "build"
    cleanOutFolder: true
    globalName: "AngularWebSocket"
    name:"angular-shortBus.min.js"
    main:"shortBusModule"
    mainConfigFile: "coffeescript/main.js"
    removeDependencies: [
       'angular', 'angularMocks', 'shortBus', 'domReady', 'underscore', 'stomp', 'flog', 'uuid', 'sockjs', 'jquery','LRUCache'
    ]

  bower:
    bowerDir:
      clean:false
    copy:
      outRoot: "managed"
      mainOverrides:
        modernizr:["modernizr.js"]
        "stomp-websocket":["dist/stomp.js"]
        "requirejs-domready":["domReady.js"]
        "requirejs-i18n":["i18n.js"]