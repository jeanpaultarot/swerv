// for testing with cocotb : `timescale 1ns/1ps

module comparator
  # (parameter LENGTH = 8)
  (
   input logic              clk,
   input logic              rst,
   input logic [LENGTH-1:0] signal1,
   input logic              signal1_enable,
   input logic [LENGTH-1:0] signal2,
   input logic              signal2_enable,
   output logic             equal
   );

   logic [LENGTH-1:0]       last_signal1;
   logic [LENGTH-1:0]       last_signal2;
   logic                    signal1_set;
   logic                    signal2_set;
   
   logic [LENGTH-1:0]       second_last_signal1;
   logic [LENGTH-1:0]       second_last_signal2;
   logic                    second_signal1_set;
   logic                    second_signal2_set;

   always @* begin
      if (signal1_set    &&    signal2_set    &&      last_signal1 != last_signal2)
        equal = 0;
      else begin
        equal = 1;
        if (signal1_set && signal2_set && last_signal1==last_signal2)
          $display("Found two matching signals : %d AND %d", last_signal1, last_signal2);
      end
   end
   
   always @(posedge clk) begin
      if (rst)
        begin
           last_signal1 <= 0;
           last_signal2 <= 0;
           signal1_set <= 0;
           signal2_set <= 0;
        end
      else begin
         if (signal1_enable) begin
            if (signal1_set   &&  signal1 != last_signal1) begin
               if (second_signal1_set && signal1 != second_last_signal1) begin
                  $display("ERROR : Writing on second_last_signal1 %d without having changed the other values (last : %d, second_last : %d)", signal1, last_signal1, second_last_signal1);
                  $finish;
               end else begin
                  second_signal1_set <= 1;
                  second_last_signal1 <= signal1;
               end
            end
            else begin
               signal1_set <= 1;
               last_signal1 <= signal1;
            end
         end
         if (signal2_enable) begin
            if (signal2_set  &&   signal2 != last_signal2) begin
               if (second_signal2_set && signal2 != second_last_signal2) begin
                  $display("ERROR : Writing on second_last_signal2 %d without having changed the other values (last : %d, second_last : %d)", signal2, last_signal2, second_last_signal2);
                  $finish;
               end else begin
                  second_signal2_set <= 1;
                  second_last_signal2 <= signal2;
               end
            end
            else begin
               signal2_set <= 1;
               last_signal2 <= signal2;
            end
         end
         if (signal1_set && signal2_set) begin
            signal1_set <= second_signal1_set;
            signal2_set <= second_signal2_set;
            last_signal1 <= second_last_signal1;
            last_signal2 <= second_last_signal2;
            second_signal1_set <= 0;
            second_signal2_set <= 0;
            second_last_signal1 <= 0;
            second_last_signal2 <= 0;
         end
      end
  end
   

endmodule

   
   
   
