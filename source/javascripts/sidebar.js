;(function(global) {
  global.sidebar = function() {
    var upcoming = document.querySelector('.sidebar .upcoming'),
      bouts = upcoming.querySelectorAll('.bouts li'),
      today = moment().startOf('day')

    var removed = 0
    for (var i = 0; i < bouts.length; i++) {
      var bout = bouts[i],
        timeel = bout.querySelector('time'),
        time = moment(timeel.getAttribute('datetime'))

      if (time.isBefore(today)) {
        bout.remove()
        removed++
      }
    }

    // should we have this hidden by default in the CSS then only show it
    // if there's valid data?
    if (!bouts.length || removed === bouts.length) {
      upcoming.remove()
    }
  }
})(NBRG)
