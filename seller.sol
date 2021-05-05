// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

// product registration.
// buyer buys the product.
// buyer confirms delivery so money will be transferred to the seller

contract seller{

  uint counter = 1; // for productId
  address payable SPContracta = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
  address payable buyera = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
  address payable sellera = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
  address payable supervisora = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;

    string name;
    string details;
    uint productId;
    uint priceHigh=15 ether;
    uint priceLow=5 ether;
    uint price=20 ether;
    uint deposit=1 ether;
    uint totalPrice;
    bool sellerstrategy=false; //0:high 1:low

 function setPrice(uint _priceHigh ,uint _priceLow,uint _price)  public{
     priceHigh = _priceHigh;
     priceLow = _priceLow;
     price = _price;
 }
 function getDeposit(uint8 _deposit) payable public{
     deposit = _deposit;
 }
 function setStrategy(bool _strategy) payable public{
     sellerstrategy = _strategy;
 }

 function payDeposit() payable public{
    assert(deposit >= price);
    SPContracta.transfer(msg.value);
 }

 
  function sendGoods() payable public{
    if(!sellerstrategy)
        buyera.transfer(msg.value);
    else
         buyera.transfer(msg.value);        

  }
}