print('Running Assembler:')

filename = "program2.txt"
read_file = open(filename, "r")
w_file = open("program2_mc.txt", "w")

PREMAPPED_BITS = {
    "rc_add":           "0000",
    "rc_sub":           "0001",
    "load_tap":         "00100",
    "lfsr":             "00101",
    "rc_loadi":         "0011",
    "rc_loadr":         "01000",
    "rc_store":         "01001",
    "parity_bit":       "01010",
    "reg_copy_short":   "01100",
    "reg_copy_long":    "01101",
    "add":              "01110",
    "addi":             "01111",
    "sub":              "10000",
    "subi":             "10001",
    "xor":              "10010",
    "xori":             "10011",
    "and":              "10100",
    "andi":             "10101",
    "lsl":              "10110",
    "lsli":             "10111",
    "lsr":              "11000",
    "lsri":             "11001",
    "mem_load":         "11010",
    "mem_store":        "11011",
    "cmp":              "11100",
    "cmpi":             "11101",
    "b_a":              "1111011",
    "b_r":              "1111111",
    "bgt_a":            "1111000",
    "bgt_r":            "1111100",
    "blt_a":            "1111001",
    "blt_r":            "1111101",
    "beq_a":            "1111010",
    "beq_r":            "1111110",
    "done" :            "010001111",
    "print":            "010111111"
}

w_file.write("001100000 //buffer no-op\n");
w_file.write("001100000 //buffer no-op\n");
num_of_error = 0;
addr = 2;

with open(filename, 'r') as f:
  for line in f:

      translated = "";

      comment = "       // ";

      line = line.replace(',','')

      str_array = line.split()

      #print(str_array);

      if line == '\n' or str_array[0][0:2] == '//':
          continue
      if str_array[0][0:2] == '/*':
          break;

      instruction = str_array[0].casefold()

      if (instruction in PREMAPPED_BITS):
          translated += PREMAPPED_BITS[instruction];
      else:
          print("I'm sorry, but " + instruction + " isn't a valid instruction.");


      for i in range (len(str_array) - 1, 1, -1):
          if (str_array[i][0:2] == "//"):
              str_array = str_array[0:i];
      #zfill and [2:] thanks to
      # https://stackoverflow.com/questions/1395356/how-can-i-make-bin30-return-00011110-instead-of-0b11110
      for i in range (1, len(str_array)):
          str_current = str_array[i].casefold().replace('r','').replace('#','')

          if (instruction == "rc_add" or instruction == "rc_sub" or instruction == "rc_loadi"):
              translated += bin(int(str_current))[2:].zfill(5);
          elif (instruction[0] == "b"):
              translated += bin(int(str_current) - 11)[2:].zfill(2);
          elif (len(str_array) == 2):
              translated += bin(int(str_current))[2:].zfill(4);
          else:
              translated += bin(int(str_current))[2:].zfill(2);
      if (len(translated) > 9):
          print("WARNING: FAULTY LINE.");
          num_of_error += 1;
      translated += comment + line;
      print(translated);
      w_file.write(translated);
      addr+=1;

if (num_of_error == 0):
    print("Finished with 0 errors");
else:
    print("Number of errors:");
    print(str(num_of_error));
w_file.close()
