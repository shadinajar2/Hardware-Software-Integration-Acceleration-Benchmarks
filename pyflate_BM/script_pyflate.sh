#!/bin/bash
# ==============================================================================
# Shadi Najar - 213557143
# Basel Qassem - 324937036
# Execution Script: Raytrace Benchmark
# ==============================================================================

echo "[*] --- 1. Environment Setup & Dependencies ---"
# Install performance profiling tools and debug-enabled Python
apt-get update
apt-get install -y linux-tools-common linux-tools-generic linux-tools-`uname -r` python3-dbg git

# Clone Brendan Gregg's FlameGraph repository if it doesn't exist
if [ ! -d "FlameGraph" ]; then
    echo "[*] Cloning FlameGraph tools..."
    git clone https://github.com/brendangregg/FlameGraph.git
fi

echo "[*] --- 2. Baseline Benchmark Execution & Profiling ---"
# Profile the unoptimized baseline script using cpu-clock events at 999 Hz
perf record -e cpu-clock -F 999 -g -- python3-dbg run_benchmark.py

# Export the baseline performance data to a readable text report
perf report --stdio > report_pyflate_baseline.txt
echo "[+] Baseline report saved to report_pyflate_baseline.txt"

echo "[*] --- 3. Flame Graph Generation ---"
# Convert perf.data into a flame graph SVG
perf script > out.perf
./FlameGraph/stackcollapse-perf.pl out.perf > out.folded
./FlameGraph/flamegraph.pl out.folded > pyflate_flamegraph.svg
echo "[+] Flame graph saved to pyflate_flamegraph.svg"

echo "[*] --- 4. Post-Optimization Execution & Comparison ---"
# Profile the optimized pyflate script
perf record -e cpu-clock -F 999 -g -- python3-dbg run_benchmark_opt.py

# Export the optimized performance data
perf report --stdio > report_pyflate_opt.txt
echo "[+] Optimized report saved to report_pyflate_opt.txt"

echo "[*] --- 5. Cleanup ---"
# Clean up temporary parsing files
rm out.perf out.folded
echo "[+] Pyflate execution complete! Compare the reports to see the ~13% speedup."