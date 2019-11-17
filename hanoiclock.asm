;______________________________________________________________________________________________________________;
;
;;; TORRE DE HANOI CICLICA - NASM - X86
;;; Linux 32 bits
;
; CIC - UESC
; Ciência da Computação
; Software Básico
; Aluno(s): 
;;;;;;;;;;; Marcus Vinicius Monteiro de Almeida Tavares (marcus.tavares@outlook.com)
;;;;;;;;;;; Luís Carlos Santos Câmara (luisuesc1@gmail.com)
;
; Professor: Paulo André Sperandio Giacomin 
;
;;; RODANDO EM LINUX
; Abrir diretório da aplicação
; nasm -f elf hanoiclock.asm
; ld hanoiclock.o -e hanoiclock -o hanoiclock
; ./hanoiclock
;______________________________________________________________________________________________________________;



;______________________PARTE EXECUTÁVEL;

section .text

    global _start                       ;SE FOR RODAR ONLINE
    ;global hanoi                       ;SE FOR RODAR EM MÁQUINA LINUX 32BITS

;______________________PRINCIPAL;

    _start:                             ;SE FOR RODAR ONLINE
    ;hanoi:                             ;SE FOR RODAR EM MÁQUINA LINUX 32BITS

        push ebp                        ; salva o registrador base na pilha
        mov ebp, esp                    ; ebp recebe o ponteiro para o topo da pilha (esp)

        ; MENSAGEM DE BOAS VINDAS
        mov edx,len                     ; recebe o tamanho da mensagem
        mov ecx,menu                    ; recebe a mensagem
        mov ebx,1                       ; entrada padrão 
        mov eax,4                       ; informa que será uma escrita no ecrã
        int 0x80                        ; Interrupção Kernel Linux

        ;ENTRADA DO TECLADO (USUÁRIO DIGITA A QUANTIDADE DE DISCOS)
        mov edx, 5                      ; tamanho da entrada 
        mov ecx, disco                   ; armazenamento em 'disco'
        mov ebx, 0                      ; entrada padrão
        mov eax, 3                      ; informa que serÃ¡ uma leitura           
        int 0x80                        ; Interrupção Kernel Linux
        
        ;MENSAGEM PARA ESCOLHA DE PINO DE ORIGEM
        mov edx,len_origem              ; recebe o tamanho da mensagem
        mov ecx,escolha_origem          ; recebe a mensagem
        mov ebx,1                       ; entrada padrão 
        mov eax,4                       ; informa que será uma escrita no ecrã
        int 0x80                        ; Interrupção Kernel Linux
        
        ;ENTRADA DE TECLADO PARA ESCOLHA DE PINO DE ORIGEM
        mov edx, 5                      ; tamanho da entrada 
        mov ecx, origem                 ; armazenamento em 'disco'
        mov ebx, 0                      ; entrada padrão
        mov eax, 3                      ; informa que serÃ¡ uma leitura           
        int 0x80                        ; Interrupção Kernel Linux
        
        ;MENSAGEM PARA ESCOLHA DE PINO DE DESTINO
        mov edx,len_destino             ; recebe o tamanho da mensagem
        mov ecx,escolha_destino         ; recebe a mensagem
        mov ebx,1                       ; entrada padrão 
        mov eax,4                       ; informa que será uma escrita no ecrã
        int 0x80                        ; Interrupção Kernel Linux
        
        ;ENTRADA DE TECLADO PARA ESCOLHA DE PINO DE DESTINO
        mov edx, 5                      ; tamanho da entrada 
        mov ecx, destino                ; armazenamento em 'disco'
        mov ebx, 0                      ; entrada padrão
        mov eax, 3                      ; informa que serÃ¡ uma leitura           
        int 0x80                        ; Interrupção Kernel Linux

        ;MENSAGEM PARA ESCOLHA DE PINO DE TRABALHO
        mov edx,len_trabalho             ; recebe o tamanho da mensagem
        mov ecx,escolha_trabalho         ; recebe a mensagem
        mov ebx,1                       ; entrada padrão 
        mov eax,4                       ; informa que será uma escrita no ecrã
        int 0x80                        ; Interrupção Kernel Linux
        
        ;ENTRADA DE TECLADO PARA ESCOLHA DE PINO DE TRABALHO
        mov edx, 5                      ; tamanho da entrada 
        mov ecx, trabalho               ; armazenamento em 'disco'
        mov ebx, 0                      ; entrada padrão
        mov eax, 3                      ; informa que serÃ¡ uma leitura           
        int 0x80                        ; Interrupção Kernel Linux

        mov edx, trabalho               ; insere o pino de trabalho no registrador edx
        call _atoi                      ; converte o valor do pino de trabalho para int
        push eax                        ; manda o pino de trabalho para a pilha 

        mov edx, destino                ; insere o pino de destino no registrador edx
        call _atoi                      ; converte o valor do pino de destino para int
        push eax                        ; manda o pino de destino para a pilha

        mov edx, origem                 ; insere o pino de origem no registrador edx
        call _atoi                      ; converte o valor do pino de origem para int
        push eax                        ; manda o pino de origem para a pilha

        mov edx, disco                  ; insere numero de discos no registrador edx
        call _atoi                      ; converte o numero de discos para para int
        push eax                        ; manda o numero de discos para a pilha
        
        call clock                      ; Chama a função clock

        ; FIM DO PROGRAMA
        mov eax, 1                      ; Saida do sistema
        mov ebx, 0                      ; saida padrão  
        int 0x80                        ; Interrupção Kernel Linux


;______________________CONVERSÃO DE ASCII PARA INTEGER;

_atoi:
    xor     eax, eax                    ; Limpa o registrador (define o bit resultante para 1 , se e somente se os bits dos operandos são diferentes. Se os bits dos operandos são os mesmos ( ambos 0 ou ambos 1 ) , o bit resultante é limpo para 0)
    mov     ebx, 10                     ; EBX vai ser o registrador auxiliar de multiplicação.
    
    .loop:
        movzx   ecx, byte [edx]         ; Mover um byte de EDX para ECX. [Representando um "nÃºmero"]
        inc     edx                     ; Aumenta o EDX para que aponte para o prÃ³ximo byte.
        cmp     ecx, '0'                ; Comparar ECX com '0'
        jb      .done                   ; Caso for menor, pule pra linha .done
        cmp     ecx, '9'                ; Comparar ECX com '9'
        ja      .done                   ; Caso for maior, pule pra linha .done
        
        sub     ecx, '0'                ; Subtrai a "string" de 'zero', irá "transformar em int"
        imul    eax, ebx                ; Multiplica por EBX, na primeira interação resultado Ã© 0!
        add     eax, ecx                ; Adiciona o valor de ECX que foi "convertido" a EAX
        jmp     .loop                   ; Fazer isso até chegar em uma das comparações acima.
    
    .done:
        ret 


;______________________FUNÇÃO QUE EXECUTA O ALGORITMO HANOI;

    clock: 

        ;[ebp+8] = n (número de discos iniciais) 
        ;[ebp+12] = pino de origem
        ;[ebp+16] = pino de trabalho
        ;[ebp+20] = pino de destino

        push ebp                        ; salva o registrador ebp na pilha
        mov ebp,esp                     ; ebp recebe o endereço do topo da pilha

        mov eax,[ebp+8]                 ; pega o a posição do primeiro elemento da pilha e mov para eax
        cmp eax,0x0                     ; cmp faz o comparativo do valor que está em eax com 0x0 = 0 em hexadecimal 
        jle fim                         ; se eax for menor ou igual a 0, vai para o fim, desempilhar
        
        ;PASSO1 - RECURSIVIDADE
        dec eax                         ; decrementa 1 de eax
        push dword [ebp+16]             ; coloca na pilha o pino de destino
        push dword [ebp+20]             ; coloca na pilha o pino de trabalho
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword eax                  ; poe eax na pilha como parâmetro n, já com -1 para a recursividade
        call anti                       ; Chama a função anti(recursividade)

        ;PASSO2 - MOVER PINO E IMPRIMIR
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+16]             ; pega o pino de trabalho
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword [ebp+8]              ; coloca na pilha o pino de o numero de disco inicial
        call imprime                    ; Chama a função 'imprime'
        
        ;PASSO3 - RECURSIVIDADE
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+16]             ; coloca na pilha o pino de origem
        push dword [ebp+12]             ; coloca na pilha o pino de destino
        push dword [ebp+20]             ; coloca na pilha o pino de trabalho
        mov eax,[ebp+8]                 ; move para o registrador eax o espaço reservado ao número de discos atuais
        dec eax                         ; decrementa 1 de eax
        push dword eax                  ; poe eax na pilha
        call anti                       ; (recursividade)

        jp fim

    anti:

        push ebp                        ; salva o registrador ebp na pilha
        mov ebp,esp                     ; ebp recebe o endereço do topo da pilha

        mov eax,[ebp+8]                 ; pega o a posição do primeiro elemento da pilha e mov para eax
        cmp eax,0x0                     ; cmp faz o comparativo do valor que está em eax com 0x0 = 0 em hexadecimal 
        jle fim

        ;PASSO1 - RECURSIVIDADE ANTI
        dec eax                         ; decrementa 1 de eax
        push dword [ebp+20]             ; coloca na pilha o pino de trabalho
        push dword [ebp+16]             ; coloca na pilha o pino de destino
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword eax                  ; poe eax na pilha como parâmetro n, já com -1 para a recursividade
        call anti                       ; Chama a função anti(recursividade)

        ;PASSO2 - MOVER PINO E IMPRIMIR
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+20]             ; pega o pino de trabalho
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword [ebp+8]              ; coloca na pilha o pino de o numero de disco inicial
        call imprime                    ; Chama a função 'imprime'

        ;PASSO3 - RECURSIVIDADE CLOCK
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+12]             ; coloca na pilha o pino de trabalho
        push dword [ebp+16]             ; coloca na pilha o pino de origem
        push dword [ebp+20]             ; coloca na pilha o pino de destino
        mov eax,[ebp+8]                 ; move para o registrador eax o espaço reservado ao número de discos atuais
        dec eax                         ; decrementa 1 de eax
        push dword eax                  ; poe eax na pilha
        call clock                      ; (recursividade)

        ;PASSO4 - MOVER PINO E IMPRIMIR
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+16]             ; pega o pino de destino referenciado pelo parâmetro ebp+16
        push dword [ebp+20]             ; coloca na pilha o pino de trabalho
        push dword [ebp+8]              ; coloca na pilha o pino de o numero de disco inicial
        call imprime                    ; Chama a função 'imprime'

        ;PASSO5 - RECURSIVIDADE ANTI 
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+20]             ; coloca na pilha o pino de trabalho
        push dword [ebp+16]             ; coloca na pilha o pino de destino
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        mov eax,[ebp+8]                 ; move para o registrador eax o espaço reservado ao número de discos atuais
        dec eax                         ; decrementa 1 de eax
        push dword eax                  ; poe eax na pilha
        call anti                       ; (recursividade)

        jp fim

    fim: 

        mov esp,ebp                     ; Move o valor de ebp para esp (guarda em outro registrador)
        pop ebp                         ; Remove da pilha (desempilha) o ebp
        ret                             ; Retorna a função de origem (antes de ter chamado a função 'fim')

    imprime:

        push ebp                        ; Empilha
        mov ebp, esp                    ; ebp recebe o endereÃ§o do topo da pilha

        mov eax, [ebp + 12]             ; pino de trabalho
        add al, '0'                     ; conversao para ASCII
        mov [pino_origem], al           ; movimento: movendo o conteudo de al para [pino_origem]

        mov eax, [ebp + 16]             ; pino de destino**
        add al, '0'                     ; conversao para ASCII
        mov [pino_destino], al          ; movimento: movendo o conteudo de al para [pino_destino]

        mov edx, lenght                 ; tamanho da mensagem formatada
        mov ecx, msg                    ; mensagem formatada
        mov ebx, 1                      ; dá permissão para a saida
        mov eax, 4                      ; informa que será uma escrita no ecrã
        int 0x80                        ; Interrupção para kernel do linux

        mov     esp, ebp                ; Copiando o valor do registrador EBP para o ESP
        pop     ebp                     ; Recupera valor do topo da pilha para o registrador EBP
        ret                             ; retornar ao chamador


;______________________DECLARAÇÃO DE VARIÁVEIS INICIALIZADAS;
section .data
   
    menu db 'DIGITE A QUANTIDADE DE DISCOS: ' ,0xa      ; mensagem do menu que aparecerá ao rodar a aplicação
    len equ $-menu                                      ; tamanho da mensagem do menu armazenado em na variável 'len'
    escolha_origem db 'ESCOLHA O PINO DE ORIGEM (1, 2 OU 3)', 0xd
    len_origem equ $-escolha_origem
    escolha_destino db 'ESCOLHA O PINO DE DESTINO (1, 2 OU 3)', 0xf
    len_destino equ $-escolha_destino
    escolha_trabalho db 'ESCOLHA O PINO DE TRABALHO (1, 2 OU 3)', 0x12
    len_trabalho equ $-escolha_trabalho

    ; FORMATAÃ‡ÃƒO DE SAÃ DA
    msg:

                          db        "ORIGEM: "                      
        pino_origem:      db        " "  
                          db        " | DESTINO: "     
        pino_destino:     db        " ", 0xa  
        lenght            equ       $-msg


;______________________DECLARAÇÃO DE VARIÁVEIS NÃO INICIALIZADAS;
section .bss

    disco resb 5                 ; Armazenamento de dados não inicializado
    origem resb 3
    destino resb 3
    trabalho resb 3
    
    