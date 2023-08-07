use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::{TryInto, Into};
use starknet::{
    ContractAddress, get_caller_address, Felt252TryIntoContractAddress, contract_address_const
};
use cheatcodes::PreparedContract;

use bugs::bug001::market_factory::{IMarketFactorySafeDispatcher, IMarketFactorySafeDispatcherTrait};

#[test]
fn bug001_test() {
    let data_store_address = deploy_data_store();
    let market_factory_address = deploy_market_factory(data_store_address);
    let market_factory = IMarketFactorySafeDispatcher { contract_address: market_factory_address };
    let result = market_factory
        .create_market(
            // 0 is an invalid value and should cause a panic.
            contract_address_const::<0>(),
            contract_address_const::<'long_token'>(),
            contract_address_const::<'short_token'>(),
            'market_type',
        );
    match result {
        // If the result is ok, then the test failed.
        Result::Ok(_) => assert(false, 'bad_result'),
        // If the result is err, then the test passed.
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'invalid_market_params', *panic_data.at(0))
        }
    }
}


fn deploy_data_store() -> ContractAddress {
    let class_hash = declare('DataStore');
    let mut constructor_calldata = ArrayTrait::new();
    let prepared = PreparedContract {
        class_hash: class_hash, constructor_calldata: @constructor_calldata
    };
    deploy(prepared).unwrap()
}


fn deploy_market_factory(data_store_address: ContractAddress) -> ContractAddress {
    let class_hash = declare('MarketFactory');
    let mut constructor_calldata = ArrayTrait::new();
    constructor_calldata.append(data_store_address.into());
    let prepared = PreparedContract {
        class_hash: class_hash, constructor_calldata: @constructor_calldata
    };
    deploy(prepared).unwrap()
}
