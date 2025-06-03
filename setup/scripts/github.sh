#!/bin/bash

set -e

# Windows
if [ ! -d /opt/resources/windows/Ghostpack-CompiledBinaries ]; then
  git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries /opt/resources/windows/Ghostpack-CompiledBinaries
fi 
