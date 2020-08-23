const erc20 = artifacts.require("erc20");

module.exports = function(deployer, network, accounts) {

  deployer.deploy(erc20, 'mytoken', 'MYT').then(function(instance){
    console.log("=> Contract deployed");

    instance.mint(accounts[1], 100).then(function(){
      console.log("=> Operation 'mint' done!");

      instance.balanceOf(accounts[1]).then(function(balance){
        console.log("current balance of account 1 : " + balance + " tokens");
      });
    }).catch(function(err){ 
      //error in mint function (not enough fund)
      console.log("error: " + err);
    }).catch(function(err){ 
      //error in deployer
      console.log("deploy failed " + err);
    });
  });
};