// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

// product registration.
// buyer buys the product.
// buyer confirms delivery so money will be transferred to the seller

contract supplyChain{

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
bool delivered;
uint supervisoraBalance;
string review;
uint CL=20;
uint R1=10;
uint R2=10;
uint F1=10;
uint F2=10;
bool supervisorstrategy=false; //0:sup 1:unsup
bool sellerstrategy=false; //0:high 1:low
bool buyerstrategy=false; //0:co 1:unco

struct Product{
    string name;
    string details;
    address payable seller;
    uint productId;
    uint price; // in wel
    uint quantity; // in kgs
    uint totalPrice;
    address buyer;
    bool delivered;
    string review;
  }

function getOtherStrategy(bool sellerstrategy1 , bool buyerstrategy1) public{
    sellerstrategy = sellerstrategy1;
    buyerstrategy = buyerstrategy1;
}
function getsupervisorStrategy(bool supervisorstrategy1) public{
    supervisorstrategy = supervisorstrategy1;
}

  function getBalance() public returns(uint){
      supervisoraBalance=supervisora.balance;
        return supervisora.balance;
    }


 function cheakDeposit(uint deposit)payable  public returns(uint){
     if(supervisoraBalance -2*deposit > 0)
         return 0;
    
     if(supervisoraBalance -2*deposit < 0) {
         return 1;
     }
 }
 function setRF(uint _CL, uint _R1,uint _R2, uint _F1,uint _F2) public{
    CL=_CL;
    R1=_R1;
    R2=_R2;
    F1=_F1;
    F2=_F2;
}

function rewardAndPunish() payable public{
    if(!supervisorstrategy){
        if(!sellerstrategy){
            if(!buyerstrategy){
                sellera.transfer(R1+deposit);
                buyera.transfer(R2+deposit);
            }else{
                sellera.transfer(R1+deposit);
                buyera.transfer(deposit-F2);
            }
        }else{
            if(!buyerstrategy){
                sellera.transfer(deposit-F1);
                buyera.transfer(R2+deposit);
            }else{
                sellera.transfer(deposit-F1);
                buyera.transfer(deposit-F2);
            }
        }
    }
    
}

  Product[] public products;

  // events.
  event registered(string name, uint productId, uint totalPrice, address seller);
  event bought(uint productId, address buyer);


  // creating function registerProduct - to product registration.
  function registerProduct(string memory _name, string memory _details, uint _price, uint _quantity) public{

    require(_price > 0, "Price should be greater than 0.");
    // enter product details inculding who is seller
    Product memory newProduct;
    newProduct.name = _name;
    newProduct.details = _details;
    newProduct.price = _price * 10**18; // converting wels to ether
    newProduct.quantity = _quantity;
    newProduct.totalPrice = newProduct.price * newProduct.quantity;
    newProduct.seller = msg.sender;
    newProduct.productId = counter;
    products.push(newProduct);
    counter++;

    emit registered(_name, newProduct.productId, newProduct.totalPrice, msg.sender);
  }

  // creating function getBalance -  to display the current balance in the contract 
  function getDetails(uint _productId) public view returns (string memory, string memory, uint, uint, address, address, string memory){
    return  (products[_productId - 1].name, products[_productId - 1].details, products[_productId - 1].price, products[_productId - 1].totalPrice, products[_productId - 1].seller, products[_productId - 1].buyer, products[_productId - 1].review);
  }

  // creating function buy - for buyer buys the product.
  function buy(uint _productId) payable public{

    // seller cannot buy his/her own product
    require(products[_productId - 1].seller != msg.sender,"Seller cannot buy his/her own product.");

    // players must invest astleast 1 ether
    require(products[_productId - 1].totalPrice == msg.value,"Buyer buy price must be same as the price of seller");

    // once product is delivered then it cannot be buyed again
    require(products[_productId - 1].delivered == false ,"The product have sold already");
    products[_productId - 1].buyer = msg.sender;

    emit bought(_productId, msg.sender);
  }

  // creating function delivery - buyer confirms delivery so money will be transferred to the seller
  function delivery(uint _productId, string memory _review) public{

    // buyer can only able to confirm about the product delivery
    require(products[_productId - 1].buyer == msg.sender,"Buyer can only confirm delivery.");

    products[_productId - 1].delivered = true;
    products[_productId - 1].seller.transfer(products[_productId - 1].totalPrice);
    products[_productId - 1].seller = msg.sender;
    products[_productId - 1].buyer = address(0);
    products[_productId - 1].review = _review;

  }

  // function for changing reselling it. (optional function)
  function reSell(string memory _name, string memory _details, uint _productId, uint _price) public {

    // price must be gearter than zero
    require(_price > 0,"Price cannot be less than or equal to 0");

    // only rightful owner can sell the product
    require(products[_productId - 1].seller == msg.sender,"Only owner can place sell order");

    // reselling the product.
    products[_productId - 1].name = _name;
    products[_productId - 1].details = _details;
    products[_productId - 1].price = _price;
    products[_productId - 1].totalPrice = products[_productId - 1].quantity * products[_productId - 1].price; 
    products[_productId - 1].seller = msg.sender;
    products[_productId - 1].delivered = false;
    products[_productId - 1].review = "";
    emit registered(products[_productId - 1].name, _productId, products[_productId - 1].totalPrice, msg.sender);
  }


}