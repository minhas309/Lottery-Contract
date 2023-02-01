//SPDX-License-Identifier: Unidentified

pragma solidity ^0.8.6;

contract Lottery {

    address private manager;
    address payable[] private players;
    uint256 public constant minAmount = 1  ether ;

    constructor () {
        manager = msg.sender;
    }

     function random() view  private returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % players.length;
    }

    function enter() payable public {
        require(msg.sender != manager, "Manager cannot Participate");
        for(uint i =0;i < players.length;i++){
            require(players[i] != msg.sender, "Player already exists");
        }
        require(msg.value >= minAmount, "Your account should have minimum balance of 1 ether");
        players.push(payable(msg.sender));
    }

    function pickWinner() payable public returns(address){
        require(msg.sender == manager, "Only manager can pick the WINNER");
        require(players.length>=1, "No Player has entered yet");
        uint index = random();
        (bool send,) = players[index].call{value: address(this).balance}("");
        require(send, "Transection failed");
        return players[index];
    }

    function reset() public {
        require(msg.sender == manager);
        players = new address payable[](0);
    }

    fallback() payable external {

    }

    receive() payable external {}
}