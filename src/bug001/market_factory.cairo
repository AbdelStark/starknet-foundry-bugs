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
    #[storage]
    struct Storage {}

    #[external(v0)]
    impl MarketFactory of super::IMarketFactory<ContractState> {
        fn create_market(
            ref self: ContractState,
            index_token: ContractAddress,
            long_token: ContractAddress,
            short_token: ContractAddress,
            market_type: felt252,
        ) {
            if index_token.is_zero() {
                assert(false, 'invalid_market_params');
            }
        }
    }
}
