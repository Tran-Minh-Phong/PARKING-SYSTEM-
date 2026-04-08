module decimal(

  input  wire [3:0] count,

  output wire [3:0] so_chuc,

  output wire [3:0] so_dv

);

  reg [11:0] num;

  always @(*) begin
  // 4 bit hàng đơn vị, 4 bit hàng chục, 4 bit của số, ghép lại chuẩn bị dịch
    num = {4'b0000,4'b0000,count};
    
    // theo nháp thì dịch 3 lần là xong số 15

    for (int i = 0; i < 4; i++) begin 

      // nếu hàng đơn vị lớn hơn 4 thì +3 để không tràn bit

      if(num[7:4] > 4) num [7:4] = num [7:4] + 3;

      // dịch 1 bit qua trái mỗi lần lặp

      num = num << 1;

  end

  end

  assign so_chuc = num [11:8];

  assign so_dv   = num [7:4];

endmodule