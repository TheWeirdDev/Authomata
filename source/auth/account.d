module auth.account;

public struct Account {
    string name;
    string secret;
    string username;

    auto toAssociativeArray() const {
        return ["name": name, "secret": secret, "username": username];
    }
}
