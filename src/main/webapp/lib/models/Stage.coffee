class window.beats.Stage extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Stage()
    greentime = $(xml).attr('greentime')
    obj.set('greentime', Number(greentime))
    movA = $(xml).attr('movA')
    obj.set('movA', movA)
    movB = $(xml).attr('movB')
    obj.set('movB', movB)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('stage')
    if @encode_references
      @encode_references()
    xml.setAttribute('greentime', @get('greentime')) if @has('greentime')
    xml.setAttribute('movA', @get('movA')) if @has('movA')
    xml.setAttribute('movB', @get('movB')) if @has('movB')
    xml
  
  deep_copy: -> Stage.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null