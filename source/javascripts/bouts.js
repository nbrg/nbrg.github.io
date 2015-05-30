;(function() {
  function sixMonthsAgo() {
    var date = new Date()
    date.setMonth(date.getMonth() - 6)
    return date
  }

  function map() {
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

  function boutsList() {
    var bouts = document.querySelectorAll('.bouts li')
    for (var i = 0; i < bouts.length; i++) {
      var bout = bouts[i],
        timeel = bout.querySelector('time'),
        time = moment(timeel.getAttribute('datetime'))

      if (!time.isBefore(moment(), 'day')) {
        bout.className += ' future'
      }
    }
  }

  function makeWholeBoutClickable() {
    var bouts = document.querySelectorAll('.bouts li')

    for (var i = 0; i < bouts.length; i++) {
      var bout = bouts[i]
      bout.style.cursor = 'pointer'
      bout.onclick = function() {
        window.location.href = this.querySelector('a').getAttribute('href')
      }
    }
  }

  map()
  makeWholeBoutClickable()
  // boutsList()
})()
