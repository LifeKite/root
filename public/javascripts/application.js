// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require jquery-ui

$(document).ready(function(){
	
	function setCenterStage(image) {
		$('#showcase').css('background', 'url(' + $(image).attr('src') + ') no-repeat center');
		//$('#showcase').empty();
		var end = $('#moreinfo a').attr('href').lastIndexOf('/');
		var y = end == 0 ? $('#moreinfo a').attr('href') : $('#moreinfo a').attr('href').slice(0, end); 
		y = y + '/' + $(image).attr('name');
		$('#moreinfo a').attr('href', y);
		
		$('#kiteDesc').text($(image).attr('alt'));
	}
	
	$('#kitesContainer').jcarousel({vertical:true, scroll: 1, wrap: "circular"});
	
	$('#kitesContainer li img').click(function(){
		setCenterStage(this);	
	});
	
	//Automatically select the first
	setCenterStage($('#kitesContainer li:first img'));

});
