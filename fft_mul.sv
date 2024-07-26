
//////////////////////////////////////////////////////////////////////
//
// Proprietary to PIMIC Inc.
// Copyright 2022, PIMIC Inc., All Rights Reserved.
//
// File name     : fft_mult.sv
// Author        :                      
// Description   : Merges the dnn mask results with FFT buffer to produce the noise reduced 
//                 audio output
//
//////////////////////////////////////////////////////////////////////
////`include "sonoma_defines.svh"

module fft_mult # (
    parameter DATA_WIDTH = 32
)
(

input        [DATA_WIDTH-1:0]   data1_i,
input        [DATA_WIDTH-1:0]   data2_i,
output logic [DATA_WIDTH-1:0]   mulout_o

);
reg          [2*DATA_WIDTH-1:0] product;
reg          [2*DATA_WIDTH-1:0] product_round;

reg          sign_bit;

wire      [DATA_WIDTH-1:0]   first_number;   
wire      [DATA_WIDTH-1:0]   second_number; 

assign   first_number = (data1_i[DATA_WIDTH-1]== 1'b1) ? (~data1_i+1) : data1_i;
assign  second_number = (data2_i[DATA_WIDTH-1]== 1'b1) ? (~data2_i+1) : data2_i;

assign      sign_bit=  data1_i[DATA_WIDTH-1] ^ data2_i[DATA_WIDTH-1];


//assign product                     = data1_i[DATA_WIDTH-2:0] * data2_i[DATA_WIDTH-2:0];



//assign product                     = first_number * second_number;

assign product                     = data1_i * data2_i;

//assign Product_round               = Product[[2*DATA_WIDTH-3: DATA_WIDTH-2] + 1'b1 ;

assign product_round= sign_bit ? (~product+1) :product ; 


assign mulout_o[31]      = product_round[63] ;//data1_i[DATA_WIDTH-1] ^ data2_i[DATA_WIDTH-1];////1

//assign mulout_o[DATA_WIDTH-2 :0 ]  = Product_round[2*DATA_WIDTH-3 : DATA_WIDTH -1];
//assign mulout_o[DATA_WIDTH-2 :0 ]  = product_round[62:31];   //used upper one bit to accomodate overflow after scaling 

assign mulout_o[30:0]  = product_round[62:31];  ////1

//assign mulout_o[31:0]  = product_round[31:0]; /////2
endmodule

//////////////////////////////////////////

