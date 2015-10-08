chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'mackerel', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/mackerel')(@robot)

  it 'hubot:mackerel', ->
    expect(@robot.hear).to.have.been.calledWith(/mackerel$/i)
