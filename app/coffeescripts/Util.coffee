class window.sirius.Util
  @_round_dec: (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  @_getLat: (elem) ->
    elem.get('position').get('point')[0].get('lat')

  @_getLng: (elem) ->
    elem.get('position').get('point')[0].get('lng')

  @getLatLng: (elem) ->
    new google.maps.LatLng(@_round_dec(@_getLat(elem),4), @_round_dec(@_getLng(elem),4));
  
  @toLowerCaseAndDashed: (text) ->
    text.toLowerCase().replace(/\ /g,"-")
