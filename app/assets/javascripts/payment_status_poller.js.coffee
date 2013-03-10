window.FastRego or= {}
class FastRego.PaymentStatusPoller

  interval: 3000
  timeout: 30000
  timeoutCounter: 0

  constructor: (@payment_id, @statusEl, @progressEl, @doneEl, @completedEl, @timedoutEl) ->
    console.log 'in constructor'

  isComplete: ->
    @statusEl.text() == 'Completed'
  
  isTimedout: ->
    @timeoutCounter >= @timeout

  setStatus: (data) ->
    @statusEl.html(data.status)

  finishPolling: ->
    @progressEl.addClass('hide')
    @doneEl.removeClass('hide')

  start: =>
    if @isComplete() 
      @finishPolling()
      @completedEl.removeClass('hide')
    else if @isTimedout()
      @finishPolling()
      @timedoutEl.removeClass('hide')
    else
      @pollStatus()

  pollStatus: ->
    $.ajax
      url: "/payments/#{@payment_id}"
      success: (data) =>
        @setStatus(data)
        @timeoutCounter += @interval
        setTimeout @start, @interval

