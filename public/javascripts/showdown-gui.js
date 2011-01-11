window.onload = startGui;

var converter;
var convertTextTimer,processingTime;
var lastText,lastOutput,lastRoomLeft;
var inputPane;
var slidesPane;
var maxDelay = 3000; // longest update pause (in ms)


//
//	Initialization
//
function insertAtCursor(myField, myValue) {
    //IE support
    if (document.selection) {
        myField.focus();
        sel = document.selection.createRange();
        sel.text = myValue;
    }

    //MOZILLA/NETSCAPE support
    else if (myField.selectionStart || myField.selectionStart == '0') {
        var startPos = myField.selectionStart;
        var endPos = myField.selectionEnd;
        restoreTop = myField.scrollTop;
        
        myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);
        
        myField.selectionStart = startPos + myValue.length; 
        myField.selectionEnd = startPos + myValue.length;
        
        if (restoreTop>0) {
            myField.scrollTop = restoreTop;
            }
        } else {
          myField.value += myValue;
        }
    }
function interceptTabs(evt, control) {
    key = evt.keyCode ? evt.keyCode : evt.which ? evt.which : evt.charCode;
    if (key==9) {
        insertAtCursor(control, '  ');
        evt.preventDefault();
        return false; 
        } else {
          return key;
        }
    }

function startGui() {
	// find elements

	inputPane = document.getElementById("inputPane");
	slidesBox = document.getElementById("slidesBox");

	// set event handlers
	//window.onresize = setPaneHeights;

	// First, try registering for keyup events
	// (There's no harm in calling onInput() repeatedly)
	window.onkeyup = inputPane.onkeyup = onInput;

	// In case we can't capture paste events, poll for them
	var pollingFallback = window.setInterval(function(){
		if(inputPane.value != lastText)
			onInput();
	},1000);

	// Try registering for paste events
	inputPane.onpaste = function() {
		// It worked! Cancel paste polling.
		if (pollingFallback!=undefined) {
			window.clearInterval(pollingFallback);
			pollingFallback = undefined;
		}
		onInput();
	}

	// Try registering for input events (the best solution)
	if (inputPane.addEventListener) {
		// Let's assume input also fires on paste.
		// No need to cancel our keyup handlers;
		// they're basically free.
		inputPane.addEventListener("input",inputPane.onpaste,false);
		inputPane.addEventListener("keydown", function(event) {
                  return interceptTabs(event, this);
                }, false);
	}

	// poll for changes in font size
	// this is cheap; do it often
	//window.setInterval(setPaneHeights,250);

	// start with blank page?
	if (top.document.location.href.match(/\?blank=1$/))
		inputPane.value = "";

	// refresh panes to avoid a hiccup
	//[nPaneSettingChanged();

	// build the converter
	converter = new Showdown.converter();

	// do an initial conversion to avoid a hiccup
	convertText();

	// give the input pane focus
	inputPane.focus();

	// start the other panes at the top
	// (our smart scrolling moved them to the bottom)
}


//
//	Conversion
//

var divIdx = 0;
var codeSnippets = [];

var idxFun = function() {
  return '<div id="to-pygmentize-' + (divIdx++) + '"></div>';
};

function colorizeCode(code, urlId) {
  new Ajax.Request('/backend/colorize', {
    method: 'get',
      parameters: { id : urlId, code: code },
      onSuccess: function(transport) {
        var response = transport.responseText;
        var div = document.getElementById("to-pygmentize-"+urlId);
        div.innerHTML = response;
      }
  });
};

function convertText() {
	// get input text
	var text = inputPane.value;
        //var regex = /@@@\s+[a-z]+(\n|\r\n)([^@][^@][^@]|\n|\r)+@@@(\r\n|\n|$)/gm;
        //var newCodeSnippets;

	if (text && text == lastText) {
		return;
	} else {
		lastText = text;
	}

        //newCodeSnippets = text.match(regex);
        //if (newCodeSnippets.length != codeSnippets.length) {
          //alert("inna ilość");
          //[> colorize all <]
          //var currentIdx = divIdx;
          //if ( newCodeSnippets.length != 0 ) {
            //text = text.replace(regex, idxFun);
            //for(var i=0; i< newCodeSnippets.length; ++i) {
              //var urlId = currentIdx + i;
              //colorizeCode(newCodeSnippets[i], urlId);
            //}
          //} 
        //} else {
          //for(var i = 0; i < newCodeSnippets.length; ++i) {
            //if (codeSnippets[i] != newCodeSnippets[i]) {
              //var divs = $$("div.highlight");
              //[> colorize only one snippet, but it's exists <]
              //colorizeCode(newCodeSnippets[i], divs[i].parentNode.readAttribute("id").match(/\d+/)[0]);
            //} 
          //}
          //var divs = $$('div.highlight');
          ////alert(divs.length);
          //var replaceFunction = function() {
            //var j = 0 
              //return function() {
                //var parent = divs[j++].parentNode;
                //var elId = parent.readAttribute("id");
                ////alert('<div id="' + elId + '">' + parent.innerHTML + '</div>');
                //return '<div id="' + elId + '">' + parent.innerHTML + '</div>';
              //}  
          //}
          //text = text.replace(regex, replaceFunction());
        //}
        //codeSnippets = newCodeSnippets;

	// if there's no change to input, cancel conversion

	var startTime = new Date().getTime();

	// Do the conversion
	textTab = text.split(/\s*!SLIDE\s*/);
	markdownTab = []
	for(var i=0; i<textTab.length; ++i) {
	    if (textTab[i] !== "") {
                //alert(textTab[i].match(regex).length);

                /* ajax call */
		markdownTab.push(converter.makeHtml(textTab[i]));
	    }
	}

	text = converter.makeHtml(text);

	// display processing time
	var endTime = new Date().getTime();	
	processingTime = endTime - startTime;
	//document.getElementById("processingTime").innerHTML = processingTime+" ms";

	// save proportional scroll positions
	saveScrollPositions();

	// update right pane
	//if (paneSetting.value == "outputPane") {
		// the output pane is selected
		//outputPane.value = text;
	//} else if (paneSetting.value == "previewPane") {
	    // the preview pane is selected
	    //previewPane.innerHTML = text;

	    // clear the slides box
	    slidesBox.innerHTML = '';
	    for(var i= markdownTab.length - 1; i >= 0 ; --i) {
		div = document.createElement("div");
		div.innerHTML = converter.makeHtml(markdownTab[i]);
		div.setAttribute('class', 'slide');
		slidesBox.appendChild(div);
            }

	//}

	lastOutput = text;

	// restore proportional scroll positions
	restoreScrollPositions();
};

//
//	Event handlers
//

function onInput() {
  // In "delayed" mode, we do the conversion at pauses in input.
  // The pause is equal to the last runtime, so that slow
  // updates happen less frequently.
  //
  // Use a timer to schedule updates.  Each keystroke
  // resets the timer.

  // if we already have convertText scheduled, cancel it
  if (convertTextTimer) {
    window.clearTimeout(convertTextTimer);
    convertTextTimer = undefined;
  }

  var timeUntilConvertText = 0;
  timeUntilConvertText = processingTime;

  if (timeUntilConvertText > maxDelay)
    timeUntilConvertText = maxDelay;

  // Schedule convertText().
  // Even if we're updating every keystroke, use a timer at 0.
  // This gives the browser time to handle other events.
  convertTextTimer = window.setTimeout(convertText,timeUntilConvertText);
}


//
// Smart scrollbar adjustment
//
// We need to make sure the user can't type off the bottom
// of the preview and output pages.  We'll do this by saving
// the proportional scroll positions before the update, and
// restoring them afterwards.
//

var previewScrollPos;
var outputScrollPos;

function getScrollPos(element) {
	// favor the bottom when the text first overflows the window
	if (element.scrollHeight <= element.clientHeight)
		return 1.0;
	return element.scrollTop/(element.scrollHeight-element.clientHeight);
}

function setScrollPos(element,pos) {
	element.scrollTop = (element.scrollHeight - element.clientHeight) * pos;
}

function saveScrollPositions() {
	//previewScrollPos = getScrollPos(previewPane);
	//outputScrollPos = getScrollPos(outputPane);
}

function restoreScrollPositions() {
	// hack for IE: setting scrollTop ensures scrollHeight
	// has been updated after a change in contents
	//previewPane.scrollTop = previewPane.scrollTop;

	//setScrollPos(previewPane,previewScrollPos);
	//setScrollPos(outputPane,outputScrollPos);
}

//
// Textarea resizing
//
// Some browsers (i.e. IE) refuse to set textarea
// percentage heights in standards mode. (But other units?
// No problem.  Percentage widths? No problem.)
//
// So we'll do it in javascript.  If IE's behavior ever
// changes, we should remove this crap and do 100% textarea
// heights in CSS, because it makes resizing much smoother
// on other browsers.
//

function getTop(element) {
	var sum = element.offsetTop;
	while(element = element.offsetParent)
		sum += element.offsetTop;
	return sum;
}

function getElementHeight(element) {
	var height = element.clientHeight;
	if (!height) height = element.scrollHeight;
	return height;
}

function getWindowHeight(element) {
	if (window.innerHeight)
		return window.innerHeight;
	else if (document.documentElement && document.documentElement.clientHeight)
		return document.documentElement.clientHeight;
	else if (document.body)
		return document.body.clientHeight;
}

function setPaneHeights() {
  var textarea  = inputPane;
  var footer = document.getElementById("footer");

  var windowHeight = getWindowHeight();
  //var footerHeight = getElementHeight(footer);
  var textareaTop = getTop(textarea);

  // figure out how much room the panes should fill
  var roomLeft = windowHeight - footerHeight - textareaTop;

  if (roomLeft < 0) roomLeft = 0;

  // if it hasn't changed, return
  if (roomLeft == lastRoomLeft) {
    return;
  }
  lastRoomLeft = roomLeft;

  // resize all panes
  inputPane.style.height = roomLeft + "px";
};
