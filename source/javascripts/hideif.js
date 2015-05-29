;(function() {
  function parentByTagName(el, tag) {
    tag = tag.toUpperCase()
    var parent = el.parentNode
    while (parent && parent.tagName !== tag) {
      parent = parent.parentNode
    }
    return parent
  }

  var hiders = {
    datePast: function(el) {
      var time = el.querySelector('time')

      if (!time) {
        // always show timeless elements
        return false
      }

      // hide if the time is in the past
      return moment(time.getAttribute('datetime'))
        .isBefore(moment(), 'day')
    },

    dateFuture: function(el) {
      return !hiders.datePast(el)
    }
  }

  var hideIfs = document.querySelectorAll('[data-hide-if]')

  for (var i = 0; i < hideIfs.length; i++) {
    var el = hideIfs[i],
      hiderName = el.getAttribute('data-hide-if'),
      hider = hiders[hiderName]

    if (!hider) {
      console.error('Unable to find hider "%s"', hiderName)
      continue
    }

    if (hider(el)) {
      el.parentNode.removeChild(el)
    }
  }

  var hideNone = document.querySelectorAll('[data-hide-none]')

  for (var i = 0; i < hideNone.length; i++) {
    var el = hideNone[i],
      hideSelector = el.getAttribute('data-hide-none')

    if (!el.querySelector(hideSelector)) {
      el.parentNode.removeChild(el)
    }
  }
})()
