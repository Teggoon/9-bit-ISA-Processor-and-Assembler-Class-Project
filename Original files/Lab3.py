print('Running Lab3:')

#fileObj = open("filename", "mode")
filename = "assembly.txt"

read_file = open(filename, "r")

#Print read_file

#w_file is the file we are writing to

w_file = open("machine_code.txt", "w")

comments = open("commented_machine_code.txt", "w")

#Open a file name and read each line
#to strip \n newline chars
#lines = [line.rstrip('\n') for line in open('filename')]

#1. open the file
#2. for each line in the file,
#3.     split the string by white spaces
#4.      if the first string == SET then op3 = 0, else op3 = 1
#5.
with open(filename, 'r') as f:
  for line in f:
    #print(line + " fjd ")
    str_array = line.split()

    if line == '\n' or str_array[0][0:2] == '//':
      continue

    instruction = str_array[0]

    #print("inst = " + instruction)
    #print("len = " + str(len(instruction)))

    #print("len = " + str(len(str_array)))


    #print instruction
    #print str_array

    rd = "-1"
    rs = "-1"
    rt = "-1"
    opcode = "floof"
    imm = "00000"
    addr = "null"
    sign = "0"
    type = "null"

    if instruction == "add":
      opcode = "0001"
      rd = str_array[1]
      rs = str_array[2]
      rt = str_array[3]
      type = "RR"
    elif instruction == "and":
      opcode = "0010"
      rd = str_array[1]
      rs = str_array[2]
      rt = str_array[3]
      type = "RR"
    elif instruction == "or":
      opcode = "0011"
      rd = str_array[1]
      rs = str_array[2]
      rt = str_array[3]
      type = "RR"
    elif instruction == "xor":
      opcode = "0100"
      rd = str_array[1]
      rs = str_array[2]
      rt = str_array[3]
      type = "RR"
    elif instruction == "ld":
      opcode = "0101"
      rd = str_array[1]
      rs = str_array[2]
      rt = str_array[3]
      type = "RR"
    elif instruction == "st":
      opcode = "0110"
      rd = str_array[1]
      rs = str_array[2]
      rt = str_array[3]
      type = "RR"
    elif instruction == "sll":
      opcode = "0111"
      num = str_array[3]
      imm = '{0:05b}'.format(int(num)) # 5-bit immediate
      rd = str_array[1]
      rt = str_array[2]
      type = "I"
    elif instruction == "srl":
      opcode = "1000"
      num = str_array[3]
      imm = '{0:05b}'.format(int(num)) # 5-bit immediate
      rd = str_array[1]
      rt = str_array[2]
      type = "I"
    elif instruction == "rxor":
      opcode = "1001"
      rd = str_array[1]
      rt = str_array[2]
      type = "I"
    elif instruction == "bne":
      opcode = "1010"
      addr = str_array[3]
      rd = str_array[1]
      rt = str_array[2]
      type = "I"

      if addr == "block_one":
        imm = "01011"
        sign = "0"
      elif addr == "no_change_zero":
        imm = "00010"
        sign = "0"
      elif addr == "compare":
        imm = "01100"
        sign = "0"
      elif addr == "no_change_one":
        imm = "00010"
        sign = "0"
      elif addr == "comp":
        imm = "00010"
        sign = "0"
      elif addr == "loop":
        imm = "10110"
        sign = "1"
      elif addr == "inner_compare":
        imm = "00010"
        sign = "0"
      elif addr == "inner_loop":
        imm = "00101"
        sign = "1"
      elif addr == "ctb_outer_loop":
        imm = "01010"
        sign = "1"
      elif addr == "cts_inner_loop":
        imm = "01001"
        sign = "1"
      elif addr == "store":
        imm = "00110"
        sign = "0"
      elif addr == "cts_outer_loop":
        imm = "01111"
        sign = "1"
      elif addr == "cto_outer_loop":
        imm = "01100"
        sign = "1"
      elif addr == "end_prog":
        imm = "00010"
        sign = "0"

    elif instruction == "slti":
      opcode = "1011"
      num = str_array[3]
      imm = '{0:05b}'.format(int(num)) # 5-bit immediate
      rd = str_array[1]
      rt = str_array[2]
      type = "I"
    elif instruction == "set":
      opcode = "1100"
      rd = str_array[1]
      num = str_array[2]
      num = num[1:]
      imm = '{0:08b}'.format(int(num)) # 8-bit immediate
      type = "IR"
    elif instruction == "dec":
      opcode = "1101"
      rd = str_array[1]
      type = "R"
    elif instruction == "jmp":
      opcode = "1110"
      addr = str_array[1]
      type = "J"

      if addr == "compare":
        imm = "100010000"   #272
      elif addr == "cts_inner_loop":
        imm = "110110000"   #432
      elif addr == "prog_one":
        imm = "000001010"   #10
      elif addr == "prog_two":
        imm = "010000110"   #134

    elif instruction == "HALT":
      opcode = "0000"
      imm = "000000000"
      type = "J"

    else:
      continue

    if rd == "$r0" or rd == "$r0,":
      rd = "0000"
    elif rd == "$r1" or rd == "$r1,":
      rd = "0001"
    elif rd == "$r2" or rd == "$r2,":
      rd = "0010"
    elif rd == "$r3" or rd == "$r3,":
      rd = "0011"
    elif rd == "$r4" or rd == "$r4,":
      rd = "0100"
    elif rd == "$r5" or rd == "$r5,":
      rd = "0101"
    elif rd == "$r6" or rd == "$r6,":
      rd = "0110"
    elif rd == "$r7" or rd == "$r7,":
      rd = "0111"
    elif rd == "$r8" or rd == "$r8,":
      rd = "1000"
    elif rd == "$r9" or rd == "$r9,":
      rd = "1001"
    elif rd == "$r10" or rd == "$r10,":
      rd = "1010"
    elif rd == "$r11" or rd == "$r11,":
      rd = "1011"
    elif rd == "$r12" or rd == "$r12,":
      rd = "1100"
    elif rd == "$r13" or rd == "$r13,":
      rd = "1101"
    elif rd == "$r14" or rd == "$r14,":
      rd = "1110"
    elif rd == "$r15" or rd == "$r15,":
      rd = "1111"
    else:
      rd = "010101"

    if rs == "$r0,":
      rs = "0000"
    elif rs == "$r1,":
      rs = "0001"
    elif rs == "$r2,":
      rs = "0010"
    elif rs == "$r3,":
      rs = "0011"
    elif rs == "$r4,":
      rs = "0100"
    elif rs == "$r5,":
      rs = "0101"
    elif rs == "$r6,":
      rs = "0110"
    elif rs == "$r7,":
      rs = "0111"
    elif rs == "$r8,":
      rs = "1000"
    elif rs == "$r9,":
      rs = "1001"
    elif rs == "$r10,":
      rs = "1010"
    elif rs == "$r11,":
      rs = "1011"
    elif rs == "$r12,":
      rs = "1100"
    elif rs == "$r13,":
      rs = "1101"
    elif rs == "$r14,":
      rs = "1110"
    elif rs == "$r15,":
      rs = "1111"
    else:
      rs = "101010"

    if rt == "$r0" or rt == "$r0,":
      rt = "0000"
    elif rt == "$r1" or rt == "$r1,":
      rt = "0001"
    elif rt == "$r2" or rt == "$r2,":
      rt = "0010"
    elif rt == "$r3" or rt == "$r3,":
      rt = "0011"
    elif rt == "$r4" or rt == "$r4,":
      rt = "0100"
    elif rt == "$r5" or rt == "$r5,":
      rt = "0101"
    elif rt == "$r6" or rt == "$r6,":
      rt = "0110"
    elif rt == "$r7" or rt == "$r7,":
      rt = "0111"
    elif rt == "$r8" or rt == "$r8,":
      rt = "1000"
    elif rt == "$r9" or rt == "$r9,":
      rt = "1001"
    elif rt == "$r10" or rt == "$r10,":
      rt = "1010"
    elif rt == "$r11" or rt == "$r11,":
      rt = "1011"
    elif rt == "$r12" or rt == "$r12,":
      rt = "1100"
    elif rt == "$r13" or rt == "$r13,":
      rt = "1101"
    elif rt == "$r14" or rt == "$r14,":
      rt = "1110"
    elif rt == "$r15" or rt == "$r15,":
      rt = "1111"
    else:
      rt = "010101"

    #print("opcode = " + opcode)

    if type == "RR":
      one = opcode + rd + "0"
      two = rs + rt + "0"
    elif type == "I":
      one = opcode + imm
      two = rd + rt + sign
    elif type == "IR":
      one = opcode + rd + "0"
      two = imm + "0"
    elif type == "R":
      one = opcode + rd + "0"
      two = "000000000"
    elif type == "J":
      one = opcode + "00000"
      two = imm

    w_file.write(one + '\n' + two + '\n')

    if type == "RR":
      one = opcode + rd + "0" + '\t' \
            + '#' + " " + instruction + " " + rd \
            + " " + rs + " " + rt
      two = rs + rt + "0"
    elif type == "I":
      one = opcode + imm + '\t' \
            + '#' + " " + instruction + " " + rd \
            + " " + rt + " " + imm
      two = rd + rt + sign
    elif type == "IR":
      one = opcode + rd + "0" + '\t' \
            + '#' + " " + instruction + " " + rd + " " + imm
      two = imm + "0"
    elif type == "R":
      one = opcode + rd + "0" + '\t' \
            + '#' + " " + instruction + " " + rd
      two = "000000000"
    elif type == "J":
      one = opcode + "00000" + '\t' \
            + '#' + " " + instruction + " " + imm
      two = imm

    comments.write(one + '\n' + two + '\n')

w_file.close()
