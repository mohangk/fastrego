window.FastRego or= {}
class FastRego.PaymentStatusPoller

  interval: 3000
  timeout: 30000
  timeoutCounter: 0

  constructor: (@payment_id, @statusEl) ->
    console.log 'in constructor'

  isComplete: ->
    @statusEl.text() == 'Completed'
  
  isTimedout: ->
    @timeoutCounter >= @timeout

  setStatus: (data) ->
    @statusEl.html(data.status)

  start: =>
    if @isComplete() or @isTimedout()
      @redirect '/'
    @pollStatus() unless @isComplete() or @isTimedout()

  pollStatus: ->
    $.ajax
      url: "/payments/#{@payment_id}"
      success: (data) =>
        @setStatus(data)
        @timeoutCounter += @interval
        setTimeout @start, @interval

  redirect: (location) ->
    window.location = location
