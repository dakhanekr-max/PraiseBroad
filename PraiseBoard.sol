// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Tips with a short note. Every tip is stored on-chain and emitted as an
/// event, so the wall can be rebuilt by anyone straight from the chain.
contract PraiseBoard {
    uint256 public constant MAX_NOTE_BYTES = 140;

    struct Tip { address from; uint256 amount; string note; uint256 timestamp; }

    address public immutable owner;   // Ifeoma. Fixed forever: nobody can redirect funds.
    Tip[] private _tips;

    event Tipped(address indexed from, uint256 amount, string note, uint256 timestamp);
    event Withdrawn(address indexed to, uint256 amount);

    error NoValue();
    error NoteTooLong(uint256 length, uint256 max);
    error NotOwner();
    error TransferFailed();

    constructor(address _owner) { owner = _owner; }

    function tip(string calldata note) external payable {
        if (msg.value == 0) revert NoValue();
        if (bytes(note).length > MAX_NOTE_BYTES) revert NoteTooLong(bytes(note).length, MAX_NOTE_BYTES);
        _tips.push(Tip(msg.sender, msg.value, note, block.timestamp));
        emit Tipped(msg.sender, msg.value, note, block.timestamp);
    }

    function tipCount() external view returns (uint256) { return _tips.length; }
    function getTip(uint256 i) external view returns (Tip memory) { return _tips[i]; }

    /// Only Ifeoma can withdraw, and only to herself. No platform cut, no admin.
    function withdraw() external {
        if (msg.sender != owner) revert NotOwner();
        uint256 bal = address(this).balance;
        (bool ok, ) = owner.call{value: bal}("");
        if (!ok) revert TransferFailed();
        emit Withdrawn(owner, bal);
    }
    // No receive()/fallback: plain transfers revert, so every wei arrives with a record.
}
