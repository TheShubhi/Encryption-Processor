module ProgCtr (
  input               Reset,		
                      Clk,
                      BranchEn,
                      Inc,
  input        [3:0]  Target,
  output logic [7:0]  PgmCtr         
);
	 
  always_ff @(posedge Clk) begin
    if(Reset)
	  PgmCtr <= 0;
    else if (BranchEn)
      PgmCtr <= PgmCtr + {Target[3],Target[3],Target,2'b00};
    else if (Inc)
      PgmCtr <= PgmCtr + 1;
  end

endmodule

