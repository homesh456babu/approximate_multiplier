`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2025 11:11:39
// Design Name: 
// Module Name: multiplier_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module exact_half_adder(a,b,sum,carry);
input a,b;
output sum,carry;
assign sum = a^b;
assign carry = a&b;
endmodule

module exact_full_adder(a,b,c,sum,carry);
input a,b,c;
output sum,carry;
assign sum = a^b^c;
assign carry = (a&b)|(b&c)|(c&a);
endmodule

module approx_half_adder(a,b,sum,carry);
input a,b;
output sum,carry;
assign sum = a|b;
assign carry = a&b;
endmodule

module approx_full_adder(a,b,c,sum,carry);
input a,b,c;
output sum,carry;
assign carry = (a&b)|(b&c);
assign sum = (a^b) | c;
endmodule


module approx_4_compressor(a,b,c,d,sum,carry);
input a,b,c,d;
output sum,carry;
assign sum = (a ^ b) | (c ^ d);
assign carry =  (a & (b | c | d)) | (b & (c | d)) | (c & d);
endmodule

module exact_4_compressor(a,b,c,d,cin,sum,carry,cout);
input a,b,c,d,cin;
output sum,carry,cout;
wire w1;
exact_full_adder x1(.a(a),.b(b),.c(c),.sum(w1),.carry());
assign cout = a&b&c&d;
exact_full_adder x2(.a(w1),.b(d),.c(cin),.sum(sum),.carry(carry));
endmodule

module multiplier_1 (A,B,result);
input [3:0] A,B;
output [7:0] result;
wire [3:0] p1 ,p2, p3, p4;
wire [6:0] x1;
wire [6:0] x2;
assign p1={4{B[0]}}&A;
assign p2={4{B[1]}}&A;
assign p3={4{B[2]}}&A;
assign p4={4{B[3]}}&A;
assign x1[0]=p1[0];
assign x2[0]=1'b0;
assign x2[1]=1'b0;
approx_half_adder uo(.a(p1[1]),.b(p2[0]),.sum(x1[1]),.carry(x1[2]));
approx_full_adder u1(.a(p1[2]),.b(p2[1]),.c(p3[0]),.sum(x2[2]),.carry(x1[3]));
approx_4_compressor u2(.a(p1[3]),.b(p2[2]),.c(p3[2]),.d(p4[0]),
                        .sum(x2[3]),.carry(x1[4]));             
exact_full_adder u4(.a(p2[3]),.b(p3[2]),.c(p4[1]),.sum(x2[4]),.carry(x1[5]));
exact_half_adder u5(.a(p3[3]),.b(p4[2]),.sum(x2[5]),.carry(x1[6]));
assign x2[6]=p4[3];
assign result= x1+x2;
endmodule


