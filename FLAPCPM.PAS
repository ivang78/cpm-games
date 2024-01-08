program flapcpm;

{uses crt;}

var tunel: array[1..82,0..1] of byte;
    tunpos, birdxpos, birdypos, birdnypos, tunheight: byte;
    curkey: byte;
    dlsec, dli, dli2: integer;
    level: byte;
    live: boolean;
    terminal: byte;

const scrw = 80;
     scrh = 24;
     key_space = #32;
     dlstart = 150;
     tunstart = 8;

{$I ANSICOLR.INC}

{$I CPM.INC}

{ ----------------------------------------------------------- }
Procedure Hello;
    var tc: char;
begin
    ClrScr;
    repeat
        SetTextColor(_WHITE);
        gotoxy(32, 10); write('                ');
        gotoxy(32, 11); write('* FLAPPY CP/M * ');
        gotoxy(32, 12); write('                ');
        gotoxy(32, 13); write('Choose terminal:');
        gotoxy(32, 14); write('   1. ANSI      ');
        gotoxy(32, 15); write('   2. VT102     ');
        repeat until keypressed;
        tc := readkey;
    until (tc = '1') or (tc = '2');
    terminal := ord(tc) - 48;
end;

{ ----------------------------------------------------------- }
Procedure DrawLine(x, ss1, ss2: byte);
    var i: byte;
        ts: char;
begin
    for i:=2 to ss1 do
        begin
            gotoxy (x,i);
            if i=ss1 then
                begin
                    SetTextColor(_BLUE);
                    ts := '=';
                end
                    else
                begin
                    SetTextColor(_GREEN);
                    ts := '#';
                end;
            write(ts);
        end;
    for i:=ss2 to scrh do
        begin
            gotoxy (x,i);
            if i=ss2 then
                begin
                    SetTextColor(_BLUE);
                    ts := '=';
                end
                    else
                begin
                    SetTextColor(_GREEN);
                    ts := '#';
                end;
            write(ts);
        end;
end;

{ ----------------------------------------------------------- }
Procedure GenerateTunel(th, level: byte);
    var s1, s2, b, i, j, k, colnum: byte;
    td: integer;
begin
    randomize;
    { tunnel start pos }
    tunpos := random(th) + trunc(scrh /2 - th / 2);
    { bird start pos }
    birdxpos := 1;
    birdypos := tunpos + trunc(th /2);
    s1 := tunpos;
    colnum := trunc(scrw/8);

    { Draw sea }
    SetTextColor(_CYAN);
    for b:=1 to scrw do
        begin
            s2 := trunc(random(3));
            for j:=scrh - s2 to scrh do
                begin
                    gotoxy(b, j); write('~');
                end;
        end;

    { Draw tunnel }
    i:=1;
    s2 := 0;
    for b:=1 to colnum do
        begin
            for j:=1 to 4 do
                begin
                    tunel[i,0] := 0;
                    tunel[i,1] := 99;
                    i:=i+1;
                end;
            for j:=1 to 4 do
                begin
                    tunel[i,0] := s1;
                    tunel[i,1] := s1 + th;
                    DrawLine (i, tunel[i,0], tunel[i,1]);
                    i:=i+1;
                end;
            td := random(5) - 2;
            if ((s1 + td < 3) or (s1 + th + td > scrh - 5)) then
               td := -td;
            s1 := s1 + td;
        end;
    SetTextColor(_WHITE);
    gotoxy(2, 1);
    write('-  Level: ', level, '  --   SPACE - Fly   Q - Exit');
end;

{ ----------------------------------------------------------- }
Procedure DrawBird(dr: boolean);
begin
    gotoxy(birdxpos, birdypos);
    if dr = true then
        begin
            SetTextColor(_YELLOW);
            write('@');
            SetTextColor(_RED);
            write('>');
        end
            else
        begin
            write('  ');
        end;
end;

{ ----------------------------------------------------------- }
Function CheckCollision(x, y: byte): boolean;
begin
    if (y <= tunel[x][0]) or (y >= tunel[x][1]) then CheckCollision := true else CheckCollision := false;
end;

{ ----------------------------------------------------------- }
Procedure Death;
begin
    SetTextColor(_YELLOW);
    gotoxy(32, 10); write('               ');
    gotoxy(32, 11); write(' +-----------+ ');
    gotoxy(32, 12); write(' | YOU DEAD! | ');
    gotoxy(32, 13); write(' +-----------+ ');
    gotoxy(32, 14); write('               ');
    live := false;
    delay(2000);
end;

{ ----------------------------------------------------------- }
Procedure Game;
    var key: char;
    bdy: byte;
begin
    repeat
        ClrScr;
        live := true;
        GenerateTunel(tunheight, level);
        repeat
            DrawBird(true);
            birdnypos := birdypos;
            bdy := 1;
            for dli2:=0 to dlsec do
            begin
                delay(1);
                if keypressed then
                   begin
                       key := readkey;
                       if key=key_space then
                           begin
                               bdy := 0;
                               birdnypos := birdnypos - 1;
                               DrawBird(false);
                               birdypos := birdnypos;
                               DrawBird(true);
                               if CheckCollision(birdxpos, birdypos) then
                                  Death;
                           end
                       else
                           if (key='q') or (key='Q') then
                              begin
                                  CursorOn;
                                  ClrScr;
                                  SetTextColor(_WHITE);
                                  exit;
                              end;
                   end;
            end;
            DrawBird(false);
            birdxpos := birdxpos + 1;
            birdypos := birdypos + bdy;
            if CheckCollision(birdxpos, birdypos) then
               Death;
        until (birdxpos > scrw - 2) or (live = false);
        if live = false then
          begin
                dlsec := dlstart;
                level := 1;
                tunheight := tunstart;
                live := true;
          end
        else
            begin
                level := level + 1;
                if (level < 6) then
                   begin
                        dlsec := dlsec - 10;
                        tunheight := tunheight - 1;
                   end;
            end;
    until (level > 100);
    ClrScr;
end;

begin
    CursorOff;
    Hello;
    tunheight := tunstart;
    dlsec := dlstart;
    level := 1;
    Game;
    CursorOn;
    ClrScr;
    SetTextColor(_WHITE);
end.
