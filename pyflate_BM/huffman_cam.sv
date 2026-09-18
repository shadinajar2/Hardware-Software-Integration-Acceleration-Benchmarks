module huffman_cam #(
    parameter TABLE_SIZE = 288, // Max symbols in Bzip2 dynamic table
    parameter MAX_BITS = 16,    // Max Huffman bit-length
    parameter ADDR_WIDTH = 9    // $clog2(TABLE_SIZE)
)(
    input  logic                  clk,
    input  logic                  rst_n,
    
    // Configuration Interface (Software loads the table)
    input  logic                  config_we,
    input  logic [ADDR_WIDTH-1:0] config_sym_addr,
    input  logic [MAX_BITS-1:0]   config_code,
    input  logic [4:0]            config_len,
    
    // Stream Interface (Software queries the bitstream)
    input  logic [MAX_BITS-1:0]   bitstream_peek,
    output logic                  match_valid,
    output logic [ADDR_WIDTH-1:0] match_symbol,
    output logic [4:0]            match_len
);

    // Internal Storage: Code and Length arrays
    logic [MAX_BITS-1:0] table_codes [0:TABLE_SIZE-1];
    logic [4:0]          table_lengths [0:TABLE_SIZE-1];

    // Synchronous write for configuration
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < TABLE_SIZE; i++) begin
                table_lengths[i] <= '0;
            end
        end else if (config_we) begin
            table_codes[config_sym_addr] <= config_code;
            table_lengths[config_sym_addr] <= config_len;
        end
    end

    // Combinational parallel matching logic
    always_comb begin
        match_valid  = 1'b0;
        match_symbol = '0;
        match_len    = '0;

        for (int i = 0; i < TABLE_SIZE; i++) begin
            // Dynamically generate mask based on the symbol's bit length
            // Example: length 5 -> mask 0x001F
            logic [MAX_BITS-1:0] mask;
            mask = (1 << table_lengths[i]) - 1;

            // Check if valid entry AND bitstream matches prefix code
            if (table_lengths[i] > 0 && (bitstream_peek & mask) == table_codes[i]) begin
                match_valid  = 1'b1;
                match_symbol = i;
                match_len    = table_lengths[i];
            end
        end
    end

endmodule
