.686P
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
.data  
ClassName db "life",0
AppName   db "life",0
.data?
hwnd      LPVOID ?
hInstance HINSTANCE ?
msg       MSG <>
wndClassEx WNDCLASSEX <>
.code
WndProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .IF uMsg==WM_CLOSE
        invoke DestroyWindow,hwnd
        invoke PostQuitMessage,0
    .ELSE
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam        
        ret
    .ENDIF
    xor eax,eax
    ret
WndProc ENDP
life:
	invoke	GetModuleHandle,NULL
	mov hInstance, eax
	mov wndClassEx.hInstance, eax
	mov wndClassEx.cbSize,SIZEOF WNDCLASSEX
    mov wndClassEx.style,CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNCLIENT
    mov wndClassEx.lpfnWndProc,OFFSET WndProc
    mov wndClassEx.cbClsExtra,NULL
    mov wndClassEx.cbWndExtra,NULL
    mov wndClassEx.hbrBackground,COLOR_MENUTEXT
    mov wndClassEx.lpszMenuName,NULL
    mov wndClassEx.lpszClassName,OFFSET ClassName
    invoke LoadCursor,NULL,IDC_ARROW
    mov wndClassEx.hCursor,eax
    invoke LoadIcon,hInstance,500
    mov wndClassEx.hIcon,eax
    mov wndClassEx.hIconSm,eax
	invoke RegisterClassEx,ADDR wndClassEx
    invoke CreateWindowEx,0,ADDR ClassName,ADDR AppName,\
                          WS_POPUP,0,0,1366,768,NULL,NULL,\
                          hInstance,NULL
	mov hwnd,eax
    invoke ShowWindow,hwnd,SW_SHOWNORMAL
    invoke UpdateWindow,hwnd
    MsgLoop:
        invoke GetMessage,ADDR msg,0,0,0
        test eax,eax
        jz EndLoop
        invoke TranslateMessage,ADDR msg
        invoke DispatchMessage,ADDR msg
        jmp MsgLoop
    EndLoop:
    invoke ExitProcess,eax
end life