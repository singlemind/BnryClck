// wait for document to load ...
window.onload = function () {
    // Gauge the proper height
  
  if( $(document).height() > $(window).height() )
      setupHeight = $(document).height();
  else
      setupHeight = $(window).height();
  $('canvas').width($(window).width());
  $('canvas').height(setupHeight);
  //size($(window).width(), setupHeight);

}
