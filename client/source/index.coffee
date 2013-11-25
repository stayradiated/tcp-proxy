Socket = require './socket'
Message = require './views/message'

document.addEventListener 'DOMContentLoaded', ->

  socket = new Socket()

  console.log 'started socket'

  logEl = document.querySelector '.log ul'

  logEl.addEventListener 'click', (event) ->
    target = event.target
    while target isnt logEl
      console.log target
      if target.classList.contains 'message'
        console.log 'found it'
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
