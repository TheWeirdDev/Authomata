module utils;
import std.path;
import std.file;

pragma(inline, true) {
    static auto getUserHomeDir() {
        return expandTilde("~");
    }

    static auto getConfigDirName() {
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
