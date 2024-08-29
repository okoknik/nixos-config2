#!/bin/bash

cd /root/nixos-config2

nix flake update 
nixos-rebuild switch --flake .#framework


