      ******************************************************************
      *PROGRAM : BLDG-ADD.CBL                                          *
      *AUTHOR  : Lee Hawthorne                                         *
      *DATE    : 2/17/2015                                             *
      *ABSTRACT: This program adds to the BUILDING-ISAM.DAT FILE       *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BLDG-ADD AS "BLDG-ADD" IS INITIAL PROGRAM.
      *----------------------------------------------------------------- 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.                                                    
           SELECT ISAM-BLDG-IO ASSIGN TO "../BUILDING-ISAM.DAT"         
                               ORGANIZATION  IS INDEXED
                               ACCESS        IS RANDOM    
                               RECORD KEY    IS ISAM-IO-KEY
                               FILE STATUS   IS WS-STAT.
      *----------------------------------------------------------------- 
       DATA DIVISION.
      *----------------------------------------------------------------- 
       FILE SECTION.
       FD  ISAM-BLDG-IO.
       01  ISAM-REC-IO.
           03  ISAM-IO-KEY.
               05  ISAM-IO-BLDG PIC X(7).
               05  ISAM-IO-ROOM PIC X(5).
           03  ISAM-IO-SEATS    PIC X(4).
      *----------------------------------------------------------------- 
       WORKING-STORAGE SECTION.
       01  MISC-VARS.
           03  WS-MSG                  PIC X(40)   VALUE SPACES.
           03  WS-RESP                 PIC X       VALUE SPACES.
           03  WS-STAT                 PIC XX      VALUE SPACES.
           03  WS-CONT                 PIC X       VALUE 'Y'.
               
       01  WS-REC.
           03  WS-KEY.
               05  WS-BLDG     PIC X(7)        VALUE SPACES.
               05  WS-ROOM     PIC X(5)        VALUE SPACES.
           03  WS-SEATS        PIC X(4)        VALUE SPACES.
      *----------------------------------------------------------------- 
       SCREEN SECTION.
       01  BLANK-SCREEN.
           03  BLANK SCREEN.
           03  LINE 1 COL  1 VALUE 'BLDG-ADD'.
           03  LINE 1 COL 37 VALUE "U of H".
           03  LINE 1 COL 71 VALUE "2/13/2015".
           03  LINE 2 COL 37 VALUE "BUILDING".
       01  SCRN-BLDG-REQ.
           03  LINE 04 COL 35                       VALUE ' BUILDING:'.
           03  LINE 04 COL 45 PIC X(7)  TO WS-BLDG  AUTO.
           03  LINE 09 COL 35 PIC X(40) FROM WS-MSG.
           
       01  SCRN-ROOM-REQ.
           03  LINE 05 COL 35                       VALUE '     ROOM:'. 
           03  LINE 05 COL 45 PIC X(5)  TO WS-ROOM  AUTO.
           
       01  SCRN-BLDG-DATA.
           03  LINE 06 COL 35                       VALUE '    SEATS:'.
           03  LINE 06 COL 45 PIC X(4)  TO WS-SEATS AUTO.
           
       01  SCRN-ADD-ANOTHER.
           03  LINE 11 COL 33                     VALUE 'ADD ANOTHER?:'.
           03  LINE 12 COL 33                     VALUE '(Y/N)'.
           03  LINE 11 COL 45 PIC X  TO WS-CONT   AUTO.
      *----------------------------------------------------------------- 
       PROCEDURE DIVISION.
       000-MAIN-MODULE.
           OPEN I-O ISAM-BLDG-IO.
           DISPLAY BLANK-SCREEN
           PERFORM UNTIL WS-CONT='n' OR 'N'
               DISPLAY SCRN-BLDG-REQ
               DISPLAY SCRN-ROOM-REQ
               DISPLAY SCRN-BLDG-DATA
               ACCEPT  SCRN-BLDG-REQ
               ACCEPT  SCRN-ROOM-REQ
               MOVE WS-KEY TO ISAM-IO-KEY
               READ ISAM-BLDG-IO
                   INVALID KEY
                       ACCEPT  SCRN-BLDG-DATA
                       MOVE WS-SEATS TO ISAM-IO-SEATS
                       WRITE ISAM-REC-IO
                           INVALID KEY
                               MOVE   'INVALID ID' TO WS-MSG
                           NOT INVALID KEY
                               STRING ISAM-IO-KEY ' ADDED' INTO WS-MSG
                       END-WRITE
                   NOT INVALID KEY
                       MOVE   'ID ALREADY EXISTS' TO WS-MSG
                       
               DISPLAY SCRN-ADD-ANOTHER
               ACCEPT  SCRN-ADD-ANOTHER
               PERFORM UNTIL WS-CONT='y' OR 'Y' OR 'n' OR 'N'
                   MOVE 'PLEASE ENTER Y OR N' TO WS-MSG
                   DISPLAY SCRN-BLDG-REQ
                   DISPLAY SCRN-ADD-ANOTHER
                   ACCEPT  SCRN-ADD-ANOTHER
               END-PERFORM
           END-PERFORM.
           
           
           
           CLOSE ISAM-BLDG-IO.
           EXIT PROGRAM.
           STOP RUN.
