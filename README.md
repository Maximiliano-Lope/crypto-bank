# CryptoBank

Banco descentralizado construido con Solidity, Foundry y Next.js. Permite depositar y retirar ETH y tokens ERC-20 a través de una interfaz web conectada a MetaMask.

## Estructura del proyecto

```
crypto-bank/
├── services/
│   └── blockchain-bank/       # Smart contracts (Foundry)
│       ├── src/               # Contratos Solidity
│       │   ├── MiToken.sol    # Token ERC-20 (MaxToken)
│       │   └── CryptoBank.sol # Banco descentralizado
│       ├── test/              # Tests automatizados
│       │   └── CryptoBank.t.sol
│       ├── script/            # Scripts de deploy
│       │   └── Deploy.s.sol
│       └── foundry.toml
├── apps/
│   └── frontend/              # Next.js + wagmi + viem
│       ├── app/               # Pages (App Router)
│       ├── contracts/         # ABIs y direcciones
│       ├── config/            # Configuración wagmi
│       └── providers/         # Web3Provider
```

## Prerrequisitos

### 1. Node.js (v18+)

Descarga e instala desde [nodejs.org](https://nodejs.org/).

```bash
node --version
npm --version
```

### 2. Git (con Git Bash en Windows)

Descarga e instala desde [git-scm.com](https://git-scm.com/). En Windows, asegúrate de instalar **Git Bash** (se incluye por defecto).

```bash
git --version
```

### 3. Foundry

Foundry es el toolkit de desarrollo de smart contracts. **Debe instalarse desde Git Bash** (en Windows, PowerShell y CMD no están soportados).

Abre **Git Bash** y ejecuta:

```bash
curl -L https://foundry.paradigm.xyz | bash
```

Cierra y abre Git Bash, luego ejecuta:

```bash
foundryup
```

Si al cerrar y abrir la terminal `foundryup` no se reconoce, agrega Foundry al PATH manualmente:

```bash
echo 'export PATH="$PATH:$HOME/.foundry/bin"' >> ~/.bashrc
source ~/.bashrc
```

Verifica la instalación:

```bash
forge --version
cast --version
anvil --version
```

### 4. MetaMask

Instala la extensión de navegador desde [metamask.io](https://metamask.io/).

## Configuración

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd crypto-bank
```

### 2. Instalar dependencias de smart contracts

```bash
cd services/blockchain-bank
forge install foundry-rs/forge-std --no-commit
forge build
```

### 3. Instalar dependencias del frontend

```bash
cd ../../apps/frontend
npm install
```

### 4. Configurar MetaMask

#### Agregar la red local Anvil

En MetaMask:

1. Haz clic en el selector de red (arriba)
2. "Add Network" → "Add a network manually"
3. Completa los campos:
   - **Network Name:** Anvil Local
   - **RPC URL:** http://127.0.0.1:8545
   - **Chain ID:** 31337
   - **Currency Symbol:** ETH
4. Guarda

#### Importar cuenta de prueba

1. En MetaMask → menú de cuentas → "Import Account"
2. Pega esta clave privada (cuenta de prueba de Anvil, **nunca usar en mainnet**):

```
0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

3. La cuenta aparecerá con 10,000 ETH de prueba

> ⚠️ **IMPORTANTE:** Esta clave privada es pública y conocida. Solo úsala para desarrollo local. Nunca envíes fondos reales a esta dirección.

## Ejecución

Necesitas **3 terminales** abiertas simultáneamente (todas en Git Bash si estás en Windows):

### Terminal 1: Nodo local (Anvil)

```bash
anvil
```

Deja esta terminal abierta. Anvil levanta una blockchain local en `http://127.0.0.1:8545` con 10 cuentas de prueba.

### Terminal 2: Deploy de contratos

```bash
cd services/blockchain-bank

forge script script/Deploy.s.sol:DeployScript \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

Anota las direcciones de los contratos desplegados que aparecen en la salida:

```
Contract: MiToken
Contract Address: 0x...

Contract: CryptoBank
Contract Address: 0x...
```

**Actualiza las direcciones** en los archivos del frontend:

- `apps/frontend/contracts/miToken.ts` → `MI_TOKEN_ADDRESS`
- `apps/frontend/contracts/cryptoBank.ts` → `CRYPTO_BANK_ADDRESS`

### Terminal 3: Frontend

```bash
cd apps/frontend
npm run dev
```

Abre `http://localhost:3000` en el navegador donde tienes MetaMask instalado.

## Uso

1. Asegúrate de que MetaMask esté en la red **Anvil Local**
2. Haz clic en **"Conectar Wallet"** y aprueba la conexión en MetaMask
3. Para depositar: escribe una cantidad en ETH y haz clic en **"Depositar"**. Aprueba la transacción en MetaMask.
4. Para retirar: escribe una cantidad y haz clic en **"Retirar"**. Aprueba la transacción.

## Tests

```bash
cd services/blockchain-bank
forge test -v
```

## Comandos útiles

```bash
# Compilar contratos
forge build

# Ejecutar tests
forge test

# Tests con detalle
forge test -vvv

# Consultar un contrato desplegado (ejemplo: nombre del token)
cast call <TOKEN_ADDRESS> "name()(string)" --rpc-url http://127.0.0.1:8545

# Enviar una transacción (ejemplo: depositar 1 ETH)
cast send <BANK_ADDRESS> "depositarEth()" \
  --value 1ether \
  --rpc-url http://127.0.0.1:8545 \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## Stack técnico

| Capa | Tecnología | Propósito |
|------|-----------|-----------|
| Smart Contracts | Solidity 0.8.x | Lógica del banco y token ERC-20 |
| Framework | Foundry (forge, cast, anvil) | Compilación, testing, deploy |
| Frontend | Next.js 16 + TypeScript | Interfaz de usuario |
| Blockchain hooks | wagmi v3 + viem | Conexión frontend ↔ blockchain |
| Wallet | MetaMask | Firma de transacciones |
| Nodo local | Anvil | Blockchain de desarrollo |