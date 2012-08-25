// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require jquery-ui

$(document).ready(function(){
	
	function setCenterStage(image) {
		$('#showcase').css('background', 
				'#E4E2D6' + ' url(' + $(image).attr('src') + ') no-repeat center');
		//$('#showcase').empty();
		var end = $('#moreinfo a').attr('href').lastIndexOf('/');
		var y = end == 0 ? $('#moreinfo a').attr('href') : $('#moreinfo a').attr('href').slice(0, end); 
		y = y + '/' + $(image).attr('name');
		$('#moreinfo a').attr('href', y);
		
		$('#kiteDesc').text($(image).attr('alt'));
		
		var sharelevel = $(image).attr('title');
		$('#kiteState').text(sharelevel);
		if(sharelevel == "public") {
			
			$('#kiteState').toggleClass('badge-success', true);
			$('#kiteState').toggleClass('badge-important', false);
		} else {
			
			$('#kiteState').toggleClass('badge-success', false);
			$('#kiteState').toggleClass('badge-important', true);
		}
	}
	
	$('#kitesContainer').jcarousel({vertical:true, scroll: 1, wrap: "circular"});
	
	$('#kitesContainer li img').click(function(){
		setCenterStage(this);	
	});
	
	if($('.alert-success').text().length > 0) {
		$('.alert-success').show();
	}
	
	if($('.alert-error').text().length > 0) {
		$('.alert-error').show();
	}
	$( ".selectable" ).selectable({
		stop: function() {
			var name = "";
			$(".ui-selected #thumbnail", this).each(function(){
				if( $(this).attr('name') != undefined)
					name = name + $(this).attr('name') + ", ";
			})
			$('#kite_ids').val(name.slice(0,-2));
		}
	});
	
	$('.SectionGroup').mouseover(function(){
		$(this).animate({opacity:1},1000);
		$(this).css('border-color', 'white');
	})
	
	$('.SectionGroup').mouseout(function(){
		$(this).animate({opacity:0.5},1000);
		$(this).css('border-color', 'gray');
	})
	
	//Automatically select the first
	if($('#kitesContainer') != null && $('#kitesContainer').length > 0)
		setCenterStage($('#kitesContainer li:first img'));

});
