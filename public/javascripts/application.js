// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require jquery-ui

$(document).ready(function(){
	$('#kiteContainerUl li:first').before($('#kiteContainerUl li:last'));
	
	//Get the number of items currently in the list
	var kiteCount = $('#kiteContainerUl').children("li").length;
	
		
	//Get the number of kites that can fit on the container
	// at its current width
	var maxKites = Math.floor($('#kites').width() / 210);
	
	var kites = Math.min(kiteCount, maxKites);
	
	var actualWidth = kites * (210);
	
	//Set the width of the kitesinner to a multiple of the
	// width of an item coresponding to the number of items 
	// that can completely fit in the current window
	$('#kitesInner').width(actualWidth);
	
	$('#left_scroll').click(function(){
		var itemWidth = $('#kiteContainerUl li').outerWidth() + 20;
		var leftIndent = parseInt($('#kiteContainerUl').css('left')) - itemWidth;
		$('#kiteContainerUl:not(:animated)').animate({'left' : leftIndent},500, function(){
					$('#kiteContainerUl li:last').after($('#kiteContainerUl li:first'));
					$('#kiteContainerUl').css({'left':'-220px'});
				});
	});
	
	$('#right_scroll').click(function(){
		var itemWidth = $('#kiteContainerUl li').outerWidth() + 20;
		var leftIndent = parseInt($('#kiteContainerUl').css('left')) + itemWidth;
		$('#kiteContainerUl:not(:animated)').animate({'left' : leftIndent},500, function(){
					$('#kiteContainerUl li:first').before($('#kiteContainerUl li:last'));
					$('#kiteContainerUl').css({'left' : '-220px'});
				});
	});
	$('#kiteContainerUl li').click(function(){
		$('#showcase').empty();
		$(this).clone().appendTo('#showcase');
	});
	
	//Automatically select the first
	$('#kiteContainerUl li:first').clone().appendTo('#showcase');
});
