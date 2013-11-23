
net = require 'net'

class Proxy


  ###*
   * options
   *   - target: The port to target
   *   - host: Where to host the proxy
  ###

  constructor: (options) ->

    @host = options.host
    @target = options.target

    @server = net.createServer()

    @server.on 'connection', @handleConnection

    @server.on 'close', ->
      console.log 'socket closed'

    @server.listen @host


  handleConnection: (input) =>

    console.log 'socket connected', input.remoteAddress

    output = net.createConnection @target

    input.on 'data', (data) =>
      @log 'upstream', data

    input.on 'close', (data) =>
      @log 'input close'

    output.on 'data', (data) =>
      @log 'downstream', data

    output.on 'close', (data) =>
      @log 'output close'

    # Hook up the pipes!
    input.pipe(output)
    output.pipe(input)

  log: (message, data) =>
    console.log Date.now(), message

module.exports = Proxy
