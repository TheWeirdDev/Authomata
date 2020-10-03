module ui.account_view;

import gtk.HBox, gtk.VBox, gtk.ListBoxRow, gtk.ListBox, gtk.Frame;
import gtk.Label;

import auth.account;
import ui.timer_view;

package final class AccountView : Frame {

    this(Account acc) {
        super("");
        this.account = acc;

        setLabelWidget(null);
        setShadowType(GtkShadowType.IN);
        setMarginRight(20);
        setMarginLeft(20);

        bgbox = new ListBox();
        bgbox.setSelectionMode(SelectionMode.NONE);

        bgboxChild = new ListBoxRow();
        bgboxChild.setActivatable(false);

        vbox = new VBox(false, 0);

        name_lbl = new Label(account.name);
        name_lbl.getStyleContext().addClass("acc-name");
        name_lbl.setAlignment(0, 0);
        name_lbl.setPadding(6, 2);

        code_lbl = new Label(account.secret);
        code_lbl.getStyleContext().addClass("code-number");
        code_lbl.setAlignment(0, 0);
        code_lbl.setPadding(6, 2);

        hbox = new HBox(false, 0);
        hbox.packStart(code_lbl, true, true, 0);
        auto tmv = new TimerView();
        import std.conv : to;

        tmv.setTimerCallback({ code_lbl.setText(i++.to!string); });
        hbox.packStart(tmv, false, false, 10);

        vbox.packStart(name_lbl, false, false, 0);
        vbox.packStart(hbox, false, false, 0);

        bgboxChild.add(vbox);

        bgbox.add(bgboxChild);
        add(bgbox);
    }

private:
    int i = 0;
    Account account;
    ListBox bgbox;
    ListBoxRow bgboxChild;
    VBox vbox;
    HBox hbox;
    Label name_lbl;
    Label code_lbl;
    /* TimerView timer */
}
