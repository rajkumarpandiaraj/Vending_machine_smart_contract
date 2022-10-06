// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


error unAuthorized(string _msg) ;
error Insufficient(string _msg) ;

contract DonutVendingMachine {

    address public owner ;
    mapping (address => uint) donutBalances ;

    event Success(string _msg) ;


    constructor () {
        owner = msg.sender ;
        donutBalances[address(this)] = 100 ;
    }

    // Modifiers
    modifier checkOwner(){
        if(msg.sender != owner){
            revert unAuthorized("Error : only owner can restock");
        }

        _;
    }

    modifier checkAmount(uint _qty){
        if(msg.value < _qty * 2 ether){
            revert Insufficient("Error : Insufficient Amount - 2 ether per donut");
        }

        _;
    }

    modifier checkDonutInMachine(uint _qty){
        if(_qty > getVendingMachineBalance()){
            revert Insufficient("Error : Insufficient Donut - please try again");
        }

        _;
    }

    function getVendingMachineBalance() public view returns(uint) {
        return donutBalances[address(this)] ;
    }

    function restock(uint qty) public checkOwner {
        donutBalances[address(this)] += qty ;
        emit Success("donut purchased");
    }

   
    function purchaseDonut(uint qty) public  payable checkAmount(qty) checkDonutInMachine(qty){
        donutBalances[msg.sender] += qty ;
        donutBalances[address(this)] -= qty ;
    }





    
}
