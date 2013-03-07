#= require application.js
#= require support/sinon-1.6.0.js
mocha.ignoreLeaks()

beforeEach ->
  @page = $('#konacha')
  @sandbox = sinon.sandbox.create()

afterEach ->
  @sandbox.restore()
