import std.stdio;
import std.string;
import core.stdc.time;

import gtk.Application;
import gtk.ApplicationWindow;
import gtk.CssProvider;
import gtk.StyleContext;
import gdk.Screen;

import ui.window;
import utils;

int main(string[] args) {
	Window win;
	auto app = new Application("com.theweirddev.authomata", GApplicationFlags.FLAGS_NONE);
	app.addOnActivate((Application) {

		win = new Window(app);
		win.setDefaultSize(400, 600);
		win.setSizeRequest(400, 600);
		win.addOnDelete((Event, Widget) { app.quit(); return true; });
		win.showAll();
		auto styleProvider = new CssProvider();
		styleProvider.loadFromData(utils.CSS_STYLES);
		StyleContext.addProviderForScreen(Screen.getDefault(), styleProvider,
			STYLE_PROVIDER_PRIORITY_APPLICATION);
	});
	createConfigDirIfNotExists();
	return app.run(args);
}
