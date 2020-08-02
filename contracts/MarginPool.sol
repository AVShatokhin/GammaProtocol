/**
 * SPDX-License-Identifier: UNLICENSED
 */
pragma solidity 0.6.10;

import {ERC20Interface} from "./interfaces/ERC20Interface.sol";
import {AddressBookInterface} from "./interfaces/AddressBookInterface.sol";
import {SafeMath} from "./packages/oz/SafeMath.sol";

/**
 * @author Opyn Team
 * @title MarginPool
 * @notice contract that hold all protocol funds
 */
contract MarginPool {
    using SafeMath for uint256;

    /// @notice scaling unit
    uint256 public constant BASE_UNIT = 1e18;

    /// @notice AddressBook module
    address public addressBook;

    /**
     * @notice contructor
     * @param _addressBook adressbook module
     */
    constructor(address _addressBook) public {
        require(_addressBook != address(0), "Invalid address book");

        addressBook = _addressBook;
    }

    /**
     * @notice check if the sender is the Controller module
     */
    modifier onlyController() {
        require(
            msg.sender == AddressBookInterface(addressBook).getController(),
            "MarginPool: Sender is not Controller"
        );

        _;
    }

    /**
     * @notice transfers asset from user to pool
     * @dev all tokens are scaled to have 1e18 precision in contracts,
     *      so amounts are scaled down to native token decimals using _calcTransferAmount().
     *      If _asset equal to WETH address, transfer WETH from Controller address to pool
     * @param _asset address of asset to transfer
     * @param _user address of user to transfer assets from
     * @param _amount amount of token to transfer from _user, scaled to 1e18 of precision
     * @return true if successful transfer
     */
    function transferToPool(
        address _asset,
        address _user,
        uint256 _amount
    ) external onlyController returns (bool) {
        require(_amount > 0, "MarginPool: transferToPool amount is below 0");

        // transfer val from _user to pool
        return ERC20Interface(_asset).transferFrom(_user, address(this), _amount);
    }

    /**
     * @notice transfers asset from pool to user
     * @dev all tokens are scaled to have 1e18 precision in contracts,
     *      so amounts are scaled down to native token decimals using _calcTransferAmount()
     * @param _asset address of asset to transfer
     * @param _user address of user to transfer assets to
     * @param _amount amount of token to transfer to _user, scaled to 1e18 of precision
     * @return true if successful transfer
     */
    function transferToUser(
        address _asset,
        address payable _user,
        uint256 _amount
    ) external onlyController returns (bool) {
        require(_amount > 0, "MarginPool: transferToUser amount is below 0");

        // transfer asset val from Pool to _user
        return ERC20Interface(_asset).transfer(_user, _amount);
    }
}