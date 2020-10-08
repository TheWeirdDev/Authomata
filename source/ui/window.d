module ui.window;

import gtk.ApplicationWindow, gtk.Application, gtk.Dialog, gtk.ScrolledWindow;
import gtk.HBox, gtk.VBox, gtk.HeaderBar, gtk.Image, gio.ThemedIcon;
import gtk.Button, gtk.Label, gtk.Frame, gtk.ListBox, gtk.ListBoxRow;
import gtk.Entry, gtk.EditableIF, gtk.Widget;

import ui.account_view, ui.topbar;
import ui.welcome;
import auth.account;
import auth.storage;

public final class Window : ApplicationWindow {

    this(Application app) {
        super(app);
        createUI();
    }

    void createUI() {
        storage = new Storage();
        topbar = new TopBar(&onAddClicked, (bool isEditing) {
            import std.algorithm;

            accViews.each!(a => a.setEditMode(isEditing));
        });
        setTitlebar(topbar);
        contents = new VBox(false, 0);
        reloadAccountList();

        add(contents);
    }

private:

    void onAddClicked(Button b) {
        auto d = new Dialog("Add a new account", this, GtkDialogFlags.MODAL,
                ["Cancel", "Add"], [ResponseType.CANCEL, ResponseType.ACCEPT]);

        with (d.getWidgetForResponse(ResponseType.ACCEPT)) {
            setSensitive(false);
            setCanDefault(true);
            grabDefault();
        }

        scope (exit)
            d.destroy();

        d.setDefaultResponse(ResponseType.ACCEPT);
        d.setDefaultSize(400, -1);

        auto box = new VBox(false, 0);
        auto hbox = new HBox(false, 0);

        auto name_ent = new Entry();
        auto secret_ent = new Entry();
        auto username_ent = new Entry("@");

        static foreach (ent; [
                name_ent.stringof, secret_ent.stringof, username_ent.stringof
            ]) {
            mixin(ent ~ ".setActivatesDefault(true);");
        }
        void delegate(EditableIF) cb = (EditableIF) {
            d.getWidgetForResponse(ResponseType.ACCEPT).setSensitive(name_ent.getText()
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
        d.getContentArea().add(box);
        d.showAll();
        const res = d.run();

        if (res == ResponseType.ACCEPT) {
            const user = username_ent.getText();
            const username = user == "@" ? "" : user;
            storage.addAccount(Account(name_ent.getText(), secret_ent.getText(), username));
            reloadAccountList();
        }
    }

    void reloadAccountList() {
        import std.conv : to;

        // header.setTitle(storage.countAccounts().to!string ~ " Accounts");
        if (auto t = contents.getChildren()) {
            foreach (ref w; t.toArray!Widget()) {
                contents.remove(w);
                w.destroy();
            }
        }
        if (storage.countAccounts() == 0) {
            auto welcome = new Welcome("Authomata",
                    "You currently don't have any accounts. Use the button below to add the first one");
            auto ic = new Image();
            ic.setFromIconName("gtk-add", GtkIconSize.LARGE_TOOLBAR);
            welcome.addButton("Add an account",
                    "Add a new 2-factor authentication account", ic, &onAddClicked);
            contents.packStart(welcome, true, true, 0);
        } else {
            auto s = new ScrolledWindow();
            auto vb = new VBox(false, 0);

            auto title = new Label("Authomata");
            title.getStyleContext().addClass("app-title");
            vb.packStart(title, false, false, 20);

            foreach (acc; storage.getAccounts()) { // Add them to a list and remove callbacks
                auto av = new AccountView(acc);
                accViews ~= av;
                vb.packStart(av, false, false, 5);
            }
            vb.packStart(new Label("Click on any code to copy it to the clipboard"),
                    false, false, 5);
            s.add(vb);
            contents.packStart(s, true, true, 0);

        }
        contents.showAll();
    }

    AccountView[] accViews;
    Storage storage;
    VBox contents;
    TopBar topbar;
}
