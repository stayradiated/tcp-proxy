
fs      = require 'fs'
Scrunch = require 'coffee-scrunch'

input  = './client/source/index.coffee'
output = './client/script.js'

init = (scrunch) ->

  scrunch.vent.on 'init', ->
    scrunch.scrunch()

  scrunch.vent.on 'scrunch', (data) ->
    console.log '...writing'
    fs.writeFile output, data

  scrunch.init()


task 'proxy', ->
  Proxy = require './source/proxy'
  proxy = new Proxy
    target: 1337
    host: 6600


task 'server', ->
  require './source/index'

task 'watch', ->
  init new Scrunch
    path: input
    compile: true
    watch: true

task 'build', ->
  init new Scrunch
    path: input
    compile: true
    verbose: true


