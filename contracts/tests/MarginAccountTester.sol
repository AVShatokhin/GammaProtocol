pragma solidity =0.6.10;

// SPDX-License-Identifier: UNLICENSED
pragma experimental ABIEncoderV2;

import {MarginAccount} from "../libs/MarginAccount.sol";

contract MarginAccountTester {
    using MarginAccount for MarginAccount.Vault;

    mapping(address => mapping(uint256 => MarginAccount.Vault)) private vault;

    function getVault(uint256 _vaultIndex) external view returns (MarginAccount.Vault memory) {
        return vault[msg.sender][_vaultIndex];
    }

    function testAddShort(
        uint256 _vaultIndex,
        address _shortOtoken,
        uint256 _amount,
        uint256 _index
    ) external {
        vault[msg.sender][_vaultIndex]._addShort(_shortOtoken, _amount, _index);
    }

    function testRemoveShort(
        uint256 _vaultIndex,
        address _shortOtoken,
        uint256 _amount,
        uint256 _index
    ) external {
        vault[msg.sender][_vaultIndex]._removeShort(_shortOtoken, _amount, _index);
    }

    function testAddLong(
        uint256 _vaultIndex,
        address _longOtoken,
        uint256 _amount,
        uint256 _index
    ) external {
        vault[msg.sender][_vaultIndex]._addLong(_longOtoken, _amount, _index);
    }

    function testRemoveLong(
        uint256 _vaultIndex,
        address _longOtoken,
        uint256 _amount,
        uint256 _index
    ) external {
        vault[msg.sender][_vaultIndex]._removeLong(_longOtoken, _amount, _index);
    }

    function testAddCollateral(
        uint256 _vaultIndex,
        address _collateralAsset,
        uint256 _amount,
        uint256 _index
    ) external {
        vault[msg.sender][_vaultIndex]._addCollateral(_collateralAsset, _amount, _index);
    }

    function testRemoveCollateral(
        uint256 _vaultIndex,
        address _collateralAsset,
        uint256 _amount,
        uint256 _index
    ) external {
        vault[msg.sender][_vaultIndex]._removeCollateral(_collateralAsset, _amount, _index);
    }

    function testClearVault(uint256 _vaultIndex) external {
        vault[msg.sender][_vaultIndex]._clearVault();
    }
}