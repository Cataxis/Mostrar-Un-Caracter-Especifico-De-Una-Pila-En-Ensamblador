.MODEL SMALL
.STACK
.DATA
  arr db 100 dup("$") ;arreglo para guardar los datos que se ingresan
  continuar db ?
  posicion db ?
  unidad db ?
  cant db ?
  letra db ?, "$"
  m1 db 10,13,"Cuantos datos quiere ingresar? $"
  m2 db 10,13,"Ingrese los datos: $"
  m3 db 10,13,"El arreglo es igual a: $"
  m4 db 10,13,"El arreglo invertido es igual a: $"
  m5 db 10,13,"Cual posicion quiere buscar? $"
  m6 db 10,13,"El arreglo es: [$"
  m77 db " es: ",10,13,"$"
  m7 db 10,13,"El caracter en la posicion $"
  m8 db 10,13,"Volver a intentarlo? Si = 1 y No = 0",10,13,"$"
  m9 db 10,13,"Numero no valido$"


.CODE
  mov ax, @DATA
  mov ds, ax ;Inicializar variables


  inicio:
  mov ah, 09h
  lea dx, m1 ;Mensaje 1
  int 21h


  mov ah, 01h
  int 21h
  sub al, 30h  ;Pedir decimal numero de datos
  mov cant, al
 
  mov ah, 01h
  int 21h
  sub al, 30h  ;Pedir unidad numero de datos
  mov ah, cant
  aad ;Ah = 0 Al = 10 * Ah + Al
  mov cant, al


  cmp cant, 0 ;Compara para que sea distinto a cero
  je inicio ;Salta a inicio si es 0


  mov ah, 09h
  lea dx, m2 ;Mensaje 2
  int 21h
  ;Cantidad de veces que se hara el ciclo
  mov cl, cant


  ;Ingresar datos
  ingresar:
  mov ah,01h ;servicio para ingresar caracteres
  int 21h
  push ax ;meter a la pila de ax la tecla pulsada
  inc si ;Incremento en SI para despues tomar la posicion del arreglo
  loop ingresar
 
  ;Mostrar cadena
  mov ah,09h
  lea dx, m4 ;llamamos la variable mensaje
  int 21h


  ;Cantidad de veces que se hara el ciclo
  mov cl, cant
  sub si, 01h ;Restar 1 a si


  sacar: ;metodo para sacar de la pila
  pop ax ;Toma el ultimo dato de la pila y se almacena en ax
  ;el pop se almacena en al el caracter de la pila
  mov ah,02h ;mandamos el servicio para imprimir caracter
  mov dl, al ;movemos a dl para imprimir
  int 21h ;llamamos la interrupcion
  mov arr[si], al ;tomar la posicion del arreglo con si para moverlo a al
  dec si ;decrementamos si para obtener la pos anterior
  loop sacar
;Mensaje 3
  mov ah,09h
  lea dx, m3
  int 21h
;Mostrar cadena
  mov ah,09h
  lea dx, arr ; imprimimos la cadena
  int 21h
;Mensaje 5
PedirPosi:
  mov ah,09h
  lea dx, m5 ;Imprimimos el mensaje
  int 21h


  mov ah, 01h
  int 21h      ;Pedir la decena de posicion a buscar
  sub al, 30h
  mov posicion, al


  mov ah, 01h
  int 21h   ;Pedir la unidad de posicion a buscar
  sub al, 30h
  mov ah, posicion
  aad ;Juntarlas
  mov posicion, al


  mov al, cant
  cmp posicion, al ;Comparar para asegurarnos que la posicion que buscamos exista(No este vacia)
  jg Novali ;Salta si posicion es mayor al tamaño del arreglo
  jmp mostrarArr


  Novali:
  mov ah, 09h
  lea dx, m9
  int 21h
  jmp PedirPosi
 
mostrarArr:
  mov cl, posicion ;Movemos a cl para el ciclo en Posi
  XOR si, si
;Mensaje 6
  mov ah, 09h
  lea dx, m6 ;Mensaje 6
  int 21h


  mov cl, cant
RecorreArr:
  mov al, arr[si] ;Movemos lo de arr a al
  mov ah, 02h
  mov dl, al
  int 21h
  inc unidad
  mov al, cant
  cmp unidad, al
  je comafin
  mov ah, 02h
  mov dl, 2ch
  int 21h
  comafin:
  inc si ;Incrementamos si
  loop RecorreArr ;(Hace el ciclo hasta que llegue a la posicion que queremos)
  mov ah, 02h
  mov dl, 5dh
  int 21h
  XOR si, si ;Limpiamos SI por si se quiere continuar ejecutando el programa


  mov cl, posicion
Posi:
  mov al, arr[si] ;Movemos lo de arr a al
  inc si ;Incrementamos si
  loop Posi ;(Hace el ciclo hasta que llegue a la posicion que queremos)
  mov letra, al ;Movemos la posicion que buscamos a letra
  XOR si, si ;Limpiamos SI por si se quiere continuar ejecutando el programa
;Mensaje 7
  mov ah,09h
  lea dx, m7 ;Imprimimos mensaje
  int 21h


  mov al, posicion ;Separamos posicion en decenas y unidades
  aam ;AH=AL/10 AL=AL mod 10
  mov posicion, ah ;Guardamos ah en posicion
  mov unidad, al ;Guardamos al en unidad


  mov ah, 02h ;Imprimimos posicion(decena)
  mov dl, posicion
  add dl, 30h ;Lo hacemos hexadecimal
  int 21h
 
  mov ah, 02h
  mov dl, unidad ;Imprimimos unidad
  add dl, 30h ;Lo hacemos hexadecimal
  int 21h
 
  mov unidad, 00h


  mov ah, 09h
  lea dx, m77
  int 21h


letraposicion:
mov ah, 09h
lea dx, letra ;Imprimimos la letra que buscamos
int 21h


;Mensaje 8
Continua:
  mov ah,09h
  lea dx, m8
  int 21h
 
  mov ah, 01h ;Pedir 1 o 0
  int 21h
  sub al, 30h
  mov continuar, al
  cmp continuar, 0
  je Salir
  cmp continuar, 1
  jne Novalido
  mov cl, cant
 
Limpiar:
  mov arr[si], 00h ;Movemos 00h a arr
  inc si ;Incrementamos si
  loop Limpiar ;(Hace el ciclo hasta que limpiar todo el arreglo)
  XOR si, si ;Limpiamos SI por si se quiere continuar ejecutando el programa
  jmp inicio


Novalido:
  mov ah, 09h
  lea dx, m9
  int 21h
  jmp Continua


Salir:
  mov ah, 4ch  
  int 21h


end
