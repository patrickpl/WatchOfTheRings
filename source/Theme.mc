import Toybox.Graphics;
import Toybox.System;

class Theme {
    public static function getTheme(string) {
        switch(string) {
            case "yellow":
                return {
                    "stepsColor" => 0xF7FE72,
                    "floorsClimbedColor" => 0x8FF7A7,
                    "activityMinutesColor" => 0x51BBFE,
                    "caloriesColor" => 0xF4E76E
                };
            case "red":
                return {
                    "stepsColor" => 0x941B0C,
                    "floorsClimbedColor" => 0xBC3908,
                    "activityMinutesColor" => 0xF6AA1C,
                    "caloriesColor" => 0x621708
                };
            case "green":
                return {
                    "stepsColor" => 0x136F63,
                    "floorsClimbedColor" => 0x4CE0D2,
                    "activityMinutesColor" => 0x84CAE7,
                    "caloriesColor" => 0x22AAA1
                };
            case "blue":
                return {
                    "stepsColor" => 0x336699,
                    "floorsClimbedColor" => 0x9EE493,
                    "activityMinutesColor" => 0x86BBD8,
                    "caloriesColor" => 0xDAF7DC
                };
            default:
                return {
                    "stepsColor" => Graphics.COLOR_BLUE,
                    "caloriesColor" => Graphics.COLOR_ORANGE,
                    "activityMinutesColor" => Graphics.COLOR_YELLOW,
                    "floorsClimbedColor" => Graphics.COLOR_PURPLE
                };
        }        
    }
}