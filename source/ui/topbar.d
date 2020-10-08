module ui.topbar;

import gtk.Stack, gtk.HeaderBar, gtk.Button, gtk.ToggleButton;
import gtk.Image, gio.ThemedIcon;
import ui.window;

package final class TopBar : Stack {
    private enum Headers : string {
        MAIN = "main_page",
        EDIT = "edit_page"
    }

    this(CBType, CBEType)(CBType addCallback, CBEType editCallback) {
        super();

        setTransitionType(GtkStackTransitionType.CROSSFADE);
        setTransitionDuration(200);

        header = new HeaderBar();
        header.setShowCloseButton(true);

        auto addBtn = new Button();
        auto icon = new Image;
        icon.setFromGicon(new ThemedIcon("list-add-symbolic"), GtkIconSize.BUTTON);
        addBtn.setImage(icon);

        addBtn.addOnClicked(addCallback);
        header.packStart(addBtn);

        auto editBtn = new Button();
        auto iconx = new Image;
        iconx.setFromGicon(new ThemedIcon("edit-symbolic"), GtkIconSize.BUTTON);
        editBtn.setImage(iconx);

        editBtn.addOnClicked((Button) {
            setVisibleChildName(Headers.EDIT);
            editCallback(true);
        });
        header.packEnd(editBtn);

        addNamed(header, Headers.MAIN);

        editingHeader = new HeaderBar();
        editingHeader.setShowCloseButton(false);
        editingHeader.getStyleContext().addClass("selection-mode");

        auto addBtn2 = new Button();
        auto icon2 = new Image;
        icon2.setFromGicon(new ThemedIcon("list-add-symbolic"), GtkIconSize.BUTTON);
        addBtn2.setImage(icon2);
        addBtn2.addOnClicked(addCallback);
        editingHeader.packStart(addBtn2);

        auto doneBtn = new Button("Done");
        doneBtn.addOnClicked((Button) {
            setVisibleChildName(Headers.MAIN);
            editCallback(false);
        });
        editingHeader.packEnd(doneBtn);

        addNamed(editingHeader, Headers.EDIT);

    }

private:
    HeaderBar header;
    HeaderBar editingHeader;
}
