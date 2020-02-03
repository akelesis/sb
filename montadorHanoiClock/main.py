"""
Dupla: Marcus Vinicius Tavares, Luís Carlos Câmara
TRABALHO FINAL DA DISCIPLINA SOFTWARE BÁSICO
"""

codes = []
opcodes = []
ilcs = []
tableofSymbols = []
ilcTotal = 150
result = []
strippedCodes = []
hanoiLines = []
opcode = ""
program = ""
blockCounter = -1
lineCounter = 0
finalProg = []
block = ""

""" LER ARQUIVO DE DICIONARIO """
def readInput():
    f = open("opcodeMap.txt", "r")
    content = f.read()

    return content

content = readInput()

""" SEPARAR LINHAS """
parcial = content.splitlines();

""" SEPARAR 'COLUNAS' """
for res in parcial:
    result.append(res.split('|', 3))

""" LIMPAR ULTIMA LINHA VAZIA """
result.pop()


""" ATRIBUIR 'COLUNAS' """
codes = [res[0] for res in result]
for code in codes:
    strippedCodes.append(code.rstrip())

opcodes = [res[1] for res in result]
ilcs = [res[2] for res in result]

""" LER ARQUIVO HANOICLOCK """
file = open("hanoiclock.asm", "r")
hanoiFile = file.read()
hanoiFile = hanoiFile.splitlines()

""" RETIRAR COMENTÁRIOS """
for line in hanoiFile:
    line = line.split(";")
    hanoiLines.append(line[0].strip())

""" RETIRAR CAMPOS VAZIOS """
while("" in hanoiLines) : 
    hanoiLines.remove("") 


""" ABRIR CONEXÃO COM ARQUIVO DE SAIDA """
output = open("output.o", "w")

""" VARRER O CODIGO FONTE E SUBSTITUIR LINHAS POR OPCODES """
for line in hanoiLines:
    for index, code in enumerate(strippedCodes):
        if line == code:
            opcode = opcodes[index]
            """ CASO ENCONTRE A FLAG ILC SUBSTITUIR PELO VALOR DO ILC EM HEXADECIMAL """
            if opcode.find("ilc") > -1 :
                currentIlc = ilcTotal
                currentIlc = hex(currentIlc)
                currentIlc = currentIlc.split("x")
                while len(currentIlc[1]) < 8:
                    currentIlc[1] = "0" + currentIlc[1]
                opcode = opcode.replace("ilc", currentIlc[1])
            
            opcode = opcode.replace(" ", "")
            """ ADICIONA O OPCODE AO CONTEUDO DE PROGRAMA """
            program += opcode
            ilcTotal += int(ilcs[index])
            break
    else:
        """ ADICIONA À TABELA """
        if len(line.split("db")) > 1:
            symbol = line.split("db")
            tableofSymbols.append([symbol[0].strip(), len(symbol[1]), "db"])
        if len(line.split("resb")) > 1:
            symbol = line.split("resb")
            tableofSymbols.append([symbol[0].strip(), symbol[1], "resb"])
        if len(line.split("equ")) > 1:
            symbol = line.split("equ")
            tableofSymbols.append([symbol[0].strip(), 0, "equ"])
        if len(line.split(":")) > 1:
                line = line.split(":")
                if not line[0].find("db") > -1:
                    for sym in tableofSymbols:
                        if sym == line[0]:
                            break
                    tableofSymbols.append(line[0])

tableofSymbols.append(ilcTotal)


""" RETIRAR CAMPOS VAZIOS """
while("" in tableofSymbols) : 
    tableofSymbols.remove("") 

""" DIVIDE EM BLOCOS DE 4 SIMBOLOS """
for index, letter in enumerate(program):
    if blockCounter < 3:
        block += program[index]
        blockCounter += 1
    else:
        blockCounter = 0
        block = block[2] + block[3] + block[0] + block[1]
        finalProg.append(block)
        block = program[index] 
    
""" DIVIDE EM LINHAS DE 8 BLOCOS """
for index, block in enumerate(finalProg):
    output.write(finalProg[index])
    if(lineCounter < 7):
        output.write(" ")
        lineCounter += 1
    else:
        output.write("\n")
        lineCounter = 0

output.close()

