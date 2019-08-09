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
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div > div > div.box-body > div:nth-child(3)",
			intro: "Hello world!1",
			position: "top"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div > div > div.box-body > div:nth-child(4)",
			intro: "Hello world!2",
			position: "bottom"
			
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div",
			intro: "Hello world!3",
			position: "bottom"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(1) > div:nth-child(2) > div:nth-child(2) > div",
			intro: "Hello world!4",
			position: "bottom"
		},
		{
			element: ".col-sm-6 > .row:nth-child(4) .box",
			intro: "Hello world!5",
			position: "right"
			
		},
		{
			element: "#fileUploadBox > div:nth-child(2)",
			intro: "Hello world!6",
			position: "left"
		},
		{
			element: "#fileUploadBox > div:nth-child(4)",
			intro: "Hello world!7",
			position: "left"
		}
		,
		{
			element: "#fileUploadBox > div:nth-child(6)",
			intro: "Hello world!8",
			position: "left"
		}
		,
		{
			element: "#fileUploadBox > div:nth-child(8)",
			intro: "Hello world!9",
			position: "left"
		}
		,
		{
			element: "#fileUploadBox > div:nth-child(10)",
			intro: "Hello world!10",
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

