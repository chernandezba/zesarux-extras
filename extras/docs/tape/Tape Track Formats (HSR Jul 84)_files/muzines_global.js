$("document").ready(function(){

	function themeSwitch(switchToTheme) {

		// set theme cookie and reload current page
//		$('#div_theme_write').load('/session_write.php?theme=' + switchToTheme);
		$('#div_theme_write').load('/session_write.php?theme=' + switchToTheme);

// 		localStorage.muzines_theme = switchToTheme;
// 		localStorage.muzines_theme;

		// check status of bg to determine whether we are in dark mode
		myDMcheck = $(".bgc-white").css("background-color");
		if (myDMcheck == "rgb(48, 48, 48)") {
			isDark = 1;
		} else {
			isDark = 0;
		}

		if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
			// dark mode
			isSystemDark = 1;
		} else {
			isSystemDark = 0;
		}

		// give it a little time for cookie to be set
		// setTimeout(() => {  window.location.reload(); }, 100);

		// switch themes dynamically

		if (switchToTheme == 0) {
			// going light, unload all dark stuff
			$('link[rel=stylesheet][href*="dark-theme"]').remove();
			$('link[rel=stylesheet][href*="dark-auto"]').remove();

			// enable twitter feed
			//$("#tweetPanel").show();

			// update links
			$('#theme_display').html('<img class="dM" alt="Display Mode" src="/gfx/displaymode.png" height="10" width="10"> <span style="color: #FFFFFF;">Light</span> | <a class="themeSwitch" href="?theme=1">Dark</a> | <a class="themeSwitch" href="?theme=2">Auto</a>');

		} else if (switchToTheme == 1) {
			// going dark, load dark stuff
			$("head").append(
			  '<link href="/css/dark-theme.css" rel="stylesheet" type="text/css">'
			);

			// hide twitter feed
			//$("#tweetPanel").hide();

			// update links
			$('#theme_display').html('<img class="dM" alt="Display Mode" src="/gfx/displaymode.png" height="10" width="10"> <a class="themeSwitch" href="?theme=0">Light</a> | <span style="color: #FFFFFF;">Dark</span> | <a class="themeSwitch" href="?theme=2">Auto</a>');

		} else if (switchToTheme == 2) {
			// going auto, unload dark, load auto stuff
			if (isDark == 0) {				// currently light
				// check mode system is in
				if (isSystemDark == 0) {
					// light to light, remove dark stuff
					$('link[rel=stylesheet][href*="dark-theme"]').remove();
				} else {
					// light to dark, pull in auto dark
					$("head").append(
					  '<link href="/css/dark-auto.css" rel="stylesheet" type="text/css">'
					);
				}

			} else if (isDark == 1) {		// currently dark
				// check mode system is in
				if (isSystemDark == 0) {
					// light to dark
					$('link[rel=stylesheet][href*="dark-theme"]').remove();
					$("head").append(
					  '<link href="/css/dark-auto.css" rel="stylesheet" type="text/css">'
					);
				} else {
					// dark to dark
					$("head").append(
					  '<link href="/css/dark-auto.css" rel="stylesheet" type="text/css">'
					);
				}

			}

			// update links
			$('#theme_display').html('<img class="dM" alt="Display Mode" src="/gfx/displaymode.png" height="10" width="10"> <a class="themeSwitch" href="?theme=0">Light</a> | <a class="themeSwitch" href="?theme=1">Dark</a> | <span style="color: #FFFFFF;">Auto</span>');

		}

		// re-establish event handlers
		$( ".themeSwitch" ).click(function() {
			event.preventDefault();
			switchToTheme = $( this ).attr('href').substr(7,1);
			themeSwitch(switchToTheme);		
		});	

	}

	$( ".themeSwitch" ).click(function() {
		event.preventDefault();
		switchToTheme = $( this ).attr('href').substr(7,1);
		themeSwitch(switchToTheme);		
	});	

	$( "#doSearch" ).click(function() {

		$("#mainnavlist").fadeOut(100);
		$("#search_panel").fadeIn(100);
		$('#global_search_home').select2('open');

	});	

	$( "#doSearchPhone" ).click(function() {
// 		$("#home_search_phone").fadeOut(100);
		$("#search_panel").fadeIn(100);
		$('#global_search_home').select2('open');
		$('#global_search_home').select2('open');
	});	

	$('#global_search_home').on('select2:close', function (e) {
		$("#search_panel").fadeOut(100);		
		$("#mainnavlist").fadeIn(100);
	});

	$( "#promo_contribute" ).click(function() {
		window.location.href = '/contribute';
	});	

	$('#global_search_home').select2({
			placeholder: "Search for...",
		ajax: {
			url: "/homesearch.php",
			dataType: 'json',
			delay: 100,
			data: function (params) {
			  return {
				q: params.term, // search term
				page: params.page
			  };
			},
			success: resp => {
 		     	// console.log('response: ', resp);
 		       $('.select2-results').show();
		      },
			processResults: function (data, params) {
			  // params.page = params.page || 1;

			  return {
				results: data,
				pagination: {
				  // more: (params.page * 10) < data.total_count
				}
			  };
			},
    	cache: true
		  },		  
		  minimumInputLength: 2
	}).maximizeSelect2Height();


	// depending on selection, we'll change the search target
		// %g535 = gear id
		// %m2 = man id
		// %t24 = type id
		// %v19 = vendor id (ads only)
		// %a17 = artist id
		// %p32 = topic id
		// %r9 = role id


	$('#global_search_home').change(
    function(){
		selectedItem = $( "#global_search_home" ).val();
		
		if (selectedItem != null && selectedItem != "")
		{
			switch (selectedItem.substr(0, 2))
			{
				case "%a": window.location.assign('/artists/' + selectedItem.substr(2)); break;
				case "%r": window.location.assign('/artists/t/' + selectedItem.substr(2)); break;

				case "%x": window.location.assign('/gear/tags/' + selectedItem.substr(2)); break;

				case "%m": window.location.assign('/gear/0/' + selectedItem.substr(2) + '/0'); break;
				case "%t": window.location.assign('/gear/' + selectedItem.substr(2) + '/0/0'); break;
				case "%g": window.location.assign('/gear/' + selectedItem.substr(2)); break;

				case "%v": window.location.assign('/ads/v/' + selectedItem.substr(2) + '/0/0'); break;

				case "%p": window.location.assign('/features/' + selectedItem.substr(2)); break;

				case "%u": window.location.assign('/search/a/' + selectedItem.substr(2)); break;

				// not working yet (entity search)
				//case "%y": window.location.assign('/search/' + selectedItem.substr(2)); break;

				case "%z": window.location.assign('/mags/' + selectedItem.substr(2)); break;

				case "%i": window.location.assign('/mags/' + selectedItem.substr(2)); break;

				case "%s": window.location.assign('' + selectedItem.substr(2)); break;

				default: $("#search_global").attr('action', '/search.php'); $('#search_global').submit();
			}
		}

    });


}); 






	function showlog(bar)
	{
	  // $("#notification-bar").animate({height:200},200);
		$('#' + bar).animate({
			height: $('#' + bar).get(0).scrollHeight
		}, 300, function(){
			// $(this).height('auto');
		});

	}

	function showNotificationBar(message, duration, bgColor, txtColor, height, bar) {

		/*set default values*/
		duration = typeof duration !== 'undefined' ? duration : 1500;
		bgColor = typeof bgColor !== 'undefined' ? bgColor : '#6a4d32';
		txtColor = typeof txtColor !== 'undefined' ? txtColor : "#DDDDDD";
		height = typeof height !== 'undefined' ? height : 30;
		bar = typeof bar !== 'undefined' ? bar : "notification-bar";

		/*create the notification bar div if it doesn't exist*/
		if ($('#' + bar).size() == 0) {
			var HTMLmessage = "<div class='notification-message' style='text-align:center; font-family: Lato, sans-serif; line-height: " + height + "px;'> " + message + " </div>";
			$('body').prepend("<div id='" + bar + "' style='display:none; width:100%; height:" + "30" + "px; background-color: " + bgColor + "; z-index: 100; color: " + txtColor + ";border-bottom: 1px solid " + txtColor + ";'>" + HTMLmessage + "</div>");
		}

		$( "#showlog" ).click(function() {
			showlog(bar);
		});	

		$('#' + bar).show();

		/*animate the bar*/
//		$('#notification-bar').slideDown(function() {
// 			setTimeout(function() {
// 				$('#notification-bar').slideUp(function() {});
// 			}, duration);
//		});
	}