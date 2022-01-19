$( document ).ready(function() {


Shiny.addCustomMessageHandler('shownid', function(what) {
    $("#" + what).trigger("show");
    $("#" + what).trigger("shown");
  });

});
