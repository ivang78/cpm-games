program Evas10n;

{uses crt;}
{$C-}

{
  EVAS10N.PAS 1.1

  A Turbo Pascal rewrite of Evas10n,
  a BASIC 10-Liner breakout game for the ZX Spectrum.

  Marco's Retrobits
  https://retrobits.altervista.org
  https://retrobits.itch.io

  2020.06.04 Version 1.1:
             * show bales-1
             * constants for ball, bat and brick characters
  2020.06.02 First release
}

const
  BallChar: Char = '@';
  BatChars: String[3] = '===';
  BrickChar : Char = '#';

  scrw = 80;
  scrh = 24;
  batw = 5;

{$I ANSICOLR.INC}

var
  del, code, bat, batDir, balls, v, w, x, y: Integer;
  bricks: array[3..8] of array[1..80] of Boolean;
  exit, lostBall: Boolean;
  ch: Char;
  param: String[5];
  terminal: byte;
  iter: byte;
  dc: boolean;

{$I CPM.INC}

procedure WriteBricks;
  var
    r, c: Integer;
  begin
    for r := 3 to 8 do
      begin
        if (r = 3) or (r = 8) then
          begin
            SetTextColor(_YELLOW);
          end;
        if r = 4 then
          begin
            SetTextColor(_RED);
          end;
        if r = 5 then
          begin
            SetTextColor(_GREEN);
          end;
        if r = 6 then
          begin
            SetTextColor(_BLUE);
          end;
        if r = 7 then
          begin
            SetTextColor(_MAGENTA);
          end;
        for c := 2 to scrw - 1 do
          begin
            GotoXY(c,r);
            Write(BrickChar);
          end;
      end;
  end;

procedure WriteBat;
  begin
    GotoXY(bat, 22);
    SetTextColor(_RED);
    Write('*');
    SetTextColor(_CYAN);
    Write(BatChars);
    SetTextColor(_RED);
    Write('*');
    SetTextColor(_WHITE);
    GotoXY(1, 1);
  end;

procedure DeleteBat;
  begin
    GotoXY(bat, 22);
    Write('     ');
    GotoXY(1, 1);
  end;

procedure WriteBall;
  begin
    SetTextColor(_WHITE);
    GotoXY(x, y);
    Write(BallChar);
    GotoXY(1, 1);
  end;

procedure DeleteBall;
  begin
    GotoXY(x, y);
    Write(' ');
  end;

procedure Help;
    var tc: char;
  begin
    ClrScr;
    Writeln('EVAS10N.PAS v. 1.1');
    Writeln;
    Writeln('A Turbo Pascal rewrite of Evas10n,');
    Writeln('a BASIC 10-Liner breakout game for the ZX Spectrum.');
    Writeln;
    Writeln('Synopsis:');
    Writeln(' EVAS10N [DELAY]');
    Writeln(' DELAY: game loop iteration delay in milliseconds.');
    Writeln('        Default: 800 (assuming 28MHz CPU)');
    Writeln;
    Writeln('Control keys:');
    Writeln(' q:         quit');
    Writeln(' z:         move bat left');
    Writeln(' x:         move bat right');
    Writeln(' any other: stop bat');
    Writeln;
    Writeln('Marco''s Retrobits');
    Writeln('https://retrobits.altervista.org');
    Writeln('https://retrobits.itch.io');
    Writeln('Adapted for ANSI terminal https://github.com/ivang78');
    Writeln;
    Writeln('1. ANSI      ');
    Writeln('2. VT102     ');
    repeat
      repeat until keypressed;
      tc := readkey;
    until (tc = '1') or (tc = '2');
    terminal := ord(tc) - 48;
  end;

procedure DrawBorder;
var
   l: byte;
begin
   SetTextColor(_CYAN);
   gotoxy(1,1);
   write('+');
   for l:=2 to scrw - 1 do
     begin
        write('-');
     end;
   write('+');
   for l:=2 to scrh-3 do
     begin
        gotoxy(1,l); write('|');
        gotoxy(scrw,l); write('|');
     end;
end;

procedure Init;
  var
    r, c: Integer;
  begin
    balls := 6;
    bat := 15;
    x := 40;
    y := 21;
    v := 1;
    batDir := 1;
    exit := False;
    ClrScr;
    for r := 3 to 8 do
      for c := 2 to scrw - 1 do
        begin
          bricks[r, c] := true;
        end;
    WriteBricks;
    SetTextColor(_WHITE);
    GotoXY(35, 24);
    Write('EVAS10N.PAS by Marco V. 2020, ivang78 2023');
  end;

begin
  CursorOff;
  Help;
  del := 150; { 28 MHz assumed }
  if (ParamCount > 0) then
    begin
      param := ParamStr(1);
      Val(param, del, code);
      if (code <> 0) then
        begin
          Help;
          Halt;
        end;
    end;
  repeat
    Init;
    DrawBorder;
    repeat
      w := -1;
      x := bat + 1;
      y := 21;
      WriteBat;
      GotoXY(1, 24);
      Write('Balls: ');
      Write(balls-1);
      lostBall := False;
      iter := 0;
      dc := false;
      repeat
        Delay(trunc(del/2));
        if iter = 0 then
          begin
            if dc = true then dc := false;
            DeleteBall;
            x := x + v;
            y := y + w;
          end;
        { Continuous bat movement }
        if KeyPressed then
        begin
          ch := Readkey;
          if (ch = 'q') then
            exit := True;
          if (ch = 'x') then
            batDir := 1
          else if (ch = 'z') then
            batDir := -1
          else batDir := 0;
        end;
        DeleteBat;
        if ((batDir = 1) and (bat < scrw - batw + 1)) or
           ((batDir = -1) and (bat > 1)) then
          bat := bat + batDir;
        WriteBat;
        if iter = 0 then
          begin
            WriteBall;
          end;
        if (y = 22) then
          begin
            balls := balls - 1;
            lostBall := True;
            if (balls = 0) then
              begin
                GotoXY(12, 1);
                Write('Game over');
                GotoXY(1, 24);
                Write(' ');
                Delay(del * 8);
                repeat until keypressed;
              end;
            DeleteBall;
          end
        else
          begin
            if (y >= 3) and (y <= 8) then
              bricks[y, x] := false;
            if (x > 2) and (x < scrw - 1) and (y >= 3) and (y <= 8) and (bricks[y, x + v]) then
              begin
                bricks[y, x + v] := False;
                GotoXY(x + v, y);
                Write(' ');
                GotoXY(1, 1);
                v := -v;
                w := 1;
              end
            else
              begin
                if (y > 3) and (y <= 9) and bricks[y - 1, x] then
                begin
                  bricks[y - 1, x] := False;
                  GotoXY(x, y - 1);
                  Write(' ');
                  GotoXY(1, 1);
                  w := 1;
                end;
              end;
            if (y = 21) then
              begin
                if (x >= bat - 1) and (x <= bat + batw) then
                  w := -1;
                if (x = bat - 1) then
                  v := -1
                else if (x = bat + batw) then
                  v := 1;
              end;
            if (y = 0) then
              begin
                GotoXY(14, 1);
                Write('Free!');
                Delay(del * 8);
                repeat until keypressed;
                exit := True;
              end;
            if ((x = 2) or (x = scrw - 1)) and dc = false then
              begin
                v := -v;
                dc := true;
              end;
          end;
        iter := iter + 1;
        if iter > 1 then iter := 0;
      until exit or lostBall;
    until exit or (balls = 0);
  until exit;
  CursorOn;
  ClrScr;
  SetTextColor(_WHITE);
end.
