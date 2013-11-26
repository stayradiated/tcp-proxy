
net = require 'net'
{EventEmitter} = require 'events'

class Proxy extends EventEmitter

  ###*
   * options
   *   - target: The port to target
   *   - host: Where to host the proxy
  ###

  constructor: ->
    @closed = yes
    @paused = no

  setHost: (@host) =>
    console.log '[proxy] set host'

  setTarget: (@target) =>
    console.log '[proxy] set target'

  handleConnection: (input) =>
    @emit 'connection', input.remoteAddress
    output = net.createConnection @target

    input.on 'data', (data) =>
      return if @paused
      @emit 'upstream', data

    input.on 'close', (data) =>
      return if @paused
      @emit 'close', 'input'

    output.on 'data', (data) =>
      return if @paused
      @emit 'downstream', data

    output.on 'close', (data) =>
      return if @paused
      @emit 'close', 'output'

    input.on 'error', (err) =>
      console.error 'input', err

    output.on 'error', (err) =>
      console.error 'output', err

    input.pipe(output)
    output.pipe(input)

  pauseLog: =>
    console.log '[proxy] pausing'
    @paused = yes

  resumeLog: =>
    console.log '[proxy] resuming'
    @paused = no

  stop: =>
    if @closed then return
    console.log '[proxy] stopping'
    @closed = yes
    @server.close()

  start: =>
    if not @closed then return
    @closed = no

    if not (@host and @target)
      console.log '[proxy] cannot start without host and target'
      return
    else
      console.log '[proxy] starting'

    @server = net.createServer()
    @server.on 'connection', @handleConnection
    @server.on 'close', => @emit 'close', 'server'
    @server.listen @host

module.exports = Proxy
