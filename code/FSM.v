module PARKINGSYSTEM(
    input clk,
    input rst,
    input sensor_a,
    input sensor_b,
    output reg enter,
    output reg exit,
    output reg [3:0] count

    );
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg DIR; // 1: xe vào, 0: xe ra
    wire full;
    assign full=(count == 15);
    
    parameter S0 = 2'b00; //  không có cảm biến nào bật
    parameter S1 = 2'b01; //  1 cảm biến bật (có 1 xe vào hoặc ra) 
    parameter S2 = 2'b10; //  cả 2 cảm biến bật
    parameter S3 = 2'b11; //  xe rời cảm bién
    parameter IN = 1'b1; // xe vào
    parameter OUT = 1'b0; // xe ra
    
    // 1. Cập nhật trạng thái hiện tại
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= S0;
        end  
        else current_state <= next_state;
    end
    // 2. Xác định trạng thái tiếp theo và cập nhật đếm xe
    always @(*) begin
        next_state = current_state; // Giữ nguyên trạng thái nếu không có thay đổi
            case (current_state)
                S0: begin
                if (sensor_a ^ sensor_b) begin 
                    if (sensor_a && full) next_state = S0; // không cho xe vào nếu đã đầy
                    else next_state = S1;   
                    end
                end
                S1: begin
                if (sensor_a & sensor_b) next_state = S2;
                else if (~sensor_a & ~sensor_b) next_state = S0;
                else next_state = S1; // vẫn ở trạng thái S1 nếu chỉ có 1 cảm biến bật
                end
                S2: begin
                case ({sensor_a, sensor_b})
                    2'b11: next_state = S2;
                    2'b00: next_state = S0;
                    2'b01: next_state = DIR ? S3 : S1;
                    2'b10: next_state = DIR ? S1 : S3;
                endcase
                end
                S3: begin
                case ({sensor_a ,sensor_b})
                    2'b00: next_state = S0;
                    2'b11: next_state = S2;
                    default: next_state = S3; // vẫn ở trạng thái S3 nếu chỉ có 1 cảm biến bật
                endcase
                end
                default: next_state = S0;
            endcase
    end
    // 3. xác định hướng di chuyển của xe
    always @(posedge clk or negedge rst) begin
        if (!rst) DIR <= IN;
        else if (current_state == S0 && next_state == S1) begin
                if (sensor_a && !sensor_b) DIR <= IN; // xe vào
                else if (!sensor_a && sensor_b) DIR <= OUT; // xe ra
        end 
    end
    // 4. Cập nhật tín hiệu enter , exit và đếm xe
    always @(posedge clk or negedge rst) begin
    if (!rst) begin
        enter <= 0;
        exit  <= 0;
        count <= 0;
    end else begin
        enter <= 0;
        exit  <= 0;

        // Xe vừa hoàn thành đi qua cảm biến
        if (current_state == S3 && sensor_a == 0 && sensor_b == 0) begin
            if (DIR) begin // Xe vào
                enter <= 1;
                if (count < 15) count <= count + 1;
            end else begin // Xe ra
                exit <= 1;
                if (count > 0) count <= count - 1;
            end
        end
    end
end
endmodule
