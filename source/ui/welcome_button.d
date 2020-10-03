module ui.welcome_button;

import gtk.Button, gtk.Label, gtk.Grid, gtk.Image;

public final class WelcomeButton : Button {
private:
    Label title;
    Label desc;
    Grid content;
    Image icon;
public:

    this(string title, string desc) {
        // Title label
        this.title = new Label(title);
        this.title.getStyleContext().addClass("button-title");
        this.title.setHalign(GtkAlign.START);
        this.title.setValign(GtkAlign.END);

        // Description label
        this.desc = new Label(desc);
        this.desc.setHalign(GtkAlign.START);
        this.desc.setValign(GtkAlign.START);
        this.desc.setLineWrap(true);
        this.desc.setLineWrapMode(PangoWrapMode.WORD);
        this.desc.getStyleContext().addClass("button-sub");

        getStyleContext().addClass(STYLE_CLASS_FLAT);

        // Button contents wrapper
        content = new Grid();
        content.setColumnSpacing(12);
        content.attach(this.title, 1, 0, 1, 1);
        content.attach(this.desc, 1, 1, 1, 1);
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
}
