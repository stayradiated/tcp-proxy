Socket = require './socket'
Message = require './views/message'

document.addEventListener 'DOMContentLoaded', ->

  socket = new Socket()

  socket.on 'connect', ->
    if inputHost.value
      socket.emit 'set-host', inputHost.value
    if inputTarget.value
      socket.emit 'set-target', inputTarget.value

  inputHost = document.getElementById 'input-host'
  inputTarget = document.getElementById 'input-target'

  if localStorage.host
    inputHost.value = localStorage.host

  if localStorage.target
    inputTarget.value = localStorage.target

  inputHost.addEventListener 'input', ->
    localStorage.host = inputHost.value
    socket.emit 'set-host', inputHost.value

  inputTarget.addEventListener 'input', ->
    localStorage.target = inputTarget.value
    socket.emit 'set-target', inputTarget.value

  buttonStart = document.getElementById 'button-start'
  buttonStop = document.getElementById 'button-stop'

  buttonStart.addEventListener 'click', ->
    socket.emit 'start'

  buttonStop.addEventListener 'click', ->
    socket.emit 'stop'

  logEl = document.querySelector '.log ul'

  logEl.addEventListener 'click', (event) ->
    target = event.target
    while target isnt logEl
      if target.classList.contains 'message'
        target.classList.toggle 'expanded'
        return
      target = target.parentElement

  render = (message) ->
    logEl.innerHTML += message.render()

  socket.on 'upstream', (data) ->
    msg = new Message 'upstream', data
    render(msg)

  socket.on 'downstream', (data) ->
    msg = new Message 'downstream', data
    render(msg)
