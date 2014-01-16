var tests = Object.keys(window.__karma__.files).filter(function(file){
  return /Spec\.js$/.test(file);
});

requirejs.config({
  baseUrl: '/base/src/main/coffeescript',
  paths:{
    p:"providers",
    r:"resources",

    angular: 'vendor/managed/angular/angular',
    angularMocks: 'vendor/managed/angular-mocks/angular-mocks',
    jquery: 'vendor/managed/jquery/jquery',
    underscore: 'vendor/managed/underscore-amd/underscore',
    domReady: 'vendor/managed/requirejs-domready/domReady',

    socketio: 'vendor/managed/socket.io-client/socket.io'
  },
  shim:{
    'angularMocks':{
      deps: ['angular'],
      exports: 'angular.mock'
    },
    'angular':{
      exports: 'angular',
      deps: ['jquery']
    },
    'socketio':{
      exports: 'io'
    },
    'bootstrap':{
      deps: ['app', 'socketio']
    }
  },
  priority: ["angular"],
  deps: tests,
  callback: window.__karma__.start
});

//http://code.angularjs.org/1.2.1/docs/guide/bootstrap#overview_deferred-bootstrap
window.name = "NG_DEFER_BOOTSTRAP!";