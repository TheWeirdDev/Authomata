module auth.storage;

import std.json;
import std.file;
import std.exception;

import auth.account;
import utils;
import std.stdio;

public final class Storage {
    // TODO: try-catch
    this() {
        configName = getConfigDirName() ~ "/config.json";
        readAccounts();
    }

    ~this() {
        writeAccounts();
    }

    size_t countAccounts() {
        return accounts.length;
    }

    void readAccounts() {
        if (exists(configName)) {
            auto txt = readText(configName);
            auto j = parseJSON(txt);
            if (j.type() != JSONType.ARRAY) {
                import std.stdio : stderr;

                stderr.writeln("Malformed config file");
                return;
            }
        loop_items:
            foreach (item; j.array) {
                Account acc;

                static foreach (key; ["name", "secret", "username"]) {
                    if (auto found = key in item) {
                        mixin("acc." ~ key ~ " = found.str();");
                    } else {
                        continue loop_items;
                    }
                }
                accounts ~= acc;
            }
        }
    }

    void writeAccounts() {
        auto list = JSONValue(new JSONValue[](0));
        foreach (acc; accounts) {
            list.array ~= JSONValue(acc.toAssociativeArray());
        }
        try {
            auto file = File(configName, "w");
            scope (exit)
                file.close();

            file.write(list.toString());

        } catch (ErrnoException ex) {
            // Handle errors
        }
    }

    void addAccount(Account acc) {
        accounts ~= acc;
        writeAccounts();
    }

    immutable(Account[]) getAccounts() {
        return accounts.idup;
    }

private:
    string configName;
    Account[] accounts;
}
