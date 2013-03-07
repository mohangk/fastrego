#= require spec_helper.js.coffee
xhr = null
requests = null
fakePaymentId = 12
fakeServer = null
clock = null


beforeEach ->
  #we do this here cause we always need it stubbed
  @sandbox.stub(FastRego.PaymentStatusPoller.prototype, 'redirect')

describe 'PaymentStatusPoller', ->
  describe '#isComplete', ->
    it 'returns true if the status text is Completed', ->
      @page.append "<div class='status'>Completed</>"
      poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
      assert.equal poller.isComplete(), true

    it 'returns false if status text is not complete', ->
      @page.append "<div class='status'>Pending</>"
      poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
      assert.equal poller.isComplete(), false

  describe '#pollStatus', ->

    fakeResponse = (status) -> [200, 
        { 'Content-Type': 'application/json' },
        JSON.stringify({status: status})]

    pendingResponse = fakeResponse('Pending')
    completedResponse = fakeResponse('Completed')

    beforeEach ->
      @page.append "<div class='status'>Pending</>"
      fakeServer = sinon.fakeServer.create()
      clock = sinon.useFakeTimers();

    afterEach ->
      fakeServer.restore()
      clock.restore()

    it 'polls the payment status for the provided id', ->
      new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status')).pollStatus()

      assert.equal fakeServer.requests.length, 1
      assert.equal fakeServer.requests[0].url, "/payments/#{fakePaymentId}"

    it 'updates the statusEl with the latest status', ->
      fakeServer.respondWith completedResponse

      new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status')).pollStatus()
      assert.equal fakeServer.requests.length, 1
      fakeServer.respond()

      assert.equal @page.find('.status').text(), 'Completed'

    it 'polls every interval of poller.interval', ->

      fakeServer.respondWith pendingResponse
      fakeServer.autoRespond = true

      assert.equal fakeServer.requests.length, 0
      poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
      poller.pollStatus()

      clock.tick(poller.interval - 1)
      assert.equal fakeServer.requests.length, 1

      clock.tick(poller.interval + 1)
      assert.equal fakeServer.requests.length, 2

    it 'stops polling once it gets a completed status', ->

      fakeServer.respondWith completedResponse
      fakeServer.autoRespond = true

      poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
      poller.pollStatus()

      clock.tick(poller.interval - 1)
      assert.equal fakeServer.requests.length, 1

      clock.tick(poller.interval + 1)
      assert.equal fakeServer.requests.length, 1

    it 'stops polling once it hits the timeout', ->

      fakeServer.respondWith pendingResponse
      fakeServer.autoRespond = true

      poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
      poller.pollStatus()

      clock.tick(poller.timeout * 2)
      assert.equal fakeServer.requests.length, poller.timeout/poller.interval

  describe '#start', ->

    context 'isComplete is true', ->
      it 'redirects to the registration page', ->
        @page.append "<div class='status'>Completed</>"
        poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
        poller.start()
        #redirect is already stubbed
        assert poller.redirect.calledWith('/')
      it 'timedout', ->
        @page.append "<div class='status'>Pending</>"
        poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
        @sandbox.stub(poller, 'isTimedout').returns(true)
        poller.start()
        #redirect is already stubbed
        assert poller.redirect.calledWith('/')

    it 'calls pollStatus', ->
        @page.append "<div class='status'>Pending</>"
        poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
        @sandbox.stub(poller, 'pollStatus')
        poller.start()
        assert poller.pollStatus.calledOnce

    context 'if the status is already complete', ->
      it 'does not call pollStatus', ->
        @page.append "<div class='status'>Completed</>"
        poller = new FastRego.PaymentStatusPoller(fakePaymentId, @page.find('.status'))
        @sandbox.stub(poller, 'pollStatus')
        poller.start()
        assert.equal poller.pollStatus.calledOnce, false
