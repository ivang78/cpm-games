procedure SetTextColor(c: byte);
var cs: string[2];
begin
  if terminal = 1 then
    begin
      str(c + 30, cs);
      write(#27); write(#91); write(cs); write('m');
    end;
end;

procedure SetTextBg(c: byte);
var cs: string[2];
begin
  if terminal = 1 then
    begin
      str(c + 40, cs);
      write(#27); write(#91); write(cs); write('m');
    end;
end;

{ emulate missing CRT functions }
function ReadKey : Char;
begin
    ReadKey := Chr(Bios(2)); {ConIn}
end;

{ ANSI CursorOff }
procedure CursorOff;
begin
  Write(_COFF);
end;

{ ANSI CursorOn }
procedure CursorOn;
begin
  Write(_CON);
end;
