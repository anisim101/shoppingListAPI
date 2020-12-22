
.PHONY: build
build:
    swift build --enable-test-discovery;
    sudo .build/debug/Run serve -b 46.101.222.236

