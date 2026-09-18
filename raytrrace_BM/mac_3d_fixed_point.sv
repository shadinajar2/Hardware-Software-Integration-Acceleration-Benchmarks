module mac_3d_fixed_point #(
    // Using a 32-bit fixed-point format (e.g., Q16.16)
    parameter WIDTH = 32
)(
    input  logic clk,
    input  logic rst_n,
    
    // Vector A inputs
    input  logic signed [WIDTH-1:0] ax, ay, az,
    // Vector B inputs
    input  logic signed [WIDTH-1:0] bx, by, bz,
    
    // Result
    // Multiplication doubles the bit width
    output logic signed [(WIDTH*2)-1:0] dot_product
);

    // --- Pipeline Stage 1: Multiplication Registers ---
    logic signed [(WIDTH*2)-1:0] mult_x;
    logic signed [(WIDTH*2)-1:0] mult_y;
    logic signed [(WIDTH*2)-1:0] mult_z;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mult_x <= '0;
            mult_y <= '0;
            mult_z <= '0;
        end else begin
            // Compute the partial products
            mult_x <= ax * bx;
            mult_y <= ay * by;
            mult_z <= az * bz;
        end
    end

    // --- Pipeline Stage 2: Accumulation Register ---
    logic signed [(WIDTH*2)-1:0] sum_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= '0;
        end else begin
            // Sum the partial products to get the dot product
            sum_reg <= mult_x + mult_y + mult_z;
        end
    end

    // Assign final output
    assign dot_product = sum_reg;

endmodule
