Program trabalho_impressora ;

type cliente = record
		 	nome:string;
			qtdc:integer;
end;
			 	
		 ptnodo = ^elemento;
     elemento = record
         cli:cliente;
         prox:ptnodo;
         ante:ptnodo;
         priori:boolean;
     end;
     
var f:ptnodo;
		fim:ptnodo;
    nome_cli:cliente;
    op:byte;
    
Procedure leitura(var inf:cliente);

begin
    clrscr;
    WRITE ('Digite o numero: ');
    readln (inf.nome);
end;

Procedure Cria_fila(Var fila:ptnodo);

Begin
   fila:=nil;
   fim:=nil;
End;

{Funcao para Incluir no Inicio da fila}

Procedure Inclui (Var fila, fim:ptnodo;inf:cliente);
var aux,aux2:ptnodo;

Begin
   new(aux);
   if aux=nil then begin
      gotoxy (5,20);
      write ('Memoria cheia');
      readkey;
   end
   else
   		aux^.cli.nome:=inf.nome;
      if (fila=nil) then {Primeiro elemento}
         begin
            aux^.prox:=fila;
            aux^.ante := fila;
            fila:=aux;
            fim:=aux;
         end
      else
         begin {Inclui no Fim da Fila}
            aux2:=fim;
            aux^.ante:=aux2;
            aux2^.prox := aux;
            fim:=aux;
            aux^.prox := nil;
            
         end
End;


{Funcao para Remover no Inicio da fila}

Procedure Remove (Var fila, fim:ptnodo);
var aux, aux2 :ptnodo;

Begin
   if fila=nil then begin
      Writeln('fila Vazia');
      readkey;
   end
   else
      Begin
         aux:=fila;
         aux2:=aux^.prox;
         Writeln('Elemento retirado ', aux^.cli.nome);
         if fim = fila then
         	fim := nil;
         fila:=aux2;
         aux2^.ante := nil;
         dispose(aux);
         readkey;
      End;
End;


{Funcao para Contar Elementos da fila}

Function Conta_Elementos (fila:ptnodo):byte;
var aux:ptnodo;
    i:byte;

Begin
   if fila=nil then
      i:=0
   else
      Begin
         i:=0;
         aux:=fila;
         while aux <> nil do
         begin
            i:=i+1;
            writeln(i,' - ',aux^.cli.nome);
            aux:=aux^.prox;
         end;
      End;
   Conta_elementos:=i
End;

Function Conta_Elementos_fim (fim:ptnodo):byte;
var aux:ptnodo;
    i:byte;
Begin
   if fim=nil then
      i:=0
   else
      Begin
         i:=0;
         aux:=fim;
         while aux <> nil do
         begin
            i:=i+1;
            writeln(i,' - ',aux^.cli.nome);
            aux:=aux^.ante;
         end;
      End;
   Conta_elementos_fim:=i
End;

begin
    op:=1;
    cria_fila(f);
    while op<>0 do
    begin
       clrscr;
       writeln ('0-Sair');
       writeln ('1-Incluir');
       writeln ('2-Remover');
       writeln ('3-Mostrar Fila de Impressão');
       writeln ('4-Mostrar Fila de Impressão de Trás para Frente');
       writeln ('5-Prioridades de Impressão');
       readln (op);
       writeln;
       case op of
          1: begin
               leitura(nome_cli);
               inclui(f,fim,nome_cli)
             end;
          2: begin
              remove(f,fim);
             end;
          3: begin
               writeln (conta_elementos(f),' elementos');
               readkey;
             end;
          4: begin
               writeln (Conta_Elementos_fim(fim),' elementos');
               readkey;
             end;
       end;
    end;
end.
     