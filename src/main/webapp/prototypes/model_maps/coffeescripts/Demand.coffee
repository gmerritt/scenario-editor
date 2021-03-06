class window.aurora.Demand extends Backbone.Model
  @dim = 2
  @delims = [",", ":"]
  @cell_type = "String"
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Demand()
    knob = $(xml).attr('knob')
    obj.set('knob', Number(knob))
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time))
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    link_id = $(xml).attr('link_id')
    obj.set('link_id', link_id)
    
    obj.set('cells', $a.ArrayText.parse(xml.text(), @delims, "String", null))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('demand')
    if @encode_references
      @encode_references()
    xml.setAttribute('knob', @get('knob')) if @has('knob')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('link_id', @get('link_id')) if @has('link_id')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('cells') || [], @delims)))
    xml
  
  deep_copy: -> Demand.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null