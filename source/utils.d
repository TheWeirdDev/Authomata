module utils;
import std.path;
import std.file;

pragma(inline, true) {
    static string getUserHomeDir() {
        return expandTilde("~");
    }

    static string getConfigDirName() {
        return getUserHomeDir() ~ "/.config/Authomata/";
    }
}

static void createConfigDirIfNotExists() {
    auto cfgDir = getConfigDirName();
    if (!exists(cfgDir)) {
        mkdirRecurse(cfgDir);
    } else if (!isDir(cfgDir)) {
        remove(cfgDir);
        mkdirRecurse(cfgDir);
    }
}
