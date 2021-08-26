module DataMem (
  input               Clk,
                      Reset,
                      WriteEn,
  input        [7:0]  DataAddress,
                      DataIn,
  output logic [7:0]  DataOut
);

  logic [7:0] Core[256];

  always_comb 
    DataOut = Core[DataAddress];

  always_ff @ (posedge Clk)
    if(WriteEn) 
      Core[DataAddress] <= DataIn;

endmodule
