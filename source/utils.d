module utils;
import std.path;
import std.file;

import gtk.Image;

pragma(inline, true) static {
    auto getUserHomeDir() {
        return expandTilde("~");
    }

    auto getConfigDirName() {
        return getUserHomeDir() ~ "/.config/Authomata/";
    }
}

static auto createConfigDirIfNotExists() {
    auto cfgDir = getConfigDirName();
    if (!exists(cfgDir)) {
        mkdirRecurse(cfgDir);
    } else if (!isDir(cfgDir)) {
        remove(cfgDir);
        mkdirRecurse(cfgDir);
    }
}

static auto getImageForIcon(string name, GtkIconSize size) {
    auto icon = new Image();
    icon.setFromIconName(name, size);
    return icon;
}

public enum CSS_STYLES = `
.app-title {
	font-weight: bold;
	font-size: 2.5rem;
}
.code-number {
	font-weight: bold;
	font-size: 2.5rem;
	color: rgb(80, 216, 230);
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
.no-padding-btn {
	padding: 0;
}
.button-sub {
	font-size:1.1rem;
}
`;
