
module tb;
reg a;
reg b;  
wire d;
add uut(.a(a),.b(b),.d(d)); 
initial begin
a=0;    
b=0;
$display("a=%b b=%b d=%b", a, b, d);
#10 a=0;        
b=1;
$display("a=%b b=%b d=%b", a, b, d);   
#10 a=1;                
b=0;
$display("a=%b b=%b d=%b", a, b, d);
#10 a=1;
b=1;
$display("a=%b b=%b d=%b", a, b, d);
#10 $finish;
end 
endmodule   
