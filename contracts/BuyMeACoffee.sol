
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./IERC20.sol";
import "hardhat/console.sol";


contract BuyMeACoffee {
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }
    
    address payable owner;
    address payable withdrawalRecipient;

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor() {
        owner = payable(msg.sender);
        withdrawalRecipient = payable(msg.sender);
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "can't buy coffee for free!");

        console.log(
        "msg logging",
            msg
        );

        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(withdrawalRecipient.send(address(this).balance));
    }

    function changeOwner(address _withdrawalRecipient) public {
        require(msg.sender == owner, 'Only owner can modify the withdrawal recipient address');
        withdrawalRecipient = payable(_withdrawalRecipient);     
    }
}
