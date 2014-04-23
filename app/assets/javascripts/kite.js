$(document).ready(function () {

  if ($(".detail-kite-img").size() > 0) {

    var img = $(".detail-kite-img img");
    img.data('height', img.height());
    img.data('posTop', img.position().top);
    img.height(img.height()).width('auto');

    $('.detail-kite-header').css({
      position: 'fixed',
      width: '1140px',
      'margin-top': 0
    });

    $(".detail-kite-img").css({
      position: 'fixed',
      top: '150px'
    });

    $(".kite-comments-frame").css({
      'margin-top': parseInt($('.detail-kite-img').position().top, 10) + parseInt(img.height(), 10) - 60
    });

    $("#kite-details-frame").css({
      top: '150px',
      width: '1140px',
      left: 'auto',
      right: 'auto',
      position: 'fixed'
    });

    $(window).scroll(function () {

      if (window.resizing) return;
      window.resizing = true;

      var scrollTop = $(window).scrollTop(),
          docHeight = $(document).height(),
          windowHeight = $(window).height();

      var scrollPercent = (scrollTop / (docHeight - windowHeight)) * 100;
      if (scrollPercent >= 100) {
        window.resizing = false;
        return;
      }

      var minHeight = 300;
      var originalHeight = parseInt(img.data('height'), 10);

      var height = originalHeight - scrollTop;

      if (height > originalHeight) {
        height = originalHeight;
      }

      if (height < minHeight) {
        height = minHeight;

        //set header and image to position: static
        $('.detail-kite-header').css({
          position: 'static',
          width: '1140px',
          'margin-top': '460px'
        });

        $(".detail-kite-img").css({
          position: 'static',
          top: ''
        });

        $(".kite-comments-frame").css({
          'margin-top': '10px'
        });

        $("#kite-details-frame").css({
          top: '',
          position: ''
        })
      } else {

        //set header and image to position: fixed
        $('.detail-kite-header').css({
          position: 'fixed',
          width: '1140px',
          'margin-top': 0
        });

        $(".detail-kite-img").css({
          position: 'fixed',
          top: '150px'
        });

        $(".kite-comments-frame").css({
          'margin-top': parseInt($('.detail-kite-img').position().top, 10) + parseInt(img.height(), 10) - 60
        });

        $("#kite-details-frame").css({
          top: '150px',
          width: '1140px',
          left: 'auto',
          right: 'auto',
          position: 'fixed'
        })
      }


      img.height(height);

      window.resizing = false;

    }).trigger('scroll');
  }
});
