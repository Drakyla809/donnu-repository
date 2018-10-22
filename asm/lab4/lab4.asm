.686p
.model flat, stdcall

; ��������� ������� �������
SetConsoleTitleA PROTO :DWORD
GetStdHandle PROTO :DWORD
WriteConsoleA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadConsoleA PROTO, handle:dword, lpBuffer:ptr byte, nNumberOfCharsToRead:dword, lpNumberOfCharsRead:ptr dword, pInputControl:dword
CharToOemA PROTO :DWORD, :DWORD
Sleep PROTO :DWORD
ExitProcess PROTO :DWORD
AllocConsole PROTO

MessageBoxA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD 
wsprintfA PROTO C :VARARG

.const
STD_OUTPUT_HANDLE equ -11 ; ��������� Win API
STD_INPUT_HANDLE equ -10 ; ��������� Win API

BUFFER_SIZE equ 128
.data
sConsoleTitle db 'Fourth lab on MASM',0
consoleOutHandle dd	 ? ; ���������� ������� ������
consoleInHandle dd ? ; ���������� ������� �����
bytesWritten dd ? ; ���������� ����
message db "������ ����!",13,10,0 ;

readbuffer db BUFFER_SIZE dup (0)
countreadBuffer dd ?

buffer db 128 dup(0)
answer db 128 dup(0)

bufferSpace db 128 dup(0)
answerSpace db 128 dup(0)
formatSpace db 'string:%sspaces:%d', 0

countSpaces dd 0

h EQU $ - message ; ����� ��������� ������ (���������)
.code
start:

INVOKE AllocConsole

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov consoleOutHandle, eax

invoke GetStdHandle, STD_INPUT_HANDLE 
mov consoleInHandle, eax

invoke SetConsoleTitleA, offset sConsoleTitle

invoke ReadConsoleA, consoleInHandle, addr readbuffer, BUFFER_SIZE, offset countreadBuffer, 0 ; realCountreadBuffer = countreadBuffer - 2 

mov eax, countreadBuffer
sub eax,3
mov countreadBuffer, eax

mov ecx,0
mov edi,0

.WHILE ecx <= countreadBuffer
push ecx

mov ebp, ecx

mov eax, dword ptr [readbuffer + ebp]

cmp al, ' '
jne @notspace

cmp ebx,1
jne @space

mov eax, countSpaces
inc eax
mov countSpaces, eax

jmp @cnt
@space:

mov ebx,1

mov dword ptr [answer + edi], eax
inc edi

jmp @cnt

@notspace:

mov ebx,0

mov dword ptr [answer + edi], eax
inc edi

jmp @cnt

@cnt:
pop ecx
inc ecx
.ENDW	

invoke wsprintfA, addr bufferSpace, addr formatSpace, addr answer, countSpaces

mov eax, h
INVOKE WriteConsoleA, consoleOutHandle, addr bufferSpace, 64, offset bytesWritten, 0

INVOKE Sleep, 10000
INVOKE ExitProcess, 0
END start