import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class WatchOfTheRingsApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() {
        return [new WatchOfTheRingsView()];
    }

    function getSettingsView() {
        return [new SettingsMenu(),new SettingsMenuDelegate()];
    } 

}

function getApp() as WatchOfTheRingsApp {
    return Application.getApp() as WatchOfTheRingsApp;
}