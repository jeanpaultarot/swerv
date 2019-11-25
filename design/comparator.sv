module comparator
  (
   input logic              clk,
   input logic              rst,
   input logic [LENGTH-1:0] signal_to_delay,
   input logic [LENGTH-1:0] signal_delayed,
   output logic             equal
   );

   parameter LENGTH = 32;
   
   logic [LENGTH-1:0] signal_to_delay_delayed_1;
   logic [LENGTH-1:0] signal_to_delay_delayed_2;
   logic [LENGTH-1:0] signal_to_delay_delayed_3;

   always @* begin
      if (signal_to_delay_delayed_3 == signal_delayed)
        equal = 1;
      else
        equal = 0;
   end
   
   always @(posedge clk) begin
      if (rst)
        begin
           signal_to_delay_delayed_3 <= 0;
           signal_to_delay_delayed_2 <= 0;
           signal_to_delay_delayed_1 <= 0;
        end
      else
        begin
           signal_to_delay_delayed_3 <= signal_to_delay_delayed_2;
           signal_to_delay_delayed_2 <= signal_to_delay_delayed_1;
           signal_to_delay_delayed_1 <= signal_to_delay;
        end
  end
   

endmodule

   
   
   
