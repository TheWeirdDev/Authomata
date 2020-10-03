module ui.window;

import gtk.ApplicationWindow, gtk.Application, gtk.Dialog, gtk.ScrolledWindow;
import gtk.HBox, gtk.VBox, gtk.HeaderBar, gtk.Image, gio.ThemedIcon;
import gtk.Button, gtk.Label, gtk.Frame, gtk.ListBox, gtk.ListBoxRow;
import gtk.Entry, gtk.EditableIF, gtk.Widget;

import ui.account_view;
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

        auto header = new HeaderBar();
        header.setShowCloseButton(true);
        header.setTitle("4 Accounts");

        auto addBtn = new Button();
        auto icon = new Image;
        icon.setFromGicon(new ThemedIcon("gtk-add"), GtkIconSize.LARGE_TOOLBAR);
        addBtn.setImage(icon);

        addCallback = (Button) {
            auto d = new Dialog("Add a new account", this, GtkDialogFlags.MODAL,
                    ["Cancel", "Add"], [
                        ResponseType.CANCEL, ResponseType.ACCEPT
                    ]);

            d.getWidgetForResponse(ResponseType.ACCEPT).setSensitive(false);
            scope (exit)
                d.destroy();

            d.setDefaultResponse(ResponseType.ACCEPT);
            d.setDefaultSize(400, -1);

            auto box = new VBox(false, 0);
            auto hbox = new HBox(false, 0);

            auto name_ent = new Entry();
            auto secret_ent = new Entry();

            const void delegate(EditableIF) cb = (EditableIF) {
                d.getWidgetForResponse(ResponseType.ACCEPT).setSensitive(name_ent.getText()
                        .length > 0 && secret_ent.getText().length > 0);
            };
            name_ent.addOnChanged(cb);
            secret_ent.addOnChanged(cb);

            auto lbl1 = new Label("The name of this account:");
            auto lbl2 = new Label("The secret code that you got:");
            lbl1.setAlignment(0, 0);
            lbl2.setAlignment(0, 0);
            lbl2.setMarginTop(10);

            box.packStart(lbl1, false, false, 5);
            box.packStart(name_ent, false, false, 0);
            box.packStart(lbl2, false, false, 5);
            box.packStart(secret_ent, false, false, 0);

            box.setMarginStart(15);
            box.setMarginEnd(15);
            secret_ent.setMarginBottom(15);
            d.getContentArea().add(box);
            d.showAll();
            const res = d.run();

            if (res == ResponseType.ACCEPT) {
                Account acc = {
                    name: name_ent.getText(), secret: secret_ent.getText()};
                    storage.addAccount(acc);
                    reloadAccountList();
                }
            };

            addBtn.addOnClicked(addCallback);
            header.add(addBtn);
            setTitlebar(header);

            contents = new VBox(false, 0);
            reloadAccountList();

            add(contents);
        }

    private:
        void reloadAccountList() {
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
                        "Add a new 2-factor authentication account", ic, addCallback);
                contents.packStart(welcome, true, true, 0);
            } else {
                auto s = new ScrolledWindow();
                auto vb = new VBox(false, 0);

                auto title = new Label("Authomata");
                title.getStyleContext().addClass("app-title");
                vb.packStart(title, false, false, 20);

                foreach (acc; storage.getAccounts())
                    vb.packStart(new AccountView(acc), false, false, 5);
                s.add(vb);
                contents.packStart(s, true, true, 0);
            }
            contents.showAll();
        }

        Storage storage;
        VBox contents;
        void delegate(Button) addCallback;
    }
