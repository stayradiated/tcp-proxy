
class Socket

  constructor: ->
    @socket = io.connect('http://localhost:8090')

  emit: =>
    @socket.emit.apply(@socket, arguments)

  on: =>
    @socket.on.apply(@socket, arguments)

module.exports = Socket
