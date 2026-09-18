#!/bin/bash
# ==============================================================================
# Shadi Najar - 213557143
# Basel Qassem - 324937036
# Hardware Simulation Script: Pyflate Huffman VLD CAM
# ==============================================================================

echo "[*] --- 1. Hardware Environment Setup ---"
# Update package lists and install Icarus Verilog for SystemVerilog simulation
apt-get update
apt-get install -y iverilog

echo "[*] --- 2. Compiling Hardware Modules ---"
# Compile the SystemVerilog design and testbench into an executable named 'huffman_sim'
# The -g2012 flag is strictly required to enable SystemVerilog features
if [ -f "huffman_cam.sv" ] && [ -f "tb_huffman_cam.sv" ]; then
    iverilog -g2012 -o huffman_sim huffman_cam.sv tb_huffman_cam.sv
    echo "[+] Compilation successful."
else
    echo "[-] Error: Missing .sv files. Ensure huffman_cam.sv and tb_huffman_cam.sv are in this directory."
    exit 1
fi

echo "[*] --- 3. Executing Hardware Simulation ---"
# Run the compiled hardware simulation
./huffman_sim

echo "[+] Pyflate Huffman CAM simulation complete!"