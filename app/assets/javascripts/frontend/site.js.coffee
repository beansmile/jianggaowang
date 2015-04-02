# pageReloadedEvent is delegating events "document:ready" and "page:load"
pageReloadedEvent = new CustomEvent('page:reloaded');

$ ->
  $(document).on 'page:load', ->
    document.dispatchEvent pageReloadedEvent
  document.dispatchEvent pageReloadedEvent

# Animated page transitions
# From https://coderwall.com/p/t5ghhw
$(document).on 'page:change', ->
  if $('#animated').length
    $animateEle = $('#animated')
  else
    $animateEle = $('#content')
  $animateEle.addClass 'animated fadeIn'

$(document).on 'page:fetch', ->
  if $('#animated').length
    $animateEle = $('#animated')
  else
    $animateEle = $('#content')
  $animateEle.addClass += 'animated fadeOut'
