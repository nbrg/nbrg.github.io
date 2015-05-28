;(function() {
  function makeWholeBoutClickable() {
    var bouts = document.querySelectorAll('.sidebar .upcoming .bouts li')

    for (var i = 0; i < bouts.length; i++) {
      var bout = bouts[i],
        url = bout.querySelector('a').getAttribute('href')
      bout.style.cursor = 'pointer'
      bout.onclick = function() {
        window.location.href = url
      }
    }
  }

  makeWholeBoutClickable()
})()
