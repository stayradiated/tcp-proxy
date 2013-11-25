SocketIo = require 'socket.io'

class Socket

  @init: (server) =>
    @io = SocketIo.listen(server)
    @io.set 'log level', 1
    @io.sockets.on 'connection', (socket) ->
      new Socket(socket)

  @emit: (key, value) =>
    @io.sockets.emit(key, value)

  events:
    'msg': 'message'

  constructor: (@socket) ->
    for event, fn of @events
      @socket.on event, @[fn]

  message: (data) =>
    console.log data

module.exports = Socket