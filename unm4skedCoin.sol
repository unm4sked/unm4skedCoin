pragma solidity ^0.4.18;

import "./StandardToken.sol";

contract unm4skedCoin is StandardToken {
    string public name; //Token name
    uint public decimals; //How many decimals to show. To be standard complicant keep it 18
    string public symbol; //An identifier: eg SBX, XPR etc...
    string public version = "H1.0";
    uint256 public unitsOneEthCanBuy; //How many units of your coin can be bought by 1 ETH.
    uint256 public totalEthInWei; //WEI is the smallest unit of ETH (the equivalent of cent is USD or satoshi in BTC). We'll store the total ETH raised vai our ICO here.
    address public fundsWallet; //Where should the raised  ETH go ?

    //This is a constructior function
    //which means the followinf function name has to mach the contract name declared above
    function unm4skedCoin() {
        balances[msg.sender] = 1000000000000000000000;
        totalSupply = 1000000000000000000000;
        name = "unm4skedCoin";
        decimals = 18;
        symbol = "UN4S";
        unitsOneEtheCanBuy = 10;
        fundsWallet = msg.sender;
    }

    function() payable {
        totalEthInWei = totalEthInWei + msg.value;
        uint256 amount = msg.value * unitsOneEthCanBuy;
        if (balances[fundsWallet] < amount) {
            return;
        }

        balances[fudsWallet] = balances[fundsWallet] - amount;
        balances[msg.sender] = balances[msg.sender] + amount;

        Transfer(fundsWallet, msg.sender, amount);

        //transfer ether to fundsWallet
        fundsWallet.transfer(msg.value);
    }

    // Approves and then calls the receiving contract
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed one would use vanilla apprive instead
        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
        return true;
    }
}