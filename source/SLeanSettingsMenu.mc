import Toybox.WatchUi;

class SLeanSettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize(null);
        Menu2.setTitle("Settings");
        Menu2.addItem(new WatchUi.ToggleMenuItem("Show Seconds When Possible", null,"sec",MySettings.showSecs, null));
        //other things
    }    
}