using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Activity;
using Toybox.ActivityMonitor;

class WatchOfTheRingsView extends WatchUi.WatchFace {

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

        // Set background color
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        var batteryValue = View.findDrawableById("BatteryValue") as WatchUi.Text;
        batteryValue.setText(Lang.format("$1$%", [statsInfo.battery.toNumber()]));

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

        var floorsClimbedValue = View.findDrawableById("FloorsClimbedValue") as WatchUi.Text;
        floorsClimbedValue.setText(activityInfo.floorsClimbed.toString());

        var heartrateValue = View.findDrawableById("HeartrateValue") as WatchUi.Text;
        heartrateValue.setText(getHeartRate());

        var ringSteps = View.findDrawableById("RingSteps") as CustomArc;
        ringSteps.setPercentageOfCompletion(activityInfo.steps / activityInfo.stepGoal.toFloat());
        
        var ringFloorsClimbed = View.findDrawableById("RingFloorsClimbed") as CustomArc;
        ringFloorsClimbed.setPercentageOfCompletion(activityInfo.floorsClimbed / activityInfo.floorsClimbedGoal.toFloat());

        var ringActiveMinutesWeek = View.findDrawableById("RingActivityMinutesWeek") as CustomArc;
        ringActiveMinutesWeek.setPercentageOfCompletion(activityInfo.activeMinutesWeek.total / activityInfo.activeMinutesWeekGoal.toFloat());

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

    function onEnterSleep( ) {
    }

    function onExitSleep( ) {
    }
}