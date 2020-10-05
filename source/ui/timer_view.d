module ui.timer_view;

import core.stdc.time;

import gtk.DrawingArea, gtk.Widget;
import cairo.Context;
import std.math;
import std.algorithm;
import std.datetime.systime;

package final class TimerView : DrawingArea {

    alias TimerCallback = void delegate();

    this() {
        super(25, 25);

        addTickCallback(cast(GtkTickCallback) function(GtkWidget*, GdkFrameClock*, Widget _widget) {
            _widget.queueDraw();
            return G_SOURCE_CONTINUE;
        }, cast(void*) this, null);

        addOnDraw((Scoped!Context context, Widget) {
            const height = this.getAllocatedHeight();
            const width = this.getAllocatedWidth();

            const xc = width / 2.0;
            const yc = height / 2.0;
            const radius = min(width, height) / 2.0;
            auto angle1 = -PI / 2.0;
            auto angle2 = -PI / 2.0;

            auto t = (Clock.currTime() - SysTime.fromUnixTime(0)).total!"msecs";
            auto percentage = t % 3_0000 / 3_00.0;

            if (percentage < 1) {
                tc();
            }

            if (percentage > 0) {
                angle1 = angle2;
                const ratio = cast(double) percentage / 100;
                angle2 = ratio * 2 * PI - PI / 2.0;
                context.moveTo(xc, yc);
                context.setSourceRgba(1, 1, 1, 1);
                context.arc(xc, yc, radius, angle1, angle2);
                context.fill();
            }

            angle1 = angle2;
            angle2 = 2 * PI - PI / 2.0;
            context.moveTo(xc, yc);
            context.setSourceRgba(0.4, 0.4, 1, 1);
            context.arc(xc, yc, radius, angle1, angle2);
            context.fill();
            return true;
        });
    }

    auto setTimerCallback(TimerCallback tcb) {
        tc = tcb;
    }

private:
    TimerCallback tc;
}
