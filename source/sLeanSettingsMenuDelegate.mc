import Toybox.WatchUi;
import Toybox.Application.Storage; 

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

  	function onSelect(item) {
  		var id=item.getId();
		if(id.equals("default")) {
			Storage.setValue("Color", "default");
		} else if(id.equals("red")) {
			Storage.setValue("Color", "red");
		} else if(id.equals("blue")) {
			Storage.setValue("Color", "blue");
		} else if(id.equals("green")) {
			Storage.setValue("Color", "green");
		} else if(id.equals("yellow")) {
			Storage.setValue("Color", "yellow");
		} 
		WatchUi.popView(WatchUi.SLIDE_BLINK);
		WatchUi.requestUpdate();
	}

  	function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}