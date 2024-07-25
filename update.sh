#!/usr/bin/env bash

cd ~/nixos-config2

nix flake update 
nixos-rebuild switch --flake .#framework


