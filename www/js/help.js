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
					<p>Calibration curve data is data on concentration levels and peak area (ratios) used to generate the calibration for estimating the level of concentration in a given new sample.</p>\
					<h4>External Standard Error</h4>\
					<p>In place of the standard error of regression, standard error from previous calibration curve data can be pooled together with current calibration data to obtain a more reliable estimate. This is recommended if calibration curve data uploaded above have only one replicate or is based on single point calibration system.</p>',
			position: "right",
			width: "500px"
		},
		{
			element: "#shiny-tab-start #methodprec",
			intro: "<h4>Method Precision</h4>\
					<p>Method precision quantifies the closeness of agreement between measured values obtained through replicate measurements on the same or similar objects under specified conditions. The replicate measurements could be carried out over different concentration range of Low, Medium and High.</p>",
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
			intro: "<h4>Weighted Least Square (WLS) Regression</h4>\
					<p>WLS is recommend if the standard deviation data correlates with the magnitude of the concentration being estimated, such that plot of residuals shows a non-constant error (termed heteroscedasticity).</p>\
					<p><img src='images/wls-help.png' alt='Example plot showing the presence of heteroscedasticity' style='width: 100%'/></p>\
					<p>Figure from <a href='https://pdfs.semanticscholar.org/5814/151283d2b44412edfb8ae5a9d3e53616fa32.pdf' target='_blank'>Regression and Calibration</a> shows an example of where the standard deviation of data is proportional to the magnitude concentration (a) such that the plot of residuals have high variability for high predicted values. For more information on choosing the appropriate weight see the paper by <a href='https://pubs.acs.org/doi/pdf/10.1021/ac5018265' target='_blank'>Huidong Gu et al.</a></p>",
			position: "left"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(2) > div:nth-child(2)",
			intro: "<h4>Case Sample Data</h4>\
					<p>Case sample replicate is the number of repeated measurement taken on a sample to estimate the mean concentration of the sample.</p>\
					<p>Case sample mean concentration is the amount of compound substance estimated to be contained in a given sample.</p>",
			position: "left"
		},
		{
			element: "#shiny-tab-start > div:nth-child(2) > div:nth-child(2) > div:nth-child(4)",
			intro: "<h4>Confidence Interval</h4>\
					<p>A 95% CI means that 95 out of 100 times, we will be correct in estimating an interval that is believed to include the unknown parameter of interest. A high percentage probability will broaden the estimated confidence interval and vice versa.</p>\
					<p>Specify the required confidence interval percentage probability needed to calculate the Expanded Uncertainty. </p>",
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
