timescale 1ns / 1ps
module tb;
    reg clk;
    reg rst;
    reg sensor_a;
    reg sensor_b;
    wire enter;
    wire exit;
    wire [3:0] count;
    wire led_S0;
    wire led_S1;
    wire led_S2;
    wire led_S3;
    wire led_FULL;
    wire led_EMPTY;

    PARKINGSYSTEM uut (
        .clk(clk),
        .rst(rst),
        .sensor_a(sensor_a),
        .sensor_b(sensor_b),
        .enter(enter),
        .exit(exit),
        .count(count),
        .led_S0(led_S0),
        .led_S1(led_S1),
        .led_S2(led_S2),
        .led_S3(led_S3),
        .led_FULL(led_FULL),
        .led_EMPTY(led_EMPTY)
    );

    initial begin 
        $monitor ("Time: %0t | Sensor A: %b | Sensor B: %b | Enter: %b | Exit: %b | Count: %d | S0: %b | S1: %b | S2: %b | S3: %b | FULL: %b | EMPTY: %b", 
                 $time, sensor_a, sensor_b, enter, exit, count, led_S0, led_S1, led_S2, led_S3, led_FULL, led_EMPTY);
        // Initialize inputs
        clk = 0;
        rst = 1; // Reset the system
        sensor_a = 0;
        sensor_b = 0;

        // Wait for a few clock cycles
        #10 rst = 0; // Release reset

        // xe vào
        #20 sensor_a = 1; sensor_b = 0; 
        #20 sensor_a = 1; sensor_b = 1;
        #20 sensor_b = 1; sensor_a = 0; 
        #20 sensor_a = 0; sensor_b = 0;

        // xe ra
        #20 sensor_a = 0; sensor_b = 1;
        #20 sensor_a = 1; sensor_b = 1;
        #20 sensor_a = 1; sensor_b = 0;
        #20 sensor_a = 0; sensor_b = 0; 

        // Test đi đến 2 lùi lại
        #20 sensor_a = 1; sensor_b = 0; 
        #20 sensor_a = 1; sensor_b = 1;
        #20 sensor_a = 1; sensor_b = 0; 
        #20 sensor_a = 0; sensor_b = 0;
        // đi đến S3 xong lùi lại
        #20 sensor_a = 1; sensor_b = 0; 
        #20 sensor_a = 1; sensor_b = 1;
        #20 sensor_a = 0; sensor_b = 1; 
        #20 sensor_a = 1; sensor_b = 1;
        #20 sensor_a = 1; sensor_b = 0; 
        #20 sensor_a = 0; sensor_b = 0;
        // Test đếm đến 15
        repeat (15) begin
            #20 sensor_a = 1; sensor_b = 0; 
            #20 sensor_a = 1; sensor_b = 1;
            #20 sensor_a = 0; sensor_b = 0;
        end 

        #100 $finish; // End simulation after some time
    end

    always #5 clk = ~clk; // Clock generation
endmodule