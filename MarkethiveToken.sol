pragma solidity ^0.4.23;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 * Licensed under the MIT license by OpenZeppelin, Smart Contract Solutions, Inc.
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

contract MarkethiveToken
{
	using SafeMath for uint256;

	address public owner;

	string public constant name = "Markethive Consumer Coin";
	string public constant symbol = "MHV";
	uint8 public constant decimals = 18;

	uint256 public constant maxTokens = 8888888888 * 10**uint(decimals);

	mapping(address => uint256) private balances;
	mapping(address => mapping (address => uint256) ) private allowances;

	constructor() public
	{
		owner = msg.sender;

		balances[owner] = balances[owner].add (maxTokens);

		emit Transfer (address (0), owner, maxTokens);
	}

	modifier onlyOwner ()
	{
		require (msg.sender == owner);
		_;
	}

	function totalSupply ()  public pure returns (uint256)
	{
		return (maxTokens);
	}

	function balanceOf (address tokenOwner)  public view returns (uint256)
	{
		return (balances[tokenOwner]);
	}

	function allowance (address tokenOwner, address spender)  public view returns (uint256)
	{
		return (allowances[tokenOwner][spender]);
	}

    function transfer (address to, uint256 tokens)  public returns (bool)
	{
		require (tokens <= balances[msg.sender]);
		require (to != address (0));
		require (to != owner);

		balances[msg.sender] = balances[msg.sender].sub (tokens);
		balances[to] = balances[to].add (tokens);

		emit Transfer (msg.sender, to, tokens);

		return (true);
	}

    function approve (address spender, uint256 tokens)  public returns (bool)
	{
		require (spender != address (0));
		//if (tokens > 0)
		//require(allowances[msg.sender][spender] == 0);

		allowances[msg.sender][spender] = tokens;

		emit Approval (msg.sender, spender, tokens);

		return (true);
	}

    function transferFrom (address from, address to, uint256 tokens) public returns (bool)
	{
		require (tokens <= balances[from]);
		require (tokens <= allowances[from][msg.sender]);
		require (to != address(0));

		balances[from] = balances[from].sub (tokens);
		balances[to] = balances[to].add (tokens);
		allowances[from][msg.sender] = allowances[from][msg.sender].sub (tokens);

		emit Transfer (from, to, tokens);

		return (true);
	}

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}
