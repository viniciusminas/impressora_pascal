{Fazer um software para gerenciar as filas de atendimento da empresa Copytech: fila mono, fila color e fila plotter.  
O sistema deve gerenciar entradas/saídas/consultas nas filas, além de informar a quantidade de pessoas entrantes, a quantidade de cópias por fila. 
Para cada cliente são informados nome e quantidade de cópias. O sistema deve possibilitar ainda que um determinado cliente seja atendido prioritariamente, 
ou seja, após entrar na fila, o usuário pode escolher aleatoriamente um processo e jogá-lo para a primeira posição da fila, 
desde que o processo que esteja na primeira posição já não seja prioritário.

Observações:

* Fila duplamente encadeada
* Prioridade é informada pelo usuário e o processo é deslocado para o início da fila, porém deve ser respeitado se há outros processos prioritários à frente}

Program trabalho_impressora;

type
    cliente = record
        nome: string;
        qtdc: integer;
    end;

    ptnodo = ^elemento;
    elemento = record
        cli: cliente;
        prox: ptnodo;
        ante: ptnodo;
        priori: boolean;
    end;

var
    f,f2,f3: ptnodo;
    fim, fim2, fim3: ptnodo;
    nome_cli: cliente;
    op: byte;
    total_clientes: integer;
    total_copias: integer;
    f_inc: integer;
    qtdc:integer;

Procedure leitura(var inf: cliente);
begin
    clrscr;
    write('Digite o nome: ');
    readln(inf.nome);
    write('Digite a quantidade de cópias: ');
    readln(inf.qtdc);
end;

Procedure Cria_fila(var fila, fim: ptnodo);
begin
    fila := nil;
    fim := nil;
    total_clientes := 0;
    total_copias := 0;
end;

{Função para Incluir no Fim da fila}
Procedure Inclui(var fila, fim: ptnodo; inf: cliente);
var
    aux, aux2: ptnodo;
begin
    new(aux);
    if aux = nil then
    begin
        write('Memória cheia');
        readkey;
    end
    else
    begin
    		aux^.cli.qtdc := 0;
        aux^.cli := inf;
        aux^.prox := nil;
        aux^.priori := False;
        if fila = nil then
        begin
            aux^.ante := nil;
            fila := aux;
            fim := aux;
        end
        else
        begin
            aux2 := fim;
            aux^.ante := aux2;
            aux2^.prox := aux;
            fim := aux;
        end;
        total_clientes := total_clientes + 1;
        total_copias := total_copias + inf.qtdc;
    end;
end;

{Função para Remover no Início da fila}
Procedure Remove(var fila, fim: ptnodo);
var
    aux: ptnodo;
begin
    if fila = nil then
    begin
        writeln('Fila Vazia');
        readkey;
    end
    else
    begin
        aux := fila;
        writeln('Elemento retirado: ', aux^.cli.nome);
        fila := aux^.prox;
        if fila <> nil then
            fila^.ante := nil
        else
            fim := nil;
        total_clientes := total_clientes - 1;
        total_copias := total_copias - aux^.cli.qtdc;
        dispose(aux);
        readkey;
    end;
end;

{Função para Contar Elementos da fila}
Function Conta_Elementos(fila: ptnodo; var qtdc:integer): byte;
var
    aux: ptnodo;
    i: byte;
begin
    i := 0;
    qtdc := 0;
    aux := fila;
    while aux <> nil do
    begin
        i := i + 1;
        writeln(i, ' - ', aux^.cli.nome, ' (', aux^.cli.qtdc, ' cópias)');
        qtdc := qtdc + aux^.cli.qtdc;
        aux := aux^.prox;
    end;
    Conta_Elementos := i;
end;

Function Conta_Elementos_fim(fim: ptnodo; var qtdc:integer): byte;
var
    aux: ptnodo;
    i: byte;
begin
    i := 0;
    qtdc := 0;
    aux := fim;
    while aux <> nil do
    begin
        i := i + 1;
        writeln(i, ' - ', aux^.cli.nome, ' (', aux^.cli.qtdc, ' cópias)');
        qtdc := qtdc + aux^.cli.qtdc;
        aux := aux^.ante;
    end;
    Conta_Elementos_fim := i;
end;

procedure prioridade(var fila, fim: ptnodo);
var
    aux, aux2, aux3: ptnodo;
    processo: string;
    q : integer;
begin
		q := 0;
    Conta_Elementos(fila, q);
    write('Digite o nome do processo que deseja dar prioridade: ');
    readln(processo);
    

    aux := fila;
    aux2 := fila;

    while (processo <> aux^.cli.nome) and (aux <> nil) do
    begin
        aux2 := aux;
        aux := aux^.prox;
    end;

    if aux = nil then
    begin
        writeln;
        writeln('Processo não encontrado');
        readkey;
    end
    else
    begin
        if aux^.priori <> True then
        begin
            aux3 := aux^.prox;
            aux^.priori := True;

            if aux <> fila then
            begin
                if aux3 = nil then
                begin
                    aux2^.prox := nil; 
                    fim := aux2;
                end
                else
                begin
                    aux2^.prox := aux3;
                    aux3^.ante := aux2;
                end;

                aux2 := fila;
                aux3 := fila;

                if fila^.priori = true then
                begin
                    while (aux3^.priori) and (aux3 <> nil) do
                    begin
                        aux2 := aux3;
                        aux3 := aux3^.prox;
                    end;
                    if aux3 <> nil then
                    begin
                        aux2^.prox := aux;
                        aux^.prox := aux3;
                        aux^.ante := aux2;
                        aux3^.ante := aux;
                    end
                    else
                    begin
                        aux2^.prox := aux;
                        aux^.prox := nil;
                        aux^.ante := aux2;
                        fim := aux;
                    end;
                end
                else
                begin
                    fila := aux;
                    aux^.prox := aux2;
                    aux^.ante := nil;
                    aux2^.ante := aux;
                end;
            end;
        end;
    end;
end;

procedure mostrar_informacoes;
begin
	writeln('Total de clientes na fila: ', total_clientes);
	writeln('Total de cópias na fila: ', total_copias);
	readkey;
end;

begin
    op := 1;
    cria_fila(f, fim);
    while op <> 0 do
    begin
        clrscr;
        writeln('0 - Sair');
        writeln('1 - Incluir');
        writeln('2 - Remover');
        writeln('3 - Mostrar Fila de Impressão');
        writeln('4 - Mostrar Fila de Impressão de Trás para Frente');
        writeln('5 - Priorizar Impressão');
        writeln('6 - Mostrar Informações da Fila');
        readln(op);
        writeln;
        case op of
            1: begin
                   leitura(nome_cli);
                   clrscr;
                   writeln('1 - Fila Mono');
                   writeln('2 - Fila Color');
                   writeln('3 - Fila Plotter');
                   writeln;
                   write('Digite o número da fila em que deseja incluir o processo: ');                   
                   read(f_inc);
                   	if f_inc = 1 then
                   		inclui(f, fim, nome_cli)
                   	else if f_inc = 2 then
                   		inclui(f2, fim2, nome_cli)
                   	else if f_inc = 3 then
                   		inclui(f3, fim3, nome_cli)
                   	else
                   		writeln('Fila de Impressão Inexistente!');					
               end;
            2: begin
            			 clrscr;
                   writeln('1 - Fila Mono');
                   writeln('2 - Fila Color');
                   writeln('3 - Fila Plotter');
                   writeln;
                   write('Digite o número da fila em que deseja remover o processo: ');                   
                   read(f_inc);
                   	if f_inc = 1 then
                   		remove(f, fim)
                   	else if f_inc = 2 then
                   		remove(f2, fim2)
                   	else if f_inc = 3 then
                   		remove(f3, fim3)
                   	else
                   		writeln('Fila de Impressão Inexistente!');     
               end;
            3: begin
            			 writeln;
            			 writeln(conta_elementos(f, qtdc), ' Elemento(os) na FILA 1 - ', qtdc, ' Cópias');
            			 writeln;
            			 writeln(conta_elementos(f2, qtdc), ' Elemento(os) na FILA 2 - ', qtdc, ' Cópias');
            			 writeln;
            			 writeln(conta_elementos(f3, qtdc), ' Elemento(os) na FILA 3 - ', qtdc, ' Cópias');
                   readkey;
               end;
            4: begin
            			 writeln;
                   writeln(conta_elementos_fim(fim, qtdc), ' Elemento(os) na FILA 1 - ', qtdc, ' Cópias');
            			 writeln;
            			 writeln(conta_elementos_fim(fim2, qtdc), ' Elemento(os) na FILA 2 - ', qtdc, ' Cópias');
            			 writeln;
            			 writeln(conta_elementos_fim(fim3, qtdc), ' Elemento(os) na FILA 3 - ', qtdc, ' Cópias');
                   readkey;
               end;
            5: begin
                   clrscr;
                   writeln('1 - Fila Mono');
                   writeln('2 - Fila Color');
                   writeln('3 - Fila Plotter');
                   writeln;
                   write('Digite o número da fila em que deseja priorizar o processo: ');                   
                   read(f_inc);
                   	if f_inc = 1 then
                   		prioridade(f, fim)
                   	else if f_inc = 2 then
                   		prioridade(f2, fim2)
                   	else if f_inc = 3 then
                   		prioridade(f3, fim3)
                   	else
                   		writeln('Fila de Impressão Inexistente!'); 
               end;
            6: begin
                   mostrar_informacoes;
               end;
        end;
    end;
end.
