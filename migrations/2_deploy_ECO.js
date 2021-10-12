const EcoToken = artifacts.require('./EcoToken.sol')
const fs = require('fs')

module.exports = function (deployer) {
  var name = "ECO Token";
  var symbol = "ECO";

  //EcoToken 배포하면 받는 json데이터를 파일에 저장
  deployer.deploy(EcoToken, name, symbol)
    .then(() => {
      if (EcoToken._json) {
        fs.writeFile(
          'deployedABI',
          JSON.stringify(EcoToken._json.abi),
          (err) => {
            if (err) throw err
            console.log("파일에 ABI 입력 성공");
          })
      }

      fs.writeFile(
        'deployedAddress',
        EcoToken.address,
        (err) => {
          if (err) throw err
          console.log("파일에 주소 입력 성공");
        })
    })
}