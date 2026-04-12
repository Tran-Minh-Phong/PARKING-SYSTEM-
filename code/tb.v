`timescale 1ns / 1ps
module tb;

    reg clk;
    reg rst;
    reg sensor_a;
    reg sensor_b;
    wire enter;
    wire exit;
    wire [3:0] count;

    PARKINGSYSTEM uut (
        .clk(clk),
        .rst(rst),
        .sensor_a(sensor_a),
        .sensor_b(sensor_b),
        .enter(enter),
        .exit(exit),
        .count(count)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Dump waveform
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);

        $monitor ("Time: %0t | A: %b | B: %b | Enter: %b | Exit: %b | Count: %d", 
                 $time, sensor_a, sensor_b, enter, exit, count);
    end

    // In sự kiện
    always @(posedge clk) begin
        if (enter)
            $display(">>> XE VAO  | t=%0t | count=%d", $time, count);
        if (exit)
            $display("<<< XE RA   | t=%0t | count=%d", $time, count);
    end

    // Xe vào
    task car_in;
    begin
        @(posedge clk); sensor_a = 1; sensor_b = 0;
        @(posedge clk); sensor_b = 1;
        @(posedge clk); sensor_a = 0;
        @(posedge clk); sensor_b = 0;
    end
    endtask

    // Xe ra
    task car_out;
    begin
        @(posedge clk); sensor_b = 1; sensor_a = 0;
        @(posedge clk); sensor_a = 1;
        @(posedge clk); sensor_b = 0;
        @(posedge clk); sensor_a = 0;
    end
    endtask

    initial begin
        rst = 0;
        sensor_a = 0;
        sensor_b = 0;

        #10 rst = 1;

        repeat (15) car_in(); // đầy
        car_in();             // thử vào khi full

        repeat (15) car_out(); // về 0

        #2000 $finish;
    end

endmodule
