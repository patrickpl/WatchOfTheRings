using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Activity;
using Toybox.ActivityMonitor;

class WatchOfTheRingsView extends WatchUi.WatchFace {

    //! Constants
    const BAR_THICKNESS = 6;
    const ARC_MAX_ITERS = 300;

    //! Class vars
    var device_settings;

    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        device_settings = System.getDeviceSettings();
        setLayout(Rez.Layouts.WatchFace(dc));

        
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        var statsInfo = System.getSystemStats();
        var activityInfo = ActivityMonitor.getInfo();
        var dateInfo = Time.Gregorian.info( Time.now(), Time.FORMAT_MEDIUM );
        var font_ofst = BAR_THICKNESS - dc.getFontHeight(Graphics.FONT_TINY) + 4;
        var font_icon = WatchUi.loadResource(Rez.Fonts.font_icon);

        // Define the middle of the screen
        var x = dc.getWidth() / 2; 
        var y = dc.getHeight() / 2; 

        // Set background color
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        // Draw circles
        drawArc(dc, x, y, 173, (activityInfo.steps / activityInfo.stepGoal.toFloat()) * 2 * Math.PI, Graphics.COLOR_BLUE);
        drawArc(dc, x, y, 158, (activityInfo.floorsClimbed / activityInfo.floorsClimbedGoal.toFloat()) * 2 * Math.PI, Graphics.COLOR_PURPLE);
        drawArc(dc, x, y, 143, (activityInfo.activeMinutesWeek.total / activityInfo.activeMinutesWeekGoal.toFloat()) * 2 * Math.PI, Graphics.COLOR_YELLOW);

        // Battery indicator
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 80 + font_ofst, Graphics.FONT_XTINY, Lang.format("$1$%", [statsInfo.battery.toNumber()]), Graphics.TEXT_JUSTIFY_CENTER);

        // Time
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 60 + font_ofst, Graphics.FONT_LARGE, Lang.format("$1$:$2$", [dateInfo.hour, dateInfo.min.format("%02d")]),  Graphics.TEXT_JUSTIFY_CENTER);

        // Date
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 15 + font_ofst, Graphics.FONT_XTINY, Lang.format(dateInfo.month + " $1$, $2$", [dateInfo.day, dateInfo.day_of_week]), Graphics.TEXT_JUSTIFY_CENTER);

        // Floors climbed
        dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 90, y + 40, font_icon, "0", Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 50, y + 70 + font_ofst, Graphics.FONT_XTINY, activityInfo.floorsClimbed.toString() , Graphics.TEXT_JUSTIFY_LEFT);

        // Activity Minutes
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 90, y - 0, font_icon, "6", Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 50, y + 30 + font_ofst, Graphics.FONT_XTINY, activityInfo.activeMinutesWeek.total.toString() , Graphics.TEXT_JUSTIFY_LEFT);

        // Calories burned
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 10, y + 40, font_icon, "2", Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 50, y + 70 + font_ofst, Graphics.FONT_XTINY, activityInfo.calories.toString() , Graphics.TEXT_JUSTIFY_LEFT);

        // Steps
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 10, y - 0, font_icon, "5", Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 50, y + 30 + font_ofst, Graphics.FONT_XTINY, activityInfo.steps.toString() , Graphics.TEXT_JUSTIFY_LEFT);

        // Heart beat
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 10 , y + 80, font_icon, "3", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 10, y + 110 + font_ofst, Graphics.FONT_XTINY, getHeartRate() , Graphics.TEXT_JUSTIFY_LEFT);

        // View.onUpdate(dc);
    }

    function getHeartRate() {
        if (ActivityMonitor has :getHeartRateHistory) {
            var heartRate = Activity.getActivityInfo().currentHeartRate;
            if(heartRate==null) {
                var HRH=ActivityMonitor.getHeartRateHistory(1, true);
                var HRS=HRH.next();

                if(HRS!=null && HRS.heartRate!= ActivityMonitor.INVALID_HR_SAMPLE){
                    heartRate = HRS.heartRate;
                }
            }

            if(heartRate!=null) {
                heartRate = heartRate.toString();
            } else {
                heartRate = "--";
            }
            return heartRate;
        }
        return null;
    }

    function drawArc(dc, cent_x, cent_y, radius, theta, color) {
        dc.setColor( color, Graphics.COLOR_WHITE);

        var iters = ARC_MAX_ITERS * ( theta / ( 2 * Math.PI ) );
        var dx = 0;
        var dy = -radius;
        var ctheta = Math.cos(theta/(iters - 1));
        var stheta = Math.sin(theta/(iters - 1));

        dc.fillCircle(cent_x + dx, cent_y + dy, BAR_THICKNESS);

        for(var i=1; i < iters; ++i) {
            var dxtemp = ctheta * dx - stheta * dy;
            dy = stheta * dx + ctheta * dy;
            dx = dxtemp;
            dc.fillCircle(cent_x + dx, cent_y + dy, BAR_THICKNESS);
        }
    }

    function onEnterSleep( ) {
    }

    function onExitSleep( ) {
    }
}