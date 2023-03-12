import Toybox.WatchUi;
import Toybox.Lang;

class CustomArc extends WatchUi.Drawable {
    //! Constants
    const BAR_THICKNESS = 6;
    const ARC_MAX_ITERS = 300;

    //! Class vars
    public var xMid, yMid, radius, completion, color;

    function draw(dc) as Void {
        dc.setColor( color, Graphics.COLOR_WHITE);

        var xMid = dc.getWidth() / 2;
        var yMid = dc.getHeight() / 2;

        var iters = ARC_MAX_ITERS * ( completion / ( 2 * Math.PI ) );
        var dx = 0;
        var dy = -radius;
        var ctheta = Math.cos(completion/(iters - 1));
        var stheta = Math.sin(completion/(iters - 1));

        dc.fillCircle(xMid + dx, yMid + dy, BAR_THICKNESS);

        for(var i=1; i < iters; ++i) {
            var dxtemp = ctheta * dx - stheta * dy;
            dy = stheta * dx + ctheta * dy;
            dx = dxtemp;
            dc.fillCircle(xMid + dx, yMid + dy, BAR_THICKNESS);
        }
    }

    public function initialize (params) {
        Drawable.initialize(params);

        radius = params.get(:radius);
        completion = params.get(:completion) * 2 * Math.PI;
        color = params.get(:color);
    }

    public function setPercentageOfCompletion (p) {
        completion = p;
    }
}