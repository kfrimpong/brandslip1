jQuery(document).ready(function($) {

	/*----------- Portfolio -----------*/
	var $portfolio = (function() {
		
		var $span,	
			$container = $('#portfolio'),
			$articles = $container.find('.portfolio'),
			$columns = $container.data('columns'),
			$filters = $('#portfolio-filters a'),
			$changer = $('#portfolio-selector'),

		init = function() {
			initEvents();
			columns($columns);
			isotope();
		},

		initEvents = function() {

			$filters.click(function(e) {
				e.preventDefault();
				var selector = $(this).data('filter');
				$container.isotope({
					filter: selector
				});
				return false;
			});

			$changer.change(function() {
				val = $(this).val();
				columns(val);
			});

		},

		columns = function(val) {
			if(val == 4) { $span = 3; $columns = 4; };
			if(val == 3) { $span = 4; $columns = 3; };
			if(val == 2) { $span = 6; $columns = 2; };
			$articles.removeClass('span3 span4 span6').addClass('span' + $span);
			isotope();
		},

		isotope = function() {
			$(window).smartresize(function() {
				$container.isotope({
					itemSelector: '.portfolio',
					resizable: false, // disable normal resizing
					masonry: {
						columnWidth: $container.width() / $columns
					}
				});
			}).smartresize();

			$container.imagesLoaded( function() {
				$(window).smartresize();
			});

			$changer.val($columns);
		};

		return { init: init }

	})();

	$portfolio.init();

});

$(window).load(function() {

	var $portfolioSingle = (function() {
		
		var $scrollLocation,
			$portfolio = $('section.our-work'),
			$articles = $portfolio.find('.portfolio'),
			$button = $('.portfolio-back'),
			$section = $('section.portfolio-single'),
			$basket = $section.find('.basket'),
			$nextButton = $('.portfolio-next'),
			$prevButton = $('.portfolio-prev'),
			$index,

		init = function() {
			initEvents();
			getPositions();
		},

		initEvents = function() {

			$('.portfolio-ajax').live('click', function(e) {
				e.preventDefault();
				getPositions();
				$section.slideUp();
				$index = $(this).parent('.portfolio').index();
				buttons($index);
				loader($index);
				$button.slideDown();
				$('html, body').animate({
					scrollTop: ($scrollLocation)
				}, 750, function() {
					$section.slideDown(500);
				});
			});

			$('.portfolio-next').live('click', function(e) {
				e.preventDefault();
				$basket.hide();
				loader($index + 1);
				$basket.fadeIn();
				$index = $index + 1;
				buttons($index);
			});

			$('.portfolio-prev').live('click', function(e) {
				e.preventDefault();
				$basket.hide();
				loader($index - 1);
				$basket.fadeIn();
				$index = $index - 1;
				buttons($index);
			});

			$('.portfolio-back').live('click', function(e) {
				e.preventDefault();
				$basket.html('');
				$section.slideUp();
				$('html, body').animate({
					scrollTop: ($portfolioPosition)
				}, 750);
			});

		},

		getPositions = function() {
			$section.show();
			$sectionPosition = $section.offset().top;
			$section.hide();
			$buttonHeight = $button.actual('innerHeight') + 30;
			$scrollLocation = ($sectionPosition - $buttonHeight);
			$portfolioPosition = $portfolio.offset().top;
		},

		loader = function(index) {
			$basket.html('');
			$item = $articles.eq(index).find('.portfolio-ajax');
			$link = $item.attr('href') + ' #load';
			$title = $item.data('title');
			$subtitle = $item.data('subtitle');
			$('.portfolio-title').html($title);
			$('.portfolio-subtitle').html($subtitle);
			$basket.load($link);
		},

		buttons = function(index) {
			index == ($articles.length - 1) ? $nextButton.hide() : $nextButton.show();
			index == 0 ? $prevButton.hide() : $prevButton.show();
		},

		back = function() {
			$(window).scrollTop() < ($scrollLocation+10) ? $button.hide() : $button.show();
		};

		return { init: init };

	})();

	$portfolioSingle.init();

});