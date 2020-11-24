Keypad Lock Project
Repository for the Imperial College London physics third year Microprocessor Lab project
Developed by Katherine Whitby and Philipp Sonnenschein
Written in assembly code for PIC18F87K22 microprocessor, developed in MPLAB X IDE v5.40, using a 16x2 LCD display, a 16 digit keypad, and a servo motor

The code is structured in to 10 files that can be organised in to 3 sections:

Section 1 - main body
This section includes the files Main, Keypad_numbers, Keypad_letters, and check_pin
Main:           Calls upon various setup routines that predefine fixed variables and setup external devices
                After an input is given, the corresponding number is determined and then displayed on the LCD
                After the 4th input, the code is compared to the pin before the code is repeated
Keypad_numbers: Waits for a keypad number input, measures the input at the I/O Port E, decodes the input and then saves the corresponding number as the output variable
Keypad_letters: Waits for a keypad letter input, measures the input at the I/O Port E, decodes the input and then calls the corresponding routines in check_pin
check_pin:      Goes through a series of checks to determine whether the correct pin has been entered and then calls the corresponding subroutines
                If the correct pin is entered, the system waits for a letter input that corresponds to various actions
                These include locking the door, changing the user set pin code, and changing the anonymous mode
                
Section 2 - External devices
This section includes the files LCD, Buzzer, and Door
LCD:            LCD is setup and displays hex numbers on the LCD screen
Buzzer:         A PWM signal is generated through the CCP PWM module that is then sent to the input pin of the piezo buzzer
Door:           The door is opened or closed by sending a timed pulse, corresponding to a specific position of the servo motor

Section 3 - Displayed messages
This section includes the files Write_welcome, Write_menu, and Write_wrong
Write_welcome:  Displays the welcome message
Write_menu:     Displays the menu options after the correct pin is entered
Write_wrong:    Displays a wrong pin message after the wrong pin is entered