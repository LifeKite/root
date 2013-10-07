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
