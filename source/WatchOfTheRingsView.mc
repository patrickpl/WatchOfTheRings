using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Application.Storage;

class WatchOfTheRingsView extends WatchUi.View {

    var device_settings;

    function initialize() {
        View.initialize();
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

        // Set background color
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // only for debugging
        System.println("Color: " + Storage.getValue("Color"));
        if (Storage.getValue("Color")) {
            dc.clear();
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        }




        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        var batteryValue = View.findDrawableById("BatteryValue") as WatchUi.Text;
        batteryValue.setText(Lang.format("$1$%", [statsInfo.battery.toNumber()]));
        batteryValue.setColor(Graphics.COLOR_WHITE);

        var timeValue = View.findDrawableById("TimeValue") as WatchUi.Text;
        timeValue.setText(getFortmatedTime());

        var dateValue = View.findDrawableById("DateValue") as WatchUi.Text;
        dateValue.setText(Lang.format(dateInfo.month + " $1$, $2$", [dateInfo.day, dateInfo.day_of_week]));

        var stepsValue = View.findDrawableById("StepsValue") as WatchUi.Text;
        stepsValue.setText(activityInfo.steps.toString());

        var caloriesBurnedValue = View.findDrawableById("CaloriesBurnedValue") as WatchUi.Text;
        caloriesBurnedValue.setText(activityInfo.calories.toString());

        var activityMinutesWeekValue = View.findDrawableById("ActivityMinutesWeekValue") as WatchUi.Text;
        activityMinutesWeekValue.setText(activityInfo.activeMinutesWeek.total.toString());

        // Floors climbed value is optional due to sensor availability
        var floorsClimbedValue = View.findDrawableById("FloorsClimbedValue") as WatchUi.Text;
        if (floorsClimbedValue != null) {
            floorsClimbedValue.setText(activityInfo.floorsClimbed.toString());
        }
        
        // Heart rate value is optional due to screen size limitations on some devices
        var heartrateValue = View.findDrawableById("HeartrateValue") as WatchUi.Text;
        if (heartrateValue != null) {
            heartrateValue.setText(getHeartRate());
        }

        var ringSteps = View.findDrawableById("RingSteps") as CustomArc;
        ringSteps.setPercentageOfCompletion(activityInfo.steps / activityInfo.stepGoal.toFloat());

        // Floors climbed value is optional due to sensor availability        
        var ringFloorsClimbed = View.findDrawableById("RingFloorsClimbed") as CustomArc;
        if (ringFloorsClimbed != null) {
            ringFloorsClimbed.setPercentageOfCompletion(activityInfo.floorsClimbed / activityInfo.floorsClimbedGoal.toFloat());
        }

        var ringActiveMinutesWeek = View.findDrawableById("RingActivityMinutesWeek") as CustomArc;
        ringActiveMinutesWeek.setPercentageOfCompletion(activityInfo.activeMinutesWeek.total / activityInfo.activeMinutesWeekGoal.toFloat());

        setThemeColors(dc);
        View.onUpdate(dc);
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

    function getFortmatedTime() {
        var time = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var deviceSettings = System.getDeviceSettings();
        var is24Hour = deviceSettings.is24Hour;
        var hour = time.hour;
        var pmString = "";

        if (!is24Hour) {
            hour = 1 + ( (time.hour + 11) % 12 );
            pmString = time.hour >= 12 ? "PM" : "AM";
        }

        return Lang.format("$1$:$2$ $3$", [hour, time.min.format("%02d"), pmString]);
    }

    function setThemeColors(dc) {
        var color = Storage.getValue("Color");
        var theme = Theme.getTheme(color);

        var stepsIcon = View.findDrawableById("StepsIcon") as WatchUi.Text;
        var caloriesBurnedIcon = View.findDrawableById("CaloriesBurnedIcon") as WatchUi.Text;
        var floorsClimbedIcon = View.findDrawableById("FloorsClimbedIcon") as WatchUi.Text;
        var activityMinutesWeekIcon = View.findDrawableById("ActivityMinutesWeekIcon") as WatchUi.Text;
        var ringSteps = View.findDrawableById("RingSteps") as CustomArc;
        var ringFloorsClimbed = View.findDrawableById("RingFloorsClimbed") as CustomArc;
        var ringActiveMinutesWeek = View.findDrawableById("RingActivityMinutesWeek") as CustomArc;

        stepsIcon.setColor(theme.get("stepsColor"));

        caloriesBurnedIcon.setColor(theme.get("caloriesColor"));
        ringSteps.setColor(theme.get("stepsColor"));

        floorsClimbedIcon.setColor(theme.get("floorsClimbedColor"));
        ringFloorsClimbed.setColor(theme.get("floorsClimbedColor"));

        activityMinutesWeekIcon.setColor(theme.get("activityMinutesColor"));
        ringActiveMinutesWeek.setColor(theme.get("activityMinutesColor"));
    }

    function onEnterSleep( ) {
    }

    function onExitSleep( ) {
    }
}