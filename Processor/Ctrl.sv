module Ctrl (
  input        [7:0]  Instruction,
  input               NonZero,
		       	      Parity,        
		       	      Negative,
  output logic        MemWrEn,
	       	          RegWrEn,
                      LFSRWrEn,
                      TapsEn,
                      IncLFSR,
                      BranchEn,
  			          Ack,
  output logic [1:0]  InputSelector
);

  always_comb begin
    
    MemWrEn = Instruction[7:4]==4'b0101;
    RegWrEn = ((Instruction[7]==1)&&(Instruction[7:4]!=4'b1101))||(Instruction[7:3]==5'b01100) || (Instruction[7:4]==4'b0111);
    LFSRWrEn = Instruction[7:2]==6'b011010;
    TapsEn = Instruction[7:2]==6'b011011;
    IncLFSR = Instruction[7:2]==6'b011000;
    
    case (Instruction[7:4])
      4'b0001: BranchEn = 1;
      4'b0010: BranchEn = ~Parity;
      4'b0011: BranchEn = Negative;
      4'b0100: BranchEn = NonZero;
      default: BranchEn = 0;
    endcase
    
    Ack = !(|Instruction);
    
    if (Instruction[7])
      InputSelector = 2'b00;
    else if (!Instruction[4] && Instruction[2])
      InputSelector = 2'b10;
    else if (!Instruction[4] && !Instruction[2])
      InputSelector = 2'b11;
    else
      InputSelector = 2'b01;
    
  end

endmodule

