# build a dict of opcodes and operands types
op_types = {}

op_types["00000"] = ["reg","reg","reg"]
op_types["00001"] = ["reg","reg","reg"]
op_types["00010"] = ["reg","reg","num"]
op_types["00011"] = ["reg","reg","reg"]
op_types["00100"] = ["reg","reg","reg"]
op_types["00101"] = ["reg","num"]
op_types["00110"] = ["reg","num"]
op_types["00111"] = ["reg","reg"]
op_types["01000"] = []
op_types["01001"] = ["reg"]
op_types["01010"] = ["reg"]
op_types["01011"] = ["reg"]
op_types["01100"] = ["reg"]
op_types["01101"] = ["reg"]
op_types["10000"] = ["reg"]
op_types["10001"] = ["reg"]
op_types["10010"] = ["reg","num"]
op_types["10011"] = ["reg","num"]
op_types["10100"] = ["reg","num"]
op_types["11000"] = ["reg"]
op_types["11001"] = ["reg"]
op_types["11010"] = ["reg"]
op_types["11011"] = []
op_types["11100"] = []

# build a dict of opcodes and type of num (imm or ea)
num_type = {}
num_type["00101"] = "imm"
num_type["00110"] = "imm"
num_type["00010"] = "ea"
num_type["10010"] = "imm"
num_type["10011"] = "ea"
num_type["10100"] = "ea"