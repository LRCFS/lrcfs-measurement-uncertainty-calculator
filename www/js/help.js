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

Shiny.addCustomMessageHandler("runjs_help_start",
function(startingStep) {
	var steps = [
		{
			element: "#shiny-tab-start #calcurve",
			intro: '<h4>Calibration Curve</h4>\
					<p>Upload data on concentration levels and peak area (ratios) used to generate the calibration curve. An example data file can be downloaded and edited.</p>\
					<h4>External Standard Error</h4>\
					<p>Upload existing data on concentration levels and peak area (ratios) from previous experiments if a pooled standard error of regression estimate is preferred.</p>',
			position: "right",
			width: "500px"
		},
		{
			element: "#shiny-tab-start #methodprec",
			intro: "<h4>Method Precision</h4>\
					<p>Upload data for precision estimate across the different concentration range of Low, Medium and High.</p>",
			position: "right"
			
		},
		{
			element: "#shiny-tab-start #stdsol",
			intro: "<h4>Standard Solution</h4>\
					<p>Two data files are required for standard solution; Structure and Equipment data. Equipment data requires information on all pipettes and flask used in each solution preparation including information on manufacturer’s tolerance and coverage factor, volume and number of times used for pipetting</p>\
					<p>Structure data requires information on reference compound, its purity, tolerance and coverage factor and the structure of how the reference compound was diluted to form other solutions in generating the calibration curve.</p>",
			position: "right"
		},
		{
			element: "#shiny-tab-start #samplevol",
			intro: "<h4>Sample Volume</h4>\
					<p>Sample Volume requires information on pipettes/flask used to measure sample volume, its tolerance, and volume and coverage factor.</p>",
			position: "right"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(2) > div:nth-child(1) > div > div",
			intro: "<h4>Weighted Least Square Regression</h4>\
					<p>Select a weight option to be applied to the model if weighted regression is required.</p>",
			position: "left"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(2) > div:nth-child(2)",
			intro: "<h4>Case Sample Data</h4>\
					<p>Specify the mean concentration reading of cases ample and the number of replicates taken.</p>",
			position: "left"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(2) > div:nth-child(4)",
			intro: "<h4>Confidence Interval</h4>\
					<p>Specify the confidence interval required to calculate the Expanded Uncertainty.</p>",
			position: "left"
		}
	]
	
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler("runjs_help_calibrationCurve",
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
			intro: "Squared Deviation is the awesome thing that's totally awesome"
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
