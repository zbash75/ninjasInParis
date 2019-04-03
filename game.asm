; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
;
;
; #########################################################################

;;NAME: Zain Bashey

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc

;; Has keycodes
include keys.inc

include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib

include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib

include \masm32\include\windows.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib

	
.DATA
      SndPath BYTE "In_Paris.wav", 0

      CONV_FACTOR DWORD 1000000000
      paused DWORD ?
      playing DWORD ?
      kanyeXPos DWORD ?
      kanyeYPos DWORD ?
      kanyeXVeloc DWORD ?
      kanyeYVeloc DWORD ?
      kanyeAccel DWORD ?
      kanyeDirection DWORD ?
      kanyesDead DWORD ?

      jumping DWORD ?

      firstTime DWORD ?
      secondTime DWORD ?
      timeDiff DWORD ?
      threeSeconds DWORD ?
      twelveSeconds DWORD ?
      nOrigTime DWORD ?
      nCurrTime DWORD ?
      thrOrigTime DWORD ?
      thrCurrTime DWORD ?

      yeezysPos DWORD ?
      micXPos DWORD ?
      micYPos DWORD ?

      hasMic DWORD ?
      hasYeezys DWORD ?

      micOnScreen DWORD ?
      yeezysOnScreen DWORD ?

      leftMicThrowing DWORD ?
      rightMicThrowing DWORD ?
      
      nChecking DWORD ?
      enoughTimeForSpawn DWORD ?

      leftNinjaOnScreen DWORD ?
      rightNinjaOnScreen DWORD ?
      lastNinjaDrawn DWORD ?

      starOnScreen DWORD ?
      starPos DWORD ?
      starRightThrowing DWORD ?
      starLeftThrowing DWORD ?

      score DWORD ?

      Instructions BYTE "Shoot mics at the ninjas and dodge their throwing stars", 0
      Intro BYTE "Controls:", 0
      controlOne BYTE "Use right and left arrow keys to move and up key to jump", 0
      controlTwo BYTE "Pick up the Yeezys for a speed boost", 0
      controlThree BYTE "Pick up the microphone and then", 0
      controlFour BYTE "use the space bar to shoot it at the ninjas", 0
      controlFive BYTE "Press P to Pause the Game", 0
      controlSix BYTE "Press Y to Start", 0

      sevenStr BYTE "Score: %d", 0
      eightStr BYTE 256 DUP(0)

      firstPauseStr BYTE "Game Paused", 0
      secondPauseStr BYTE "Press P to Unpause", 0

      youDied BYTE "GAME OVER!", 0
      youWon BYTE "YOU WON!", 0
    

;; If you need to, you can place global variables here


.CODE
	
CheckIntersect PROC USES esi ebx oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP
      LOCAL halfWidth:DWORD, halfHeight:DWORD, firstLeft:DWORD, firstRight:DWORD, firstTop:DWORD, firstBottom:DWORD, secondLeft:DWORD, secondRight:DWORD, secondTop:DWORD, secondBottom:DWORD

      mov esi, oneBitmap

      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      sar ebx, 1
      mov halfWidth, ebx

      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
      sar ebx, 1 
      mov halfHeight, ebx

      mov ebx, oneX
      sub ebx, halfWidth
      mov firstLeft, ebx                        ;; firstLeft = oneX - oneBitmap.dwWidth/2

      mov ebx, oneX
      add ebx, halfWidth
      mov firstRight, ebx                       ;; firstRight = oneX + oneBitmap.dwWidth/2

      mov ebx, oneY
      sub ebx, halfHeight
      mov firstTop, ebx                         ;; firstTop = oneY - oneBitmap.dwHeight/2

      mov ebx, oneY
      add ebx, halfHeight
      mov firstBottom, ebx                      ;; firstBottom = oneY + oneBitmap.dwHeight/2

      mov esi, twoBitmap

      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      sar ebx, 1
      mov halfWidth, ebx

      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
      sar ebx, 1 
      mov halfHeight, ebx

      mov ebx, twoX
      sub ebx, halfWidth
      mov secondLeft, ebx                       ;; repeat process for second bitmap

      mov ebx, twoX
      add ebx, halfWidth
      mov secondRight, ebx

      mov ebx, twoY
      sub ebx, halfHeight
      mov secondTop, ebx

      mov ebx, twoY
      add ebx, halfHeight
      mov secondBottom, ebx 

      xor eax, eax                              ;; eax = 0

      mov ebx, firstLeft
      cmp ebx, secondRight                      ;; if firstLeft > secondRight, no collision
      jg finished

      mov ebx, firstRight
      cmp ebx, secondLeft                       ;; if firstRight < secondLeft, no collision
      jl finished

      mov ebx, firstTop
      cmp ebx, secondTop
      jg firstCompare                           ;; firstTop > secondTop

      mov ebx, firstBottom
      cmp ebx, secondBottom
      jl secondCompare                          ;; firstBottom < secondBottom
      jmp continue                              ;; if neither true, collision

firstCompare:
      mov ebx, firstTop
      cmp ebx, secondBottom
      jg finished                               ;; firstTop > secondBottom: no collision
      jmp continue                              ;; firstTop < secondBottom: collision

secondCompare:
      mov ebx, firstBottom                      ;; firstBottom < secondTop: no collision
      cmp ebx, secondTop                        ;; firstBottom > secondTop: collision
      jl finished

continue:
      mov eax, 1                                ;; if collision, eax = 1
      
finished:    
      ret
CheckIntersect ENDP
;; Note: You will need to implement CheckIntersect!!!

drawBackground PROC
      invoke BasicBlit, OFFSET darealsky, 319, 239   ;; Draws Background Image  
      invoke BasicBlit, OFFSET sun, 570, 55
      invoke BasicBlit, OFFSET eifel, 317, 200
      invoke BasicBlit, OFFSET walkway, 317, 385

      ret
drawBackground ENDP

clearScreen PROC USES esi edi ebx
      mov esi, ScreenBitsPtr
      mov edi, 0
      mov ebx, 0
stuff:
      mov BYTE PTR [esi + edi], 0               ;; sets all values in a row to black
      cmp edi, 639
      jge next
      inc edi
      jmp stuff
next:
      add esi, 640                              ;; when done, reset variables and start next row
      mov edi, 0
      inc ebx
      cmp ebx, 480
      jl stuff

      invoke drawBackground                     ;; draws Background
      cmp kanyesDead, 1                         ;; if Kanye is dead, don't draw any other sprites
      je continue
      mov esi, kanyeDirection
      cmp esi, 1
      je drawRight 
      invoke BasicBlit, OFFSET kanyeLeft, kanyeXPos, kanyeYPos      ;; draw Kanye facing left or facing right depending on previous direction
      jmp star

drawRight:
      invoke BasicBlit, OFFSET kanyeRight, kanyeXPos, kanyeYPos

star:
      cmp starOnScreen, 0                       ;; if objects were on screen before calling clearScreen, redraw them
      je mic
      invoke BasicBlit, OFFSET throwingStar, starPos, 375

mic:
      cmp micOnScreen, 0
      je yeezysBlock
      invoke BasicBlit, OFFSET micLeft, micXPos, micYPos

yeezysBlock:
      cmp yeezysOnScreen, 0
      je leftNinja
      invoke BasicBlit, OFFSET yeezys, yeezysPos, 420

leftNinja:
      cmp leftNinjaOnScreen, 0
      je rightNinja
      invoke BasicBlit, OFFSET ninjaLeft, 60, 375

rightNinja:
      cmp rightNinjaOnScreen, 0
      je continue
      invoke BasicBlit, OFFSET ninjaRight, 579, 375
      
continue:
      ret
clearScreen ENDP


pauseScreen PROC
      cmp paused, 1                 ;; if currently paused, unpause
      je unpause

      mov paused, 1                 ;; if paused, clear screen and draw pause message
      invoke clearScreen
      invoke DrawStr, OFFSET firstPauseStr, 300, 100, 0f3h
      invoke DrawStr, OFFSET secondPauseStr, 300, 130, 0f3h
      jmp continue

unpause:
      mov paused, 0
      invoke clearScreen

continue:
      ret

pauseScreen ENDP


moveKanye PROC USES esi edi ebx
      mov esi, KeyPress                     ;; check to see if left or right arrow is pressed
      cmp esi, VK_LEFT
      je left
      cmp esi, VK_RIGHT
      je right
      jmp continue
      
left:
      cmp kanyeXPos, 12                     ;; if Kanye is in bounds, if so draw him to the left of his original position
      jle continue
      mov edi, kanyeXVeloc
      sub kanyeXPos, edi
      mov kanyeDirection, 0
      invoke clearScreen
      jmp continue
right:
      cmp kanyeXPos, 628                    ;; if in bounds, draw him to the right of his original position a certain amount
      jge continue
      mov edi, kanyeXVeloc
      add kanyeXPos, edi
      mov kanyeDirection, 1                 ;; update kanye's direction
      invoke clearScreen

continue:
      ret
moveKanye ENDP

jumpKanye PROC USES esi edi
      cmp jumping, 1                        ;; if currently jumping
      je do

      mov esi, KeyPress                     ;; check if up is being pressed
      cmp esi, VK_UP
      jne continue
jump:
      mov kanyeYVeloc, -35                  ;; original velocity
      mov jumping, 1

do:
      mov edi, kanyeAccel                   ;; velocity = prev_velocity + accel
      add kanyeYVeloc, edi
      mov edi, kanyeYVeloc                  ;; position = prev_position + velocity
      add kanyeYPos, edi
      invoke clearScreen
      cmp kanyeYPos, 375                    ;; if kanye reaches starting position, end jump
      jg wereDone
      jmp continue

wereDone:
      mov kanyeYPos, 375
      invoke clearScreen
      mov jumping, 0      

continue:
      ret
jumpKanye ENDP

spawnPowerups PROC
      invoke nrandom, 200                   ;; if nrandom hits specified numbers, spawn powerups
      cmp eax, 186
      je drawYeezys
      cmp eax, 140
      je drawMic
      jmp continue
drawYeezys:
      cmp hasYeezys, 1                      ;; if you have yeezys or it's already on screen, don't draw
      je continue
      cmp yeezysOnScreen, 1
      je continue
      invoke clearScreen
      invoke nrandom, 430                   ;; draw yeezys at random position
      add eax, 120
      mov yeezysPos, eax
      mov yeezysOnScreen, 1
      invoke BasicBlit, OFFSET yeezys, yeezysPos, 420
      jmp continue
drawMic:
      cmp hasMic, 1                         ;; if you have mic or already on screen, don't draw
      je continue
      cmp micOnScreen, 1
      je continue
      invoke clearScreen
      invoke nrandom, 430                   ;; draw mic and random position
      add eax, 120
      mov micXPos, eax
      mov micYPos, 400
      mov micOnScreen, 1
      invoke BasicBlit, OFFSET micLeft, micXPos, micYPos
continue:
      ret

spawnPowerups ENDP


getPowerups PROC USES ecx edx esi
      cmp yeezysOnScreen, 0                  ;; check if kanye is touching yeezys, but only if they are on screen
      je checkMic
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeLeft, yeezysPos, 420, OFFSET yeezys
      cmp eax, 1
      je yeezysBoost
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeRight, yeezysPos, 420, OFFSET yeezys
      cmp eax, 1
      je yeezysBoost
      jmp checkMic

yeezysBoost:
      mov kanyeXVeloc, 8                    ;; double Kanye's speed
      mov hasYeezys, 1
      mov yeezysOnScreen, 0
      invoke clearScreen

checkMic:
      cmp micOnScreen, 1                    ;; check if kanye is touching mic, but only if it's on screen
      jne continue
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeLeft, micXPos, micYPos, OFFSET micLeft
      cmp eax, 1
      je micBoost
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeRight, micXPos, micYPos, OFFSET micLeft
      cmp eax, 1
      je micBoost
      jmp continue

micBoost:
      mov hasMic, 1                         ;; kanye now has mic
      mov micOnScreen, 0
      invoke clearScreen

continue:
      ret

getPowerups ENDP

useMic PROC USES esi

      cmp leftMicThrowing, 1                ;; if mic is being thrown, go to appropriate block
      je goLeft

      cmp rightMicThrowing, 1
      je goRight

    
      cmp hasMic, 0                         ;; if Kanye doesn't have mic, don't execute
      je continue
      
      mov esi, KeyPress                     ;; check if space is being pressed
      cmp esi, VK_SPACE
      jne continue

      mov hasMic, 0

      
      cmp kanyeDirection, 1                 ;; if kanye is facing right, do a right throw
      je rightThrow

leftThrow:
      mov esi, kanyeXPos                    ;; initialize mic's position on screen
      sub esi, 29
      mov micXPos, esi
      mov micOnScreen, 1
      mov leftMicThrowing, 1
goLeft:
      cmp micXPos, 0                        ;; if mic goes off screen, end throw
      jle leftsOver
      cmp leftNinjaOnScreen, 1 
      je checkLeftNinja
keepGoingLeft:
      invoke clearScreen                    ;; clear screen and draw mic at current position
      invoke BasicBlit, OFFSET micLeft, micXPos, micYPos
      sub micXPos, 7                        ;; update mic's position
      jmp continue

rightThrow:
      mov esi, kanyeXPos                    ;; initialize mic's position on screen
      add esi, 29
      mov micXPos, esi
      mov micOnScreen, 1
      mov rightMicThrowing, 1
goRight:
      cmp micXPos, 639                      ;; if mic goes off screen, end throw
      jge rightsOver
      cmp rightNinjaOnScreen, 1
      je checkRightNinja
keepGoingRight:
      invoke clearScreen                    ;; clear screen and draw mic at current position
      invoke BasicBlit, OFFSET micLeft, micXPos, micYPos
      add micXPos, 7
      jmp continue

checkLeftNinja:
      invoke CheckIntersect, micXPos, micYPos, OFFSET micLeft, 60, 375, OFFSET ninjaLeft
      cmp eax, 1                            ;; if mic intersects with ninja, kill ninja and end throw, else keep going
      je killLeftNinja
      jmp keepGoingLeft

checkRightNinja:
      invoke CheckIntersect, micXPos, micYPos, OFFSET micLeft, 579, 375, OFFSET ninjaRight
      cmp eax, 1                            ;; if mic intersects with ninja, kill ninja and end throw, else keep going
      je killRightNinja
      jmp keepGoingRight

leftsOver:
      mov leftMicThrowing, 0                ;; update variables and clear screen
      mov micOnScreen, 0
      invoke clearScreen
      jmp continue

rightsOver:
      mov rightMicThrowing, 0               ;; update variables and clear screen
      mov micOnScreen, 0
      invoke clearScreen
      jmp continue

killLeftNinja:
      mov leftNinjaOnScreen, 0              ;; erase ninja off screen, end throw, and update score
      mov leftMicThrowing, 0
      mov micOnScreen, 0
      mov hasMic, 0
      inc score
      invoke clearScreen
      cmp hasYeezys, 1          
      je removeYeezys
      jmp continue

killRightNinja:
      mov rightNinjaOnScreen, 0             ;; erase ninja off screen, end throw, and update score
      mov rightMicThrowing, 0
      mov micOnScreen, 0
      mov hasMic, 0
      inc score
      invoke clearScreen
      cmp hasYeezys, 1
      je removeYeezys
      jmp continue

removeYeezys:
      mov kanyeXVeloc, 4                    ;; if kanye had yeezys powerup, end effect if ninja has been killed
      mov hasYeezys, 0

continue:
      ret
useMic ENDP



ninjaCheckTime PROC USES ecx newTime:DWORD, origTime:DWORD
      mov eax, 0                            ;; compare newTime to original Time, if at least three seconds set eax to 1
      mov ecx, newTime
      sbb ecx, origTime
      cmp ecx, threeSeconds
      jl continue
      mov eax, 1
     
continue:
      ret

ninjaCheckTime ENDP



spawnNinja PROC
      cmp leftNinjaOnScreen, 1              ;; check if ninja already on screen
      je continue
      cmp rightNinjaOnScreen, 1
      je continue

      cmp nChecking, 1                      ;; see if checking for time
      je checking

      rdtsc
      mov nOrigTime, eax                    ;; get original time
      mov nChecking, 1

checking:
      rdtsc                                 ;; get current time and compare to original time using ninjaCheckTime
      mov nCurrTime, eax
      invoke ninjaCheckTime, nCurrTime, nOrigTime
      cmp eax, 1
      jne continue
      

      cmp lastNinjaDrawn, 0                 ;; check which ninja to draw
      je rightSide

      invoke BasicBlit, OFFSET ninjaLeft, 60, 375       ;; draw left ninja and update variables
      mov leftNinjaOnScreen, 1
      mov lastNinjaDrawn, 0
      jmp continue

rightSide:  
      invoke BasicBlit, OFFSET ninjaRight, 579, 375     ;; update right ninja and update variables
      mov rightNinjaOnScreen, 1
      mov lastNinjaDrawn, 1

continue:
      ret
spawnNinja ENDP


throwingStars PROC

      cmp starRightThrowing, 1              ;; check if stars are currently being thrown
      je throwingRight

      cmp starLeftThrowing, 1
      je throwingLeft

      cmp leftNinjaOnScreen, 1              ;; see which ninja is on screen
      je throwRight

      cmp rightNinjaOnScreen, 1
      je throwLeft

      jmp continue

throwRight:
      mov starPos, 117                      ;; initialize star position and other variables
      mov starOnScreen, 1
      mov starRightThrowing, 1
      

throwingRight:
      cmp starPos, 639                      ;; if star goes off screen, end throw
      jge rightThrowsOver   
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeLeft, starPos, 375, OFFSET throwingStar          ;; check if star touches Kanye
      cmp eax, 1
      je killKanye
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeRight, starPos, 375, OFFSET throwingStar
      cmp eax, 1
      je killKanye
      invoke clearScreen
      cmp leftMicThrowing, 0
      je continueRight
      invoke BasicBlit, OFFSET micLeft, micXPos, micYPos        ;; if mic is being thrown, draw it
continueRight:
      add starPos, 4                        ;; update star position
      jmp continue

throwLeft:
      mov starPos, 522                      ;; initialize star position and update other variables
      mov starOnScreen, 1
      mov starLeftThrowing, 1

throwingLeft:
      cmp starPos, 0                        ;; if star goes off screen, end throw
      jle leftThrowsOver      
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeLeft, starPos, 375, OFFSET throwingStar          ;; check if star touches Kanye
      cmp eax, 1
      je killKanye
      invoke CheckIntersect, kanyeXPos, kanyeYPos, OFFSET kanyeRight, starPos, 375, OFFSET throwingStar
      cmp eax, 1
      je killKanye
      invoke clearScreen
      cmp rightMicThrowing, 0
      je continueLeft
      invoke BasicBlit, OFFSET micLeft, micXPos, micYPos        ;; if mic is being thrown, draw it
continueLeft:
      sub starPos, 4                        ;; update star position
      jmp continue

killKanye:
      mov kanyesDead, 1                     ;; if star is touching Kanye, update variables and end throw
      cmp starLeftThrowing, 1
      je leftThrowsOver

rightThrowsOver:
      mov starRightThrowing, 0              ;; end throw, update variables, and clear screen
      mov starOnScreen, 0
      invoke clearScreen
      jmp continue
      
leftThrowsOver:
      mov starLeftThrowing, 0               ;; end throw, update variables, and clear screen
      mov starOnScreen, 0
      invoke clearScreen

continue:
      ret

throwingStars ENDP



GameInit PROC USES esi edi
      rdtsc                                 ;; allow for random numbers later in the game
      invoke nseed, eax

      mov paused, 0                         ;; initialize all global variables

      mov firstTime, 0
      mov timeDiff, 0

      mov eax, CONV_FACTOR
      mov esi, 3
      imul esi
      mov threeSeconds, eax

      mov kanyeXPos, 317

      mov kanyeYPos, 375

      mov kanyeAccel, 3

      mov kanyeXVeloc, 4

      mov kanyeDirection, 0
      mov jumping, 0

      mov playing, 0

      mov hasMic, 0
      mov hasYeezys, 0
      mov micOnScreen, 0
      mov yeezysOnScreen, 0
      mov leftMicThrowing, 0
      mov rightMicThrowing, 0

      mov nChecking, 0
      mov enoughTimeForSpawn, 0
      mov leftNinjaOnScreen, 0
      mov rightNinjaOnScreen, 0
      mov lastNinjaDrawn, 1
      mov starOnScreen, 0
      mov starLeftThrowing, 0
      mov starRightThrowing, 0

      mov kanyesDead, 0

      mov score, 0
      
      invoke drawBackground                 ;; draw Background

      invoke PlaySound, OFFSET SndPath, 0, SND_FILENAME OR SND_ASYNC OR SND_LOOP        ;; play song

      invoke DrawStr, OFFSET Instructions, 182, 100, 00h        ;; draw Instructions and Controls to screen
      ;invoke DrawStr, OFFSET Intro, 170, 100, 00h
      invoke DrawStr, OFFSET controlOne, 182, 115, 00h
      invoke DrawStr, OFFSET controlTwo, 182, 130, 00h
      invoke DrawStr, OFFSET controlThree, 182, 150, 00h
      invoke DrawStr, OFFSET controlFour, 182, 170, 00h
      invoke DrawStr, OFFSET controlFive, 182, 190, 00h
      invoke DrawStr, OFFSET controlSix, 182, 210, 00h


      invoke BasicBlit, OFFSET startTitle, 200, 50              ;; draw Title and Kanye to screen
      invoke BasicBlit, OFFSET kanyeLeft, kanyeXPos, kanyeYPos
          
            	
	ret         ;; Do not delete this line!!!
GameInit ENDP

GamePlay PROC USES esi edi

      
      cmp playing, 1
      je mainGame
      
      mov esi, KeyPress                     ;; do not start game until player presses Y
      cmp esi, VK_Y
      jne youHaventStarted

      mov playing, 1
      
mainGame:
      cmp kanyesDead, 1                     ;; if Kanye is dead, end game
      je gameOver

      cmp score, 10                         ;; if score is 10 or over, end game
      jge winGame

      mov esi, KeyUp                        ;; if P is pressed trigger pauseScreen
      cmp esi, VK_P
      jne nextPart
      mov KeyUp, 0
      invoke pauseScreen

nextPart:

      cmp paused, 1                         ;; if paused, skip all of main gameplay
      je continue

      
      invoke spawnNinja                     ;; invoke all helper functions to check for user input and respond accordingly
      invoke moveKanye
      invoke jumpKanye
      invoke spawnPowerups
      invoke useMic
      invoke getPowerups
      invoke throwingStars


      jmp continue

gameOver:
      invoke clearScreen                    ;; draw "GAME OVER!" to screen
      invoke DrawStr, OFFSET youDied, 320, 50, 00h
      jmp continue

winGame:
      invoke clearScreen                    ;; draw "YOU WON!" to screen
      invoke DrawStr, OFFSET youWon, 320, 50, 00h

                 
continue: 
      mov edi, score                        ;; print score to screen
      push edi
      push OFFSET sevenStr
      push OFFSET eightStr
      call wsprintf
      add esp, 12
      invoke DrawStr, OFFSET eightStr, 182, 180, 00h
      
youHaventStarted:
	ret         ;; Do not delete this line!!!
GamePlay ENDP

END
