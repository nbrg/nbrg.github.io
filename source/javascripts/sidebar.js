;(function(global) {
  global.sidebar = function() {
    var upcoming = document.querySelector('.sidebar .upcoming'),
      bouts = upcoming.querySelectorAll('.bouts li')

    // should we have this hidden by default in the CSS then only show it
    // if there's valid data?
    if (!bouts.length) {
      upcoming.parentNode.removeChild(upcoming)
    }

    // for (var i = 0; i < bouts.length; i++) {
    //   var bout = bouts[i],
    //     timeel = bout.querySelector('time')

    // }
  }
})(NBRG)
