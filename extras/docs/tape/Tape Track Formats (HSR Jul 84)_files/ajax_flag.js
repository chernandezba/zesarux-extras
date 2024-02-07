// magic.js
$(document).ready(function() {


	// process the form
	$("#flagged-form").submit(function(event) {

		$('.form-group').removeClass('has-error'); // remove the error class
		$('.help-block').remove(); // remove the error text

		article_id = $('input[name=article_id]').val();
		admin = $('input[name=admin]').val();
		honeypot = $('input[name=url]').val();
		
		if (admin != 1) { admin = 0; }

		// check for spammy stuffs

		checkContents = $('textarea[name=issue_notes]').val();
		checkContents = checkContents.toLowerCase();
		if (checkContents.indexOf('[url=') >= 0 || checkContents.indexOf('[link=') >= 0 || checkContents.indexOf('[/url]') >= 0 || checkContents.indexOf('[/link]') >= 0 
		|| checkContents.indexOf('http') >= 0 || checkContents.indexOf('www') >= 0 || checkContents.indexOf('wordpress') >= 0 
		|| checkContents.indexOf('miftolo') >= 0 || checkContents.indexOf('rank') >= 0 || checkContents.indexOf('duplicate content') >= 0 
		|| checkContents.indexOf('направления') >= 0
		|| checkContents.indexOf('освоить') >= 0
		|| checkContents.indexOf('Наши') >= 0
		|| checkContents.indexOf('трудоустройством') >= 0
		|| checkContents.indexOf('года') >= 0
		|| checkContents.indexOf('собрать') >= 0
		|| checkContents.indexOf('профессий') >= 0
		|| checkContents.indexOf('Программы') >= 0
		|| checkContents.indexOf('Профессии') >= 0
		|| checkContents.indexOf('П') >= 0
		|| checkContents.indexOf('л') >= 0
		|| checkContents.indexOf('д') >= 0
		|| checkContents.indexOf('ф') >= 0
		|| checkContents.indexOf('и') >= 0
		|| checkContents.indexOf('б') >= 0
		|| checkContents.indexOf('й') >= 0
		|| checkContents.indexOf('porn') >= 0
		|| checkContents.indexOf('butt') >= 0
		|| checkContents.indexOf('video') >= 0
		|| checkContents.indexOf('sex') >= 0
		|| checkContents.indexOf('billionaire') >= 0
		|| checkContents.indexOf('millionaire') >= 0
		|| checkContents.indexOf('btc') >= 0
		|| checkContents.indexOf('hello. and bye.') >= 0
		|| checkContents.indexOf('TeamSpeak') >= 0
		|| checkContents.indexOf('Are you still in business?') >= 0
		|| checkContents.indexOf('908-9255') >= 0
		|| checkContents.indexOf('206-0526') >= 0
		|| checkContents.indexOf('free report') >= 0
		|| checkContents.indexOf('turning into sales') >= 0		
		)
		{
			// ok, we match something we don't want, put something in honeypot to ignore this submission
			honeypot = 'filterit';
		}


		// do nothing if honeypot
		if (honeypot != "")
		{
			// ALL GOOD! just show the success message!
			$('textarea[name=issue_notes]').val("");
			$('select[name=flagOption]').val(1).change();
			document.getElementById('problem_notes').style.display = "none";
			$("#output_data").empty();
			$('#output_data').append('<p><span class="sbfix"><br>Thanks for letting us know.</span></p>');

			$("#output_data").delay(3000).fadeIn(function() {					
				$("#revealFlagger").collapse('hide');
				$("#output_data").empty();
				$("#output_data").html("<p><span class='sbfix'><br>You can send us a note about this article, or let us know of a problem - select the type from the menu above.<br><br><i>(Please include your email address if you want to be contacted regarding your note.)</i></span></p>");
			});
			event.preventDefault();
			return true;
		}
		
		if ($('select[name=flagOption]').val() != 1 && honeypot == "")
		{

			// get the form data
			// there are many ways to get this data using jQuery (you can use the class or id also)
			var formData = {
				'flagOption'			: $('select[name=flagOption]').val(),
				'article_id'			: $('input[name=article_id]').val(),
				'admin'					: admin,
				'issue_notes'			: $('textarea[name=issue_notes]').val()		

	//            'email'             : $('input[name=email]').val(),
	//            'superheroAlias'    : $('input[name=superheroAlias]').val()
			};

			// process the form
			$.ajax({
				type 		: 'POST', // define the type of HTTP verb we want to use (POST for our form)
				url 		: '/process.php', // the url where we want to POST
				data 		: formData, // our data object
				dataType 	: 'json', // what type of data do we expect back from the server
				encode 		: true
			})

			// using the done promise callback
			.done(function(data) {

				// log data to the console so we can see
				// console.log(data); 

				// here we will handle errors and validation messages
				if ( ! data.success) {
					
					// handle errors for name ---------------
					if (data.errors.flagOption) {
//						$('#flagged-group').addClass('has-error'); // add the error class to show red input
//						$('#flagged-group').append('<div class="help-block">' + data.errors.name + '</div>'); // add the actual error message under our input
						$('#output_data').append('<p><span class="sbfix"><br>' + data.errors.name + '</span></p>');
					}

				} else {

					// ALL GOOD! just show the success message!
					$('textarea[name=issue_notes]').val("");
					$('select[name=flagOption]').val(1).change();
					document.getElementById('problem_notes').style.display = "none";
					
					// $('#output_data').append('<div class="alert alert-success">' + data.message + '</div>');
					$("#output_data").empty();
					$('#output_data').append('<p><span class="sbfix"><br>' + data.message + '</span></p>');

					$("#output_data").delay(3000).fadeIn(function() {					
						$("#revealFlagger").collapse('hide');
						$("#output_data").empty();
						$("#output_data").html("<p><span class='sbfix'><br>You can send us a note about this article, or let us know of a problem - select the type from the menu above.<br><br><i>(Please include your email address if you want to be contacted regarding your note.)</i></span></p>");
					});

					// we've updated the problems, so if we are in admin, update the problems display
					if ($('#output_problems').length > 0) {
						$('#output_problems').html("<p class='text-center'><img src='/gfx/ajax-loader-2.gif'><p>");
						
						var newproblems = $.post( "/ajax_get_problems.php", { id: article_id } );						

						  newproblems.done(function( data ) {
								$( "#output_problems" ).empty().append( data );		
						  });

 					}
				}
			})

			// using the fail promise callback
			.fail(function(data) {

						$("#output_data").empty();
						$('#output_data').append('<p><span class="sbfix"><br>Error: could not save this note!</span></p>');

				// show any errors
				// best to remove for production
				// console.log(data);
			});
		}

		// stop the form from submitting the normal way and refreshing the page
		event.preventDefault();
	});

	$('#error_flag_display').on('click', 'a', function() {

		$('#output_problems').html("<p class='text-center'><img src='/gfx/ajax-loader-2.gif'><p>");
		array_index = $(this).data("id");
		article_id = $('input[name=article_id]').val();
		
		var updateproblems = $.post( "/ajax_update_problems.php", { id: article_id, index: array_index } );						

		  updateproblems.done(function( data ) {

			var newproblems = $.post( "/ajax_get_problems.php", { id: article_id } );						

			  newproblems.done(function( data ) {
					$( "#output_problems" ).empty().append( data );		
			  });
		  });
	});

});