class window.beats.SplitRatioSet extends Backbone.Model
  ### $a = alias for beats namespace ###
  $a = window.beats
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.beats.SplitRatioSet()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    VehicleTypeOrder = xml.children('VehicleTypeOrder')
    obj.set('vehicletypeorder', $a.VehicleTypeOrder.from_xml2(VehicleTypeOrder, deferred, object_with_id))
    splitRatioProfile = xml.children('splitRatioProfile')
    obj.set('splitratioprofile', _.map($(splitRatioProfile), (splitRatioProfile_i) -> $a.SplitRatioProfile.from_xml2($(splitRatioProfile_i), deferred, object_with_id)))
    project_id = $(xml).attr('project_id')
    obj.set('project_id', Number(project_id))
    id = $(xml).attr('id')
    obj.set('id', Number(id))
    name = $(xml).attr('name')
    obj.set('name', name)
    mod_stamp = $(xml).attr('mod_stamp')
    obj.set('mod_stamp', mod_stamp)
    lockedForEdit = $(xml).attr('lockedForEdit')
    obj.set('lockedForEdit', (lockedForEdit.toString().toLowerCase() == 'true') if lockedForEdit?)
    lockedForHistory = $(xml).attr('lockedForHistory')
    obj.set('lockedForHistory', (lockedForHistory.toString().toLowerCase() == 'true') if lockedForHistory?)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('SplitRatioSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('vehicletypeorder').to_xml(doc)) if @has('vehicletypeorder')
    _.each(@get('splitratioprofile') || [], (a_splitratioprofile) -> xml.appendChild(a_splitratioprofile.to_xml(doc)))
    if @has('project_id') && @project_id != 0 then xml.setAttribute('project_id', @get('project_id'))
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    if @has('mod_stamp') && @mod_stamp != "0" then xml.setAttribute('mod_stamp', @get('mod_stamp'))
    if @has('lockedForEdit') && @lockedForEdit != false then xml.setAttribute('lockedForEdit', @get('lockedForEdit'))
    if @has('lockedForHistory') && @lockedForHistory != false then xml.setAttribute('lockedForHistory', @get('lockedForHistory'))
    xml
  
  deep_copy: -> SplitRatioSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null