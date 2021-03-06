class window.beats.Decision_point_split extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.Decision_point_split()
    path_segment_in = $(xml).attr('path_segment_in')
    obj.set('path_segment_in', path_segment_in)
    path_segment_out = $(xml).attr('path_segment_out')
    obj.set('path_segment_out', path_segment_out)
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('decision_point_split')
    if @encode_references
      @encode_references()
    xml.setAttribute('path_segment_in', @get('path_segment_in')) if @has('path_segment_in')
    xml.setAttribute('path_segment_out', @get('path_segment_out')) if @has('path_segment_out')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Decision_point_split.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null