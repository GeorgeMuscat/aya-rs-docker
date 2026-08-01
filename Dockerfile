# syntax=docker/dockerfile:1
FROM rust:1.96.0-trixie

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
	apt-get -y install --no-install-recommends \
		libelf1 \
		sudo \
		bpftool \
		llvm && \
	rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash devuser && usermod -aG sudo devuser

# allow the user to run sudo without a password prompt
RUN echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER devuser
WORKDIR /home/devuser

ENV USER=devuser

RUN rustup install stable
RUN rustup toolchain install nightly --component rust-src

# used by aya-rs
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
RUN cargo binstall --no-confirm bpf-linker

# also used by aya-rs
RUN cargo install --timings cargo-generate

ENTRYPOINT []
