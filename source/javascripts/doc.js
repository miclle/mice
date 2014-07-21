//= require mice/jquery
//= require mice
//= require_tree .

// ZeroClipboard
// ZeroClipboard.config( { moviePath: '/images/ZeroClipboard.swf' } );

$(function(){

  $(window).load(function(){
    $('#basic-slider').flexslider({
      animation: "slide",
      start: function(slider){
        $('body').removeClass('loading');
      }
    });


    $('#thumbnail-control-slider').flexslider({
      animation: "slide",
      controlNav: "thumbnails"
    });


    $('#basic-carousel').flexslider({
      animation: "slide",
      animationLoop: false,
      itemWidth: 140,
      itemMargin: 5
    });

  });

});