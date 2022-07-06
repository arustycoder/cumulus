#!/usr/bin/env bash

tests=(
    statemine
    statemint
)

rm -R logs &> /dev/null
mkdir logs &> /dev/null

for t in ${tests[@]}
do
    printf "\n🔍  Running $t tests...\n\n"

    mkdir logs/$t &> /dev/null

    parachains-integration-tests \
        -m zombienet \
        -c ./parachains/integration-tests/$t/config.toml \
        -cl ./logs/$t/chains.log 2> /dev/null &

    parachains-integration-tests \
        -m test \
        -t ./parachains/integration-tests/$t/xcm/0_init.yml \
        -tl ./logs/$t/tests.log & tests=$!

    wait $tests

    pkill -f polkadot
    pkill -f parachain

    printf "\n🎉 $t integration tests finished! \n\n"
done
