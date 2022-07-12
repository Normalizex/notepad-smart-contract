// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Notepad {
    /**
        If for personal reasons you want to hide contact from "similar contracts" in scan
        then just write something unique here
        but the more you write here, the longer the deployment of the contract will be.
    **/
    string uniq = "data";

    address public owner;
    mapping(address => string[]) notes;

    modifier ownerOnly(){
        require(msg.sender == owner, "Owner only");
        _;
    }

    function transferOwner(address _tansferTo) public ownerOnly {
        owner = _tansferTo;
    }

    function appendNote(string memory text) payable public returns (uint) {
        require(msg.value <= 0, "The method does not require funds");
        require(bytes(text).length > 0, "Empty value");
        require(bytes(text).length <= 2048, "The maximum record length is 2048 characters.");

        notes[msg.sender].push(text);
        return notes[msg.sender].length;
    }

    function removeNote(uint index) payable public returns (uint) {
        require(msg.value <= 0, "The method does not require funds");
        require(notes[msg.sender].length - 1 >= index, "Out of array range");

        for (uint256 i = index; i < notes[msg.sender].length - 1; i++) {
            notes[msg.sender][i] = notes[msg.sender][i + 1];
        }
        notes[msg.sender].pop();

        return notes[msg.sender].length;
    }

    function removeNoteByAddress(address target, uint index) payable ownerOnly public returns (uint) {
        require(msg.value <= 0, "The method does not require funds");
        require(notes[target].length - 1 >= index, "Out of array range");

        for (uint256 i = index; i < notes[target].length - 1; i++) {
            notes[target][i] = notes[target][i + 1];
        }
        notes[msg.sender].pop();

        return notes[target].length;
    }

    function getNote(address target, uint256 index) view public returns (string memory) {
        require(notes[target].length - 1 >= index, "Out of array range");
        return notes[target][index];
    }

    function getNotesCount(address target) view public returns (uint) {
        return notes[target].length;
    }

    function getNotes(address target) view public returns (string[] memory) {
        return notes[target];
    }

    function transferFunds(address _to, uint256 _amount) public ownerOnly payable returns (bool) {
        (bool success, ) = address(_to).call{value: _amount}("");
        require(success, "Transfer failed.");

        return success;
    }

    constructor(){
        owner = msg.sender;
    }
}