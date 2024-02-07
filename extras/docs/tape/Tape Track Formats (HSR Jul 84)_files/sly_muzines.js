$("document").ready(function(){

	var slyFullActive = 0;
	var slyFullInitialised = 0;
	var slyMainActive = 0;
	var slyMainInitialised = 0;
	var slyMainSpeed = 500;
	var slyFullSpeed = 500;
	var itemClicked;
	var timeout;
	var pageFullChanged = false;

	var $frame = $('#forcecentered');
	var $wrap  = $frame.parent();

    var slyMain = new Sly($frame,
        {
			horizontal: 1,
			itemNav: 'forceCentered',
			smart: 1,
			activateMiddle: 1,
			activateOn: null,
			mouseDragging: 0,
			touchDragging: 1,
			releaseSwing: 1,
			startAt: 0,
			scrollBar: $wrap.find('.scrollbar'),
			scrollBy: 1,
			speed: slyMainSpeed,
			syncSpeed: 0.3,
			elasticBounds: 1,
			easing: 'easeOutExpo',
			dragHandle: 1,
			dynamicHandle: 1,
			clickBar: 0,				// bar click causes images not to be loaded, disabling for now until I can find a solution
			keyboardNavBy: 'pages',

			// Buttons
			prevPage: $wrap.find('.backward'),
			nextPage: $wrap.find('.forward')
     })

	// initial load of first set of images
 	slyMain.on('load', function () {
		//console.log('(Main) activePage: ' + slyMain.rel.activeItem + ', activeItem: ' + slyMain.rel.activeItem + ", first: " + slyMain.rel.firstItem + ", centre: " + slyMain.rel.centerItem + ", last: " + slyMain.rel.lastItem);		
 		slyLazyLoad(slyMain,4);
 	});

	// if pagescans is open, init here 
	if ( $('#bloc-14').css('display') != 'none' )
	{
	    slyMain.init();
		slyMainInitialised = 1;
	}

	var $frame2 = $('#forcecentered2');
	var $wrap2  = $frame2.parent();

    slyFull = new Sly($frame2,
        {
			horizontal: 1,
			itemNav: 'basic',
			smart: 1,
			activateMiddle: 0,
			activateOn: null,
			mouseDragging: 1,
			touchDragging: 1,
			releaseSwing: 1,
			startAt: 0,
			scrollBar: $wrap2.find('.scrollbar'),
			scrollBy: 1,
			speed: slyFullSpeed,
			syncSpeed: 0.2,
			elasticBounds: 1,
			easing: 'easeOutExpo',
			dragHandle: 1,
			dynamicHandle: 1,
			clickBar: 1,
			keyboardNavBy: null,

			// Buttons
			prevPage: $wrap2.find('.backward'),
			nextPage: $wrap2.find('.forward')
     });     


	if($(window).width() > 767 && $(window).height() > 768){
	// only affix page scans on larger screens
	$('#bloc-14').affix({
		  offset: {
//			top: $('nav-bloc').height()
//			should really be dynamic depending on nav height, but doesn't seem to work now
//			if we change the navbar height, also need to update it here
			top: 140
		  }
	});	
		} else {
			$(window).off('.affix');
			$('#bloc-14').removeData('bs.affix').removeClass('affix affix-top affix-bottom');
	 		$('#bloc-9').css('padding-top', 0);
		}

	$('#bloc-14').on('affix.bs.affix affix-top.bs.affix', function (e) {
 		var padding = e.type === 'affix' ? $(this).height() : '';
 		$('#bloc-9').css('padding-top', padding);
	});
	$( "#showpages" ).click(function() {
		var linktext = replace_toggle_scan_text($('#togglepages').html());
		$('#togglepages').html(linktext);

		var badge_color = $('#togglepages span').css( "background-color" );

		if (badge_color == 'rgb(255, 165, 0)')
		{
   			$('#togglepages span').css('background-color', 'rgb(119, 119, 119)');
		    $( "#miniScans" ).fadeIn(600);
		} else {
   			$('#togglepages span').css('background-color', 'orange');
		    $( "#miniScans" ).fadeOut(600);
		}
	  $('#div_session_write').load('/session_write.php?display_pagescans=toggle');

		// if main not inited, init here
		// a bit hacky
		// if scans closed on page load, show the draw to init the sly, then hide it again
		// then do the anim
		if ( $('#bloc-14').css('display') == 'none' && slyMainInitialised == 0)
		{
			$('#bloc-14').css('display', 'block');

			if (slyMainInitialised == 0)
			{
				slyMain.init();
				slyMainInitialised = 1;
			}

			$('#bloc-14').css('display', 'none');
		}


	  $( "#bloc-14" ).slideToggle( 600, "easeInOutCubic", function() {
		// Animation complete.
	  });

	});

	$( "#minitogglepages" ).click(function() {
		$( "#togglepages" ).click();
	});

	$( "#togglepages" ).click(function() {

		var linktext = replace_toggle_scan_text($('#togglepages').html());
		$('#togglepages').html(linktext);

		var badge_color = $('#togglepages span').css( "background-color" );

		if (badge_color == 'rgb(255, 165, 0)')
		{
   			$('#togglepages span').css('background-color', 'rgb(119, 119, 119)');

		    $( "#miniScans" ).fadeIn(600);

		} else {
   			$('#togglepages span').css('background-color', 'orange');


		    $( "#miniScans" ).fadeOut(600);
		}

	  $('#div_session_write').load('/session_write.php?display_pagescans=toggle');

		// if main not inited, init here
		// a bit hacky
		// if scans closed on page load, show the draw to init the sly, then hide it again
		// then do the anim
		if ( $('#bloc-14').css('display') == 'none' && slyMainInitialised == 0)
		{
			$('#bloc-14').css('display', 'block');

			if (slyMainInitialised == 0)
			{
				slyMain.init();
				slyMainInitialised = 1;
			}

			$('#bloc-14').css('display', 'none');
		}

	  $( "#bloc-14" ).slideToggle( 600, "easeInOutCubic", function() {
		// Animation complete.
		});

	});

	function replace_toggle_scan_text($link_contents)
	{
		// alert($link_contents);
		// Show Page Scans <span class="badge">84</span>

		// str.replace("Microsoft", "W3Schools");

		var str_show_result = $link_contents.search("Show");
		var str_hide_result = $link_contents.search("Hide");
		if (str_show_result >= 0)
		{
			$link_contents = $link_contents.replace("Show", "Hide");
		} else if (str_hide_result >= 0)
		{
			$link_contents = $link_contents.replace("Hide", "Show");
		}
		
		return $link_contents;
	}

	$( "#artInfo" ).click(function() {

		var badge_contents = $('#artInfo span').html();

 		if (badge_contents == "Off")
 		{
  			$('#artInfo span').html("On");
   			$('#artInfo span').css('background', 'orange');
		} else if (badge_contents == "On")
		{
  			$('#artInfo span').html("Off");
   			$('#artInfo span').css('background', 'rgb(119, 119, 119)');
		}

	  $('#div_session_write').load('/session_write.php?display_pagedescriptions=toggle');
	});

//	use active item on one sly to set another sly
//slyMain.on('change', function () {slyFull.activate(slyMain.rel.activeItem;);});


	function setPaths(el) {
		var imgs = el.querySelectorAll('[data-src]');
		for (var i = 0; i < imgs.length; i++) {
			$(imgs[i]).hide();

			imgs[i].src = imgs[i].dataset ? imgs[i].dataset.src : imgs[i].getAttribute(attr);

			$(imgs[i]).fadeIn(600);
		}
	}

	function slyLazyLoad(slyInstance,extraBufferedImages) {
		var start = Math.max(0,slyInstance.rel.firstItem - extraBufferedImages);
		var end = slyInstance.rel.lastItem + extraBufferedImages;

		for (var i = start; i <= end; i++) {
			if (!slyInstance.items[i] || slyInstance.items[i].lazyLoaded) continue;
			slyInstance.items[i].lazyLoaded = true;
			setPaths(slyInstance.items[i].el);
		}
	}


	slyMain.on('change', function () {
//		console.log('(Main) activePage: ' + slyMain.rel.activeItem + ', activeItem: ' + slyMain.rel.activeItem + ", first: " + slyMain.rel.firstItem + ", centre: " + slyMain.rel.centerItem + ", last: " + slyMain.rel.lastItem);		
		slyLazyLoad(slyMain,4);
	});

	// catch all to make sure current visible images are loaded
	slyMain.on('active', function () {
		slyLazyLoad(slyMain,0);
	});

	slyFull.on('change', function () {
//		console.log('(Full:change) activePage: ' + slyFull.rel.activePage + ', activeItem: ' + slyFull.rel.activeItem + ", first: " + slyFull.rel.firstItem + ", centre: " + slyFull.rel.centerItem + ", last: " + slyFull.rel.lastItem);		
		slyLazyLoad(slyFull,2);
		if (slyFull.rel.activePage != slyMain.rel.activePage)
		{
			pageFullChanged = true;
//			console.log("pageFullChanged (true): " + pageFullChanged);
		} else {
			pageFullChanged = false;
//			console.log("pageFullChanged (false): " + pageFullChanged);
		}
	});

	slyFull.on('load', function () {
//		console.log('(Full:load) activePage: ' + slyFull.rel.activePage + ', activeItem: ' + slyFull.rel.activeItem + ", first: " + slyFull.rel.firstItem + ", centre: " + slyFull.rel.centerItem + ", last: " + slyFull.rel.lastItem);		
//		console.log('slyfull load');

		if (!pageFullChanged && slyFull.rel.activePage != slyMain.rel.activePage)
		{
//			console.log('activate (on load) RESET');
			slyFull.activate(slyMain.rel.activePage,true);
			// slyFull.activate(slyMain.rel.activePage +1,true);
		}

		
		slyLazyLoad(slyFull,2);

	});

	// when main scan is clicked on, open in full view

	$(".supersize").click(function( event ) {

		if($(window).width() > 480 && $(window).height() > 480){

//		alert(slyMain.rel.centerItem);
		var id = event.target.id;
		itemClicked = parseInt(id.substring(3));
//	    console.log('id = ' + id); 
//		console.log('Main active: ' + slyMain.rel.activeItem + ", start: " + slyMain.rel.firstItem + ", end: " + slyMain.rel.lastItem);		
//	    console.log('item_clicked = ' + itemClicked); 

  		$('#myModal').modal('show');

		} else {
			//alert("Your current screen size is to small to display larger size images.");
		}

	});
	
	$(".articleshow").hover(
		function(e) {			
			var id = $(this).attr("id");
			var itemHovered = parseInt(id.substring(3));

			timeout = setTimeout(function(e){
				slyMain.activate(itemHovered);
		//	    console.log('id = ' + id); 


				setTimeout(function(){
					slyLazyLoad(slyMain,0);
				},450);
			}, 300);		
		}, 
		function(e) {
			clearTimeout(timeout);
		}
	);

	$(".articlefirst").click(
		function(e) {		
			var id = $(this).attr("id");
			var itemHovered = parseInt(id.substring(3));

			slyMain.activate(itemHovered);
			slyLazyLoad(slyMain,0);

		}
	);
/*
	$(".supersize").hover(
 		  function (e) {
			var id = $(this).attr("id");
			var itemHovered = parseInt(id.substring(3));
			highlight_row(itemHovered);
 		  }, 
 		  function (e) {
			var id = $(this).attr("id");
			var itemHovered = parseInt(id.substring(3));
			unhighlight_row(itemHovered);
 		  }
	);

function highlight_row(itemHovered)
{
	var table_row = '#ar_' + itemHovered;
	$(table_row).css("background","#F5E0F5");
}
function unhighlight_row(itemHovered)
{
	var table_row = '#ar_' + itemHovered;
	$(table_row).css("background","");
}
*/
	    
/*
	$("#goFull").click(function() {
  		$('#myModal').modal('show');
	});
*/
	$('#myModal').on('show.bs.modal', function () {

//	    console.log('slyFul being shown'); 

		// we've added extra blank page which may or may not be shown, but is always counted, so compensate
		// also need to align to dual-page boundaries
		// if itemClicked is odd (left), ok, if even (right), we should activate left page

		// if pairs of pages, do, if single, we need to go item clicked only
		// check if dummy page is visible or not to determine

/*
		if ($(".dummy_page")[0]){
			// Do something if class exists
		} else {
			// Do something if class does not exist
		}
*/

		if ( $('.dummy_page').css('display') == 'none' )
		{
			// console.log("Dummy is not visible (single pages shown)");
			//console.log('activate (on show) NORESET');
			slyFull.activate(itemClicked+1 ,true);
		} else {
			// console.log("Dummy is visible (page pairs shown)");

			//console.log('activate (on show) NORESET');
			slyFull.activatePage(Math.floor((itemClicked+1)/2),true);

		}


		// console.log('myModal show slyFull (pre) - init to main active item: ' + slyMain.rel.activePage);

/*
		if (slyFullInitialised == 1) { 
			console.log('Open slyFull (pre) - init to main active item: ' + slyMain.rel.activePage);
			if (slyFull.rel.activePage != slyMain.rel.activePage)
			{			
//				slyFull.activate(slyMain.rel.activePage);
			}

			console.log('Main active: ' + slyMain.rel.activeItem + ", start: " + slyMain.rel.firstItem + ", end: " + slyMain.rel.lastItem);		
			console.log('item_clicked = ' + itemClicked); 
			console.log('Full active: ' + slyFull.rel.activeItem + ", start: " + slyFull.rel.firstItem + ", end: " + slyFull.rel.lastItem);		

			// make sure item we clicked on is scrolled to in slyFull
			if (itemClicked >= slyFull.rel.firstItem && itemClicked <= slyFull.rel.lastItem)
			{
				console.log('itemClicked is in view'); 
			} else {
				console.log('itemClicked is NOT in view'); 

				slyFull.activate(itemClicked);
			}
		}
*/

	})
	
	function monitor()
	{
		// display variables to console
//		console.log('Monitor variables\n-----------------------');
//		console.log('itemClicked: ' + itemClicked);
		//console.log('(Main) activePage: ' + slyMain.rel.activeItem + ', activeItem: ' + slyMain.rel.activeItem + ", first: " + slyMain.rel.firstItem + ", centre: " + slyMain.rel.centerItem + ", last: " + slyMain.rel.lastItem);		
//		console.log('(Full) activePage: ' + slyFull.rel.activePage + ', activeItem: ' + slyFull.rel.activeItem + ", first: " + slyFull.rel.firstItem + ", centre: " + slyFull.rel.centerItem + ", last: " + slyFull.rel.lastItem);		

	}
	
	function check_page_offset()
	{
		// not using at the moment, trying a different way
/*
		if (slyFull.rel.lastItem - slyFull.rel.firstItem == 1)
		{
			// two items are displayed
			// add empty item at beginning, to shift page 1 onto the right to keep pages in pairs
			// console.log('slyFull firstload: two items displayed');
			// slyFull.add('<li></li>', 0);
			console.log('check_page_offset: two items displayed, adding empty item');
		} else {
			console.log('check_page_offset: one item displayed');
		}
*/
	}
	
	$('#myModal').on('shown.bs.modal', function () {
		slyFullActive = 1;
		slyMain.set('keyboardNavBy', null); 

		// console.log('myModal shown slyFull - init to main active item: ' + slyMain.rel.activePage);

/*
		if (slyFull.rel.activePage != slyMain.rel.activePage)
		{
			alert("problem");
		}
*/		
		// only init slyFull the first time

		if (slyFullInitialised == 0) { 
			slyFull.init(); 
			slyFullInitialised = 1;

			if ( $('.dummy_page').css('display') == 'none' )
			{
				// alert("Dummy is not visisble (single pages shown");
			//console.log('activate (on shown) NORESET');
				slyFull.activate(itemClicked+1,true);
			} else {
				// alert("Dummy is visisble (page pairs shown");
			//console.log('activate (on shown) NORESET');
				slyFull.activatePage(Math.floor((itemClicked+1)/2),true);
			}


		}

		slyLazyLoad(slyFull,2);

		slyFull.set('keyboardNavBy', 'pages');

	})

	$('#myModal').on('hide.bs.modal', function (e) {
		// console.log('Close slyFull - update main active item: ' + slyFull.rel.activePage);
		if (slyFull.rel.activePage != slyMain.rel.activePage)
		{
//			slyMain.activate(slyFull.rel.activePage);

			if (slyFull.rel.firstItem != itemClicked + 1)
			{
				slyMain.activate(slyFull.rel.firstItem - 1);
			} else {
				slyMain.activate(itemClicked);
			}

			// slyMain.activate(slyFull.rel.firstItem - 1);
			slyLazyLoad(slyMain,4);

		}
	})

	// when modal closed, turn keyboard nav back on
	$('#myModal').on('hidden.bs.modal', function (e) {
		slyFull.set('keyboardNavBy', null);
		slyMain.set('keyboardNavBy', 'pages');
		slyFullActive = 0;

//		slyFull.destroy(); 
//		slyFullInitialised = 0;
	})


	// on orientatio change and full sly is open, redraw it so paging etc works correctly
	jQuery( window ).on( "orientationchange", function( ) {

		// only reload if page scans are open (as doing it when close kills it

		var linktext = replace_toggle_scan_text($('#togglepages').html());
		$('#togglepages').html(linktext);
		var badge_color = $('#togglepages span').css( "background-color" );
		if (badge_color == 'rgb(255, 165, 0)')
		{
			// page scans are open, reload to adjust for new layout
			slyMain.reload();
		} else {
			// page scans are close, don't reload, as often doesn't init properly when not visible
		}


		if (slyFullActive == 1)
		{
			// console.log('orientation change slyFull reload');
			slyFull.reload();	
		}
	 })
	 
	$(window).resize(_.debounce(function(){
		// slyMain.reload();

		if (slyFullActive == 1)
		{
//			console.log('resize slyFull reload');
//			monitor();
			slyFull.reload();

			if ( $('.dummy_page').css('display') == 'none' )
			{
				// alert("Dummy is not visisble (single pages shown");

				// this reloads with itemCLicked, but we might have changed pages

//			console.log('activate (on resize) RESET');
			if (!pageFullChanged)
			{			
				slyFull.activate(itemClicked+1,true);
			}
			} else {
				// alert("Dummy is visisble (page pairs shown");

				// this reloads with itemCLicked, but we might have changed pages

//			console.log('activate (on resize) RESET');
			if (!pageFullChanged)
			{			
				slyFull.activatePage(Math.floor((itemClicked+1)/2),true);
			}
			// monitor();
			}

		} else {
			// if we are resizing with fullSly closed, it breaks it, so in this case, destroy the object
			// it will be recreated the next time it's opened
			if (slyFull.initialized)
			{
				slyFull.destroy();
				slyFullInitialised = 0;
				// console.log('resize slyFull destroy');
			}
		}

		if($(window).width() > 767 && $(window).height() > 768){
			// only affix page scans on larger screens
			$('#bloc-14').affix({
				  offset: {
		//			top: $('nav-bloc').height()
		//			should really be dynamic depending on nav height, but doesn't seem to work now
		//			if we change the navbar height, also need to update it here
					top: 140
				  }
			});	
		} else {
			$(window).off('.affix');
			$('#bloc-14').removeData('bs.affix').removeClass('affix affix-top affix-bottom');
	 		$('#bloc-9').css('padding-top', 0);
		}

	},400));



	// handle cursor keys when in input field
	$("#problem_notes").on('focus', ":input:visible:enabled", function () {
		// turn off keyboard handling on main sly
		slyMain.set('keyboardNavBy', null);
	});
 	$("#problem_notes").on('focusout', ":input:visible:enabled", function () {
		// turn on keyboard handling on main sly
		slyMain.set('keyboardNavBy', 'pages');
 	});



	// handle cursor keys when in search field
	$('#global_search_home').on('select2:open', function (e) {
		slyMain.set('keyboardNavBy', null);
	});
	$('#global_search_home').on('select2:close', function (e) {
		slyMain.set('keyboardNavBy', 'pages');
	});


	// doesn't work with select2 search
	$("#global_search").on('focus', function () {
		// turn off keyboard handling on main sly
		slyMain.set('keyboardNavBy', null);
	});
 	$("#global_search").on('focusout',function () {
		// turn on keyboard handling on main sly
		slyMain.set('keyboardNavBy', 'pages');
 	});

// upload form
	$("#file_comment").on('focus', function () {
		// turn off keyboard handling on main sly
		slyMain.set('keyboardNavBy', null);
	});
 	$("#file_comment").on('focusout',function () {
		// turn on keyboard handling on main sly
		slyMain.set('keyboardNavBy', 'pages');
 	});
	$("#notes").on('focus', function () {
		// turn off keyboard handling on main sly
		slyMain.set('keyboardNavBy', null);
	});
 	$("#notes").on('focusout',function () {
		// turn on keyboard handling on main sly
		slyMain.set('keyboardNavBy', 'pages');
 	});
	$("#email").on('focus', function () {
		// turn off keyboard handling on main sly
		slyMain.set('keyboardNavBy', null);
	});
 	$("#email").on('focusout',function () {
		// turn on keyboard handling on main sly
		slyMain.set('keyboardNavBy', 'pages');
 	});
	$("#displayname").on('focus', function () {
		// turn off keyboard handling on main sly
		slyMain.set('keyboardNavBy', null);
	});
 	$("#displayname").on('focusout',function () {
		// turn on keyboard handling on main sly
		slyMain.set('keyboardNavBy', 'pages');
 	});
	$("#name").on('focus', function () {
		// turn off keyboard handling on main sly
		slyMain.set('keyboardNavBy', null);
	});
 	$("#name").on('focusout',function () {
		// turn on keyboard handling on main sly
		slyMain.set('keyboardNavBy', 'pages');
 	});






	// page scans close button
	$("#psclosescans").on('click', function () {

		var linktext = replace_toggle_scan_text($('#togglepages').html());
		$('#togglepages').html(linktext);

		var badge_color = $('#togglepages span').css( "background-color" );

		if (badge_color == 'rgb(255, 165, 0)')
		{
   			$('#togglepages span').css('background-color', 'rgb(119, 119, 119)');
		    $( "#miniScans" ).fadeIn(600);
		} else {
   			$('#togglepages span').css('background-color', 'orange');
		    $( "#miniScans" ).fadeOut(600);
		}

	  $('#div_session_write').load('/session_write.php?display_pagescans=toggle');
	  $( "#bloc-14" ).slideToggle( 600, "easeInOutCubic", function() {
		// Animation complete.
			$('#bloc-9').css('padding-top', 0);
	  });
 	});

}); 