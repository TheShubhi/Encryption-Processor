module TopLevel #(parameter ROM_FILE = "machine_code.txt") (
    input         Reset,
                  Start,
                  Clk,
    output logic  Ack
);

  wire  [7:0]  PgmCtr,
               Instruction;
  logic [7:0]  InA;
  wire  [7:0]  ALU_out,
               ReadA, ReadB,
               MemReadValue;
  wire  [6:0]  LFSROut;
  wire         MemWrEn,
               RegWrEn,
               LFSRWrEn,
               TapsEn,
               IncLFSR,
               BranchEn;
  wire  [1:0]  InputSelector;
  logic        Parity,
               Negative,
               NonZero,
               IncPC;

  ProgCtr PC1 (
    .Reset,  
    .Clk, 
    .BranchEn, 
    .Inc       (IncPC),
    .Target    (Instruction[3:0]), 
    .PgmCtr
  );

  InstROM #(.ROM_FILE(ROM_FILE)) IR1 (.*);

  Ctrl Ctrl1 (.*);

  RegFile RF1 (
    .Clk,
    .WriteEn   (RegWrEn), 
    .RaddrA    (Instruction[3:2]),    
    .AddrB     (Instruction[1:0]), 
    .DataIn    (ALU_out), 
    .DataOutA  (ReadA), 
    .DataOutB  (ReadB)
  );
  
  LFSRModule LFSR (
    .Clk,
    .Inc       (IncLFSR),
    .WriteEn   (LFSRWrEn), 
    .TapsEn,    
    .DataIn    (ReadB[6:0]), 
    .State     (LFSROut)
  );
  
  ALU ALU1  (
    .InputA    (InA),
    .InputB    (ReadB),
    .OP        (Instruction[7:2]),
    .Out       (ALU_out)
  );
  
  DataMem DM(
    .Clk,
    .Reset,
    .DataAddress  (ReadA), 
    .WriteEn      (MemWrEn), 
    .DataIn       (ReadB), 
    .DataOut      (MemReadValue) 
  );
  
  always_comb begin
    case (InputSelector)
      'b00: InA = ReadA;
      'b01: InA = MemReadValue;
      'b10: InA = 8'h20;
      'b11: InA = {1'b0,LFSROut};
    endcase
    
    IncPC = |Instruction || Start;
    
  end

  always_ff @(posedge Clk) begin
    Parity = ^ALU_out;
    Negative = ALU_out[7];
    NonZero = |(ALU_out[6:0]);
  end
  
endmodule