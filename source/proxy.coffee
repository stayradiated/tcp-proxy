
net = require 'net'
{EventEmitter} = require 'events'

class Proxy extends EventEmitter

  ###*
   * options
   *   - target: The port to target
   *   - host: Where to host the proxy
  ###

  constructor: (options) ->
    @paused = no
    @host = options.host
    @target = options.target

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

    input.pipe(output)
    output.pipe(input)

  pauseLog: =>
    @paused = yes

  resumeLog: =>
    @paused = no

  stop: =>
    @server.close()

  start: =>
    @server = net.createServer()
    @server.on 'connection', @handleConnection
    @server.on 'close', => @emit 'close', 'server'
    @server.listen @host

module.exports = Proxy
