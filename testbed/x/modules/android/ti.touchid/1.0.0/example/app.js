

var TiTouchId = require('ti.touchid');

var win = Ti.UI.createWindow();

var btn = Ti.UI.createButton({
	title: 'authenticate'
});

win.add(btn);
win.open();

btn.addEventListener('click', function(){

	if(!TiTouchId.isSupported()) {
		alert("Touch ID is not supported on this device!");
		return;
	}
	
	TiTouchId.authenticate({
		reason: 'We need your fingerprint to continue.',
		callback: function(e) {
			if (!e.success) {
				alert('Message: ' + e.error);
				
			} else {
				alert('YAY! success');
			}
		}
	});

});
