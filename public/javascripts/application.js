// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require jquery-ui

$(document).ready(function(){
	
	function CheckMaxLength(object) {
		var iMaxLen = parseInt(object.getAttribute('maxLength'));
		var iCurLen = object.value.length;
		
		if(object.getAttribute && iCurLen > iMaxLen) {
			object.value = object.value.substring(0, iMaxLen);
		}
	}
	
	function setCenterStage(image) {
		
		var iUpfront = ' url("' + $(image).attr('src') + '") no-repeat center';
				
		$('#showcase').css('background', iUpfront);
		
		$('#showcase').css('background', iUpfront + ', ' +
					  ' -webkit-gradient(linear, left top, left bottom, from(#444444), to(#999999))' +
					  ' -webkit-background-size: cover');
		$('#showcase').css('background', iUpfront + ', ' +
					  ' -webkit-linear-gradient(top, #444444, #999999)' +
					  ' -webkit-background-size: cover');
		$('#showcase').css('background', iUpfront + ', ' +
					  ' -moz-linear-gradient(top, #444444, #999999)' +
					  ' -moz-background-size: cover');
		$('#showcase').css('background', iUpfront + ', ' +
					  ' -ms-linear-gradient(top, #444444, #999999)' +
					  ' background-size: cover');
		$('#showcase').css('background', iUpfront + ', ' +
					  ' -o-linear-gradient(top, #444444, #999999)' +
					  ' -o-background-size: cover');
		$('#showcase').css('background', iUpfront + ', ' +
					  ' linear-gradient(top, #444444, #999999)' +
					  ' background-size: cover');
		
		
		
//		$('#showcase').css('filter', 
//		'filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr="#444444", endColorstr="#999999")');
		
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
	
	//$('#kitesContainer').jcarousel({vertical:true, scroll: 1, wrap: "circular"});
	
	$('#kitelist li img').click(function(){
		setCenterStage(this);	
	});
	
	if($('.alert-success').text().length > 0) {
		$(this).alert();
		//$('.alert-success').show();
	}
	
	if($('.alert-error').text().length > 0) {
		$(this).alert();
		//$('.alert-error').show();
	}
	
	//Checkbox which controls enable/disable button (e.g. TOS for account create)
	if ($('.mustAcceptSource').is(':checked')) {
		$('.mustAcceptTarget').removeAttr("disabled");     
	} else {
		$('.mustAcceptTarget').attr("disabled", "disabled");
	}
	$('.mustAcceptSource').change(function() {
		if ($(this).is(':checked')) {
			$('.mustAcceptTarget').removeAttr("disabled");     
		} else {
			$('.mustAcceptTarget').attr("disabled", "disabled");
		}
	});
	
});
