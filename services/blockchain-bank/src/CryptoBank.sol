// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract CryptoBank {
    address public owner;
    bool public paused;

    modifier soloOwner() {
        require(msg.sender == owner, "Solo el owner");
        _;
    }

    modifier noEnPausa() {
        require(!paused, "El banco esta pausado");
        _;
    }

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    mapping(address => uint256) public ethBalances;
    mapping(address => mapping(address => uint256)) public tokenBalances;

    event DepositoEth(address indexed usuario, uint256 cantidad);
    event RetiroEth(address indexed usuario, uint256 cantidad);
    event DepositoToken(
        address indexed usuario,
        address indexed token,
        uint256 cantidad
    );
    event RetiroToken(
        address indexed usuario,
        address indexed token,
        uint256 cantidad
    );

    function depositarEth() public payable noEnPausa {
        require(msg.value > 0, "Debes enviar ETH");
        ethBalances[msg.sender] += msg.value;
        emit DepositoEth(msg.sender, msg.value);
    }

    function retirarEth(uint256 cantidad) public noEnPausa {
        require(
            ethBalances[msg.sender] >= cantidad,
            "Balance ETH insuficiente"
        );
        ethBalances[msg.sender] -= cantidad;
        emit RetiroEth(msg.sender, cantidad);
        (bool success, ) = msg.sender.call{value: cantidad}("");
        require(success, "Fallo el envio de ETH");
    }

    function depositarToken(
        address tokenAddress,
        uint256 cantidad
    ) public noEnPausa {
        require(cantidad > 0, "Cantidad debe ser mayor a 0");
        tokenBalances[msg.sender][tokenAddress] += cantidad;
        emit DepositoToken(msg.sender, tokenAddress, cantidad);
        IERC20 tokenContrato = IERC20(tokenAddress);
        bool success = tokenContrato.transferFrom(
            msg.sender,
            address(this),
            cantidad
        );
        require(success, "Fallo transferFrom");
    }

    function retirarToken(
        address tokenAddress,
        uint256 cantidad
    ) public noEnPausa {
        require(
            tokenBalances[msg.sender][tokenAddress] >= cantidad,
            "Balance token insuficiente"
        );
        tokenBalances[msg.sender][tokenAddress] -= cantidad;
        emit RetiroToken(msg.sender, tokenAddress, cantidad);
        IERC20 tokenContrato = IERC20(tokenAddress);
        bool success = tokenContrato.transfer(msg.sender, cantidad);
        require(success, "Fallo transfer");
    }

    function togglePausa() public soloOwner {
        paused = !paused;
    }

    receive() external payable {
        ethBalances[msg.sender] += msg.value;
        emit DepositoEth(msg.sender, msg.value);
    }
}
