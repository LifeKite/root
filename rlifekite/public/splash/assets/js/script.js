jQuery(document).ready(function(){
	$(window).resize(function(){
			$('.screenshot').height(Math.min($(window).width()*(431/635),Math.max(350,$('.blurb').outerHeight())));
	}).resize();
});