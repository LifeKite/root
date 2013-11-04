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
				$('.kite-nav-content').bind('jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight){
					if(isAtBottom) {
						$('.next_page').trigger('click');
					}
				})
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
		
	// Groups Page
	
	// Get members list
	var members = JSON.parse('["John Doe", "Jane Doe", "Jim Doe"]');
	
	
	// Increment 
	
	// Expand a group
	$('.group-icons .edit').click(function() {
		$(this).closest('.group-box').toggleClass('active');
	});

	// Delete a group
	$('.group-icons .delete').click(function() {
		$(this).closest('.group-box').fadeOut();
	});

	// Delete user from group
	$('.group-member .group-member-delete').click(function() {
		var box = $(this).closest('.group-box');
		var number_element = box.find('.the-number');
		
		var number = Number(number_element.text());
		number_element.text(number - 1);

		$(this).parent().fadeOut();
	});
	
	// Add user
	$('.add-user-button').click(function() {
		var box = $(this).closest('.group-box');
		
		var username = box.find('.add-user').val();
		var usersbox = box.find('.group-members');
		var number_element = box.find('.the-number');
		
		var number = Number(number_element.text());
		number_element.text(number + 1);
		
		$("#group-member-template .group-member").clone(true, true).appendTo(usersbox);

		var userbox = box.find('.group-member-name.fresh').removeClass('fresh');
		userbox.text(username);
	});

	// Add a group
	$('#create-new-group').click(function() {
		$("#group-box-template .group-box").clone(true, true).appendTo('#groups-holder');
		var freshbox = $('#groups-holder .add-user.fresh').removeClass('fresh');
		
		freshbox.autocomplete({
			source: members
		});
	});

	// Sidebar Button
	//$('.sidebar-button').click(function() {
	//	window.location=$(this).find("a").attr("href");
	//	return false;
	//});

});