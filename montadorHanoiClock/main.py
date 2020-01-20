def readInput():
    f = open("./entrada.asm", "r")
    if f.mode == 'r':
        content = f.read()
        print(content)

readInput()