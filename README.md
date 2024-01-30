## A set of games for CP/M

Games written or adapted for CP/M [ZX2022 computer](https://github.com/michalin/ZX2022).
All written in Turbo Pascal 3.0 for CP/M.

## FLAP CP/M

A flappy-bird like game for CP/M OS and ANSI color or VT-102 B/W terminal 80x24.

![](flapcpm.png)

**Controls:**

**SPACE** : Maked bird fly  
**q** : Quit

## EVAS10N

Adaptation of [brick-style CP/M game](https://github.com/marcosretrobits/EVAS10N.PAS) for classic CP/M ANSI color or VT102 B/W terminal 80x24.

![](evas10n.png)

**Controls**

**z** : Move bat left  
**x** : Move bat right  
**any key** : Stop bat
**q** : Quit

## 2048

Adaptation of 2048 game written for [CRISS CP/M computer](http://criss.radio.ru) to ANSI color terminal.

![](2048.jpg)

## BALLS

Adaptation of color balls game written for [CRISS CP/M computer](http://criss.radio.ru) to ANSI color terminal.

## Compiling

You may use and modify source code for your own purpose. Compiling instructions:
* Copy [Turbo Pascal 3](http://www.retroarchive.org/cpm/lang/lang.htm) to target CP/M system.
* Start Turbo Pascal 3.
* Set drive, main file to FLAPCPM.PAS.
* Set compiler options to COM.
* Compile.

## Extra

With a little changes this game might be compiled and run under DOS with Turbo Pascal 5.5 or 7.0. 
Simply add "uses crt", change code for using DOS crt functions. 
