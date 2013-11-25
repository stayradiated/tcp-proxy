
# Create a template from the array
createTemplate = (template) ->
  template = template.join ''
  return (obj) ->
    html = template
    for name, value of obj
      regex = new RegExp "\\{\\{\\s*#{ name }\\s*\\}\\}", 'gi'
      html = html.replace regex, value
    return html

templates = require '../template'
template = createTemplate templates.message

class Message

  @index: 0

  getId: ->
    Message.index++

  constructor: (@type, @content) ->
    @id = @getId()

  render: =>
    template
      id: @id
      type: @type
      content: @content

module.exports = Message
