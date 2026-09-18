`timescale 1ns/1ps

module tb_mac_3d_fixed_point;

    localparam WIDTH = 32;

    logic clk;
    logic rst_n;
    
    logic signed [WIDTH-1:0] ax, ay, az;
    logic signed [WIDTH-1:0] bx, by, bz;
    
    logic signed [(WIDTH*2)-1:0] dot_product;

    // Instantiate the Device Under Test (DUT)
    mac_3d_fixed_point #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .ax(ax), .ay(ay), .az(az),
        .bx(bx), .by(by), .bz(bz),
        .dot_product(dot_product)
    );

    // 10ns Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        ax = 0; ay = 0; az = 0;
        bx = 0; by = 0; bz = 0;

        // Release Reset
        #15 rst_n = 1;

        // --- Test Case 1: Positive Integers ---
        @(posedge clk);
        ax = 1; ay = 2; az = 3;
        bx = 4; by = 5; bz = 6;
        
        // Wait 2 cycles for pipeline latency
        @(posedge clk);
        @(posedge clk);
        #1; // Delay slightly to read stable output
        $display("Test 1: Vector(1,2,3) dot Vector(4,5,6)");
        $display("Expected: 32 | Actual: %0d", dot_product);

        // --- Test Case 2: Negative Integers ---
        @(posedge clk);
        ax = -2; ay = 4; az = -1;
        bx = 3;  by = 2; bz = -5;
        
        @(posedge clk);
        @(posedge clk);
        #1;
        $display("Test 2: Vector(-2,4,-1) dot Vector(3,2,-5)");
        $display("Expected: 7 | Actual: %0d", dot_product);

        #10 $finish;
    end

endmodule
