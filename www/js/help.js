/*
###########################################################################
#
# Measurement Uncertainty Calculator - Copyright (C) 2019
# Leverhulme Research Centre for Forensic Science
# Roy Mudie, Joyce Klu, Niamh Nic Daeid
# Website: https://github.com/LRCFS/lrcfs-measurement-uncertainty-calculator/
# Contact: lrc@dundee.ac.uk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###########################################################################
*/

$(document).ready(function() {
  
  
});

function embedVideoLink(url){
  return("<p><iframe width='100%' height='350px' src='https://www.youtube.com/embed/"+url+"' frameborder='0' allow='accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe></p>");
}

function showHelp(steps, startingStep)
{
	var intro = introJs();
	intro.setOption('steps', steps)
	.setOption('skipLabel', '<i class="fa fa-times"></i> Close').setOption('nextLabel', 'Next <i class="fa fa-angle-right"></i>')
	.setOption('prevLabel', '<i class="fa fa-angle-left"></i> Prev')
	.setOption('showBullets', false)
	.setOption('showProgress', true)
	.setOption('hidePrev', true)
	.setOption('hideNext', true)
	.goToStepNumber(startingStep)
	.start();
	
	var introJsClass = '.introjs-tooltip';
	
	//after we started introjs load mathjax again to force any latex conversion
	MathJax.Hub.Queue(["Typeset", MathJax.Hub, introJsClass]);
	
	//Lets then attach an observer to the tooltips so that any time its displayed we can force mathjax again
	var target = document.querySelector(introJsClass);
	
  var reloadMathjax = new MutationObserver(function(mutations) {
    if(window.getComputedStyle(target).getPropertyValue( 'display' ) !== 'none')
    {
       MathJax.Hub.Queue(["Typeset", MathJax.Hub, introJsClass]);
    }
  });
 
  reloadMathjax.observe(target, {
    attributes: true
  });
}

Shiny.addCustomMessageHandler('runjs_help_start',
function(startingStep) {
	var steps = [
		{
			intro: '<h4>' + APP_NAME + ' Help</h4>\
					<p>Welcome to the ' + APP_NAME_SHORT + ' help. These help windows are specific to each section so make sure to explore the help on each page as you use the application.</p>\
					<p>To use the help, move between each section by using the <strong>Previous</strong> and <strong>Next</strong> buttons at the bottom of each help window. You can exit the help at any time by clicking the <strong>Close</strong> button or just outside a help window.</p>\
					<p>To get started please view the quick overview video below, click <strong>Next</strong> to continue through the help, or <strong>Close</strong> to exit.</p>' + embedVideoLink('q6ZrRuG3ilA')
		},
		{
			element: '#shiny-tab-start > div:nth-child(3) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)',
			intro: '<h4>Case Sample Data</h4>\
					<p>Case sample replicates \\((r_s)\\) is the number of repeated measurements taken on a sample to estimate the mean concentration of the sample.</p>\
					<p>Case sample mean concentration \\((x_s)\\) is the mean amount of compound substance estimated to be contained in a given sample.</p>\
					<p>If a Weighted Least Square Regression has been chosen then the case sample mean peak area ratio \\((y_s)\\) is the mean peak area (ratio) or instrument response used to estimate the concentration of a given sample.</p>',
			position: 'right'
		},
		{
			element: '#shiny-tab-start > div:nth-child(3) > div:nth-child(2) > div:nth-child(1) > div:nth-child(1)',
			intro: '<h4>Coverage Factor</h4>\
					<p>Coverage Factor can be calculated automatically or manually specified.</p>\
					<p><strong>Automatic:</strong> By specifying a Confidence Interval the Coverage Factor is automatically obtained by using the appropriate Coverage Factor from a t-distribution table.</p>\
					<p><strong>Manual:</strong> Alternatively, if a specific Coverage Factor is specified the Confidence Interval will be ignored and the specified Coverage Factor will be used for all calculations. </p>',
			position: 'left'
		}
	];
	
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_homogeneity', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Homogeneity</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_homogeneityTest', function(startingStep) {
	var steps = [{intro: '<h4>Homogeneity Test</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_calibrationCurve', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Calibration Curve</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_methodPrecision', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Method Precision</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_calibrationStandard', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Calibration Standard</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_samplePreparation', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Sample Preparation</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_combinedUncertainty', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Combined Uncertainty</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_coverageFactor', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Coverage Factor</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

Shiny.addCustomMessageHandler('runjs_help_expandedUncertainty', function(startingStep) {
	var steps = [{intro: '<h4>Uncertainty of Expanded Uncertainty</h4>' + embedVideoLink('q6ZrRuG3ilA')}];
	showHelp(steps, startingStep);
});

