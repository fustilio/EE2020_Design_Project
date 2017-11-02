`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 03:49:16 PM
// Design Name: 
// Module Name: task_selector
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


module task_selector(
    input CLK,
    input [11:0] MIC_in,
    input [15:0] sw,
    input [4:0] btn,
    output [15:0] led_selected,
    output [3:0] an_selected,
    output [6:0] seg_selected,
    output dp_selected,
    output [11:0] speaker_selected
    );
    
    wire clk_100;
    wire clk_20k3b;
    wire clk_30k3b;
    wire clk_50k3b;

    FlexiClock cc100(100,CLK,clk_100);
    FlexiClock cc3b20k(20000,CLK,clk_20k3b);
    FlexiClock cc3b30k(30000,CLK,clk_30k3b);
    FlexiClock cc3b50k(50000,CLK,clk_50k3b);

    //Declare inter values
    reg [11:0] speaker_inter;
    reg [15:0] led_inter;
    reg [3:0] an_inter;
    reg [6:0] seg_inter;
    reg dp_inter;
    
    //Declare lab 2b values and module
    wire [15:0] led_twobout;
    wire [3:0] antwobout;
    wire [6:0] segtwobout;
    project_2b mpt(MIC_in, CLK, btn, led_twobout, antwobout, segtwobout);
    
    //Declare lab 3b values and module
    wire [11:0] mpthreeOut;
    project_3b taskthreeb(CLK, clk_20k3b, clk_30k3b, clk_50k3b, btn, mpthreeOut);
    
    always @(posedge CLK) begin
        if (sw[2]) begin
            // Assigns 3b speaker value to speaker
            speaker_inter <= mpthreeOut;
            // Default turns off LED and seven-segment
            led_inter <= 16'b0;
            an_inter <= 4'b1111;
            seg_inter <= 7'b1111111;
            dp_inter <= 1;
        end 
        else if (sw[1]) begin
            // Assigns 2b LED and seven-segment values
            led_inter <= led_twobout;
            an_inter <= antwobout;
            seg_inter <= segtwobout;
            dp_inter <= 1;
            // Default turns off speaker
            speaker_inter <= 0;
        end
        else begin
            speaker_inter <= 0;
            led_inter <= 0;
            an_inter <= 4'b1111;
            seg_inter <= 7'b1111111;
            dp_inter <= 1;
        end
    end
    
    assign speaker_selected = speaker_inter;
    assign led_selected = led_inter;
    assign an_selected = an_inter;
    assign seg_selected = seg_inter;
    assign dp_selected = dp_inter;
    
endmodule
