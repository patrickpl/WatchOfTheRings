import Toybox.WatchUi;

class SettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize(null);
        Menu2.setTitle("Settings");
        Menu2.addItem(new WatchUi.MenuItem("default", null,"default", null));
        Menu2.addItem(new WatchUi.MenuItem("red", null,"red", null));
        Menu2.addItem(new WatchUi.MenuItem("blue", null,"blue", null));
        Menu2.addItem(new WatchUi.MenuItem("green", null,"green", null));
        Menu2.addItem(new WatchUi.MenuItem("yellow", null,"yellow", null));
    }    
}