

//////////////////////////////////////////////////////////////////////
//
// Proprietary to PIMIC Inc.
// Copyright 2022, PIMIC Inc., All Rights Reserved.
//
// File name     : fft_get_negative.sv
// Author        :                      
// Description   :
//
//////////////////////////////////////////////////////////////////////
////`include "sonoma_defines.svh"

module fft_get_negative #
(
  parameter DATA_WIDTH = 32
)
(
input   [DATA_WIDTH-1:0] datain_i,
output  [DATA_WIDTH-1:0] dataout_o
);
 ////1assign dataout_o = {~datain_i[DATA_WIDTH-1] , datain_i[DATA_WIDTH-2:0]};
 
 assign dataout_o = ~datain_i + 1'b1;
 
 
endmodule
