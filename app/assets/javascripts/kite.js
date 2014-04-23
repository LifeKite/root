$(document).ready(function () {

  if ($(".detail-kite-img").size() > 0) {

    var img = $(".detail-kite-img img");
    img.data('height', img.height());
    img.data('posTop', img.position().top);
    img.height(img.height()).width('auto');

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
      if (height < minHeight) {
        height = minHeight;
      }
      if (height > originalHeight) {
        height = originalHeight;
      }

      img.height(height);

      window.resizing = false;

    }).trigger('scroll');
  }
});
