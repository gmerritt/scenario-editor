window.beats.Demand::defaults =
  dt: 1
  knob: 1
  start_time: 0

window.beats.Demand::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    link_id = @get('link_id')
    link = object_with_id.link[link_id]
    @set 'link', link
    throw "Demand instance can't find link for obj id == #{link_id}" unless link
    link.set 'demand', @

window.beats.Demand::encode_references = ->
  @set('link_id', @get('link').id)