jQuery(document).ready(function($) {
	
	errors = new Array();
	form = $('#contact');
	
	form.submit(function() {
		$('#loading').fadeIn();
		$('#error, #success').hide();
		if(validate()) { 
			submission();
			$('html, body').animate({ scrollTop: $('#results').offset().top }, 'slow');
			return false;
		} else {
			$('#loading').hide();
			$('#error, #results').fadeIn();
			$('html, body').animate({ scrollTop: $('#results').offset().top }, 'slow');
			return false;
		};
	})
	
	function validate() {
		errors.length=0;

		$('.req').each(function() {
			val = $(this).val();
			id = $(this).attr('id');
			if(!val) {
				errors.push(id);
			}
		})
		
		if(errors.length === 0) {
			return true;
		} else {
			$.each(errors, function(index, value) {
				$('#' + value).addClass('error');
			});
			return false;
		}
	}
	
	function submission() {
		var name = $("input#name").val();  
		var email = $("input#email").val();  
		var comments = $("#comments").val();
		var dataString = 'name='+ name + '&email=' + email + '&comments=' + comments;  
		$.ajax({  
		  type: "POST",  
		  url: "form.php",  
		  data: dataString,  
		  success: function() {  
		    $('#results, #success').fadeIn();
			$('#loading').hide();
		  }  
		});  
		return false;
	}
				
})
