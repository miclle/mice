//= require mice/jquery
//= require mice
//= require_tree .

// ZeroClipboard
ZeroClipboard.config( { moviePath: '/images/ZeroClipboard.swf' } );

$(function(){

  if($("body.mobile").size()){
    $(document).scroll(function() {
      console.log('scroll')
      //$('#window').contents().find('body').html($('#typography').next().next().text())
    });
  }
  //

});