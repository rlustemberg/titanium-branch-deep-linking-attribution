// An Example app to show usage of the Crittercism APIs
// this does not currently contain best practices for
// Crittercism in conjunction with Titanium
// 
// Updated 10-10-2014

var ANDROID = Ti.Platform.osname === "android";
Ti.API.info("Ti App: importing Crittercism...");
var crittercism = require("com.appcelerator.apm");
Ti.API.info("module is => " + crittercism + "\n");
var serviceReady = false;

// create window
var win = Titanium.UI.createWindow({
    backgroundColor: 'white',
    title: 'Test Window'
});

var critConfig = {
    "notificationTitle": "Crittertastic Title",
    "shouldCollectLogcat": true
};

if (ANDROID) {
    Ti.API.info("customVersionName");
    critConfig.customVersionName = '2.2.2';
}

var CRITTERCISM_APP_ID = '<Crittercism_App_ID>';

if (CRITTERCISM_APP_ID === '<Crittercism_App_ID>') {
    alert("Please change the crittercism app id");
}

function onServiceReady() {
    Ti.API.info("Service Ready");

    serviceReady = true;
    //didCrashOnLastAppLoad
    Ti.API.info('didCrashOnLastAppLoad: ' + crittercism.didCrashOnLastAppLoad());
    alert('didCrashOnLastAppLoad: ' + crittercism.didCrashOnLastAppLoad());
}

if (ANDROID) {    
    // On android `serviceready` must be called before calling some methods. 
    // See documentation for details.
    crittercism.addEventListener('serviceready', onServiceReady);
}

crittercism.init(CRITTERCISM_APP_ID, critConfig);
Ti.API.info("Crittercism initialised");

if (!ANDROID) {
    onServiceReady();
}

var titleLoc = 30;
var loc = 70;

if (ANDROID) {
    titleLoc = 10;
    loc = 50;
}

var titleLabel = Ti.UI.createLabel({
  color: '#900',
  font: { fontSize:44 },
  shadowColor: '#aaa',
  shadowOffset: {x:5, y:5},
  shadowRadius: 3,
  text: 'Crittertastic Test',
  textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
  top: 30,
  width: Ti.UI.SIZE, height: Ti.UI.SIZE
});

win.add(titleLabel);


function createTestButton(title,eventListener) {
    loc+=40;
    var buttonProperties = {};
    if(typeof title == 'object') {
        buttonProperties = title;
    } else {
        buttonProperties.title = title;
    }
    buttonProperties.top = loc;
    buttonProperties.color = "#900";
    var button = Titanium.UI.createButton(buttonProperties);
    button.addEventListener('click', eventListener);
    return button;
}

win.add(createTestButton('leaveBreadcrumb',function(){
    var breadcrumb = "App // someMethod // finishedProcess";
    Ti.API.info('leaveBreadcrumb: '+breadcrumb);
    alert('leaveBreadcrumb: '+breadcrumb);
    crittercism.leaveBreadcrumb(breadcrumb);
}));

win.add(createTestButton('setUsername',function(){
    var username = "TheCritter";
    Ti.API.info('setUsername: '+username);
    alert('setUsername: '+username);
    crittercism.setUsername(username);
}));

win.add(createTestButton('setMetadata',function(){
    var metadata = {
        gameLevel:'5',
        playerID: '9491824'
    };
    for (var key in metadata) {
        Ti.API.info('setMetadata: ['+key+':'+metadata[key]+']');
        alert('setMetadata: ['+key+':'+metadata[key]+']');
        crittercism.setMetadata(key, metadata[key]);
    }
}));

win.add(createTestButton('logHandledException',function(){
    try {
        var err = new Error("My Awesome Caught Error!");
        throw err;
    } catch (err){
        Ti.API.info('logHandledException: ' + err);
        crittercism.logHandledException({
            name: err.name,
            message: err.message,
            line:err.lineNumber
        });
    }
}));

win.add(createTestButton('setOptOutStatus',function(e){
    if (!serviceReady) {
        alert('Service not ready');
        return;
    }
    var optOutStatus = !crittercism.getOptOutStatus();
    Ti.API.info('setOptOutStatus: ' + optOutStatus);
    alert('setOptOutStatus: ' + optOutStatus);
    crittercism.setOptOutStatus(optOutStatus);
}));

win.add(createTestButton('Crash App',function(e){
    if (ANDROID) { 
        var a = new Array(0x100000000);
        var array = new Array();
        win.add(array[0]); // this gets caught because the object is undefined and not a proxy  // throw a custom exception
    } else {
        crittercism.crashTheApp();
    }
}));

win.add(createTestButton('didCrashOnLastAppLoad',function(e){
    if (!serviceReady) {
        alert('Service not ready');
        return;
    }
    Ti.API.info('didCrashOnLastAppLoad: ' + crittercism.didCrashOnLastAppLoad());
    alert('didCrashOnLastAppLoad: ' + crittercism.didCrashOnLastAppLoad());
}));

if (ANDROID) {
    win.add(createTestButton('getNotificationTitle',function(e){
        Ti.API.info('getNotificationTitle: ' + crittercism.getNotificationTitle());
        alert('getNotificationTitle: ' + crittercism.getNotificationTitle());
    }));
}


win.add(createTestButton('getUUID',function(e){
    if (!serviceReady) {
        alert('Service not ready');
        return;
    }
    Ti.API.info('getUUID: ' + crittercism.getUUID());
    alert('getUUID: ' + crittercism.getUUID());
}));

win.open();
