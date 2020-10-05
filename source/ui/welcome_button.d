module ui.welcome_button;

import gtk.Button, gtk.Label, gtk.Grid, gtk.Image;

public final class WelcomeButton : Button {

    this(string title, string desc) {
        // Title label
        auto title_lbl = new Label(title);
        title_lbl.getStyleContext().addClass("button-title");
        title_lbl.setHalign(GtkAlign.START);
        title_lbl.setValign(GtkAlign.END);

        // Description label
        auto desc_lbl = new Label(desc);
        desc_lbl.setHalign(GtkAlign.START);
        desc_lbl.setValign(GtkAlign.START);
        desc_lbl.setLineWrap(true);
        desc_lbl.setLineWrapMode(PangoWrapMode.WORD);
        desc_lbl.getStyleContext().addClass("button-sub");

        getStyleContext().addClass(STYLE_CLASS_FLAT);

        // Button contents wrapper
        content = new Grid();
        content.setColumnSpacing(12);
        content.attach(title_lbl, 1, 0, 1, 1);
        content.attach(desc_lbl, 1, 1, 1, 1);
        content.setMarginBottom(5);
        content.setMarginTop(5);
        content.setMarginLeft(5);
        content.setMarginRight(5);
        this.add(content);
    }

    void setIcon(Image i) {
        if (icon !is null) {
            icon.destroy();
        }
        icon = i;
        if (icon !is null) {
            icon.setPixelSize(48);
            icon.setHalign(GtkAlign.CENTER);
            icon.setValign(GtkAlign.CENTER);
            content.attach(icon, 0, 0, 1, 2);
        }
    }

private:
    Grid content;
    Image icon;
}
