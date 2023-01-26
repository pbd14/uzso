from brownie import (
    UZSOImplementation,
    ProxyAdmin,
    TransparentUpgradeableProxy,
    Contract,
)
from scripts.helpful_scripts import get_account, encode_function_data
from web3 import Web3

initial_supply = Web3.toWei(1000, "ether")


def main():
    account = get_account(id="goerli-testnet1")
    uzso = UZSOImplementation.deploy(
        {"from": account},
        publish_source=True,
    )
    print("UZSO")
    print(uzso)

    proxy_admin = ProxyAdmin.deploy({"from": account})
    print("PROXY ADMIN")
    print(proxy_admin)

    initializer = uzso.initialize

    print("INIT")
    print(initializer)
    uzso_encoded_initializer_function = encode_function_data(initializer, 1)


    proxy = TransparentUpgradeableProxy.deploy(
        uzso.address,
        proxy_admin.address,
        uzso_encoded_initializer_function,
        {"from": account}
    )
    print("PROXY")
    print(proxy)

    proxy_uzso = Contract.from_abi(
        "UZSOImplementation", proxy.address, UZSOImplementation.abi
    )
    proxy_uzso.resume({"from": account})
