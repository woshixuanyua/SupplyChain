// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

// product registration.
// buyer buys the product.
// buyer confirms delivery so money will be transferred to the seller

contract supervisor{

  uint counter = 1; // for productId
  address payable SPContracta = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
  address payable buyera = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
  address payable sellera = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
  address payable supervisora = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;

    string name;
    string details;
    uint productId;
    uint priceHigh=15;
    uint priceLow=5;
    uint price=20;
    uint deposit=20;
    uint totalPrice;
    bool supervisorstrategy=false; //0:sup 1:unsup
    bool sellerstrategy=false; //0:high 1:low
    bool buyerstrategy=false; //0:co 1:unco
    
    uint CL=20;
    uint R1=10;
    uint R2=10;
    uint F1=10;
    uint F2=10;
    
function setRF(uint _CL, uint _R1,uint _R2, uint _F1,uint _F2) public{
    CL=_CL;
    R1=_R1;
    R2=_R2;
    F1=_F1;
    F2=_F2;
}

 function setStrategy(bool _strategy) payable public{
     supervisorstrategy = _strategy;
 }

function ConsumptionCost() payable public{
    SPContracta.transfer(CL);
    
}

}