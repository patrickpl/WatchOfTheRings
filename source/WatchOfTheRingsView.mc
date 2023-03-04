using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as ActM;

class WatchOfTheRingsView extends Ui.WatchFace {

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
        device_settings = Sys.getDeviceSettings();
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
        var font_ofst = BAR_THICKNESS - dc.getFontHeight(Gfx.FONT_TINY) + 4;
        var font_icon = WatchUi.loadResource(Rez.Fonts.font_icon);

        // Define the middle of the screen
        var x = dc.getWidth() / 2; 
        var y = dc.getHeight() / 2; 

        // Set background color
        dc.clear();
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        // Draw circles
        drawArc(dc, x, y, 173, (activityInfo.steps / activityInfo.stepGoal.toFloat()) * 2 * Math.PI, Gfx.COLOR_BLUE);
        drawArc(dc, x, y, 158, (activityInfo.floorsClimbed / activityInfo.floorsClimbedGoal.toFloat()) * 2 * Math.PI, Gfx.COLOR_PURPLE);
        drawArc(dc, x, y, 143, (activityInfo.activeMinutesWeek.total / activityInfo.activeMinutesWeekGoal.toFloat()) * 2 * Math.PI, Gfx.COLOR_YELLOW);

        // Battery indicator
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y - 80 + font_ofst, Gfx.FONT_XTINY, Lang.format("$1$%", [statsInfo.battery.toNumber()]), Gfx.TEXT_JUSTIFY_CENTER);

        // Time
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y - 60 + font_ofst, Gfx.FONT_LARGE, Lang.format("$1$:$2$", [dateInfo.hour, dateInfo.min.format("%02d")]),  Gfx.TEXT_JUSTIFY_CENTER);

        // Date
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y - 15 + font_ofst, Gfx.FONT_XTINY, Lang.format(dateInfo.month + " $1$, $2$", [dateInfo.day, dateInfo.day_of_week]), Gfx.TEXT_JUSTIFY_CENTER);

        // Floors climbed
        dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x - 90, y + 40, font_icon, "0", Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x - 50, y + 70 + font_ofst, Gfx.FONT_XTINY, activityInfo.floorsClimbed.toString() , Gfx.TEXT_JUSTIFY_LEFT);

        // Activity Minutes
        dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x - 90, y - 0, font_icon, "6", Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x - 50, y + 30 + font_ofst, Gfx.FONT_XTINY, activityInfo.activeMinutesWeek.total.toString() , Gfx.TEXT_JUSTIFY_LEFT);

        // Calories burned
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x + 10, y + 40, font_icon, "2", Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x + 50, y + 70 + font_ofst, Gfx.FONT_XTINY, activityInfo.calories.toString() , Gfx.TEXT_JUSTIFY_LEFT);

        // Steps
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x + 10, y - 0, font_icon, "5", Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x + 50, y + 30 + font_ofst, Gfx.FONT_XTINY, activityInfo.steps.toString() , Gfx.TEXT_JUSTIFY_LEFT);

        // Heart beat
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x - 10 , y + 80, font_icon, "3", Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x + 10, y + 110 + font_ofst, Gfx.FONT_XTINY, getHeartRate() , Gfx.TEXT_JUSTIFY_LEFT);

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
        dc.setColor( color, Gfx.COLOR_WHITE);

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