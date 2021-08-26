
import java.io.*;
import java.util.*;

public class Assembler {
	static String[][] arr = { { "START", "00000000" }, { "END", "00000000" }, { "BAL", "0001" },
			{ "BNX", "0010" }, { "BLT", "0011" }, { "BNE", "0100" }, { "STR", "0101" },
			{ "XLF", "011000" }, { "CON", "011001" }, { "SLF", "011010" }, { "TAP", "011011" }, { "LDR", "0111" },
			{ "INC", "100000" }, { "NOT", "100001" }, { "LSR", "100010" }, { "LSL", "100011" }, { "AND", "1001" },
			{ "ORR", "1010" }, { "ADD", "1011" }, { "SUB", "1100" }, { "CMP", "1101" }, { "XOR", "1110" },
			{ "MOV", "1111" }, { "NOP", "11111111" }  };

	static Map<String, String> map;

	public static void main(String[] args) throws FileNotFoundException {

		if (args.length != 2) {
			System.err.println("Invalid number of command line arguments");
			return;
		}

		String infile = args[0];
		String outfile = args[1];

		FileWriter output;
		Scanner sc;
		try {
			output = new FileWriter(new File(outfile));
			sc = new Scanner(new File(infile));

			map = new HashMap<>();

			for (String[] a : arr) {
				map.put(a[0], a[1]);
			}

			int lineCount = 1;

			while (sc.hasNextLine()) {

				String line = sc.nextLine().toUpperCase();

				if (line.contains("//")) {
					line = line.substring(0, line.indexOf("//"));
				}

				if (line.length() == 0) {
					lineCount++;
					continue;
				}

				String[] words = line.split(" ");

				String command = map.get(words[0]);

				if (command == null) {
					System.err.println("Invalid command on line " + lineCount);
					return;
				}

				output.append(command);

				if (words[0].equals("BAL") || words[0].equals("BNX") || words[0].equals("BLT") || words[0].equals("BNE")) {
					if (words.length != 2) {
						System.err.println(
								"Invalid number of arguments: " + (words.length - 1) + " for command on line " + lineCount);
						return;
					}
					if (words[1].length() != 4) {
						System.err.println("Invalid argument " + 1 + ":\"" + words[1] + "\" on line" + lineCount);
						return;
					}
					output.append(words[1] + "\n");
					lineCount++;
					continue;
				}

				if (2 * (words.length - 1) + command.length() != 8) {
					System.err.println(
							"Invalid number of arguments: " + (words.length - 1) + " for command on line " + lineCount);
					return;
				}

				for (int i = 1; i < words.length; i++) {
					String arg = words[i];
					if (arg.length() != 2 || arg.charAt(0) != 'R' || arg.charAt(1) > '3' || arg.charAt(1) < '0') {
						System.err.println("Invalid argument " + i + ":\"" + arg + "\" on line" + lineCount);
						return;
					}
					output.append(Integer.toBinaryString((arg.charAt(1) - '0') | 0x4).substring(1));
				}

				output.append("\n");
				lineCount++;
			}
			sc.close();
			output.close();
		} catch (Exception e) {
			System.err.print("File IO error");
		}


	}

}
