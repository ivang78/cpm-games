program g2048;

const
{$I ANSICOLR.INC}

var
  d,x,y,i,j,a,z:byte;
  f:array[0..16,0..16] of integer;
  c:char;
  score, bestscore:integer;
  terminal:byte;
label L1;

{$I CPM.INC}

procedure print;
begin
  SetTextColor(_WHITE);
  SetTextBg(_BLACK);
  for y:=1 to d+1 do begin
    gotoxy(5,y*4-1);
    for x:=1 to d do begin
      if (y=1) and (x=1) then write('+');
      if (y=d+1) and (x=1) then write('+');
      if (y>1) and (y<=d) and (x=1) then write('+');
      write('------');
      if (y=1) and (x=d) then write('+');
      if (y=d+1) and (x=d) then write('+');
      if (y>1) and (y<=d) and (x=d) then write('+');
      if (y>1) and (y<=d) and (x<d) then write('+');
      if (y=1) and (x<d) then write('+');
      if (y=d+1) and (x<d) then write('+');
    end;
    if y<=d then begin
      for z:=0 to 2 do begin
        gotoxy(5,y*4+z);
        for x:=1 to d do begin
          write('|');
          if (f[x,y]>0) then
          begin
            if (f[x,y] = 2) or (f[x,y] = 4) then
              begin
                SetTextColor(_BLUE);
                SetTextBg(_WHITE);
              end
            else if (f[x,y] = 8) or (f[x,y] = 16) then
              begin
                SetTextColor(_BLUE);
                SetTextBg(_YELLOW);
              end
            else if (f[x,y] = 32) or (f[x,y] = 64) then
              begin
                SetTextColor(_WHITE);
                SetTextBg(_MAGENTA);
              end
            else if f[x,y] > 64 then
              begin
                SetTextColor(_WHITE);
                SetTextBg(_RED);
              end;
            write(' ');
            if z = 1 then
              write(f[x,y]:4)
            else
              write('    ');
            write(' ');
            SetTextColor(_WHITE);
            SetTextBg(_BLACK);
          end
            else
          begin
            write('      ');
            end;
          end;
          write('|');
        end;
      end;
    end;
  SetTextBg(_BLUE);
  gotoxy(59,10);write('      ');
  gotoxy(52,10);write('score: ');write(score);
  if score>bestscore then
    bestscore:=score;
  gotoxy(52,11);write('best:  ');write(bestscore);
  SetTextBg(_BLACK);
end;

procedure dshf(x0,y0,dx,dy:integer);
var x,y,n:integer;
begin
  repeat
    x:=x0;y:=y0;n:=0;
 {   writeln('>',x0:4,y0:4,x:4,y:4);}
    repeat
      x:=x+dx;y:=y+dy;n:=f[x,y];
    until (n>0) or (x<1) or (x>d) or (y<1) or (y>d);
    if n=0 then exit;
    if f[x0,y0]=0 then
    begin
      f[x0,y0]:=n;f[x,y]:=0;
    end
      else
    begin
      if f[x0,y0]=n then
        begin
          f[x0,y0]:=2*n;f[x,y]:=0;score:=score+2*n;
        end;
      x0:=x0+dx;y0:=y0+dy;
    end;
{    writeln('<',x0:4,y0:4,x:4,y:4);}
  until false;
end;

procedure shft(dx,dy:integer);
var n:integer;
begin
  for n:=1 to d do begin
    if dx=-1 then dshf(1,n,1,0);
    if dx=1 then dshf(d,n,-1,0);
    if dy=-1 then dshf(n,1,0,1);
    if dy=1 then dshf(n,d,0,-1);
  end;
  n:=0;
  for x:=1 to d do begin
    for y:=1 to d do begin
      if f[x,y]=0 then n:=n+1;
    end;
  end;
  if n>0 then begin
    repeat
      x:=random(d)+1;y:=random(d)+1;
    until f[x,y]=0;
    f[x,y]:=a;
  end;
end;

begin
  randomize;
  d:=4;
  terminal:=1;
  write('2048 game, board size? (4 or 5): ');
  repeat
    repeat until keypressed;
    d:=ord(readkey)-48;
  until (d >= 4) and (d <= 5);
  clrscr;
  gotoxy(1,1);
  SetTextColor(_BLUE);
  SetTextBg(_WHITE);
  for z:=1 to 80 do
    write(' ');
  gotoxy(5,1);write('2048');
  SetTextColor(_WHITE);
  SetTextBg(_BLUE);
  for z:=2 to 12 do
  begin
    gotoxy(50,z); write('               ');
  end;
  gotoxy(52,3); write('W - up    ');
  gotoxy(52,4); write('S - down  ');
  gotoxy(52,5); write('A - left  ');
  gotoxy(52,6); write('D - right ');
  gotoxy(52,7); write('R - new   ');
  gotoxy(52,8); write('ESC - quit');
  SetTextColor(_WHITE);
  SetTextBg(_BLACK);
L1:
  score:=0;
  fillchar(f,sizeof(f),0);a:=2;
  shft(0,0);shft(0,0);
  repeat
    print;
    c:=upcase(readkey);
    case c of
      'A':shft(-1,0);
      'W':shft(0,-1);
      'S':shft(0,1);
      'D':shft(1,0);
      'R':goto L1;
      #27:begin end;
      else write(#7);
    end;
  until c=#27;
  clrscr;
end.
