

//////////////////////////////////////////////////////////////////////
//
// Proprietary to PIMIC Inc.
// Copyright 2022, PIMIC Inc., All Rights Reserved.
//
// File name     : butterfly.sv
// Author        :                      
// Description   : 
//////////////////////////////////////////////////////////////////////

module fft_butterfly_stage_2 #(
   parameter DATA_WIDTH = 32
)
(
input                    clk,               //system clock
input                    rst_n,             //activelow async reset
input                    fft_ifft,          //config input 0: FFT 1:IFFT

input  [DATA_WIDTH-1:0]  in0_r,             //input0 real data         
input  [DATA_WIDTH-1:0]  in0_i,             //input0 imaginary data
input  [DATA_WIDTH-1:0]  in1_r,             //input1 real data
input  [DATA_WIDTH-1:0]  in1_i,             //input1 imaginary data
input  [DATA_WIDTH-1:0]  twiddle_r,         //twiddle factor real 
input  [DATA_WIDTH-1:0]  twiddle_i,         //twiddle factor imaginary 

output [DATA_WIDTH-1:0]  out0_st2_r,            //output0 real
output [DATA_WIDTH-1:0]  out0_st2_i,            //output0 imaginary
output [DATA_WIDTH-1:0]  out1_st2_r,            //output1 real
output [DATA_WIDTH-1:0]  out1_st2_i             //output1 imaginary

);



logic  [DATA_WIDTH-1:0]  out0_st1_r,            //output0 real
logic  [DATA_WIDTH-1:0]  out0_st1_i,            //output0 imaginary
logic  [DATA_WIDTH-1:0]  out1_st1_r,            //output1 real
logic  [DATA_WIDTH-1:0]  out1_st1_i;             //output1 imaginary



logic  [DATA_WIDTH-1:0] CF_mult_n;
logic  [DATA_WIDTH-1:0] DE_mult_n;

logic  [DATA_WIDTH-1:0] negCF_negDE_adder;
logic  [DATA_WIDTH-1:0] negCE_DF_adder;
logic  [DATA_WIDTH-1:0] CE_mult_n;

logic  [DATA_WIDTH-1:0] CE_mult;
logic  [DATA_WIDTH-1:0] CF_mult;
logic  [DATA_WIDTH-1:0] DE_mult;
logic  [DATA_WIDTH-1:0] DF_mult;
logic  [DATA_WIDTH-1:0] DF_mult_n;
logic  [DATA_WIDTH-1:0] CE_negDF_adder;
logic  [DATA_WIDTH-1:0] CF_DE_adder;
logic  [DATA_WIDTH-1:0] CE_negDF_adder_n;
logic  [DATA_WIDTH-1:0] CF_DE_adder_n;

logic  [DATA_WIDTH-1:0] out0_r_i;
logic  [DATA_WIDTH-1:0] out0_i_i;
logic  [DATA_WIDTH-1:0] out1_r_i;
logic  [DATA_WIDTH-1:0] out1_i_i;


logic out0_r_shifted;
logic out0_i_shifted;
logic out1_r_shifted;
logic out1_i_shifted;

assign out0_st1_r = (out0_r_shifted)? out0_r_i[31:0] : {out0_r_i[31],out0_r_i[31:1]};
assign out0_st1_i = (out0_i_shifted)? out0_i_i[31:0] : {out0_i_i[31],out0_i_i[31:1]};
assign out1_st1_r = (out1_r_shifted)? out1_r_i[31:0] : {out1_r_i[31],out1_r_i[31:1]};
assign out1_st1_i = (out1_i_shifted)? out1_i_i[31:0] : {out1_i_i[31],out1_i_i[31:1]};



fft_butterfly #( .DATA_WIDTH(DATA_WIDTH))
 BUTTERFLY_1
(
.clk(clk),
.rst_n(rst_n),
.fft_ifft(fft_ifft),
.in0_r(out0_st1_r),.in0_i(out0_st1_i),
.in1_r(out1_st1_r),.in1_i(out1_st1_i),
.twiddle_r(32'h7ff62183),.twiddle_i(32'h03242abf),
.out0_r(out0_st2_r),.out0_i(out0_st2_i),
.out1_r(out1_st2_r),.out1_i(out1_st2_i)
);


   //  Multiply in1 real with twiddle real
   fft_mult  #(.DATA_WIDTH (DATA_WIDTH))
   mult_1
   (
      .data1_i         (in1_r ) ,
      .data2_i         (twiddle_r),
      .mulout_o        (CE_mult)//mult1_out)
      );


   //  Multiply in real with twiddle imaginary
   fft_mult  #(.DATA_WIDTH(DATA_WIDTH))
   mult_2
   (
      .data1_i         (in1_r),
      .data2_i         (twiddle_i),
      .mulout_o        (CF_mult)//mult2_out)
   );

   //  Multiply in1 imaginary with twiddle real
   fft_mult  #( .DATA_WIDTH(DATA_WIDTH))
   mult_3
   (
      .data1_i         (in1_i),
      .data2_i         (twiddle_r),
      .mulout_o        (DE_mult)//mult3_out)
   );

   //  Multiply in1 imaginary with twiddle imaginary
   fft_mult  #( .DATA_WIDTH(DATA_WIDTH) )
   mult_4
   (
       .data1_i        (in1_i),
       .data2_i        (twiddle_i),
       .mulout_o       (DF_mult)//mult4_out)
   );

  fft_get_negative #( .DATA_WIDTH(DATA_WIDTH) )
  neg_1
  (
       .datain_i       (DF_mult),//mult1_out),
       .dataout_o      (DF_mult_n)
  );
  
    fft_get_negative #( .DATA_WIDTH(DATA_WIDTH) )
  neg_10
  (
       .datain_i       (CF_mult),//mult1_out),
       .dataout_o      (CF_mult_n)
  );

    fft_get_negative #( .DATA_WIDTH(DATA_WIDTH) )
  neg_2
  (
       .datain_i       (DE_mult),//mult1_out),
       .dataout_o      (DE_mult_n)
  );

 fft_adder # (
      .DATA_WIDTH(DATA_WIDTH)
  )
  add_1
  (
      .data1_i         (CF_mult_n),//add_1_d1), 
      .data2_i         (DE_mult_n),//add_1_d2), 
      .sumout_o        (negCF_negDE_adder),// add_1_out -Mul sub real of lower BF arm
      .overflow        ()  
  );

  fft_adder # (
      .DATA_WIDTH(DATA_WIDTH)
  )
  add_2
  (
      .data1_i         (CE_mult),//add_1_d1), 
      .data2_i         (DF_mult_n),//add_1_d2), 
      .sumout_o        (CE_negDF_adder),// add_1_out -Mul sub real of lower BF arm
      .overflow        ()  
  );

  fft_adder # (
      .DATA_WIDTH(DATA_WIDTH)
  )
  add_3
  (
      .data1_i         (CE_mult_n),//add_1_d1), 
      .data2_i         (DF_mult),//add_1_d2), 
      .sumout_o        (negCE_DF_adder),// add_1_out -Mul sub real of lower BF arm
      .overflow        ()  
  );
  fft_adder # (
      .DATA_WIDTH(DATA_WIDTH)
  )
  add_4
  (
      .data1_i         (CF_mult),//add_2_d1), 
      .data2_i         (DE_mult),//add_2_d2), 
      .sumout_o        (CF_DE_adder),//add_2_out)  mul add imag of lower BF arm 
      .overflow        ()
  );

  fft_adder #(
      .DATA_WIDTH(DATA_WIDTH)
  )
  add_5
  (
      .data1_i         (in0_r),       //real term of output 0
      .data2_i         (CE_negDF_adder), 
      .sumout_o        (out0_r_i),  
      .overflow        (out0_r_shifted)
  );

  fft_adder #(
      .DATA_WIDTH(DATA_WIDTH)
  )
  add_6
  (
      .data1_i         (in0_i),    //imaginary term of output 0
      .data2_i         (CF_DE_adder), 
      .sumout_o        (out0_i_i),  
      .overflow        (out0_i_shifted)
  );


fft_get_negative #( .DATA_WIDTH(DATA_WIDTH) )
  neg_3
  (
       .datain_i       (CE_negDF_adder),
       .dataout_o      (CE_negDF_adder_n)
  );
  


fft_get_negative #( .DATA_WIDTH(DATA_WIDTH) )
  neg_5
  (
       .datain_i       (CF_DE_adder),
       .dataout_o      (CF_DE_adder_n)
  );


fft_adder #(
      .DATA_WIDTH(DATA_WIDTH)
  )
  add_8
  (
      .data1_i         (in0_r),           //real term of output 1
      .data2_i         (negCE_DF_adder), 
      .sumout_o        (out1_r_i),
      .overflow        (out1_r_shifted)
);

fft_adder #(
      .DATA_WIDTH(DATA_WIDTH)           // imaginary term of output 1
  )
  add_9
  (
      .data1_i         (in0_i), 
      .data2_i         (negCF_negDE_adder), 
      .sumout_o        (out1_i_i),  
      .overflow        (out1_i_shifted)    
);

   fft_get_negative #( .DATA_WIDTH(DATA_WIDTH) )///................NEEDED
  neg_6
  (
       .datain_i       (CE_mult),//mult1_out),
       .dataout_o      (CE_mult_n)
  );


endmodule


