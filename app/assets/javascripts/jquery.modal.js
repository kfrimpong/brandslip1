(function($) {

$.modal = function (config) {
	
	var defaults, options, container, header, close, content, title, overlay, modalClass;
	
	defaults = {
		 title: ''
		, html: ''
                , modalClass: ''
		, ajax: ''
		, width: null
		, overlay: true
		, overlayClose: false
		, escClose: true
	};
	
	options = $.extend (defaults, config);
	console.log(options.modalClass);
	container = $('<div>', { id: 'modal' });
	header = $('<div>',  { id: 'modalHeader' });
	content = $('<div>', { id: 'modalContent' });
	overlay = $('<div>', { id: 'overlay' });
	title = $('<h2>', { html: options.title });
	close = $('<a>', { 'class': 'close', href: 'javascript:;', html: '&times' });

	container.appendTo ('body');
	header.appendTo (container);
	content.appendTo (container);
	if (options.overlay) {
		overlay.appendTo ('body');
	}
	title.prependTo (header);
	close.appendTo (header);
        content.addClass(options.modalClass);
	
	if (options.ajax == '' && options.html == '') {
		title.text ('No Content');
	}
	
	if (options.ajax !== '') {
		content.html ('<div id="modalLoader"><img src="/assets/squares-circle.gif" /></div>');
		$.modal.reposition ();
		$.get (options.ajax, function (response) {
			content.html (response);
			$.modal.reposition ();
		});
	}
	
	if (options.html !== '') {
		content.html (options.html);
	}
	
	close.bind ('click', function (e) { 
		e.preventDefault (); 
		$.modal.close (this); 		
	});
	
	if (options.overlayClose) {
            console.log("Overlay close");
		overlay.bind ('click', function (e) { $.modal.close_without_btn (this); });
	}
	
	if (options.escClose) {
		$(document).bind ('keyup.modal', function (e) {
			var key = e.which || e.keyCode;
			
			if (key == 27) {
				$.modal.close_without_btn (this);
			}			
		});
	}
	
	$.modal.reposition ();
}

$.modal.reposition = function () {
	var width = $('#modal').outerWidth ();		
	var centerOffset = width / 2;	
	$('#modal').css ({ 'left': '50%', 'top': $(window).scrollTop () + 125, 'margin-left': '-' + centerOffset + 'px' });
};

$.modal.close_without_btn = function (ctrl) {
        console.log($(ctrl));
	$(ctrl).find('#modal').remove ();
	$('#overlay').remove ();
	$(document).unbind ('keyup.modal');
}
$.modal.close = function (ctrl) {
	$(ctrl).closest('#modal').remove ();
	$('#overlay').remove ();
	$(document).unbind ('keyup.modal');
}

function getPageScroll() {
	var xScroll, yScroll;
	
	if (self.pageYOffset) {
		yScroll = self.pageYOffset;
		xScroll = self.pageXOffset;
	} else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
		yScroll = document.documentElement.scrollTop;
		xScroll = document.documentElement.scrollLeft;
	} else if (document.body) {// all other Explorers
		yScroll = document.body.scrollTop;
		xScroll = document.body.scrollLeft;
	}
	
	return new Array(xScroll,yScroll);
}

})(jQuery);