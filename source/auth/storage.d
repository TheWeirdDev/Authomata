module auth.storage;

import std.json;
import std.file;
import std.exception;
import std.stdio;
import std.algorithm;
import core.stdc.stdlib : exit;

import auth.account;
import utils;

public final class Storage {

    this() {
        configName = getConfigDirName() ~ "/config.json";
        readAccounts();
    }

    ~this() {
        if (countAccounts() > 0)
            writeAccounts();
    }

    auto countAccounts() {
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
            stderr.writeln(ex.msg);
            exit(1);
        }
    }

    void addAccount(Account acc) {
        accounts ~= acc;
        writeAccounts();
    }

    void removeAccount(Account acc) {
        accounts.remove!(a => a == acc);
        writeAccounts();
    }

    auto getAccounts() const {
        return accounts.idup;
    }

private:
    string configName;
    Account[] accounts;
}
