================================================================================
Hardware/Software Integration & Acceleration Benchmarks
================================================================================

Shadi Najar - 213557143
Basel Qassem - 324937036

================================================================================
1. PROJECT OVERVIEW
================================================================================
This repository contains the profiling, software optimization, and hardware 
acceleration proposals for two highly CPU-bound Python workloads: 
1. Raytrace (3D light path physics rendering)
2. Pyflate (Bzip2 decompression and Huffman decoding)

For each benchmark, the baseline execution was profiled using Linux `perf` and 
Flame Graphs. Software bottlenecks (such as dynamic memory allocation and O(N) 
interpreter loops) were optimized in pure Python. Finally, custom SystemVerilog 
hardware accelerators were designed and simulated to resolve the remaining 
computational bottlenecks.

================================================================================
2. DIRECTORY LAYOUT
================================================================================

.
├── AI Tool Prompts.txt          # Documentation of LLM prompts and workflow
│
├── raytrrace_BM/                # Benchmark 1: 3D Raytrace
│   ├── report_raytrace.txt      # Full analysis, profiling, and HW/SW proposal
│   ├── script_raytrace.sh       # Bash script to automate SW profiling & Flame Graphs
│   ├── script_hw_raytrace.sh    # Bash script to compile and simulate SystemVerilog
│   ├── mac_3d_fixed_point.sv    # HW Accelerator: 2-Stage Fixed-Point MAC Engine
│   └── tb_mac_3d_fixed_point.sv # Testbench for the MAC Engine
│
└── pyflate_BM/                  # Benchmark 2: Pyflate (Bzip2)
    ├── report_pyflate.txt       # Full analysis, profiling, and HW/SW proposal
    ├── script_pyflate.sh        # Bash script to automate SW profiling & Flame Graphs
    ├── script_hw_pyflate.sh     # Bash script to compile and simulate SystemVerilog
    ├── huffman_cam.sv           # HW Accelerator: Huffman VLD CAM
    └── tb_huffman_cam.sv        # Testbench for the Huffman CAM

*(Note: Ensure that the respective baseline `run_benchmark.py` and optimized 
`run_benchmark_opt.py` scripts are placed inside each benchmark directory before 
running the software execution scripts).*

================================================================================
3. EXECUTION INSTRUCTIONS
================================================================================

All scripts are designed to run in a Linux environment (e.g., Ubuntu QEMU).

A. Software Profiling & Flame Graph Generation
To run the profiling, optimization comparisons, and generate the SVG flame graphs:
1. Navigate to the desired benchmark folder.
2. Grant execution permissions:
   $ chmod +x script_raytrace.sh
3. Execute the script:
   $ ./script_raytrace.sh

B. Hardware Simulation (SystemVerilog)
To compile and simulate the hardware accelerators (requires Icarus Verilog):
1. Navigate to the desired benchmark folder.
2. Grant execution permissions:
   $ chmod +x script_hw_raytrace.sh
3. Execute the script:
   $ ./script_hw_raytrace.sh