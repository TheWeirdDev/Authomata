module ui.topbar;

import gtk.Stack, gtk.HeaderBar, gtk.Button, gtk.ToggleButton;
import gtk.Label;

import ui.window;
import utils;

package final class TopBar : Stack {
    private enum Headers : string {
        MAIN = "main_page",
        EDIT = "edit_page"
    }

    this(T1, T2)(T1 addCB, T2 editModeCB) {
        super();

        setTransitionType(GtkStackTransitionType.CROSSFADE);
        setTransitionDuration(250);

        header = new HeaderBar();
        header.setShowCloseButton(true);

        auto addBtn = new Button();
        addBtn.setImage(getImageForIcon("list-add-symbolic", GtkIconSize.BUTTON));

        addBtn.addOnClicked(addCB);
        header.packStart(addBtn);

        auto editBtn = new Button();
        editBtn.setImage(getImageForIcon("edit-symbolic", GtkIconSize.BUTTON));

        editBtn.addOnClicked((Button) {
            setVisibleChildName(Headers.EDIT);
            editModeCB(true);
        });
        header.packEnd(editBtn);

        addNamed(header, Headers.MAIN);

        editingHeader = new HeaderBar();
        editingHeader.setShowCloseButton(false);
        editingHeader.getStyleContext().addClass("selection-mode");
        editingHeader.setCustomTitle(new Label("Edit/Delete Accounts"));

        auto addBtn2 = new Button();
        addBtn2.setImage(getImageForIcon("list-add-symbolic", GtkIconSize.BUTTON));
        addBtn2.addOnClicked(addCB);
        editingHeader.packStart(addBtn2);

        auto doneBtn = new Button("Done");
        doneBtn.addOnClicked((Button) {
            setVisibleChildName(Headers.MAIN);
            editModeCB(false);
        });
        editingHeader.packEnd(doneBtn);

        addNamed(editingHeader, Headers.EDIT);
    }

    void setTitle(string title) {
        header.setTitle(title);
    }

private:
    HeaderBar header;
    HeaderBar editingHeader;
}
