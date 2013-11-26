SocketIo = require 'socket.io'

class SocketHandler

  constructor: (server, proxy) ->
    @io = SocketIo.listen(server)
    @io.set 'log level', 1
    @io.sockets.on 'connection', (socket) ->
      new Socket(socket, proxy)

  emit: (key, value) =>
    @io.sockets.emit(key, value)


class Socket

  events:
    'msg': 'message'
    'set-host': 'setHost'
    'set-target': 'setTarget'
    'start': 'start'
    'stop': 'stop'

  constructor: (@socket, @proxy) ->
    for event, fn of @events
      @socket.on event, @[fn]

  message: (data) =>
    console.log data

  setHost: (host) =>
    @proxy.setHost host

  setTarget: (target) =>
    @proxy.setTarget target

  start: =>
    @proxy.start()

  stop: =>
    @proxy.stop()

module.exports = SocketHandler
