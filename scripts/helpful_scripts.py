from brownie import accounts, network, config
import eth_utils

LOCAL_BLOCKCHAIN_ENVIRONMENTS = [
    "development",
    "ganache",
    "hardhat",
    "local-ganache",
    "mainnet-fork",
]

def get_account(index=None, id=None):
    if index :
        return accounts[index]
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        print(accounts[0].balance())
        return accounts[0]
    if id:
        return accounts.load(id)
    if network.show_active in config["networks"]:
        return accounts.add(config["wallets"]["from_key"])
    return None

def encode_function_data(intializer=None, *args):
    if len(args) == 0 or not intializer:
        return eth_utils.to_bytes(hexstr="0x")
    return intializer.encode_input(*args)