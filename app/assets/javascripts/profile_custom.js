$(document).ready(function() {

    ////////////// Google Maps  //////////////

	gmapAdress = "Harlem, New York";

	/////////////////////////////////////////////////////////////////

	///////////////////////////////////
	// Fancybox
	///////////////////////////////////

	$(".fancybox").fancybox({
		openEffect: 'elastic',
		closeEffect: 'elastic',
		helpers : {
    		title : {
    			type : 'inside'
    		}
    	}
	});

	$(".fancybox").append('<div class="mask"><span class="icon-search"></span></div>');

	///////////////////////////////////
	// gMap 3
	///////////////////////////////////

	$('.google-maps').gmap3({
		marker:{
		address: gmapAdress
	},
	map:{
		options:{
			zoom: 14
		}
	}});

	///////////////////////////////////
	// Contact Form
	///////////////////////////////////

	$('input, textarea').placeholder();

	function validateEmail(elementValue){        
		var pattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;  
		return pattern.test(elementValue);   
	}   

	$("#contactform").submit(function(event){
		event.preventDefault();

		var fieldEmpty = '<span class="icon-cancel-circled"></span>Please fill out all fields correctly!';
		var errorSending = '<span class="icon-cancel-circled"></span>Error while sending the email!';
		var successSending = '<span class="icon-check"></span>Thanks for your Mail! I will respond as soon as possible!';

		var notification = $(".notification");
		var nameInput = $("#contact-name");
		var emailInput = $("#contact-mail");
		var messageInput = $("#contact-message");
		var name = nameInput.val();
		var email = emailInput.val();
		var message = messageInput.val();

		if (name && email && message !== "") {
			if (validateEmail(email)) {
				notification.removeClass("error").empty();
				$.ajax({
					type: "POST",
					url: "inc/contact_form.php",
					dataType: "html",
					data: "postName="+name+"&postEmail="+email+"&postMessage="+message,
					error: function(){
						notification.addClass("error").empty().append(errorSending);
					},
					success: function() {
						nameInput.attr("disabled","disabled");
						emailInput.attr("disabled","disabled");
						messageInput.attr("disabled","disabled");
						notification.show().removeClass("error").empty().addClass("success").append(successSending);
						setTimeout(function(){
							nameInput.val("").removeAttr("disabled");
							emailInput.val("").removeAttr("disabled");
							messageInput.val("").removeAttr("disabled");
							notification.slideUp(550);
						}, 2500);
					}
				});
			} else {
				notification.empty().show().append(fieldEmpty);
			}
		}
		else {
			notification.removeClass("success").addClass("error");
			notification.empty().show().append(fieldEmpty);

			if (name == "") {nameInput.addClass("red-border");}
			if (email == "") {emailInput.addClass("red-border");}
			if (message == "") {messageInput.addClass("red-border");}
			setTimeout(function(){
				nameInput.removeClass("red-border");
				emailInput.removeClass("red-border");
				messageInput.removeClass("red-border");
			}, 1800);
		}
	return false;
	});

	///////////////////////////////////
	// Scroll Effect
	///////////////////////////////////
//
//	$('a[href*=#]').bind("click", function(event) {
//		event.preventDefault();
//		var target = $(this).attr("href");
//
//		$('html,body').animate({
//			scrollTop: $('a[name='+target.replace(/#/g, "")+']').offset().top
//		}, 1500 , function (){location.hash = target;});
//	});	

	///////////////////////////////////
	// Show Info on Mobile
	///////////////////////////////////

	menuIcon = $(".show-info-mobile");
	info = $(".container-left-info");

	menuIcon.click(function() {
		if (info.attr("data-status") == "active") {
			info.slideUp(500).removeAttr("data-status");
		} else {
			info.slideDown(500).attr("data-status","active");
		}
	});

	///////////////////////////////////
	// Calculate Pie Chart
	///////////////////////////////////

	barArray = $(".pie-bar");
	heightsArray = $(".pie-inner");

	for (i=0; i <= barArray.length-1; i++) {
		height = heightsArray.eq(i).attr("data-height");
		heightPx = Math.round((height/100)*160);
		heightPx = 160 - heightPx;
		barArray.eq(i).css("clip","rect(0px 160px "+ heightPx +"px 0)");
	}

	///////////////////////////////////
	// Scrollbar
	///////////////////////////////////

	function setInfoHeight() {
		var avatarHeight = $(".container-left-picture").height();
		var viewportHeight = $(window).height();
		var infoHeight = viewportHeight - avatarHeight;

		$(".container-left-info").css("height",infoHeight);
	}

	if ($("body").innerWidth() > 1070) {
		setInfoHeight();
		$(".container-left-info").perfectScrollbar();
	} else {
		$(".container-left-info").perfectScrollbar('destroy');
	}

	///////////////////////////////////
	// Mobile Settings
	///////////////////////////////////

	function displayInfo() {
		$(".container-left-info").show();
	}

	window.onresize = function() {
		// display info
		if ($("body").innerWidth() > 1070) {
			displayInfo();
			setInfoHeight();
			$(".container-left-info").perfectScrollbar();
			$(".container-left-info").perfectScrollbar('update');
		}
		// destroy scrollbar at second breakpoint
		if ($("body").innerWidth() <= 1070) {
			$(".container-left-info").perfectScrollbar('destroy');
			$(".container-left-info").css("height","auto");
		}
	};

});