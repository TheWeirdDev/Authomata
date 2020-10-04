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
		win.setDefaultSize(400, 550);
		win.setSizeRequest(400, 550);
		win.addOnDelete((Event, Widget) { app.quit(); return true; });
		win.showAll();

		auto styleProvider = new CssProvider();
		styleProvider.loadFromData(`
            .app-title {
				font-weight: bold;
				font-size: 2.5rem;
			}
			.code-number {
				font-weight: bold;
				font-size: 2.5rem;
				color: lightblue;
			}
			.acc-name {
				font-weight: bold;
				font-size: 1.3rem;
			}
			.user-name {
				font-size: 1.0rem;
			}
			.title-label {
				font: 2.2rem raleway;
			}
            .sub-label {
				font-size:1.2rem;
			}
			.button-title {
				font-size:1.3rem;
			}
            .button-sub {
				font-size:1.1rem;
			}
        `);
		StyleContext.addProviderForScreen(Screen.getDefault(), styleProvider,
			STYLE_PROVIDER_PRIORITY_APPLICATION);

	});
	createConfigDirIfNotExists();
	return app.run(args);
}
