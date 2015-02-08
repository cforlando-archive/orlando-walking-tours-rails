@OWT = {}

@OWT.Tour = do ->
  _options = {}
  _userMap = {}
  _markers = []
  _tourData = []

  init = (options) ->
    _options = $.extend
      data_endpoint: 'https://brigades.opendatanetwork.com/resource/hzkr-id6u.json'
      tour_list: $('#tour-list')
      map_element: $('#map')
      user_map_element: $('#user_map')
      tour_stop_remove_class: '.glyphicon-remove'
      tour_stop_add_class: '.add-to-tour'
      position_latitude: 28.5558
      position_longitude: -81.3789
    , options

    # Make tour stops sortable
    _options.tour_list.sortable()

    # Remove tour stops
    $(document).on 'click', _options.tour_stop_remove_class, ->
      OWT.Tour.removeStop this

    # Add stops to tour
    $(document).on 'click', _options.tour_stop_add_class, ->
      OWT.Tour.addStop this

    # Initialize map with all available stops
    map = drawMap(
      _options.map_element[0],
      new (google.maps.LatLng)(_options.position_latitude, _options.position_longitude),
      _options.data_endpoint
    )

    # Initialize map with user stops
    _userMap = drawMap(
      _options.user_map_element[0],
      new (google.maps.LatLng)(_options.position_latitude, _options.position_longitude)
    )

    $.get '/tour.json', (data) ->
      _tourData = data.data


  addStop = (elem) ->
    marker = new (google.maps.Marker)(
      position: new (google.maps.LatLng)($(elem).data('latitude'), $(elem).data('longitude'))
      map: _userMap
      title: $(elem).data('name'))
    index = _markers.push(marker) - 1
    _options.tour_list.append '<li class="list-group-item" data-marker-id="'+index+'"><i class="glyphicon glyphicon-remove"></i> ' + $(elem).data('name') + '</li>'
    _tourData.push($(elem).data('name'))
    $.ajax '/tour.json',
      data:
        tour:
          data: _tourData
      method: "put"
      success: (data) ->
        # TODO: verify that data is being set on tour correctly



  removeStop = (elem) ->
    item = $(elem).parent()
    _markers[item.data('marker-id')].setMap(null)
    item.remove()

  drawMap = (mapElement, center, url = null) ->
    mapOptions =
      zoom: 13
      center: center

    map = new (google.maps.Map)(mapElement, mapOptions)

    if url
      infowindow = new (google.maps.InfoWindow)({})
      # Retrieve our data and plot it
      $.getJSON url, (data, textstatus) ->
        $.each data, (i, entry) ->
          marker = new (google.maps.Marker)(
            position: new (google.maps.LatLng)(entry.location.latitude, entry.location.longitude)
            map: map
            title: entry.name)
          # Adding a click event to the marker
          google.maps.event.addListener marker, 'click', ->
            infowindow.setContent entry.name + '<p><a data-name="' + entry.name + '" data-logitude="' + entry.location.longitude + '" data-latitude="' + entry.location.latitude + '" class="btn btn-primary btn-sm add-to-tour">Add To My Tour</a></p>'
            infowindow.open map, this
            $('#title').text('').text entry.name
            $('#description').text('Bacon ipsum dolor amet beef ribs tail spare ribs, doner salami short ribs kevin kielbasa meatloaf. Turkey jowl cupim ground round sirloin. Short loin ham pork capicola shankle. Tri-tip prosciutto shankle, sausage bresaola turkey meatloaf andouille tenderloin beef ribs boudin. Ham beef brisket chuck leberkas pork loin.').text entry.downtown_walking_tour
            $('.add-to-tour').data('name', entry.name).data('longitude', entry.location.longitude).data('latitude', entry.location.latitude).removeClass 'hidden'
            return
          return
        return
    return map

  init: init
  addStop: addStop
  removeStop: removeStop
