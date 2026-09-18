#!/bin/bash
# ==============================================================================
# Shadi Najar - 213557143
# Basel Qassem - 324937036
# Hardware Simulation Script: Raytrace 3D MAC Accelerator
# ==============================================================================

echo "[*] --- 1. Hardware Environment Setup ---"
# Update package lists and install Icarus Verilog for SystemVerilog simulation
apt-get update
apt-get install -y iverilog

echo "[*] --- 2. Compiling Hardware Modules ---"
# Compile the SystemVerilog design and testbench into an executable named 'mac_sim'
# The -g2012 flag is strictly required to enable SystemVerilog features
if [ -f "mac_3d_fixed_point.sv" ] && [ -f "tb_mac_3d_fixed_point.sv" ]; then
    iverilog -g2012 -o mac_sim mac_3d_fixed_point.sv tb_mac_3d_fixed_point.sv
    echo "[+] Compilation successful."
else
    echo "[-] Error: Missing .sv files. Ensure mac_3d_fixed_point.sv and tb_mac_3d_fixed_point.sv are in this directory."
    exit 1
fi

echo "[*] --- 3. Executing Hardware Simulation ---"
# Run the compiled hardware simulation
./mac_sim

echo "[+] Raytrace MAC simulation complete!"