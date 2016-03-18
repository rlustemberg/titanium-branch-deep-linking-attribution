require('ti-mocha');

function doClick(e) {
    alert($.label.text);
}

// run tests after window opens to ensure UI is initialized
$.index.addEventListener('open', function() {
    require('test/app_test')();
});

// show the UI
$.index.open();
