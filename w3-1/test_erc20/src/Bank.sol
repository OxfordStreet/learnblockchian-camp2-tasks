pragma solidity ^0.8.0;


import "openzeppelin-contracts/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC1820Registry.sol";

interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

contract Bank is TokenRecipient{
    mapping(address => uint) public deposited;
    address public immutable token;

      // keccak256("ERC777TokensRecipient")
    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;

    IERC1820Registry private erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    constructor(address _token) {
        token = _token;
        // erc1820.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
        
    }

    // 收款时被回调
    function tokensReceived(address sender, uint amount) external returns (bool) {
        require(msg.sender == token, "invalid"); // 这里的token是MyERC20Callback地址，在部署Bank合约时由constructor传递过来。
        deposited[sender] += amount; // 交易记录
        return true;
    }

    function deposit(address user, uint amount) public {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer from error");
        deposited[user] += amount;
    }

    /**
     * 用户可以一次性的调Bank中的permitDeposit函数同样的做一步存款
     rsv 签名信息就包含了用户要授权给这个合约要使用的币
     之后用Bank合约自定义的deposit函数完成转账。
    */ 
    function permitDeposit(address user, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        IERC20Permit(token).permit(msg.sender, address(this), amount, deadline, v, r, s); // 检查并完成授权
        deposit(user, amount); // deposit函数也在本合约中定义，用于转账
    }

    // 收款时被回调
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        require(msg.sender == token, "invalid");
        deposited[from] += amount;
    }

}

