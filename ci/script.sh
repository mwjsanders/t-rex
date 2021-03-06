# This script takes care of testing your crate

set -ex

main() {
    cargo build --all --tests --bins
    cargo run -- --version

    if [ ! -z $DISABLE_TESTS ]; then
        return
    fi

    cargo test --all
    if [ $TRAVIS_OS_NAME = linux ]; then
        cargo test --all -- --ignored
    fi

    if [ $TRAVIS_OS_NAME = linux ]; then
        ldd target/debug/t_rex
    fi
    if [ $TRAVIS_OS_NAME = osx ]; then
        otool -L target/debug/t_rex
    fi
}

# we don't run the "test phase" when doing deploys
if [ -z $TRAVIS_TAG ]; then
    main
fi
