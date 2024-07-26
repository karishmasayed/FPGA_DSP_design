

module fft_adder #
(
  parameter DATA_WIDTH      = 32
)
(
input   logic    [DATA_WIDTH-1:0]   data1_i,   // input data format Q(1)(31) 
input   logic    [DATA_WIDTH-1:0]   data2_i,   // input data format Q(1)(31) 
output  logic   [DATA_WIDTH-1:0]   sumout_o,   // output data format Q(1)(31)
output  logic                      overflow 
);
// Internal signals
    wire signed [32:0] extended_data1;
    wire signed [32:0] extended_data2;
    
    wire signed [32:0] full_sum;
    wire data1_zero;
    wire data2_zero;
    

wire [31:0] total_sum;
assign extended_data1 = {data1_i[31],data1_i};
assign extended_data2 = {data2_i[31],data2_i};

//assign extended_data1 = {data1_i,data1_i};
//assign extended_data2 = {1'b0,data2_i};

assign data1_zero = (data1_i == 32'h00000000)? 1'b1 : 1'b0;
assign data2_zero = (data2_i == 32'h00000000)? 1'b1 : 1'b0;

      always @(*) begin
       if ((data1_i[31] == 0 && data2_i[31] == 0 && full_sum[32] == 1)||(data1_i[31] == 1 && data2_i[31] == 1 && full_sum[32] == 0)) begin
           sumout_o = full_sum[32:1];
           overflow = 1;
           end
        else begin  
             overflow = 0;
             sumout_o = full_sum[31:0];          
     end
end
/*

     always @(*) begin
        if ((full_sum[32] == 1'b1)) begin
                sumout_o = full_sum[32:1];
                overflow = 1;
                end
            else begin
                 sumout_o = full_sum[31:0];
                 overflow = 0;
                 end 
            end       
    */


    // Perform addition
    assign full_sum = extended_data1 + extended_data2;

      // Detect overflow (when the sign of the sum is different from the sign of the inputs)
      /*
       always @(*) begin
        if ((data1_i[31] == data2_i[31]) && (data1_i[31] != sumout_o[31])) begin
            overflow <= 1;
        end else begin
            overflow <= 0;
        end
    end
    */
    
    

endmodule
