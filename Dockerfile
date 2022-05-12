# Build Stage
FROM --platform=linux/amd64 rustlang/rust:nightly as builder

ENV DEBIAN_FRONTEND=noninteractive
## Install build dependencies.
RUN apt-get update 
RUN apt-get install -y cmake clang
RUN cargo install cargo-fuzz

## Add source code to the build stage.
ADD . /untrusted/
WORKDIR /untrusted/

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.

WORKDIR /untrusted/fuzz/
RUN cargo fuzz build

FROM --platform=linux/amd64 rustlang/rust:nightly

## TODO: Change <Path in Builder Stage>
COPY --from=builder /untrusted/fuzz/target/x86_64-unknown-linux-gnu/release/from_slice /
COPY --from=builder /untrusted/fuzz/target/x86_64-unknown-linux-gnu/release/read_unconsumed /
COPY --from=builder /untrusted/fuzz/target/x86_64-unknown-linux-gnu/release/slice_less_safe /
