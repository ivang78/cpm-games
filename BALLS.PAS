program balls;

type str2=string[2];

const FSM=15;
  FSC=225;
{$I ANSICOLR.INC}
  
var x,y,i,fs,mc,pl,z:byte;
  f:array[1..FSM,1..FSM] of byte;
  c:char;
  bs:boolean;
  sc,m:integer;
  terminal:byte;

{$I DOS.INC}

procedure SetColor(b1:byte);
begin
  if b1 = 0 then
    SetTextColor(_BLACK)
  else if b1 = 1 then
    SetTextColor(_RED)
  else if b1 = 2 then
    SetTextColor(_GREEN)
  else if b1 = 3 then
    SetTextColor(_YELLOW)
  else if b1 = 4 then
    SetTextColor(_BLUE)
  else if b1 = 5 then
    SetTextColor(_MAGENTA)
  else if b1 = 6 then
    SetTextColor(_CYAN)
  else if b1 = 7 then
    SetTextColor(_WHITE);
end;

procedure drwb(x,y:byte;s:str2);
begin
  gotoxy(x*3+1,y+2); write(s);
end;

procedure updb(x,y:byte);
begin
  gotoxy(x*3,y+2); SetColor(f[x,y]);
end;

function chkl(x,y,dx,dy:integer;fl:byte):boolean;
var xx,yy,i,c:byte;
  b:boolean;
begin
  c:=f[x,y]; i:=1;
  xx:=x; yy:=y;
  while (xx>0) and (xx<=FS) and (yy>0) and (yy<=FS) do begin
    xx:=xx+dx; yy:=yy+dy;
    if f[xx,yy]=c then begin
      i:=i+1; f[xx,yy]:=f[xx,yy] or fl;
    end else xx:=0;
  end;
  xx:=x; yy:=y;
  while (xx>0) and (xx<=FS) and (yy>0) and (yy<=FS) do begin
    xx:=xx-dx; yy:=yy-dy;
    if f[xx,yy]=c then begin
      i:=i+1; f[xx,yy]:=f[xx,yy] or fl;
    end else xx:=0;
  end;
  chkl:=(i>=mc);
end;

procedure chks(s:str2;fl:byte);
var x,y:byte;
begin
  for x:=1 to FS do for y:=1 to FS do if (f[x,y] and fl)>0 then drwb(x,y,s);
  delay(100);
end;

function chk(x,y:byte):boolean;
var fl,i:byte;
  b:boolean;
begin
  fl:=0; chk:=true;
  if chkl(x,y,1,0,$80) then fl:=fl or $80;
  if chkl(x,y,0,1,$40) then fl:=fl or $40;
  if chkl(x,y,1,1,$20) then fl:=fl or $20;
  if chkl(x,y,-1,1,$10) then fl:=fl or $10;
  if fl>0 then begin
    f[x,y]:=f[x,y] or fl;
    chks('()',fl);
	chks('{}',fl);
    chks('()',fl);
    chks('<>',fl);
    chks('::',fl);
    chks('..',fl);
    SetTextColor(_WHITE);
    chks('##',fl);
    i:=0;
    for x:=1 to FS do for y:=1 to FS do if (f[x,y] and fl)>0 then begin
      f[x,y]:=0;i:=i+1;
      updb(x,y);
    end;
    sc:=sc+i;
    gotoxy(FS*3+10+7,3); SetTextColor(_WHITE); write(sc);
    chk:=false;
  end;
  for x:=1 to FS do for y:=1 to FS do f[x,y]:=f[x,y] and 7;
end;

function addb:boolean;
var x,y,i,n:byte;
  ef:array[1..FSC,1..2] of byte;
  b:boolean;
begin
  n:=0; addb:=false;
  for x:=1 to FS do for y:=1 to FS do if f[x,y]=0 then begin
    n:=n+1; ef[n,1]:=x; ef[n,2]:=y;
  end;
  if n=0 then exit;
  i:=random(n)+1; x:=ef[i,1]; y:=ef[i,2];
  f[x,y]:=random(mc)+1;
  drwb(x,y,'  '); updb(x,y);
  drwb(x,y,'..'); delay(100);
  drwb(x,y,'::'); delay(100);
  drwb(x,y,'<>'); delay(100);
  drwb(x,y,'()'); delay(100);
  drwb(x,y,'{}'); delay(100);
  drwb(x,y,'()'); delay(100);
  b:=chk(x,y);
  addb:=true;
end;

procedure add3;
var x,y,n:byte;
begin
  if addb then if addb then if addb then
  begin
    m:=m+1; gotoxy(FS*3+10+7,4); SetTextColor(_WHITE); SetTextBg(_BLUE); write(m); SetTextBg(_WHITE);
    n:=0; for x:=1 to FS do for y:=1 to FS do if f[x,y]=0 then n:=n+1;
    if n>0 then exit;
  end;
  gotoxy(1,FS+5); write('Game Over!');
  c:=#27;
end;

procedure rstb(x,y:byte);
begin
  gotoxy(x*3,y+2);
  if f[x,y] = 0 then
  begin
    SetTextColor(_BLACK);
    SetTextBg(_WHITE);
    write(' ## ');
    SetTextBg(_WHITE);
  end
  else
    write(' () ');
end;

procedure clrb(x,y:byte);
begin
  gotoxy(x*3+1,y+2); write('{}');
end;

procedure updf;
var x,y:byte;
begin
  for y:=1 to FS do begin
    for x:=1 to FS do begin
      updb(x,y); rstb(x,y);
    end;
  end;
end;

procedure _mark(c1,c2:char);
begin
  updb(x,y); write(c1);
  gotoxy(x*3+3,y+2); write(c2);
end;

procedure unmark;
begin
  _mark(' ',' ');
end;

procedure mark;
begin
  _mark('[',']');
end;

procedure mvm(dx,dy:integer);
var xx,yy,i:integer;
  b,b1:boolean;
begin
  xx:=x; yy:=y;
  repeat
    yy:=yy+dy; xx:=xx+dx; b:=true;
    b1:=(xx>0) and (xx<=FS) and (yy>0) and (yy<=FS);
    if b1 then begin
      for i:=0 to FS do if b then begin
        if dx<=0 then if (xx-i>0) and (f[xx-i,yy]<>0) then begin xx:=xx-i; b:=false; end;
        if dx>=0 then if (xx+i<=FS) and (f[xx+i,yy]<>0) then begin xx:=xx+i; b:=false; end;
      end;
      if b=false then begin
        unmark;
        x:=xx; y:=yy; mark;
        exit;
      end;
    end;
  until b1=false;
  write(#7);
end;

procedure mvb(dx,dy:integer);
var xx,yy:byte;
begin
  yy:=y+dy; xx:=x+dx;
  if (yy>0) and (yy<=FS) and (xx>0) and (xx<=FS) then if (f[xx,yy]=0) then begin
    f[xx,yy]:=f[x,y];
    f[x,y]:=0;
    SetTextColor(_BLACK);
    SetTextBg(_WHITE);
    drwb(x,y,'## ');
    SetTextBg(_WHITE);
    updb(x,y);
    unmark;
    x:=xx; y:=yy; mark;
    exit;
  end;
  write(#7);
end;

procedure mv(dx,dy:integer);
begin
  if bs then mvb(dx,dy) else mvm(dx,dy);
end;

procedure mfst;
begin
  for y:=1 to FS do for x:=1 to FS do if f[x,y]<>0 then exit;
end;

{
procedure prc;
var x,y:byte;
begin
  gotoxy(1,14);
  for y:=1 to FS do begin
    for x:=1 to FS do write(f[x,y]:3);
    writeln;
  end;
end;
}

begin
  clrscr;
  SetTextColor(_WHITE);
  writeln('CRISS CP/M CLR. Balls game');
  fs:=9; mc:=5; pl:=5;
  terminal:=1;
  writeln('Field ',fs,'x',fs,', ',mc,' Colors, ',pl,' Per line');
  writeln('Press S to change settings, any key to start or ESC to cancel');
  case readkey of
    #27:exit;
    's','S':begin
          write('Field size 5-15 (',fs,'): '); readln(fs);
          if fs<5 then fs:=5; if fs>15 then fs:=15;
          write('Number of colors 2-7 (',mc,'): '); readln(mc);
          if mc<2 then mc:=2; if mc>7 then mc:=7;
          write('Balls per line 3-7 (',pl,'): '); readln(pl);
          if pl<3 then mc:=3; if pl>7 then pl:=7;
        end;
  end;

  clrscr;
  gotoxy(1,1);
  SetTextColor(_BLUE);
  SetTextBg(_WHITE);
  for z:=1 to 80 do
    write(' ');
  gotoxy(5,1); writeln('Balls game 5 for line, CRISS CP/M CLR version 0.1');

  SetTextColor(_BLACK);
  SetTextBg(_WHITE);
  write(' +-'); for x:=1 to FS do write('---'); writeln('+');
  for y:=1 to FS do begin
    write(' |');
    write(' ');
    for x:=1 to FS do write('## ');
    writeln('|');
  end;
  write(' +-'); for x:=1 to FS do write('---'); writeln('+');
  fillchar(f,sizeof(f),0);

  SetTextColor(_WHITE);
  SetTextBg(_BLUE);
  for z:=2 to 17 do
  begin
    gotoxy(FS*3+9,z); write('                   ');
  end;
  gotoxy(FS*3+10,3);  write('Score: 0');
  gotoxy(FS*3+10,4);  write('Moves:');
  gotoxy(FS*3+10,6);  write('Settings:');
  gotoxy(FS*3+10,7);  write('Field: ',fs,'x',fs);
  gotoxy(FS*3+10,8);  write('Colors: ',mc);
  gotoxy(FS*3+10,9);  write('Balls per line: ',pl);
  gotoxy(FS*3+10,11); write('W - up    ');
  gotoxy(FS*3+10,12); write('S - down  ');
  gotoxy(FS*3+10,13); write('A - left  ');
  gotoxy(FS*3+10,14); write('D - right ');
  gotoxy(FS*3+10,15); write('R - new   ');
  gotoxy(FS*3+10,16); write('ESC - quit');

  bs:=false; sc:=0; m:=0;
  updf;
  {readkey;}
  add3;
  repeat
    if (x<1) or (x>FS) or (y<1) or (y>FS) then begin x:=1; y:=1; end;
    if f[x,y]=0 then begin mfst; mark; end;
    if bs then repeat
      drwb(x,y,'{}');
      delay(100);
      drwb(x,y,'()');
      delay(100);
    until keypressed;
    c:=upcase(readkey);
    case c of
      'Q': mv(0,-1);
      'A': mv(0,1);
      'O': mv(-1,0);
      'P': mv(1,0);
      ' ',#13: if bs then begin
              bs:=false; unmark;
              if chk(x,y) then add3; {updf;}
              if f[x,y]>0 then mark;
            end else begin
              bs:=true;
            end;
      'Z':begin updf; mark; end;
      {'X':prc;}
      #27:begin gotoxy(1,FS+5); SetTextColor(_WHITE); SetTextBg(_BLACK); write('You are leaving this game...'); end;
    end;
  until c=#27;

  SetTextColor(_WHITE);
  SetTextBg(_BLACK);
  gotoxy(1,FS+6);
  writeln('Exit to CP/M. Press any key.');
  readkey;
  clrscr;
  SetTextColor(_WHITE);
end.
