//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery{
    address public owner;
    address payable[] public players;

constructor(){
    owner = msg.sender;
}

receive() external payable{
    
        require(msg.value >= 1000 wei,"you cannot participate with amount lesser than 0.01 ETH");
        players.push(payable(msg.sender));
    
}

function getBalance() public view returns(uint){
    require(msg.sender == owner,"You don't have the access to view the balance");
    return address(this).balance;
}

function spin() internal view returns(uint){
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)
    ));
}
function finalWinner() public returns (address){
    require(msg.sender == owner, "You are not the owner");
    require(players.length>=3, "Players must be atleast 3 members");
    address payable winner;
    uint findWinner = spin();
    uint index = findWinner % players.length;
    winner = players[index];
    winner.transfer(getBalance());
    players = new address payable[](0);
    return winner;
}


}
