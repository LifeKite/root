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
	
	$('.add-image').click(function(event){
		$('.upload-actual').click();
	});
	$('.upload-actual').change(function(click) {
		$('.surrogate').val(this.value);
	});
	$('.create-button').click(function(event) {
		$('.lockpane').toggleClass('LockOn', true);
		$('.lockpane').toggleClass('LockOff', false);
	} )
	 
	$('#load-more').bind('inview', function(event, visible) {
		if(visible) {
			$(this).click();
		}
	});
	$(window).scroll()
});