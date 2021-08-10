var branch = require('io.branch.sdk');
var branchUniversalObjectProxy;

var USE_ALERT = true; // use alerts to show responses or print them otherwise

/*
 ************************************************
 * Initializers
 ************************************************
 */
$.initialize = function(params) {
    $.initializeViews();
    $.initializeHandlers();
    $.window.open();
    $.toggleButtons(false);
};

$.initializeViews = function() {
    Ti.API.info("start initializeViews");
    $.linkTextArea.editable = false;
    $.linkTextArea.value = "generated link here";
};

$.initializeHandlers = function() {
    $.initBranchButton.addEventListener('click', $.onInitBranchButtonClicked);
    $.registerViewButton.addEventListener('click', $.onRegisterViewButtonClicked);
    $.generateUrlButton.addEventListener('click', $.onGenerateUrlButtonClicked);
    $.shareSheetButton.addEventListener('click', $.onShareSheetButtonClicked);
    $.copyButton.addEventListener('click', $.onCopyButtonClicked);
    $.customEventViewButton.addEventListener('click', $.onCustomEventViewButtonClicked);
    $.standardEventViewButton.addEventListener('click', $.onStandardEventViewButtonClicked);
};

/*
 ************************************************
 * Event Handlers
 ************************************************
 */
$.onInitBranchButtonClicked = function() {
    Ti.API.info("inside onInitBranchButtonClicked");
    branchUniversalObjectProxy = branch.createBranchUniversalObject({
      "canonicalIdentifier" : "sample-id",
      "title" : "Sample",
      "contentDescription" : "This is a sample",
      "contentImageUrl" : "http://sample-host.com/media/1235904.jpg",
      "contentIndexingMode" : "private",
      "contentMetadata" : {
          "key" : "value",
          "key2" : "value2"
      },
    });

    // Branch Universal Object Listeners
    branchUniversalObjectProxy.addEventListener("bio:generateShortUrl", $.onGenerateUrlFinished);
    branchUniversalObjectProxy.addEventListener("bio:shareChannelSelected", $.onShareChannelSelected);

    if (OS_ANDROID) {
        branchUniversalObjectProxy.addEventListener("bio:shareLinkDialogLaunched", $.onShareLinkDialogLaunched);
        branchUniversalObjectProxy.addEventListener("bio:shareLinkDialogDismissed", $.onShareLinkDialogDismissed);
        branchUniversalObjectProxy.addEventListener("bio:shareLinkResponse", $.onShareLinkResponse);
    }

    $.toggleButtons(true);

    showData({"init BUO":"success"});
};

$.onRegisterViewButtonClicked = function() {
    Ti.API.info("inside onRegisterViewButtonClicked");
    branchUniversalObjectProxy.registerView();
    showData({"registerView":"success"});
};

$.onCustomEventViewButtonClicked = function() {
    Ti.API.info("inside onCustomEventViewButtonClicked");
       var eventName="Custom";
    branchUniversalObjectProxy.setBranchEvent(
    	eventName,
    	{
        "affiliation" : "sample-affiliation",
        "coupon" : "sample-coupon",
        "currency" : "USD",
        "description" : "sample-description",
        "shipping" : 10.2,
        "tax" : 8.5,
        "revenue" : 100.56,
        "transactionID" : "abc123",
        "searchQuery" : "sample-search",
        "contentMetadata" : {
          "Custom_Event_Property_Key1" : "Custom_Event_Property_val1",
          "Custom_Event_Property_Key2" : "Custom_Event_Property_val2"
      },

    });
    showData({"customEventView":"success"});
};

$.onStandardEventViewButtonClicked = function() {
    Ti.API.info("inside onStandardEventViewButtonClicked");
    var eventName="PURCHASE";
    branchUniversalObjectProxy.setBranchEvent(
    	eventName,
    	{
        "affiliation" : "sample-affiliation",
        "coupon" : "sample-coupon",
        "currency" : "USD",
        "description" : "sample-description",
        "shipping" : 10.2,
        "tax" : 8.5,
        "revenue" : 100.56,
        "transactionID" : "abc123",
        "searchQuery" : "sample-search",
        "contentMetadata" : {
          "Custom_Event_Property_Key1" : "Custom_Event_Property_val1",
          "Custom_Event_Property_Key2" : "Custom_Event_Property_val2"
      },

    });
    showData({"standardEventView":"success"});
};

$.onGenerateUrlButtonClicked = function() {
    Ti.API.info("inside onGenerateUrlButtonClicked");
    branchUniversalObjectProxy.generateShortUrl({
        "feature" : "sample-feature",
        "channel" : "sample-channel",
        "stage" : "sample-stage",
        "duration" : 1,
    }, {
        "$desktop_url" : "http://desktop_url.com",
    }, function (res) {
        Ti.API.info('Generated Short URL');
        Ti.API.info(res);
        $.linkTextArea.value = res["generatedLink"];
    });
};

$.onGenerateUrlFinished = function(data) {
    Ti.API.info("inside onGenerateUrlFinished");
    Ti.API.info("GenerateUrlFinished: " + data["generatedLink"]);
    $.linkTextArea.value = data["generatedLink"];
};

$.onShareSheetButtonClicked = function() {
    Ti.API.info("inside onShareSheetButtonClicked");
    branchUniversalObjectProxy.showShareSheet({
        "feature" : "sample-feature",
        "channel" : "sample-channel",
        "stage" : "sample-stage",
        "duration" : 1,
    }, {
        "$desktop_url" : "http://desktop-url.com",
        "$email_subject" : "This is a sample subject",
        "$email_body" : "This is a sample body",
    });


};

$.onShareLinkDialogLaunched = function(data) {
    Ti.API.info("inside onShareLinkDialogLaunched");
};

$.onShareLinkDialogDismissed = function(data) {
    Ti.API.info("inside onShareLinkDialogDismissed");
};

$.onShareLinkResponse = function(data) {
    Ti.API.info("inside onShareLinkResponse");
};

$.onShareChannelSelected = function(data) {
    Ti.API.info("inside onShareChannelSelected");
};

$.onCopyButtonClicked = function() {
    Ti.API.info("inside onCopyButtonClicked");
    Ti.UI.Clipboard.clearText();
    Ti.UI.Clipboard.setText($.linkTextArea.value);
};

/*
 ************************************************
 * Methods
 ************************************************
 */
$.toggleButtons = function(enable) {
    $.registerViewButton.enabled = enable;
    $.generateUrlButton.enabled = enable;
    $.shareSheetButton.enabled = enable;
};

function showData(data) {
    Ti.API.info("start showData");

    if (USE_ALERT) {
        var dict = {};
        for (key in data) {
            if (key != "type" && key != "source" && key != "bubbles" && key != "cancelBubble") {
                dict[key] = data[key];
            }
        }

        if (OS_ANDROID) {
            alert(JSON.stringify(dict));
        } else if (OS_IOS){
            var dialog = Ti.UI.createAlertDialog({
                title  : "Result:",
                message: "" + JSON.stringify(dict),
                buttonNames: ["OK"],
            });
            dialog.show();
        }
    } else {
        for (key in data) {
            if ((key != "type" && key != "source" && key != "bubbles" && key != "cancelBubble") && data[key] != null) {
                Ti.API.info(key + data["key"]);
            }
        }
    }
}

$.initialize();
