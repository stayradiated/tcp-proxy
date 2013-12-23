Server = require './server'
Proxy = require './proxy'
Socket = require './socket'

# Create the servers
server = new Server('./client')
proxy = new Proxy()
socket = new Socket(server.http, proxy)

# Pipe events to the client
events = ['connection', 'upstream', 'downstream', 'close']
events.forEach (event) ->
  proxy.on event, (data) =>
    switch getEncoding data
      when 'utf-8'
        socket.emit event, data.toString 'utf-8'
      when 'binary'
        text = "binary :: #{ data.length } :: "
        hex = data.toString 'hex'
        len = Math.min hex.length - 1, 256
        for byte in [0..len] by 2
          text += hex[byte] + hex[byte + 1] + ' '
        socket.emit event, text

# Start the app
server.listen 8090

# Get the encoding of a buffer
getEncoding = (buffer) ->
  # Prepare
  contentStartBinary = buffer.toString('binary',0,24)
  contentStartUTF8 = buffer.toString('utf8',0,24)
  encoding = 'utf-8'

  # Detect encoding
  for i in [0...contentStartUTF8.length]
    charCode = contentStartUTF8.charCodeAt(i)
    if charCode is 65533 or charCode <= 8
      # 8 and below are control characters (e.g. backspace, null, eof, etc.)
      # 65533 is the unknown character
      encoding = 'binary'
      break

  # Return encoding
  return encoding
