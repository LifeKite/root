(function($){
	$.each(['touchstart', 'touchend', 'touchmove'], function(i, name){
		if(!document.addEventListener){return;}
		var blockSimple;
		//capture events on document
		document.addEventListener(name, function(e){
			if(e.touches && e.touches.length > 1){
				blockSimple = true;
				setTimeout(function(){
					blockSimple = false;
				}, 9);
			}
		}, true);
		$.event.special['simple'+name] = {
			setup: function(){
				$(this).bind(name, $.event.special['simple'+name].handler);
	            return true;
	        },
			teardown: function(){
	            $(this).unbind('.touchdrag');
	            return true;
	        },
			handler: function(e, d){
				if(blockSimple || !e.originalEvent || !e.originalEvent.touches || e.originalEvent.touches.length !== 1){return;}
				var te = e.originalEvent.touches.item(0); 
				
				te.type = 'simple'+name;
				te.preventDefault = function(){
					e.preventDefault();
				};
				return $.event.handle.apply(this, [te, d]);
			}
		};
	});
})(jQuery);