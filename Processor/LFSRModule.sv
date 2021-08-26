module LFSRModule (
  input               Clk,
                      Inc,
                      WriteEn,
                      TapsEn,
  input        [6:0]  DataIn,
  output logic [6:0]  State
    );

  logic [6:0] Taps;

  always_ff @ (posedge Clk) begin
    if (WriteEn)
      State <= DataIn;
    else if (Inc) begin
      State[6:1] <= State[5:0];
      State[0] <= ^(Taps & State);
    end
    if (TapsEn) begin
      case (DataIn)
        0: Taps <= 7'h60;
        1: Taps <= 7'h48;
        2: Taps <= 7'h78;
        3: Taps <= 7'h72;
        4: Taps <= 7'h6A;
        5: Taps <= 7'h69;
        6: Taps <= 7'h5C;
        7: Taps <= 7'h7E;
        8: Taps <= 7'h7B;
      endcase
    end
  end

endmodule
