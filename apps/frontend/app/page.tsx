"use client";

import { useAccount, useConnect, useDisconnect } from "wagmi";
import { useReadContract, useWriteContract } from "wagmi";
import { parseEther, formatEther } from "viem";
import { useState } from "react";
import { CRYPTO_BANK_ADDRESS, CRYPTO_BANK_ABI } from "@/contracts/cryptoBank";

export default function Home() {
  const { address, isConnected } = useAccount();
  const { connect, connectors } = useConnect();
  const { disconnect } = useDisconnect();
  const [depositAmount, setDepositAmount] = useState("");
  const [withdrawAmount, setWithdrawAmount] = useState("");

  const { data: ethBalance, refetch: refetchBalance } = useReadContract({
    address: CRYPTO_BANK_ADDRESS,
    abi: CRYPTO_BANK_ABI,
    functionName: "ethBalances",
    args: address ? [address] : undefined,
  });

  const { writeContract } = useWriteContract();

  if (!isConnected) {
    return (
      <main className="min-h-screen flex items-center justify-center">
        <button
          onClick={() => connect({ connector: connectors[0] })}
          className="bg-blue-600 text-white px-6 py-3 rounded-lg text-lg hover:bg-blue-700"
        >
          Conectar Wallet
        </button>
      </main>
    );
  }

  return (
    <main className="min-h-screen p-8 max-w-2xl mx-auto">
      <div className="flex justify-between items-center mb-8">
        <p className="text-sm font-mono">{address}</p>
        <button
          onClick={() => disconnect()}
          className="text-red-500 hover:underline"
        >
          Desconectar
        </button>
      </div>

      <h1 className="text-3xl font-bold mb-8">CryptoBank</h1>

      <div className="bg-gray-900 rounded-lg p-6 mb-6">
        <h2 className="text-xl mb-2">Tu balance en el banco</h2>
        <p className="text-4xl font-bold">
          {ethBalance ? formatEther(ethBalance as bigint) : "0"} ETH
        </p>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div className="bg-gray-800 rounded-lg p-4">
          <h3 className="text-lg mb-3">Depositar ETH</h3>
          <input
            type="text"
            placeholder="Cantidad en ETH"
            value={depositAmount}
            onChange={(e) => setDepositAmount(e.target.value)}
            className="w-full bg-gray-700 rounded px-3 py-2 mb-3"
          />
          <button
            onClick={() => {
              writeContract(
                {
                  address: CRYPTO_BANK_ADDRESS,
                  abi: CRYPTO_BANK_ABI,
                  functionName: "depositarEth",
                  value: parseEther(depositAmount),
                },
                { onSuccess: () => { refetchBalance(); setDepositAmount(""); } }
              );
            }}
            className="w-full bg-green-600 py-2 rounded hover:bg-green-700"
          >
            Depositar
          </button>
        </div>

        <div className="bg-gray-800 rounded-lg p-4">
          <h3 className="text-lg mb-3">Retirar ETH</h3>
          <input
            type="text"
            placeholder="Cantidad en ETH"
            value={withdrawAmount}
            onChange={(e) => setWithdrawAmount(e.target.value)}
            className="w-full bg-gray-700 rounded px-3 py-2 mb-3"
          />
          <button
            onClick={() => {
              writeContract(
                {
                  address: CRYPTO_BANK_ADDRESS,
                  abi: CRYPTO_BANK_ABI,
                  functionName: "retirarEth",
                  args: [parseEther(withdrawAmount)],
                },
                { onSuccess: () => { refetchBalance(); setWithdrawAmount(""); } }
              );
            }}
            className="w-full bg-red-600 py-2 rounded hover:bg-red-700"
          >
            Retirar
          </button>
        </div>
      </div>
    </main>
  );
}