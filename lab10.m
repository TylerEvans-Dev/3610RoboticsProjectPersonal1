%%%%%%%%%%%%%
% ECE 3610
% LAB 10 -- Actuators 3: Combining Sensorimotor Loops
%%%%%%%%%%%%%

%%%%%%%%%%%%%
% Modern cyberphysical systems are simultaneously handling sensor input 
% from a number of sources, then intelligently combining that into a 
% number of actuator signals. So far you have only mapped sensors and 
% actuators in a 1:1 fashion. This lab is purposefully open-ended; 
% hopefully it will give you time to both catch up if you're behind and 
% explore if you're ahead. 

% Deliverables:
%   - A circuit and associated code which uses no fewer than six of your 
%   components and contains at least two different feedback/sensorimotor
%   loops operating at the same time. At least one of the sensorimotor
%   loops should fuse sensor data from at least two different sources.
%   - Tell me a story about what your device is meant to do. This can be
%   just part of a larger (imaginary) system, you can use analogies 
%   ("instead of an led, this would be a ____ "). Get creative!
%
% Extensions:
%   - Work with a partner to have your systems interact.
%%%%%%%%%%%%%%

%% 1. CONNECT TO YOUR NANOBOT
%  Remember to replace the first input argument with text corresponding to
%  the correct serial port you found through the Arduino IDE. Note that the
%  clc and clear all will clear your command window and all saved
%  variables!

clc
clear all
nb = nanobot('/dev/cu.usbmodem1201', 115200, 'serial');
nb.initRGB('D2', 'D3', 'D4');
nb.setRGB(255, 0, 0);
pause(1);
nb.setRGB(0, 255, 0);
pause(1);
nb.setRGB(0, 0, 255);
pause(1);
nb.setRGB(0, 0, 0);

%% 2. Building your sensorimotor loops
% Take stock of your available input and output devices. Write down a list
% of each. Categorize each input as either BINARY or CONTINUOUS. Next to
% each input in your list, if it is a sensor, write down the associated
% physical quantity being transduced.

% HINT: When working with design challenges, it can help to clearly define
% your objectives, list usable components, and brainstorm possible next
% steps. Once you have a decent idea pinned down, start by breaking your
% design task into sections.

% E.g. something for this lab could look like:
%
% Objective: 6 components, 2 interacting sensorimotor loops
%
% Components: DC Motor, LED, potentometer, photoresistor, etc.
%
% Possible concepts: System for robot that changes LED with ultrasonic,
% motor speed dependent on another sensor, etc.
%
% CODE STRUCUTRE:
% 1. pin assignments and initialization
% 2. defining useful variables and ranges
% 3. start of while loop
% 4. data collection/processing
% 5. condition testing
% 6. sensorimotor loops
% ...
% X. End of while loop/ resetting functions

% You've been setting up sensorimotor loops almost every lab so far, so go
% crazy with finding ways to combine multiple sensors and actuators/transducers!
% Binary connections button, and ultrasonic sensor
% The goal of the game is to get the servo to spin comp. a sort of simon says. 
% if you get the button wrong that you are pressing the button, or pushing the pressure sensor
% if you get the button wrong three times you are out. 
% the amount of time dec depending on how 
% but there is some adverstiy if one gets the button 

%INIT THE VARIBLES HERE

%how it starts out is giving a 

%HERE IS THE LOOP
readVal = 0;
random = 0;
isPushed = 1;
round = 0;
randomChoice = 0;
state = 1;
maxVal = 1000;
lifeVal = 3;
words = ["White Buttom", "Green button", "light",  "Force"];
points = 0;
diff = 0;
beg = 1;
%Button 1
nb.pinMode('A0', 'ainput'); % one white 
%Button 2
nb.pinMode('A1','ainput'); % two green
%light sensor 
nb.pinMode('A2', 'ainput'); % three light
%force sensor
nb.pinMode('A3', 'ainput'); %four force
%LED
nb.initRGB('D2', 'D3', 'D4'); % five done
%servo 
nb.setServo(1, 0); % six 
%test the componets to make sure they are working
highButton1 = 910;
highButton2 = 910;
highFB = 500;
highLS  = 900;
%nb.livePlot('analog','A3');

while (state == 1)
    %condtional for round track
    if (round == 0)
        % this plays if there is a starting out
        round = 1;
        while(beg < 1000)
            clc;
            fprintf("Welcome to a small robot game?\n");
            fprintf(" the goal of this game is to press the stated button it will be displayed\n");
            fprintf(" WBT, GBT, light, or FORCE on the screen once pressed pushed it will progress in to rounds\n");
            fprintf("The LED will have the amount of time, and the servo will point to which one\n");
            fprintf(" Each step will have a shorter amount of time \n");
            fprintf("press white to exit continue\n");
            beg = nb.analogRead('A0');
            nb.setServo(4, 0);
            pause(0.2);
            nb.setServo(4, 180);
            pause(0.2);

        end
    end
    while(lifeVal > 0)
        clc;
        fprintf("round %i ", round);
        fprintf('|');
        for i = 1:lifeVal
            fprintf('x');
        end
        fprintf('|\n');
        fprintf("The button you will push is ");
        random = randi(4, 1);
        val = words(random);
        fprintf(val);
        fprintf(" And the time you have is");
        disp(random);
        pause(1);
        fprintf("3\n")
        nb.setRGB(255, 0, 0);
        pause(0.5);
        fprintf("2\n");
        nb.setRGB(0, 0, 255);
        pause(0.5);
        fprintf("1\n");
        nb.setRGB(255, 0, 0);
        pause(0.5);
        fprintf("GO!\n");
        nb.setRGB(0, 255, 0);
        %while loop here is for the timing to push the button 
        tic 
        readVal =0;
        isPushed = 0; 
        while (toc < random)
            if(random == 1)
                 readVal = nb.analogRead('A0');
                 if(readVal > highButton1)
                     isPushed =1;
                 end
            elseif(random ==2)
                   readVal = nb.analogRead('A1');
                 if(readVal > highButton2)
                     isPushed =1;
                 end
            elseif(random == 3)
                   readVal = nb.analogRead('A2');
                 if(readVal > highLS)
                     isPushed =1;
                 end
            else
                   readVal = nb.analogRead('A3');
                 if(readVal > highFB)
                     isPushed =1;
                 end
                 
            end
            nb.setRGB(0, 0, 0);
        end
         if(isPushed == 0)
                lifeVal = lifeVal -1;
         else
             points = points + 1;
         end
    end
    clc;
    pause(0.1); % gives a slight
    disp("your score is ");
    disp(points);
    nb.setMotor(1, 100);
    pause(0.5);
    nb.setMotor(1, 0);
    pause(0.5);
    fprintf('THANKS FOR PLAYING!!!\n');
    state = 0;
end



%% X. DISCONNECT
%  Clears the workspace and command window, then
%  disconnects from the nanobot, freeing up the serial port.

clc
delete(nb);
clear('nb');
clear all