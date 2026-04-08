`include "decimal.v"
`include "decoder.v"
module counter_decoder (
  input wire [3:0] count,
  output wire [6:0] led_chuc,
  output wire [6:0] led_dv
);
  wire [3:0] so_chuc,so_dv;
  decimal decimal(.count(count),.so_chuc(so_chuc),.so_dv(so_dv));
  decoder chuc (.so(so_chuc),.led(led_chuc));
  decoder  dv   (.so(so_dv),.led(led_dv));           
endmodule
