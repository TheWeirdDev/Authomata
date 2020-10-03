module ui.welcome;
import ui.welcome_button;
import gtk.Label, gtk.Grid, gtk.Image, gtk.Button;

public final class Welcome : Grid {
private:
    Label title;
    Label subTitle;
    Grid options;

public:
    this(string t, string st) {
        title = new Label(t);
        title.setJustify(GtkJustification.CENTER);
        title.setHexpand(true);
        title.getStyleContext().addClass("app-title");

        subTitle = new Label(st);
        subTitle.setJustify(GtkJustification.CENTER);
        subTitle.setHexpand(true);
        subTitle.setLineWrap(true);
        subTitle.setLineWrapMode(PangoWrapMode.WORD);
        subTitle.getStyleContext().addClass("sub-label");

        options = new Grid();
        options.setOrientation(GtkOrientation.VERTICAL);
        options.setRowSpacing(12);
        options.setHalign(GtkAlign.CENTER);
        options.setMarginTop(24);

        setHexpand(true);
        setVexpand(true);
        //content.margin
        setOrientation(GtkOrientation.VERTICAL);
        setValign(GtkAlign.CENTER);
        add(title);
        add(subTitle);
        add(options);
    }

    void addButton(string title, string desc, Image icon, void delegate(Button) onClick) {
        auto button = new WelcomeButton(title, desc);
        button.setIcon(icon);
        options.add(button);

        button.addOnClicked(onClick);
    }

}
