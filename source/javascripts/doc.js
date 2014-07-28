//= require mice/jquery
//= require mice
//= require_tree .

// ZeroClipboard
// ZeroClipboard.config( { moviePath: '/images/ZeroClipboard.swf' } );

$(function(){

  $('body').on('click', '#message-show', function(){
    Message.show('This is message!');
  });

  $('body').on('click', '#message-auto-hide', function(){
    Message.show('This is message!', 2000);
  });

  $('body').on('click', '#message-hide', function(){
    Message.hide();
  });

});