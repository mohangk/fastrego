#= require spec_helper.js.coffee
xhr = null
requests = null
fakePaymentId = 12
fakeServer = null
clock = null

template = (status) ->
  "<div class='status'>"+status+"</div> <div class='progress'></div> <div class='done hide'></div> <div class='completed hide'></div> <div class='timedout hide'></div>"

getPoller = (page) ->
  new FastRego.PaymentStatusPoller(fakePaymentId, 
    page.find('.status'), 
    page.find('.progress'),
    page.find('.done'),
    page.find('.completed'),
    page.find('.timedout') 
  )

describe 'PaymentStatusPoller', ->
  describe '#isComplete', ->
    it 'returns true if the status text is Completed', ->
      @page.append template('Completed')
      poller = getPoller(@page)
      assert.equal poller.isComplete(), true

    it 'returns false if status text is not complete', ->
      @page.append template('Pending')
      poller = getPoller(@page)
      assert.equal poller.isComplete(), false

  describe '#pollStatus', ->

    fakeResponse = (status) -> [200, 
        { 'Content-Type': 'application/json' },
        JSON.stringify({status: status})]

    pendingResponse = fakeResponse('Pending')
    completedResponse = fakeResponse('Completed')

    beforeEach ->
      @page.append template('Pending')
      fakeServer = sinon.fakeServer.create()
      clock = sinon.useFakeTimers();

    afterEach ->
      fakeServer.restore()
      clock.restore()

    it 'polls the payment status for the provided id', ->
      getPoller(@page).pollStatus()

      assert.equal fakeServer.requests.length, 1
      assert.equal fakeServer.requests[0].url, "/payments/#{fakePaymentId}"

    it 'updates the statusEl with the latest status', ->
      fakeServer.respondWith completedResponse

      getPoller(@page).pollStatus()
      assert.equal fakeServer.requests.length, 1
      fakeServer.respond()

      assert.equal @page.find('.status').text(), 'Completed'

    it 'polls every interval of poller.interval', ->

      fakeServer.respondWith pendingResponse
      fakeServer.autoRespond = true

      assert.equal fakeServer.requests.length, 0
      poller = getPoller(@page)
      poller.pollStatus()

      clock.tick(poller.interval - 1)
      assert.equal fakeServer.requests.length, 1

      clock.tick(poller.interval + 1)
      assert.equal fakeServer.requests.length, 2

    it 'stops polling once it gets a completed status', ->

      fakeServer.respondWith completedResponse
      fakeServer.autoRespond = true

      poller = getPoller(@page)
      poller.pollStatus()

      clock.tick(poller.interval - 1)
      assert.equal fakeServer.requests.length, 1

      clock.tick(poller.interval + 1)
      assert.equal fakeServer.requests.length, 1

    it 'stops polling once it hits the timeout', ->

      fakeServer.respondWith pendingResponse
      fakeServer.autoRespond = true

      poller = getPoller(@page)
      poller.pollStatus()

      clock.tick(poller.timeout * 2)
      assert.equal fakeServer.requests.length, poller.timeout/poller.interval

  describe '#start', ->

    it 'calls pollStatus', ->

        @page.append template('Pending')
        poller = getPoller(@page)
        @sandbox.stub(poller, 'pollStatus')
        poller.start()
        assert poller.pollStatus.calledOnce

    context 'isComplete is true', ->

      beforeEach ->
        @page.append template('Completed')
        poller = getPoller(@page)
        poller.start()

      it 'hides the progress bar', ->
        assert @page.find('.progress').hasClass('hide')

      it 'shows the doneEl', ->
        assert.equal @page.find('.done').hasClass('hide'), false

      it 'shows the completedEl', ->
        assert.equal @page.find('.completed').hasClass('hide'), false

    context 'isTimedout is true', ->

      beforeEach ->
        @page.append template('Pending')
        poller = getPoller(@page)
        @sandbox.stub(poller, 'isTimedout').returns(true)
        poller.start()

      it 'hides the progress bar', ->
        assert @page.find('.progress').hasClass('hide')

      it 'shows the doneEl', ->
        assert.equal @page.find('.done').hasClass('hide'), false

      it 'shows the timedoutEl', ->
        assert.equal @page.find('.timedout').hasClass('hide'), false

    context 'if the status is already complete', ->
      it 'does not call pollStatus', ->
        @page.append template('Completed')
        poller = getPoller(@page)
        @sandbox.stub(poller, 'pollStatus')
        poller.start()
        assert.equal poller.pollStatus.calledOnce, false
