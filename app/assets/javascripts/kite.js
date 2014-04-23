$(document).ready(function () {
  if ($(".detail-kite-img").size() > 0) {
    $(window).scroll(function () {

      if (window.resizing) return;

      window.resizing = true;

      //Window Math
      var scrollTop = $(window).scrollTop(),
          docHeight = $(document).height(),
          windowHeight = $(window).height();
      var scrollPercent = (scrollTop / (docHeight - windowHeight)) * 100;

//      scrollPercent = Math.ceil(scrollPercent);

      if (scrollPercent < 0) {
        scrollPercent = 0;
      }
      if (scrollPercent > 100) {
        scrollPercent = 100;
      }

//      console.log(scrollPercent);

      var width = (100 - scrollPercent);
      if (width < 30) {
        width = 30;
      }

      if (scrollPercent == 0 || width == 30) {
        $(".detail-kite-img img").animate({width: width + '%'}, 'fast');
      } else {
        $(".detail-kite-img img").width(width + '%');
      }

      window.resizing = false;
    }).trigger('scroll');
  }
});
