module ui.editor_dialog;

import gtk.Entry, gtk.EditableIF, gtk.Dialog, gtk.Label;
import gtk.HBox, gtk.VBox, gtk.Window;

import auth.account;

private enum DEFAULT_USERNAME = "@";

package final class EditorDialog : Dialog {

    this(Window parent) {
        super("Add a new account", parent, GtkDialogFlags.MODAL, [
                "Cancel", "Add"
                ], [ResponseType.CANCEL, ResponseType.ACCEPT]);

        with (getWidgetForResponse(ResponseType.ACCEPT)) {
            setSensitive(false);
            setCanDefault(true);
            grabDefault();
        }

        setDefaultResponse(ResponseType.ACCEPT);
        setDefaultSize(400, -1);

        auto box = new VBox(false, 0);
        auto hbox = new HBox(false, 0);

        name_ent = new Entry();
        secret_ent = new Entry();
        username_ent = new Entry(DEFAULT_USERNAME);

        static foreach (ent; [
                name_ent.stringof, secret_ent.stringof, username_ent.stringof
            ]) {
            mixin(ent ~ ".setActivatesDefault(true);");
        }
        void delegate(EditableIF) cb = (EditableIF) {
            getWidgetForResponse(ResponseType.ACCEPT).setSensitive(name_ent.getText()
                    .length > 0 && secret_ent.getText().length > 0);
        };
        name_ent.addOnChanged(cb);
        secret_ent.addOnChanged(cb);

        auto lbl1 = new Label("The name of this account:");
        auto lbl2 = new Label("The secret code that you got:");
        auto lbl3 = new Label("Your username (optional):");
        lbl1.setAlignment(0, 0);
        lbl2.setAlignment(0, 0);
        lbl3.setAlignment(0, 0);
        lbl2.setMarginTop(10);
        lbl3.setMarginTop(10);

        enum DISABLED_OP = 0.6, ENABLED_OP = 1;
        username_ent.setOpacity(DISABLED_OP);
        lbl3.setOpacity(DISABLED_OP);
        username_ent.addOnChanged((EditableIF) {
            const txt = username_ent.getText();
            if (txt != "@" && txt.length > 0) {
                username_ent.setOpacity(ENABLED_OP);
                lbl3.setOpacity(ENABLED_OP);
            } else {
                username_ent.setOpacity(DISABLED_OP);
                lbl3.setOpacity(DISABLED_OP);
            }
        });

        box.packStart(lbl1, false, false, 5);
        box.packStart(name_ent, false, false, 0);
        box.packStart(lbl2, false, false, 5);
        box.packStart(secret_ent, false, false, 0);
        box.packStart(lbl3, false, false, 5);
        box.packStart(username_ent, false, false, 0);

        box.setMarginStart(15);
        box.setMarginEnd(15);
        username_ent.setMarginBottom(15);
        getContentArea().add(box);
    }

    void setAccount(ref Account acc) {
        name_ent.setText(acc.name);
        secret_ent.setText(acc.secret);
        username_ent.setText(acc.username);
    }

    bool run(out Account acc) {
        showAll();
        const res = super.run();
        close();

        if (res == ResponseType.ACCEPT) {
            const user = username_ent.getText();
            const username = user == DEFAULT_USERNAME ? "" : user;
            acc = Account(name_ent.getText(), secret_ent.getText(), username);
            return true;
        }
        return false;
    }

private:
    Entry name_ent;
    Entry secret_ent;
    Entry username_ent;
}
