class window.beats.Vehicle_type extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Vehicle_type()
    name = $(xml).attr('name')
    obj.set('name', name)
    weight = $(xml).attr('weight')
    obj.set('weight', Number(weight))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('vehicle_type')
    if @encode_references
      @encode_references()
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('weight', @get('weight')) if @has('weight')
    xml
  
  deep_copy: -> Vehicle_type.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null