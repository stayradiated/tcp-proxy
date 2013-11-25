
http = require 'http'
express = require 'express'

class Server

  constructor: (@folder) ->

    @app = express()
    @http = http.createServer(@app)

    @app.use express.static @folder

  listen: (port) =>

    @http.listen port


module.exports = Server
