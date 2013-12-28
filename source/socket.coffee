sockjs = require 'sockjs'
Jandal = require 'jandal'

Jandal.handle 'node'

class SocketHandler

  constructor: (server, proxy) ->
    @conn = sockjs.createServer()
    @conn.installHandlers server, prefix: '/ws'
    @conn.on 'connection', (socket) =>
      jandal = new Jandal(socket)
      new Socket(jandal, proxy)

  emit: (key, value) =>
    Jandal.all.emit key, value

class Socket

  events:
    'msg': 'message'
    'start': 'start'
    'stop': 'stop'

  constructor: (@socket, @proxy) ->
    for event, fn of @events
      @socket.on event, @[fn]

  message: (data) =>
    console.log data

  start: (host, target) =>
    @proxy.setHost host
    @proxy.setTarget target
    @proxy.start()

  stop: =>
    @proxy.stop()

module.exports = SocketHandler
