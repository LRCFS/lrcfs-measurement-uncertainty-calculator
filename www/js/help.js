function showHelp(steps, startingStep)
{
	var intro = introJs();
	intro.setOptions({steps});
	
	intro.setOption("skipLabel", "<i class='fa fa-times'></i> Close").setOption("nextLabel", "Next <i class='fa fa-angle-right'></i>")
	.setOption("prevLabel", "<i class='fa fa-angle-left'></i> Prev")
	.setOption("showBullets", false)
	.setOption("showProgress", true)
	.setOption("hidePrev", true)
	.setOption("hideNext", true)
	.goToStepNumber(startingStep)
	.start();
}

Shiny.addCustomMessageHandler("helpStartPage",
function(startingStep) {
	var steps = [
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(1)",
			intro: '<h4>Case Sample Data</h4>\
					<p>Case sample data! Awh man, this is so amazing. When you find out about case sample data you\'re going to be all like "no way man! that\'s super cool.</p>\
					<iframe width="304" height="171" src="https://www.youtube-nocookie.com/embed/Gyrfsrd4zK0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>\
					<p>Awh man, wasn\'t that dope? Click next to find out more about other things! Yay!</p>'
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div > div > div.box-body > div:nth-child(3)",
			intro: '<h4>Replicates</h4>\
					<p>Replicates are cool. You should totally check them out.</p>\
					<p>Aren\'t replicates the best?!</p>',
			position: "top"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div > div > div.box-body > div:nth-child(4)",
			intro: "<h4>Mean Concentration</h4>\
					<p>Awwwh man! Did you hear about how the cool mean concentration dude was like 'no way man', then the other guy was all like 'yes way man!' and a totally awesome thing happened and everyoen was like 'GNARLEY!' and it totally went off the hook from there.</p>",
			position: "bottom"
			
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div",
			intro: "<h4>Case Sample Replicates</h4>\
					<p>This information mirors the value entered above. Where you see this box/value being used on other pages this is the value that it represents.</p>\
					<p>If you want to change it you can come back to the start page to change it at any time.</p>",
			position: "bottom"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div:nth-child(3) > div",
			intro: "<h4>Case Sample Mean Concentration</h4>\
					<p>Help information here...</p>",
			position: "bottom"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(3)",
			intro: "<h4>Confidence Interval</h4>\
					<p>Help information here...</p>",
			position: "top"
			
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(3) > div:nth-child(1) > div > div.box-body > div",
			intro: "<h4>Specify Confidence Interval</h4>\
					<p>Help information here...</p>",
			position: "bottom"
			
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(3) > div:nth-child(2) > div",
			intro: "<h4>Selected Confidence Interval</h4>\
					<p>Help information here...</p>",
			position: "bottom"
			
		},
		{
			element: "#fileUploadBox > div:nth-child(2)",
			intro: "<h4>Upload Data Files</h4>\
					<p>Help information here...</p>",
			position: "left"
		},
		{
			element: "#fileUploadBox > div:nth-child(4)",
			intro: "<h4>Upload Calibration Curve Data</h4>\
					<p>Help information here...</p>",
			position: "left"
		}
		,
		{
			element: "#fileUploadBox > div:nth-child(6)",
			intro: "<h4>Upload Method Precision Data</h4>\
					<p>Help information here...</p>",
			position: "left"
		}
		,
		{
			element: "#fileUploadBox > div:nth-child(8)",
			intro: "<h4>Upload Standard Solution Data</h4>\
					<p>Help information here...</p>",
			position: "left"
		}
		,
		{
			element: "#fileUploadBox > div:nth-child(10)",
			intro: "<h4>Upload Sample Volume Data</h4>\
					<p>Help information here...</p>",
			position: "left"
		}
	]
	
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler("helpCalibrationCurve",
function(startingStep) {
	var steps = [
		{
			element: "#uploadedCalibrationDataStats",
			intro: "Hello world!1"
		},
		{
			element: "#shiny-tab-calibrationCurve [data-value='Graph']",
			intro: "Hello world!2"
		},
		{
			element: "#shiny-tab-calibrationCurve [data-value='Raw Data']",
			intro: "Hello world!3"
		},
		{
			element: "#rearrangedCalibrationData",
			intro: "Hello world!4"
		},
		{
			element: "#rearrangedCalibrationData thead tr th:nth-of-type(4)",
			intro: "Hello world!5"
		},
		{
			element: "#shiny-tab-calibrationCurve .row .col-sm-6:first-of-type .info-box",
			intro: "Hello world!6"
		},
		{
			element: "#shiny-tab-calibrationCurve .row .col-sm-6:last-of-type .info-box",
			intro: "Hello world!7"
		},
		{
			element: "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(3)",
			intro: "Hello world!8"
		},
		{
			element: "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(4) .col-sm-6:first-of-type .box",
			intro: "Hello world!9"
		},
		{
			element: "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(4) .col-sm-6:last-of-type .box",
			intro: "Hello world!10"
		},
		{
			element: "#shiny-tab-calibrationCurve .box-body .row:nth-of-type(5) .box",
			intro: "Hello world!11"
		}
	]
	
	showHelp(steps, startingStep);
});



Shiny.addCustomMessageHandler("helpResultsDashboard",
function(startingStep) {
	var steps = [
		{
			element: "#shiny-tab-dashboard .col-sm-6:nth-of-type(1) .small-box",
			intro: "Hello world!1"
		},
		{
			element: "#shiny-tab-dashboard .col-sm-6:nth-of-type(2) .small-box",
			intro: "Hello world!2"
		},
		{
			element: "#shiny-tab-dashboard .col-sm-6:nth-of-type(3) .small-box",
			intro: "Hello world!3"
		}
	]
	
	showHelp(steps, startingStep);
});

