// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MiToken.sol";
import "../src/CryptoBank.sol";

contract CryptoBankTest is Test {
    MiToken token;
    CryptoBank bank;

    function setUp() public {
        token = new MiToken(1000);
        bank = new CryptoBank();
    }

    receive() external payable {}

    function test_DepositarEth() public {
        bank.depositarEth{value: 1 ether}();
        assertEq(bank.ethBalances(address(this)), 1 ether);
    }

    function test_RetirarEth() public {
        bank.depositarEth{value: 5 ether}();
        bank.retirarEth(2 ether);
        assertEq(bank.ethBalances(address(this)), 3 ether);
    }

    function test_RetirarEth_SinBalance_Falla() public {
        vm.expectRevert("Balance ETH insuficiente");
        bank.retirarEth(1 ether);
    }

    function test_DepositarToken() public {
        token.approve(address(bank), 100 ether);
        bank.depositarToken(address(token), 100 ether);
        assertEq(bank.tokenBalances(address(this), address(token)), 100 ether);
    }

    function test_RetirarToken() public {
        token.approve(address(bank), 100 ether);
        bank.depositarToken(address(token), 100 ether);
        bank.retirarToken(address(token), 50 ether);
        assertEq(bank.tokenBalances(address(this), address(token)), 50 ether);
    }

    function test_Pausa_BloqueaDepositos() public {
        bank.togglePausa();
        vm.expectRevert("El banco esta pausado");
        bank.depositarEth{value: 1 ether}();
    }
}
