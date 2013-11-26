
class Socket

  constructor: (fn) ->
    @socket = io.connect('http://localhost:8090')

  onConnect: =>
    console.log 'Successfully connected to server'

  emit: =>
    @socket.emit.apply(@socket, arguments)

  on: =>
    @socket.on.apply(@socket, arguments)

module.exports = Socket
