from ISA import *

def get_opcode(operation):
    operation = operation.lower()
    if(operation == "add"):
        return "00000"
    elif(operation == "sub"):
        return "00001"
    elif(operation == "iadd"):
        return "00010"
    elif(operation == "and"):
        return "00011"
    elif(operation == "or"):
        return "00100"
    elif(operation == "shl"):
        return "00101"
    elif(operation == "shr"):
        return "00110"
    elif(operation == "swap"):
        return "00111"
    elif(operation == "nop"):
        return "01000"
    elif(operation == "not"):
        return "01001"
    elif(operation == "inc"):
        return "01010"
    elif(operation == "dec"):
        return "01011"
    elif(operation == "out"):
        return "01100"
    elif(operation == "in"):
        return "01101"
    elif(operation == "push"):
        return "10000"
    elif(operation == "pop"):
        return "10001"
    elif(operation == "ldm"):
        return "10010"
    elif(operation == "ldd"):
        return "10011"
    elif(operation == "std"):
        return "10100"
    elif(operation == "jz"):
        return "11000"
    elif(operation == "jmp"):
        return "11001"
    elif(operation == "call"):
        return "11010"
    elif(operation == "ret"):
        return "11011"
    elif(operation == "rti"):
        return "11100"
    else:
        raise Exception("Fatal Error: Entered operation: \"{}\" isn't supported".format(operation))

def get_regcode(reg):
    reg = reg.lower()
    if(reg == "r0"):
        return "000"
    elif(reg == "r1"):
        return "001"
    elif(reg == "r2"):
        return "010"
    elif(reg == "r3"):
        return "011"
    elif(reg == "r4"):
        return "100"
    elif(reg == "r5"):
        return "101"
    elif(reg == "r6"):
        return "110"
    elif(reg == "r7"):
        return "111"
    else:
        raise Exception("Fatal Error: Entered register: \"{}\" is not supported.".format(reg))

def get_imm_bin(imm):
    try:
        binary = bin(int(imm, 16)).replace("0b", "")
        return (16-(len(binary)))*'0' + binary
    except:
        raise Exception("Entered Imm value: \"{}\" isn't a number".format(imm))

def get_ea_bin(ea):
    try:
        binary = bin(int(ea, 16)).replace("0b", "")
        return (20-(len(binary)))*'0' + binary
    except:
        raise Exception("Entered EA value: \"{}\" isn't a number".format(ea))
    

def get_type(operand):
    operand = operand.lower()
    if(operand[0] == 'r' and operand[1].isnumeric() and int(operand[1]) < 9 and  int(operand[1]) >=0):
        return "reg"
    try:
        int(operand, 16)
        return "num"
    except:
        raise Exception("Fatal Error: Entered operand: \"{}\" not supported".format(operand))


def get_machine_code(inst):
    opcode = get_opcode(inst[0])
    mc = opcode
    regs = []
    nums = []
    for i in range(len(inst)-1):
        t = get_type(inst[i+1])
        if(t == "reg"):
            regs.append(inst[i+1])
        else:
            nums.append(inst[i+1])
    if(len(regs) == 1 and len(nums) == 0):
        mc += get_regcode(regs[0])
    elif(len(regs) == 1 and len(nums) == 1):
        mc += get_regcode(regs[0])
        if(num_type[opcode] == "imm"):
            mc += "0" * 8
            mc += get_imm_bin(nums[0])
        else:
            mc += '0' * 4
            mc += get_ea_bin(nums[0])
    elif(len(regs) == 2 and len(nums) == 0):
        # swap
        mc += get_regcode(regs[0])
        mc += get_regcode(regs[1])
    elif(len(regs) == 2 and len(nums) == 1):
        # iadd
        mc += get_regcode(regs[0])
        mc += '0' * 3
        mc += get_regcode(regs[1])
        mc += '0' * 2
        mc += get_imm_bin(nums[0])
    elif(len(regs) == 3 and len(nums) == 0):
        # two operand and dst
        mc += get_regcode(regs[1])
        mc += get_regcode(regs[2])
        mc += get_regcode(regs[0])
    else:
        raise Exception("FATAL: Operand types unsupported: {} regs and {} nums.".format(len(regs), len(nums)))
    if(len(mc) < 16):
        mc += '0'*(16-len(mc))
    else:
        mc += '0'*(32-len(mc))
    return mc