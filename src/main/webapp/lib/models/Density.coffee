class window.beats.Density extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Density()
    link_id = $(xml).attr('link_id')
    obj.set('link_id', link_id)
    link_id_destination = $(xml).attr('link_id_destination')
    obj.set('link_id_destination', link_id_destination)
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('density')
    if @encode_references
      @encode_references()
    xml.setAttribute('link_id', @get('link_id')) if @has('link_id')
    xml.setAttribute('link_id_destination', @get('link_id_destination')) if @has('link_id_destination')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Density.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null