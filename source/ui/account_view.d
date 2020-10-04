module ui.account_view;

import gtk.HBox, gtk.VBox, gtk.ListBoxRow, gtk.ListBox, gtk.Frame;
import gtk.Label, gtk.EventBox;

import std.array;

import auth.oath;
import auth.account;
import ui.timer_view;
import gtk.Clipboard, gdk.Atom;

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

        auto vbox = new VBox(false, 0);

        auto name_lbl = new Label(account.name);
        name_lbl.getStyleContext().addClass("acc-name");
        name_lbl.setAlignment(0, 0);
        name_lbl.setPadding(6, 2);

        auto hbox2 = new HBox(false, 0);
        hbox2.packStart(name_lbl, false, false, 0);

        if (account.username.length > 0) {
            auto user_lbl = new Label(account.username);
            user_lbl.getStyleContext().addClass("user-name");
            user_lbl.setMarginTop(2);
            hbox2.packStart(user_lbl, false, false, 0);
        }

        auto evb = new EventBox();
        code_lbl = new Label("");
        code_lbl.getStyleContext().addClass("code-number");
        code_lbl.setAlignment(0, 0);
        code_lbl.setPadding(6, 2);

        evb.add(code_lbl);

        evb.addOnButtonPress((GdkEventButton*, Widget) {
            const txt = code_lbl.getText().replace(" ", "");
            Clipboard.get(intern("CLIPBOARD", true)).setText(txt, cast(int) txt.length);
            return true;
        });

        auto hbox = new HBox(false, 0);
        hbox.packStart(evb, true, true, 0);
        auto tmv = new TimerView();

        tmv.setTimerCallback({ generateCode(); });
        hbox.packStart(tmv, false, false, 10);

        vbox.packStart(hbox2, false, false, 0);
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
    Label code_lbl;
}
