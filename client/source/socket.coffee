require './vendor/sockjs'
Jandal = require 'jandal/build/client'

Jandal.handle 'sockjs'

class Socket

  constructor: (fn) ->
    sock = new SockJS 'http://localhost:8090/ws'
    console.log sock
    sock.onopen    = @open
    @sock = new Jandal(sock)

  open: =>
    console.log 'Successfully connected to server'

  message: (e) =>
    console.log 'message', e.data

  emit: =>
    @sock.emit.apply(@sock, arguments)

  on: (event, fn) =>
    @sock.on(event, fn)

module.exports = Socket
