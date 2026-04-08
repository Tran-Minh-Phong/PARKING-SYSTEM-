module decoder (
  input wire [3:0] so, 
  output reg [6:0] led
);
  
  always @(*) begin 
    case (so) 
      4'd0: led = 7'b0000001;
      4'd1: led = 7'b1001111;
      4'd2: led = 7'b0010010;
      4'd3: led = 7'b0000110;
      4'd4: led = 7'b1001100;
      4'd5: led = 7'b0100100;
      4'd6: led = 7'b0100000;
      4'd7: led = 7'b0001111;
      4'd8: led = 7'b0000000;
      4'd9: led = 7'b0000100;
      default: led = 7'b0000001;
    endcase
  end
endmodule