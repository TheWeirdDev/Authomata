module ui.window;

import gtk.ApplicationWindow, gtk.Application, gtk.Dialog, gtk.ScrolledWindow;
import gtk.HBox, gtk.VBox, gtk.HeaderBar, gtk.Image, gio.ThemedIcon, gtk.Widget;
import gtk.Button, gtk.Label, gtk.Frame, gtk.ListBox, gtk.ListBoxRow;

import ui.account_view, ui.topbar;
import ui.welcome, ui.editor_dialog;
import auth.account;
import auth.storage;

public final class Window : ApplicationWindow {

    this(Application app) {
        super(app);
        createUI();
    }

    import std.stdio;

    void createUI() {
        storage = new Storage();
        topbar = new TopBar(&onAddClicked, (bool isEditing) {
            import std.algorithm : each;

            editMode = isEditing;
            accViews.each!(a => a.setEditMode(isEditing));
        });
        setTitlebar(topbar);
        contents = new VBox(false, 0);
        reloadAccountList();

        add(contents);
    }

private:
    void onAccountEdited(ref Account oldAcc, ref Account newAcc) {
        storage.editAccount(oldAcc, newAcc);
        reloadAccountList();
    }

    void onAccountDeleted(ref Account acc) {
        storage.removeAccount(acc);
        reloadAccountList();
    }

    void onAddClicked(Button b) {
        auto ed = new EditorDialog(this);
        Account acc;

        if (ed.run(acc)) {
            storage.addAccount(acc);
            reloadAccountList();
        }
    }

    void reloadAccountList() {
        import std.conv : to;

        topbar.setTitle(storage.countAccounts().to!string ~ " Accounts");

        foreach (ref av; accViews) {
            av.removeSelf();
            av.destroy();
        }

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

            auto accEditCB = (Account oldAcc, Account newAcc) {
                onAccountEdited(oldAcc, newAcc);
            };
            auto accDeleteCB = (Account acc) { onAccountDeleted(acc); };

            foreach (acc; storage.getAccounts()) { // Add them to a list and remove callbacks
                auto av = new AccountView(acc, accEditCB, accDeleteCB);
                av.setEditMode(editMode);
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
    bool editMode = false;
}
