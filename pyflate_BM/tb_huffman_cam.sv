`timescale 1ns / 1ps

module tb_huffman_cam;

    // Parameters matching the DUT
    localparam TABLE_SIZE = 288;
    localparam MAX_BITS = 16;
    localparam ADDR_WIDTH = 9;

    // DUT Signals
    logic                  clk;
    logic                  rst_n;
    
    logic                  config_we;
    logic [ADDR_WIDTH-1:0] config_sym_addr;
    logic [MAX_BITS-1:0]   config_code;
    logic [4:0]            config_len;
    
    logic [MAX_BITS-1:0]   bitstream_peek;
    logic                  match_valid;
    logic [ADDR_WIDTH-1:0] match_symbol;
    logic [4:0]            match_len;

    // Instantiate the Device Under Test (DUT)
    huffman_cam #(
        .TABLE_SIZE(TABLE_SIZE),
        .MAX_BITS(MAX_BITS),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .config_we(config_we),
        .config_sym_addr(config_sym_addr),
        .config_code(config_code),
        .config_len(config_len),
        .bitstream_peek(bitstream_peek),
        .match_valid(match_valid),
        .match_symbol(match_symbol),
        .match_len(match_len)
    );

    // 100 MHz Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Sanity Check Test Sequence
    initial begin
        // 1. Initialize Signals
        rst_n = 0;
        config_we = 0;
        config_sym_addr = 0;
        config_code = 0;
        config_len = 0;
        bitstream_peek = 0;

        // Apply Reset
        #20 rst_n = 1;
        #10;

        $display("--- Starting Huffman CAM Sanity Check ---");

        // ==========================================
        // PHASE 1: Software Configures the CAM
        // ==========================================
        $display("[Phase 1] Programming Huffman Tables...");
        
        // Program Symbol 65 ('A') with 5-bit code 11010 (0x1A)
        @(posedge clk);
        config_we = 1;
        config_sym_addr = 9'd65;
        config_code = 16'h001A;
        config_len = 5'd5;

        // Program Symbol 66 ('B') with 8-bit code 10101010 (0xAA)
        @(posedge clk);
        config_sym_addr = 9'd66;
        config_code = 16'h00AA;
        config_len = 5'd8;

        // Disable write enable
        @(posedge clk);
        config_we = 0;
        #20;

        // ==========================================
        // PHASE 2: Decompression Loop Queries
        // ==========================================
        $display("[Phase 2] Executing Bitstream Queries...");

        // Query 1: Peek bitstream containing 'A'
        // Bitstream: 1111_0000_0001_1010 (0xF01A). 
        // The CAM should ignore the upper 11 bits and match the lower 5.
        @(posedge clk);
        bitstream_peek = 16'hF01A; 
        #1; // Wait for combinational logic to settle
        if (match_valid && match_symbol == 65 && match_len == 5)
            $display("  PASS: Symbol 'A' (65) matched correctly ignoring upper bits.");
        else
            $display("  FAIL: Symbol 'A' failed to match.");

        // Query 2: Peek bitstream containing 'B'
        // Bitstream: 1111_1111_1010_1010 (0xFFAA)
        @(posedge clk);
        bitstream_peek = 16'hFFAA;
        #1;
        if (match_valid && match_symbol == 66 && match_len == 8)
            $display("  PASS: Symbol 'B' (66) matched correctly.");
        else
            $display("  FAIL: Symbol 'B' failed to match.");

        // Query 3: Peek an unprogrammed sequence (No Match)
        @(posedge clk);
        bitstream_peek = 16'h0000;
        #1;
        if (!match_valid)
            $display("  PASS: Correctly asserted match_valid=0 for unknown sequence.");
        else
            $display("  FAIL: False positive match detected.");

        #20;
        $display("--- Sanity Check Complete ---");
        $finish;
    end

endmodule
