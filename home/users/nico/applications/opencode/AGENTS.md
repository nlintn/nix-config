# Agent Skills Guide

This document provides instructions for agents on what guidelines and rules to follow.

## Guidelines

- **Skills**: When appropriate always use the `nix-search` skill to consult the NixOS documentation.

## General Rules

- **Missing Binaries**: If you cannot find a required binary on the system:
  1. Find the package that provides the binary using `command-not-found <binary>`.
  2. Use `nix-shell -p <package>` to make it available in an ephemeral shell.

## Script Execution Rules

- **Python**: General Python scripts should be run with `uv` instead of `python`.
- **JavaScript/TypeScript**: Scripts should be run with `bun` instead of `node`.
