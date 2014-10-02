$(document).ready(function() {
  $(".lk-notifications").popover({
    html: true,
    content: function() {
      if ($("[class*='notification-']", "#lk-notifications-content").length > 0) {
        return $("#lk-notifications-content").html();
      } else {
        $(".lk-notifications .lk-badge").hide();
        return '<li class="kite-feed-item">You have no unread notifications</li>';
      }
    }
  }).on('click', function(e) {
    e.preventDefault();
    return true;
  });

  $('body').on('click', function(e) {
    $('[data-toggle="popover"]').each(function() {
      if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
        $(this).popover('hide');
      }
    });
  });
});