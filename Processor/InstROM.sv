module InstROM #(parameter ROM_FILE = "machine_code.txt") (
  input        [7:0]  PgmCtr,
  output logic [7:0]  Instruction
);
	 
  logic[7:0] inst_rom[256];

  always_comb Instruction = inst_rom[PgmCtr];

  initial begin
    $readmemb(ROM_FILE, inst_rom);
  end
  
endmodule
