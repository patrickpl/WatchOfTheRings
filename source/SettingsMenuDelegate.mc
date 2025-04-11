import Toybox.WatchUi;
import Toybox.Application.Storage; 
import Toybox.System;
import Toybox.Application.Properties;

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

  	function onSelect(item) {
  		var id=item.getId();
		if(id.equals("default")) {
			Properties.setValue("Color", "default");
		} else if(id.equals("red")) {
			Properties.setValue("Color", "red");
		} else if(id.equals("blue")) {
			Properties.setValue("Color", "blue");
		} else if(id.equals("green")) {
			Properties.setValue("Color", "green");
		} else if(id.equals("yellow")) {
			Properties.setValue("Color", "yellow");
		} else {
			Properties.setValue("Color", "default");
		}
		WatchUi.popView(WatchUi.SLIDE_BLINK);
		WatchUi.requestUpdate();
	}

  	function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}