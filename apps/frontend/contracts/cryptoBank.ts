export const CRYPTO_BANK_ADDRESS = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9" as const;

export const CRYPTO_BANK_ABI = [
    {
        type: "function",
        name: "depositarEth",
        inputs: [],
        outputs: [],
        stateMutability: "payable",
    },
    {
        type: "function",
        name: "retirarEth",
        inputs: [{ name: "cantidad", type: "uint256" }],
        outputs: [],
        stateMutability: "nonpayable",
    },
    {
        type: "function",
        name: "ethBalances",
        inputs: [{ name: "", type: "address" }],
        outputs: [{ name: "", type: "uint256" }],
        stateMutability: "view",
    },
    {
        type: "function",
        name: "paused",
        inputs: [],
        outputs: [{ name: "", type: "bool" }],
        stateMutability: "view",
    },
    {
        type: "receive",
        stateMutability: "payable",
    },
] as const;