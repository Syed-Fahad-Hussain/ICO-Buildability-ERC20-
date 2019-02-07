var ICO = artifacts.require("./ICO.sol");
var Token = artifacts.require("./Token.sol");

module.exports = async function (deployer) {
  await deployer.deploy(Token, "Buildability", "AAP", 18, 100000000);
  await deployer.deploy(ICO, Token.address,1551420000, 1554098400, 1556690400, 1559368800);


  // deployer.deploy(Token, 'FahadToken', 'FTK', 6, 100).then(() => {
  //   deployer.deploy(ICO, Token.address);
  // });
  // await deployer.deploy(TOKEN, 'FahadToken', 'FTK', 6, 100);
};
