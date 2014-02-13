jQuery(document).ready(function($) {

	/*----------- blog -----------*/
	var $blog = (function() {
		
		var $span,	
			$container = $('#blog'),
			$articles = $container.find('.blog-item'),
			$columns = $container.data('columns'),
			$filters = $('#blog-filters a'),
			$changer = $('#blog-selector'),

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
					itemSelector: '.blog-item',
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

	$blog.init();

});

$(window).load(function() {

	var $blogSingle = (function() {
		
		var $scrollLocation,
			$blog = $('section.blog'),
			$articles = $blog.find('article.blog-item'),
			$button = $('.blog-back'),
			$section = $('section.blog-single'),
			$basket = $section.find('.basket'),
			$nextButton = $('.blog-next'),
			$prevButton = $('.blog-prev'),
			$index,

		init = function() {
			initEvents();
			getPositions();
		},

		initEvents = function() {

			$('.blog-ajax').live('click', function(e) {
				e.preventDefault();
				getPositions();
				$section.slideUp();
				$index = $(this).parent('.blog-item').index();
				loader($index);
				buttons($index);
				$button.slideDown();
				$('html, body').animate({
					scrollTop: ($scrollLocation)
				}, 750, function() {
					$section.slideDown(500);
				});
			});

			$('.blog-next').live('click', function(e) {
				e.preventDefault();
				$basket.hide();
				loader($index + 1);
				$basket.fadeIn();
				$index = $index + 1;
				buttons($index);
			});

			$('.blog-prev').live('click', function(e) {
				e.preventDefault();
				$basket.hide();
				loader($index - 1);
				$basket.fadeIn();
				$index = $index - 1;
				buttons($index);
			});

			$('.blog-back').live('click', function(e) {
				e.preventDefault();
				$basket.html('');
				$section.slideUp();
				$('html, body').animate({
					scrollTop: ($blogPosition)
				}, 750);
			});

		},

		getPositions = function() {
			$section.show();
			$sectionPosition = $section.offset().top;
			$section.hide();
			$buttonHeight = $button.actual('innerHeight') + 30;
			$scrollLocation = ($sectionPosition - $buttonHeight);
			$blogPosition = $blog.offset().top;
		},

		loader = function(index) {
			$basket.html('');
			$item = $articles.eq(index).find('.blog-ajax');
			$link = $item.attr('href') + ' #load';
			$title = $item.data('title');
			$subtitle = $item.data('subtitle');
			$('.blog-title').html($title);
			$('.blog-subtitle').html($subtitle);
			$basket.load($link);
		},

		buttons = function(index) {
			index == ($articles.length - 1) ? $nextButton.hide() : $nextButton.show();
			index == 0 ? $prevButton.hide() : $prevButton.show();
		},

		back = function() {
			$(window).scrollTop() < ($scrollLocation+10) ? $button.hide() : $button.show();
		};

		return { init: init }

	})();

	$blogSingle.init();

});