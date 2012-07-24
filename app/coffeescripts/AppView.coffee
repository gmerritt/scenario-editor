# AppView is main organizing view for the application
# It handles all the application level elements as well as
# instantiating and triggering the Network to be drawn
class window.sirius.AppView extends Backbone.View
  $a = window.sirius
  $a.SHIFT_DOWN = false
  
  initialize: ->
    #change underscores symbols for handling interpolation to {{}}
    _.templateSettings = {interpolate : /\{\{(.+?)\}\}/g }
    $a.broker = _.clone(Backbone.Events)
    @render()

  render: ->
    @_initializeMap()
    @_navBar()
    @_contextMenu()
    @_layersMenu()
    @_messagePanel()
    @_treeMenuToggle()
    google.maps.event.addDomListener(window, 'keydown', (event) => @_setKeyDownEvents(event))
    google.maps.event.addDomListener(window, 'keyup', (event) => @_setKeyUpEvents(event))
    google.maps.event.addListener($a.map, 'mouseover', (mouseEvent) => @fadeIn())
    $a.broker.on('map:upload_complete', @_displayMap, @)
    $a.broker.on("map:clear_map", @clearMap, @)
    $a.broker.on("map:alert", @showAlert, @)
    $a.broker.on("map:toggle_tree", @toggleTree, @)
    @

  # create the landing map. The latitude and longitude our arbitarily pointing
  # to the I80/Berkeley area
  _initializeMap: ->
    mapOptions = {
      center: new google.maps.LatLng(37.85794730789898, -122.29954719543457)
      zoom: 14
      mapTypeId: google.maps.MapTypeId.ROADMAP
      mapTypeControl: false
      zoomControl: true
      zoomControlOptions: {
        style: google.maps.ZoomControlStyle.DEFAULT,
        position: google.maps.ControlPosition.TOP_LEFT
      }
    }
    #attach the map to the namespace
    $a.map = new google.maps.Map document.getElementById("map_canvas"), mapOptions

  # This creates the context menu as well as adds the listeners for map area of the application.
  # Currently we have zoom in and zoom out as well as center the map. 
  _contextMenu: () ->
    contextMenuOptions = {}
    contextMenuOptions.menuItems= $a.main_context_menu
    contextMenuOptions.id='main-context-menu'
    contextMenuOptions.class='context_menu'
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    google.maps.event.addListener($a.map, 'rightclick', (mouseEvent) -> $a.contextMenu.show mouseEvent.latLng )

  # This creates the main navigation bar menu
  _navBar: () ->
    new $a.FileUploadView({name: "localNetwork", id : "uploadField", attach: "#main-nav div"})
    new $a.NavBarView({menuItems: $a.nav_bar_menu_items, attach: "#main-nav div"})

  # This creates the layers menu bar
  _layersMenu: () ->
    lmenu = new $a.LayersMenuView({className: 'dropdown-menu bottom-up', id : 'l_list', parentId: 'lh', menuItems: $a.layers_menu})
    # we'll need to get rid of this call -- it is doing things that it shouldn't do to the modals, clear map, etc
    lmenu.attachEvents()
  
  _treeMenuToggle: () ->
    toggleTree = document.createElement "button"
    toggleTree.innerHTML = " < "
    toggleTree.id = "collapseTree"
    document.getElementById("map_canvas").appendChild toggleTree
    toggleTree.onclick = ->
      $a.broker.trigger('map:toggle_tree', 0)
      
    
  # displayMap takes the uploaded file data parses the xml into the model objects, and creates the MapNetworkView
  _displayMap: (fileText) =>
    try
      xml = $.parseXML(fileText)
    catch error
      $a.broker.trigger("app:show_message:error", error)
    $a.models = $a.Scenario.from_xml($(xml).children())
    new $a.MapNetworkModel()
    @mapView = new $a.MapNetworkView $a.models

  _setKeyDownEvents: (e) =>
    # Open Local Network ALT-A
    if $a.ALT_DOWN and e.keyCode == 65
      #@clearMap()
      $("#uploadField").click() 
    
    # Save Local Network
    if $a.ALT_DOWN and e.keyCode == 83
      $("#save-local-network").click()
      
    # Set multi-select of map elements with the shift key
    $a.SHIFT_DOWN = true if e.keyCode == 16
    
    # Set alt key down in order to set up quick key for opening files
    $a.ALT_DOWN = true if e.keyCode == 18
    
  
  _setKeyUpEvents: (e) => 
    # Turn off shift and alt down flags where appropriate
    $a.SHIFT_DOWN = false if e.keyCode == 16
    $a.ALT_DOWN = false  if e.keyCode == 18
  
  fadeIn: =>
    $('.container').fadeIn(200)
    $('#lh').fadeIn(200)
    $('#mh').fadeIn(200)
    
  clearMap: =>
    $a.broker.trigger('map:toggle_tree', false)
    $a.broker.trigger('app:tree_clear')
    $a.broker.trigger('app:show_message:success', 'Cleared map')
    
  _messagePanel: ->
    new $a.MessagePanelView()

  toggleTree: (display) =>
    button = document.getElementById 'collapseTree'
    if button.innerHTML == ' &gt; ' and (display == 0 or display == false)
      button.innerHTML = ' < '
      $('#right_tree').hide(200)
      align = right: '0%'
      $('#collapseTree').animate(align, 200)
    else if button.innerHTML == ' &lt; ' and (display == 0 or display == true)
      button.innerHTML = ' > '
      $('#right_tree').show(200)
      align = right: '22%'
      $('#collapseTree').animate(align, 200)
