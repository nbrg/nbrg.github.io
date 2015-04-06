;(function(global) {
  NBRG.bouts = {
    map: function() {
      var containers = document.querySelectorAll('[data-map]')
      for (var i = 0; i < containers.length; i++) {
        var container = containers[i],
          lat = parseFloat(container.getAttribute('data-lat')),
          lng = parseFloat(container.getAttribute('data-lon'))

        var mapel = document.createElement('div')
        mapel.className = 'map'
        var map = new google.maps.Map(mapel, {
          center: { lat: lat, lng: lng },
          zoom: 17,
        })
        var maker = new google.maps.Marker({
          position: { lat: lat, lng: lng },
          map: map,
        })

        container.appendChild(mapel)
      }
    }
  }
})(NBRG)
