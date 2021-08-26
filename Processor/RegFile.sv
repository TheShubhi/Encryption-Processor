module RegFile (
  input               Clk,
                      WriteEn,
  input        [1:0]  RaddrA,
                      AddrB,
  input        [7:0]  DataIn,
  output logic [7:0]  DataOutA,			 
                      DataOutB
);

  logic [7:0] Registers[4] = '{8'h00,8'h00,8'h00,8'h00};

  always_comb begin
    DataOutA = Registers[RaddrA];
    DataOutB = Registers[AddrB];
  end
  
  always_ff @ (posedge Clk) begin
    if (WriteEn)
      Registers[AddrB] <= DataIn;
  end

endmodule
