typedef enum logic[2:0] {
        OTH, AND, ORR, ADD,
        SUB, CMP, XOR, FIRST } op_mne;

typedef enum logic[1:0] {
        INC, NOT, LSR, LSL } op_oth;

module ALU (
  input        [7:0]  InputA,
                      InputB,
  input        [5:0]  OP,
  output logic [7:0]  Out
);

  always_comb begin
    Out = 0;
    case(OP[4:2])
      OTH : begin
        case (OP[1:0])
          LSL : Out = {InputB[6:0],1'b0};
          LSR : Out = {1'b0, InputB[7:1]};
          NOT : Out = (~InputB);
          INC : Out = 1'b1 + InputB;
        endcase
      end

      AND : Out = InputA & InputB;
      ORR : Out = InputA | InputB;
      ADD : Out = InputA + InputB;
      SUB : Out = (~InputA) + InputB + 1;
      CMP : Out = (~InputA) + InputB + 1;
      XOR : begin
        Out = InputA ^ InputB;
        if (!OP[5] && OP[0])
          Out = InputA;
      end
      FIRST : Out = InputA;
      
    endcase
  end

endmodule