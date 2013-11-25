Server = require './server'
Proxy = require './proxy'
Socket = require './socket'

# Create the servers
server = new Server('./client')
Socket.init(server.http)

# Set up the proxy
proxy = new Proxy
  target: 1337
  host: 6600

# Pipe events to the client
events = ['connection', 'upstream', 'downstream', 'close']
events.forEach (event) ->
  proxy.on event, (data) => Socket.emit event, data.toString 'utf-8'

# Start the app
server.listen 8090
proxy.start()
