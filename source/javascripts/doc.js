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

  $('body').on('click', '#message-at-bottom', function(){
    // `message` can be an object (config)
    Message.show({
      message: 'message body show at bottom',
      // the placement can be `top` or `bottom`, by default is `top`
      placement: 'bottom'
    });
  });

  $('body').on('click', '#message-with-status', function(){
    // `message` can be an object (config)
    Message.show({
      message: 'message body show with danger status',
      // the placement can be `top` or `bottom`, by default is `top`
      status: 'danger'
    });
  });


});