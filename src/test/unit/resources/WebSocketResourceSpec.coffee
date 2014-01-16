define [
  "angular"
  "angularMocks"
  "app"
  "resources/WebSocketResource"
],
(angular, mocks, app, WebSocketResource) ->
  describe "Unit::Resources Testing WebSocketResource", ->

    webSocketResource = null
    finish = false
    $timeout = null
    $scope = null

    beforeEach ->
      module 'app'
      inject (WebSocketResource, _$timeout_, $rootScope)->
        $timeout = _$timeout_
        $scope = $rootScope.$new()
        $scope.stuffDone = false
        webSocketResource = new WebSocketResource
          get:
            queryIsArray: false
            inbound: "test.queue"
            outbound: "test.queue"
            inboundTransform:(rawData)-> rawData
            outboundTransform:(rawData)-> rawData

    it 'should be able to be injected', inject (WebSocketResource)->
      chai.expect(WebSocketResource).to.not.equal null

    it 'should should return both an object and an array depending on the parameters', ->
      result = webSocketResource.query({data:'data'})
      chai.expect(result).to.be.a('object')

      result = webSocketResource.query({data:'data'}, true)
      chai.expect(result).to.be.a('array')

