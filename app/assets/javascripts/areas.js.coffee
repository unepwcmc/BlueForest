# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  initializeMap('map') if $('#map').length > 0

initializeMap = (map_id) ->
    map = L.map(map_id).setView([51.505, -0.09], 8)
    L.tileLayer 'http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.png'
      maxZoom: 18
    .addTo(map)
