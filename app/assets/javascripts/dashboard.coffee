# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->
  $('.ui.dropdown').dropdown()

  setTimeout (->
    $('#notification-area .ui.message').fadeOut('fast')    
  ), 4000