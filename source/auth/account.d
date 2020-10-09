module auth.account;

public struct Account {
    string name;
    string secret;
    string username;

    auto toAssociativeArray() const {
        return ["name": name, "secret": secret, "username": username];
    }

    auto opEquals(R)(const R other) const {
        return other.secret == this.secret && other.username == this.username &&
            other.name == this.name;
    }

    auto clone() {
        return Account(name, secret, username);
    }
}

@safe unittest {
    Account acc1 = {name: "test", secret: "SECRET", username: "@test"};
    Account acc2 = {name: "test", secret: "SECRET", username: "@test"};
    assert(acc1 == acc2);

    Account acc3 = {name: "test3", secret: "OTHER", username: "@test3"};
    assert(acc1 != acc3);
}
