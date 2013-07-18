$(function() {
	// Filter List
	$('#filter-button').click(function() {
		$('#filter-list').toggle();
	});

	// Kite Nav show/hide
	$('.kite-nav-toggle').click(function() {
		$('#kite-nav').toggleClass('hidden');
	});

	// Footer show/hide
	$('.footer-tab-link').click(function() {
		$('#page-footer').toggleClass('hidden');
	});

	// Kite Nav Navigation
	$('.kite-nav-button').click(function() {
		// Toggle the button active state
		$('.kite-nav-button').removeClass('active');
		$(this).addClass('active');

		// Switch the content out
		var switch_to = $(this).attr('id');
		$('.detail-section').fadeOut(200);
		setTimeout(function() {
			$('.detail-section' + '.' + switch_to).fadeIn(200);
			
			setTimeout(function() {
				$('.kite-nav-content').jScrollPane();
			}, 201);

		}, 201);
	});

	// Comment Options Toggle
	$('.comment .options').click(function(event) {
		$(this).toggleClass('active');

		$('html').one('click', function() {
			$('.comment .options').removeClass('active');
		});

		event.stopPropagation();
	});

	// Scroll Bar
	$('.kite-nav-content').jScrollPane();

	
});