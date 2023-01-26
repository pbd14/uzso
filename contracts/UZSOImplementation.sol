// contracts/OzodToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin_upgradable/contracts/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin_upgradable/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin_upgradable/contracts/proxy/utils/Initializable.sol";

contract UZSOImplementation is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    // INITIALIZATION DATA
    bool private initialized = false;

    // PAUSABILITY DATA
    bool public paused = false;

    // SUPPLY CONTROL DATA
    address public supplyController;

    /**
     * EVENTS
     */
    // ERC20 EVENTS
    event Approve(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // PAUSABLE EVENTS
    event Pause();
    event Resume();

    // SUPPLY CONTROL EVENTS
    // event SupplyIncreased(address indexed to, uint256 value);
    // event SupplyDecreased(address indexed from, uint256 value);
    // event SupplyControllerSet(
    //     address indexed oldSupplyController,
    //     address indexed newSupplyController
    // );

    // MODIFIERS

    modifier whenNotPaused() {
        require(!paused, "whenNotPaused");
        _;
    }

    modifier onlySupplyController() {
        require(msg.sender == supplyController, "onlySupplyController");
        _;
    }

    // wei
    // constructor() ERC20("UZS Ozod Coin", "UZSO") {
    //     supplyController = msg.sender;
    //     initialized = true;
    //     _mint(msg.sender, 10 * 10**18);
    //     pause();
    // }

    // INITIALIZE
    function initialize(uint256 random) public initializer {
        __ERC20_init("UZS Ozod Coin", "UZSO");
        __Ownable_init();
        supplyController = msg.sender;
        initialized = true;
        _mint(msg.sender, 10 * 10**18);
        pause();
    }
    // ERC20 BASIC FUNCTIONALITY

    /**
     * @dev Transfer token to a specified address from msg.sender
     * @param _to The address to transfer to.
     * @param _amount The amount to be transferred.
     */
    function transfer(address _to, uint256 _amount)
        public
        override
        whenNotPaused
        returns (bool)
    {
        emit Transfer(msg.sender, _to, _amount);
        super.transfer(_to, _amount);
        return true;
    }

    // PAUSE
    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyOwner {
        require(!paused, "already paused");
        paused = true;
        emit Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function resume() public onlyOwner {
        require(paused, "already unpaused");
        paused = false;
        emit Resume();
    }

    // SUPPLY CONTROL
    // function setSupplyController(address _newSupplyController) public onlyOwner {
    //     require(_newSupplyController != address(0), "cannot set supply controller to address zero");
    //     emit SupplyControllerSet(supplyController, _newSupplyController);
    //     supplyController = _newSupplyController;
    // }

    function mintToCustomer(address payable to, uint256 amount)
        public
        onlySupplyController
    {
        _mint(to, amount);
    }

    function burn(address payable account, uint256 amount)
        public
        onlySupplyController
    {
        _burn(account, amount);
    }
}
