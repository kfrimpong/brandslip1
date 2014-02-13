jQuery(document).ready(function($) {

	function isMobile() {
		$width = $('.container').css('width');
		$width = parseInt($width.substring(0, $width.length, -2));
		$isMobile = $width < 700 ? true : false;	
		return $isMobile;
	};

	/*----------- Add clearfix to floated li elements -----------*/
	$('ul.inline').addClass('clearfix');

	/*----------- Icon Lists -----------*/
	$('ul.fancy-list').each(function() {
		icon = $(this).data('icon');
		$(this).children('li').prepend('<i class="icon ' + icon + '"></i>'); 
	})

	/*----------- Floating Navigation -----------*/
	function floatingNav() {
		$height = $(window).height();
		$header = $('header.main');
		$scroll = $(window).scrollTop();
		if($scroll > $height - $header.actual('height') - 1) {
			$header.addClass('fixed');
		} else {
			$header.removeClass('fixed');
		}
		if($scroll > $height/2) {
			$('.slide-content, .flex-direction-nav').fadeOut();
		} else {
			$('.slide-content, .flex-direction-nav').fadeIn();
		}
	}

	/*----------- Fix slider size and position of slide content -----------*/
	
	var $slider = (function() {
		
		var $height,
			$slider = $('#home ul.slides'),
			$slides = $slider.children(),
         
		init = function() {
			$height = $(window).height();
			$slider.css('height', $height);
			$('body').css('padding-top', $height);
			$slides.each(function() {
				$content = $(this).find('.slide-content');
				console.log($content.width());
				$contentHeight = $content.actual('outerHeight');
				$contentWidth = $content.actual('outerWidth');
				$content.css('margin-left', -$contentWidth/2);
				$content.css('margin-top', -$contentHeight/2);
			});
		};

		return { init: init }

	})();


	/*----------- Animation for team members -----------*/
	var $ourteam = (function() {

		var $members = $('.member'),
		
		init = function() {
			resize();
			initEvents(); 
		},

		initEvents = function() {
			$members.hover(mouseOn, mouseOut);
			$(window).on('debouncedresize', resize);
		},

		mouseOn = function() {
			$members.stop().not($(this)).animate({ opacity: 0 }, 200, 'linear');
			$(this).stop().animate({ opacity: 1 });
			$(this).addClass('animated');
		},

		mouseOut = function() {
			$members.stop().animate({ opacity: 1 });
			$(this).removeClass('animated');
		},

		unbindEvents = function() {
			$members.unbind('mouseenter mouseleave');
		},

		resize = function() {
			$width = $members.innerWidth();
			$members.css('height', $width);
		};

		return { init: init, unbindEvents: unbindEvents }

	})();

	/*----------- Skills List -----------*/
	function skills() {
	    $('ul.skills li').each(function() {
			docViewTop = $(window).scrollTop();
			docViewBottom = docViewTop + $(window).height();
			elemTop = $(this).offset().top;
			elemBottom = elemTop + $(this).height();
			progress = $(this).data('width') +  '%';
			if((elemBottom <= docViewBottom) && (elemTop >= docViewTop)) {
				$(this).find('.background > div').delay(1000).animate({
					width: progress
				}, 1000);
			}      
		})  
	}

	/*----------- Home FlexSlider -----------*/
	$('#home').flexslider({
		controlNav: false
	});

	/*----------- Testimonial Slider -----------*/
	$('.quotes').flexslider({
		directionNav:false
	})

	/*----------- IE Placeholders -----------*/
	$('[placeholder]').focus(function() {
		var input = $(this);
		if (input.val() == input.attr('placeholder')) {
			input.val('');
			input.removeClass('placeholder');
		}
	}).blur(function() {
		var input = $(this);
		if (input.val() == '' || input.val() == input.attr('placeholder')) {
			input.addClass('placeholder');
			input.val(input.attr('placeholder'));
		}
	}).blur().parents('form').submit(function() {
		$(this).find('[placeholder]').each(function() {
			var input = $(this);
			if (input.val() == input.attr('placeholder')) {
				input.val('');
			}
		})
	});

	/*----------- Navigation -----------*/
	$('nav.main a').click(function(e) {
		e.preventDefault();
		$target = $(this).attr('href');
		$padding = $($target).css('padding-top');
		$padding = $padding.substring(0, $padding.length - 2);
		$padding = parseInt($padding);
		$position = $($target).offset().top - $padding;
		$('html, body').animate({
			scrollTop: $position
		}, 1000, 'easeInQuart');
	});

	/*----------- Mobile Navigation -----------*/
	$('.mobile-nav').change(function(){
		$target = $(this).val();
		$padding = $($target).css('padding-top');
		$padding = $padding.substring(0, $padding.length - 2);
		$padding = parseInt($padding);
		$position = $($target).offset().top - $padding;
		$('html, body').animate({
			scrollTop: $position
		}, 1000, 'easeInQuart');
	});

	/*----------- Get started button -----------*/
	$('.get-started').click(function(e) {
		e.preventDefault();
		$target = $('.features');
		$padding = $($target).css('padding-top');
		$padding = $padding.substring(0, $padding.length - 2);
		$padding = parseInt($padding);
		$position = $($target).offset().top - $padding;
		$('html, body').animate({
			scrollTop: $position
		}, 1000, 'easeInQuart');
	});

	/*----------- IE Placeholders -----------*/
	$(function() {
	    if (window.PIE) {
	        $('.member, .member img, .member .overlay').each(function() {
	            PIE.attach(this);
	        });
	    }
	});


	/*----------- Initiate Functions -----------*/
	skills();
	if(!isMobile()) { $ourteam.init(); } else { $ourteam.unbindEvents(); } 
	$slider.init();

	$(window).scroll(function() {
		skills();
		floatingNav();
	});

	$(window).on('debouncedresize', function() {
		$slider.init();
		if(!isMobile()) { $ourteam.init(); } else { $ourteam.unbindEvents(); }
	});


	/*----------- Style Switcher-----------*/
	$('#switcher .handle').click(function() {
		visible = $(this).hasClass('visible') ? true : false;
		if(visible) {
			$('#switcher').animate({ marginLeft : -240});
			$(this).removeClass('visible');
		} else {
			$(this).addClass('visible');
			$('#switcher').animate({marginLeft : 0});
		}
	});

	$('#skin').change(function() {
		color = $(this).val();
		if(color == 'default') {
			$('#skinCSS').remove();
		} else {
			$('#skinCSS').remove();
			$('head').append('<link rel="stylesheet" id="skinCSS" type="text/css" href="css/skins/' + color + '.css" />');	
		}
	});

});

$(window).load(function() {
	
	/*----------- Active Navigation Link -----------*/
	$activeLink = (function() {
		
		var $mainLinks = $('nav.main').find('a'),
			$mobileMenu = $('.mobile-nav'),
			$top,
			$sections = [],
			$offsets = [],

		init = function() {
			getSections();
			getOffsets();
			initEvents();
		},

		initEvents = function() {
			$(window).scroll(function() {
				highlightLinks();
			})
			$(window).on('debouncedresize', function() {
				getOffsets();
			})
		},

		getSections = function() {
			$mainLinks.each(function() {
				$target = $(this).attr('href');
				$sections.push($($target));
			})	
		},

		getOffsets = function() {
			$offsets = [];
			$($sections).each(function() {
				$padding = $(this).css('padding-top');
				$padding = parseInt($padding.substring(0, $padding.length, -2));
				$offset = $(this).offset().top - $padding;
				$offsets.push($offset);	
			})
		},

		highlightLinks = function() {
			$top = $(window).scrollTop();
			for($i=0; $i <= $offsets.length; $i++) {
				if($top >= ($offsets[$i-1]-10) && $top < $offsets[$i]) {
					$($mainLinks).removeClass('active');
					$($mobileMenu).val($($mainLinks.eq($i-1)).attr('href'));
					$($mainLinks.eq($i-1)).addClass('active');
				} else if($top + $(window).height() + 300 > $(document).height()) {
					$($mainLinks).removeClass('active');
					$($mainLinks.eq($offsets.length-1)).addClass('active');
					$($mobileMenu).val($($mainLinks.eq($offsets.length-1)).attr('href'));
				}
			}
		};

	 	return { init: init };

	})();

	$activeLink.init();


})