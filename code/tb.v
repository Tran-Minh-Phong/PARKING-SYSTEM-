`timescale 1ns / 1ps
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
    wire led_sensor_a;
    wire led_sensor_b;

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
        .led_EMPTY(led_EMPTY),
        .led_sensor_a(led_sensor_a),
        .led_sensor_b(led_sensor_b)

    );
    always #5 clk = ~clk; // Clock generation
    
    initial begin 
        $monitor ("Time: %0t | Sensor A: %b | Sensor B: %b | Enter: %b | Exit: %b | Count: %d | S0: %b | S1: %b | S2: %b | S3: %b", 
                 $time, sensor_a, sensor_b, enter, exit, count, led_S0, led_S1, led_S2, led_S3);
        end
    // In sự kiện
    always @(posedge clk) begin
        if (enter)
            $display(">>> XE VAO  | t=%0t | count=%d", $time, count);
        if (exit)
            $display("<<< XE RA   | t=%0t | count=%d", $time, count);
        if (led_FULL)
            $display("*** FULL    | t=%0t | count=%d", $time, count);
        if (led_EMPTY)
            $display("*** EMPTY   | t=%0t | count=%d", $time, count);
    end
  
        // xe vào
        task car_in;
       begin
            @(posedge clk); sensor_a = 1; sensor_b = 0; 
            repeat(2) @(posedge clk); sensor_b = 1;
            repeat(2) @(posedge clk); sensor_a = 0; 
            repeat(2) @(posedge clk); sensor_b = 0;
            $display("==> [TB] Hoan thanh chu trinh XE VAO");
        end
        endtask
        // xe ra
        task car_out;
       begin
            @(posedge clk); sensor_a = 0; sensor_b = 1;
            repeat(2) @(posedge clk); sensor_a = 1;
            repeat(2) @(posedge clk); sensor_b = 0;
            repeat(2) @(posedge clk); sensor_a = 0; 
            $display("==> [TB] Hoan thanh chu trinh XE RA");
        end
        endtask
              // Initialize inputs
        initial begin
        clk = 0;
        rst = 1; // Reset the system
        sensor_a = 0;
        sensor_b = 0;

        // Wait for a few clock cycles
        #10 rst = 0; // Release reset

        // Test đếm đến 15
        repeat (15) car_in();
        #20;
        // Test không cho xe vào khi đã đầy
        car_in();  
        #20;
        // Test đếm đến 0
        repeat (15) car_out();
        

        #100 $finish; // End simulation after some time
    end

endmodule
