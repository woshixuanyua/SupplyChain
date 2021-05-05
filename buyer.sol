// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

// product registration.
// buyer buys the product.
// buyer confirms delivery so money will be transferred to the seller

contract buyer{

  uint counter = 1; // for productId
  address payable SPContracta = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
  address payable buyera = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
  address payable sellera = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
  address payable supervisora = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
    string name;
    string details;
    uint productId;
    uint priceBHigh=25 ether;
    uint priceBLow=15 ether;
    uint price=20 ether;
    uint deposit=20 ether;
    uint totalPrice;
    bool buyerstrategy=false; //0：co  1:unco
    

   function getDeposit(uint _deposit) payable public{
     deposit = _deposit;
 }
 function setStrategy(bool _strategy) payable public{
     buyerstrategy = _strategy;
 }

 function payDeposit() payable public returns(uint){
    assert(deposit >= price);
    SPContracta.transfer(msg.value);
 }
 
 function deliveryAndPay() payable public{
     if(!buyerstrategy){
         sellera.transfer(msg.value);
     }
 }

}