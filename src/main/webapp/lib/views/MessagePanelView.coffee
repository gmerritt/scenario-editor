# This class creates the warnings panel and controls its display
class window.beats.MessagePanelView extends Backbone.View
  $a = window.beats
  className: 'alert alert-bottom close'
 
  initialize: ->
    @template = _.template($('#message-panel-template').html())
    $a.broker.on("app:show_message:success", @success, @)
    $a.broker.on("app:show_message:error", @error, @)
    $a.broker.on("app:show_message:info", @info, @)
    @render()

  render: ->
    $('body').append(@el)
  
  show: (message, type) ->
    @$el.addClass "#{type}"
    @$el.html(@template({message: message})) 
    @$el.fadeIn(3000, () => @$el.fadeOut(3000))
  
  success: (message) ->
    @show message, 'alert-success'
  
  error: (message) ->
    @show message, 'alert-error'
  
  info: (message) ->
    @show message, 'alert-info'