//= require mice/jquery
//= require mice
//= require_tree .

// ZeroClipboard
// ZeroClipboard.config( { moviePath: '/images/ZeroClipboard.swf' } );

$(function(){

  $(window).load(function(){
    $('.flexslider').flexslider({
      animation: "slide",
      start: function(slider){
        $('body').removeClass('loading');
      }
    });
  });

});