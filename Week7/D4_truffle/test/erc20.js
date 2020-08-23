const erc20 = artifacts.require("erc20");

contract("erc20", accounts => {

    it("should put 100 tokens in account 1", () =>
        erc20.deployed()
            .then(instance => instance.balanceOf(accounts[1]))
            .then(balance => {
                assert.equal(
                    balance, 100,
                    "there's not 100 tokens in account 1"
                );
            })
    );
});
