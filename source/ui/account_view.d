module ui.account_view;

import gtk.HBox, gtk.VBox, gtk.ListBoxRow, gtk.ListBox, gtk.Frame;
import gtk.Label;

import auth.oath;
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

        tmv.setTimerCallback({ generateCode(); });
        hbox.packStart(tmv, false, false, 10);

        vbox.packStart(name_lbl, false, false, 0);
        vbox.packStart(hbox, false, false, 0);

        bgboxChild.add(vbox);

        bgbox.add(bgboxChild);
        generateCode();
        add(bgbox);
    }

private:
    void generateCode() {
        import std.conv : to;

        char[7] buff;
        const char[] secret = account.secret;
        char[50] b;
        char* bb = &b[0];
        size_t s;
        oath_base32_decode(secret.ptr, secret.length, &bb, &s);

        import core.stdc.time;

        oath_totp_generate(bb, s, time(null), 30, 0, 6, buff.ptr);
        auto code = buff.to!string;
        code_lbl.setText(code[0 .. 3] ~ " " ~ code[3 .. $]);
    }

    Account account;
    ListBox bgbox;
    ListBoxRow bgboxChild;
    VBox vbox;
    HBox hbox;
    Label name_lbl;
    Label code_lbl;
}
