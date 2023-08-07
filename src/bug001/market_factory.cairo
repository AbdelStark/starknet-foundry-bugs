use starknet::ContractAddress;
use zeroable::Zeroable;

#[starknet::interface]
trait IMarketFactory<TContractState> {
    fn create_market(
        ref self: TContractState,
        index_token: ContractAddress,
        long_token: ContractAddress,
        short_token: ContractAddress,
        market_type: felt252,
    );
}

#[starknet::contract]
mod MarketFactory {
    use core::zeroable::Zeroable;
    use starknet::{get_caller_address, ContractAddress, contract_address_const};
    use bugs::bug001::data_store::{IDataStoreDispatcher, IDataStoreDispatcherTrait};
    #[storage]
    struct Storage {
        data_store: IDataStoreDispatcher,
    }

    #[constructor]
    fn constructor(ref self: ContractState, data_store_address: ContractAddress) {
        self.data_store.write(IDataStoreDispatcher { contract_address: data_store_address });
    }

    #[external(v0)]
    impl MarketFactory of super::IMarketFactory<ContractState> {
        fn create_market(
            ref self: ContractState,
            index_token: ContractAddress,
            long_token: ContractAddress,
            short_token: ContractAddress,
            market_type: felt252,
        ) {
            self.data_store.read().store_market(index_token, long_token, short_token, market_type);
        }
    }
}
