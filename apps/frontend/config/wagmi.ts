import { hardhat } from "viem/chains"
import { createConfig, http, injected } from "wagmi"

export const config = createConfig({
    chains: [hardhat],
    connectors: [injected()],
    transports: {
        [hardhat.id]: http("http://127.0.0.1:8545"),
    },
});