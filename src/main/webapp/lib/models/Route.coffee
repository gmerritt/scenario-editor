class window.beats.Route extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Route()
    link_references = xml.children('link_references')
    obj.set('link_references', $a.Link_references.from_xml2(link_references, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set('id', id)
    name = $(xml).attr('name')
    obj.set('name', name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('route')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('link_references').to_xml(doc)) if @has('link_references')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml
  
  deep_copy: -> Route.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null