-------------------------------------------------------------------------------
-- database.sql
-------------------------------------------------------------------------------
-- Description:
-- 					Contains the database creation sql for the SWS core tables
--						that are required for the SWS to function
-------------------------------------------------------------------------------
-- CVS Details
-- -----------
-- $Author: kerrin $
-- $Date: 2004/04/17 16:52:30 $
-- $Revision: 1.18 $
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Table:			MEMBER_DETAILS
-------------------------------------------------------------------------------
-- Description:	Used to store site specific details about users
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- member_ID				The member this is the details for
-- show_rows            The number of rows to show on the board screen
-- show_columns         The number of columns to show on the board screen
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS MEMBER_DETAILS;
CREATE TABLE MEMBER_DETAILS
(
	ID	            BIGINT NOT NULL,
	member_ID      BIGINT,
   show_rows      SMALLINT NOT NULL DEFAULT 10,
   show_columns   SMALLINT NOT NULL DEFAULT 10,
	PRIMARY KEY (ID),
	FOREIGN KEY (member_ID) REFERENCES MEMBER(ID),
   UNIQUE(member_ID), KEY(member_ID)
);

INSERT INTO MEMBER_DETAILS (ID,member_ID,show_rows,show_columns) VALUES (1,1,10,10);
INSERT INTO MEMBER_DETAILS (ID,member_ID,show_rows,show_columns) VALUES (2,2,10,10);
INSERT INTO MEMBER_DETAILS (ID,member_ID,show_rows,show_columns) VALUES (3,3,10,10);
INSERT INTO SEQUENCE (table_name,count) VALUES ('MEMBER_DETAILS',4);

-------------------------------------------------------------------------------
-- Table:			FREQUENCY_WEEKDAY_TYPE_CONST
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- name                 The brief description
-- description          The full desctription
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS FREQUENCY_WEEKDAY_TYPE_CONST;
CREATE TABLE FREQUENCY_WEEKDAY_TYPE_CONST
(
	ID	BIGINT NOT NULL,
   name        VARCHAR(30) NOT NULL,
   description VARCHAR(50) NOT NULL,
	PRIMARY KEY (ID)
);

INSERT INTO FREQUENCY_WEEKDAY_TYPE_CONST (ID,name,description) VALUES (1,'Everyday','Both weekdays and weekends');
INSERT INTO FREQUENCY_WEEKDAY_TYPE_CONST (ID,name,description) VALUES (2,'Weekdays','Weekdays and not weekends');
INSERT INTO FREQUENCY_WEEKDAY_TYPE_CONST (ID,name,description) VALUES (3,'Weekends','Weekends and not weekdays');
INSERT INTO SEQUENCE (table_name,count) VALUES ('FREQUENCY_WEEKDAY_TYPE_CONST',4);

-------------------------------------------------------------------------------
-- Table:			GAME
-------------------------------------------------------------------------------
-- Description:	
--                The game details
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- creator_ID           The member ID of the member creating the game
-- height               The number of squares high the board is
-- width                The number of squares wide the board is
-- players              The number of players
-- next_turn            The date and time of the next game turn tick
-- start_date_time      The date the game starts or started
-- max_turns            The maximum number of turns before the game ends
-- turn                 The turn number, 0 for not running
-- turn_frequency_hours The number of hours between turns
-- frequency_weekday_type_ID  The days of the week the turns run on
-- turn_start_time      The time of day to start turn ticks
-- turn_stop_time       The time of day to stop turn ticks
-- done                 Marks games that are not running or pending starting
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS GAME;
CREATE TABLE GAME
(
	ID	                           BIGINT NOT NULL,
   creator_ID                    BIGINT NOT NULL,
   height                        SMALLINT NOT NULL,
   width                         SMALLINT NOT NULL,
   players                       SMALLINT NOT NULL,
   next_turn                     DATETIME,
   start_date_time               DATE NOT NULL,
   max_turns                     BIGINT,
   turn                          BIGINT NOT NULL,
   turn_frequency_hours          INT NOT NULL,
   frequency_weekday_type_ID     BIGINT NOT NULL,
   turn_start_time               TIME NOT NULL,
   turn_stop_time                TIME NOT NULL,
   done                          SMALLINT DEFAULT 0,
	PRIMARY KEY (ID),
   FOREIGN KEY (creator_ID) REFERENCES MEMBER(ID),
   FOREIGN KEY (frequency_weekday_type_ID) REFERENCES FREQUENCY_WEEKDAY_TYPE_CONST(ID)
);

-- INSERT INTO GAME (ID,) VALUES (1,);
INSERT INTO SEQUENCE (table_name,count) VALUES ('GAME',1);

-------------------------------------------------------------------------------
-- Table:			PLAYER_COLOUR
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- name                 The colour name
-- image                The image filename for the colour hue
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS PLAYER_COLOUR;
CREATE TABLE PLAYER_COLOUR
(
	ID	         BIGINT NOT NULL,
   name        VARCHAR(20) NOT NULL,
   image       VARCHAR(80) NOT NULL,
   PRIMARY KEY (ID)
);

INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (1,'Red','/Image/player_colour_red.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (2,'Blue','/Image/player_colour_blue.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (3,'Orange','/Image/player_colour_orange.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (4,'Yellow','/Image/player_colour_yellow.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (5,'Cyan','/Image/player_colour_cyan.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (6,'Brown','/Image/player_colour_brown.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (7,'Purple','/Image/player_colour_purple.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (8,'Pink','/Image/player_colour_pink.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (9,'Gray','/Image/player_colour_gray.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (10,'White','/Image/player_colour_white.gif');
INSERT INTO PLAYER_COLOUR (ID,name,image) VALUES (11,'Light Green','/Image/player_colour_green.gif');
INSERT INTO SEQUENCE (table_name,count) VALUES ('PLAYER_COLOUR',12);

-------------------------------------------------------------------------------
-- Table:			GAME_PLAYER
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- member_ID            The member that is playing this player
-- game_ID              The game the player is in
-- colour_ID            The players colour
-- recruits_left        The number of recruits still to be assigned
-- money                The amount of money available to spend
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS GAME_PLAYER;
CREATE TABLE GAME_PLAYER
(
	ID	               BIGINT NOT NULL,
   member_ID         BIGINT NOT NULL,
   game_ID           BIGINT NOT NULL,
   colour_ID         BIGINT NOT NULL,
   recruits_left     INT NOT NULL DEFAULT 0,
   money             INT NOT NULL DEFAULT 0,
   start_across      SMALLINT NOT NULL,
   start_down        SMALLINT NOT NULL,
	PRIMARY KEY (ID),
   FOREIGN KEY (member_ID) REFERENCES MEMBER(ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID),
   FOREIGN KEY (colour_ID) REFERENCES PLAYER_COLOUR(ID),
   UNIQUE(member_ID,game_ID),
   UNIQUE(game_ID,colour_ID),
   INDEX(game_ID)
);

-- INSERT INTO GAME_PLAYER (ID,member_ID,game_ID,colour_ID,recruits_left,money) VALUES (1,);
INSERT INTO SEQUENCE (table_name,count) VALUES ('GAME_PLAYER',1);

-------------------------------------------------------------------------------
-- Table:			GAME_PLAYER_QUICK_LOOKUP
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- game_ID              The game the player is in (short cut only)
-- game_player_ID       The player
-- squares              The number of squares owned by the player (modifed)
-- science_per_turn     The number of science points the player gets a turn
-- units                The number of units the player has in play
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS GAME_PLAYER_QUICK_LOOKUP;
CREATE TABLE GAME_PLAYER_QUICK_LOOKUP
(
	ID	               BIGINT NOT NULL,
   game_ID           BIGINT NOT NULL,
   game_player_ID    BIGINT NOT NULL,
   squares           INT NOT NULL DEFAULT 0,
   science_per_turn  INT NOT NULL DEFAULT 0,
   units             INT NOT NULL DEFAULT 0,
	PRIMARY KEY (ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID),
   FOREIGN KEY (game_player_ID) REFERENCES GAME_PLAYER(ID),
   UNIQUE(game_player_ID),
   INDEX(game_ID)
);

-- INSERT INTO GAME_PLAYER_QUICK_LOOKUP (ID,game_ID,game_player_ID,squares,science_per_turn,units) VALUES (1,);
INSERT INTO SEQUENCE (table_name,count) VALUES ('GAME_PLAYER_QUICK_LOOKUP',1);

-------------------------------------------------------------------------------
-- Table:			PENDING_GAME_PLAYER_START
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- game_ID              The game the player is in (short cut only)
-- game_player_ID       The player
-- across               The offset across of this square (0 based)
-- down                 The offset down of this square   (0 based)
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS PENDING_GAME_PLAYER_START;
CREATE TABLE PENDING_GAME_PLAYER_START
(
	ID	               BIGINT NOT NULL,
   game_ID           BIGINT NOT NULL,
   game_player_ID    BIGINT NOT NULL,
   across            SMALLINT NOT NULL,
   down              SMALLINT NOT NULL,
	PRIMARY KEY (ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID),
   FOREIGN KEY (game_player_ID) REFERENCES GAME_PLAYER(ID),
   UNIQUE(game_player_ID), UNIQUE (game_ID,across,down), 
   INDEX(game_ID)
);

-- INSERT INTO PENDING_GAME_PLAYER_START (ID,game_ID,game_player_ID,across,down) VALUES (1,);
INSERT INTO SEQUENCE (table_name,count) VALUES ('PENDING_GAME_PLAYER_START',1);

-------------------------------------------------------------------------------
-- Table:			LAND_TYPE_CONST
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- name                 The brief description
-- description          The full desctription
-- image                The image filename for the expansion graphic
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS LAND_TYPE_CONST;
CREATE TABLE LAND_TYPE_CONST
(
	ID	            BIGINT NOT NULL,
   name           VARCHAR(30) NOT NULL,
   description    VARCHAR(255) NOT NULL,
   image          VARCHAR(80),
	PRIMARY KEY (ID)
);

INSERT INTO LAND_TYPE_CONST (ID,name,description,image) VALUES (1,'Sea','Sea, passible only with a port, or by building a bridge (which can be owned)','sea_land_type.gif');
INSERT INTO LAND_TYPE_CONST (ID,name,description,image) VALUES (2,'Plains','Plains, land no advantages, no disadvantages','plains_land_type.gif');
INSERT INTO LAND_TYPE_CONST (ID,name,description,image) VALUES (3,'Mountain','Mountain, difficult to get in to, easy to attack out of (+1 to attack and defence)','mountain_land_type.gif');
INSERT INTO LAND_TYPE_CONST (ID,name,description,image) VALUES (4,'Forest','Forest, easy to defend (+1 to defence)','forest_land_type.gif');
INSERT INTO SEQUENCE (table_name,count) VALUES ('LAND_TYPE_CONST',5);

-------------------------------------------------------------------------------
-- Table:			EXPANSION_TYPE_CONST
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- name                 The brief description
-- description          The full desctription
-- money_cost           The cost to build
-- unit_cost            The number of units to build
-- turns                The number of turns to build
-- image                The image filename for the expansion graphic
-- require_tech_ID      The technology required to build
-- require_land_ID      The land type required (-ve means anything except)
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS EXPANSION_TYPE_CONST;
CREATE TABLE EXPANSION_TYPE_CONST
(
	ID	            BIGINT NOT NULL,
   name           VARCHAR(30) NOT NULL,
   description    VARCHAR(255) NOT NULL,
   money_cost     INT NOT NULL,
   unit_cost      INT NOT NULL,
   turns          INT NOT NULL,
   image          VARCHAR(80),
   require_tech_ID   BIGINT DEFAULT 0,
   require_land_ID   BIGINT DEFAULT -1,
	PRIMARY KEY (ID),
   FOREIGN KEY (require_tech_ID) REFERENCES TECHNOLOGY_TYPE_CONST(ID),
   FOREIGN KEY (require_land_ID) REFERENCES LAND_TYPE_CONST(ID)
);

INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID) VALUES (1,'Base','Must have one of these to stay in the game, recruits are started at these. Plus 1 to all attacks and defence. Has sight of 2.',100,9,4,'exp_base.gif',5);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID) VALUES (2,'Fort','Plus 1 to all attacks and defence. Has sight of 2.',50,9,1,'exp_fort.gif',7);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID,require_land_ID) VALUES (3,'Irragation','Plus 1 to area when calulating money and recruits',10,9,2,'exp_irragation.gif',9,2);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID,require_land_ID) VALUES (4,'Bridge','Allows occupation of sea squares, and movement over.',50,9,2,'exp_bridge.gif',8,1);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID) VALUES (5,'Port','One of these allows all your units to enter the sea. You do not own the sea.',100,9,1,'exp_port.gif',8);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID) VALUES (6,'School','Generates 1 science point per turn, which is used to research new technology',20,9,2,'exp_school.gif',11);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID) VALUES (7,'University','Generates 2 science points per turn, which is used to research new technology',40,9,3,'exp_university.gif',12);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID) VALUES (8,'Research Center','Generates 3 science points per turn, which is used to research new technology',60,9,4,'exp_research_center.gif',12);
INSERT INTO EXPANSION_TYPE_CONST (ID,name,description,money_cost,unit_cost,turns,image,require_tech_ID) VALUES (9,'Tower','When occupied, allows the player to see 4 squares away',50,9,1,'exp_.gif',6);
INSERT INTO SEQUENCE (table_name,count) VALUES ('EXPANSION_TYPE_CONST',10);

-------------------------------------------------------------------------------
-- Table:			EFFECT_TYPE_CONST
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- name                 The brief description
-- description          The full desctription
-- money_cost           The cost in money to create
-- unit_cost            The cost in units to create (-ve means up to that many)
-- image                The image to display
-- require_tech_ID      The technology required to build
-- require_land_ID      The land type required (-ve means anything except)
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS EFFECT_TYPE_CONST;
CREATE TABLE EFFECT_TYPE_CONST
(
	ID	            BIGINT NOT NULL,
   name           VARCHAR(30) NOT NULL,
   description    VARCHAR(255) NOT NULL,
   money_cost     INT NOT NULL,
   unit_cost      INT NOT NULL,
   image          VARCHAR(80),
   require_tech_ID   BIGINT DEFAULT 0,
   require_land_ID   BIGINT DEFAULT -1,
	PRIMARY KEY (ID),
   FOREIGN KEY (require_tech_ID) REFERENCES TECHNOLOGY_TYPE_CONST(ID),
   FOREIGN KEY (require_land_ID) REFERENCES LAND_TYPE_CONST(ID)
);

INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (1,'Fire','FIRE! A fire, that may move to an adjacent square. Minus 1 to all attacks and defence.',0,1,'effect_fire.gif',10,-1);
INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (2,'Storm','Terrible wind. A storm that may move to an adjacent square. Minus 1 to all attacks and defence. May cause expansion damage.',0,0,'effect_storm.gif',0,0);
INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (3,'Scout','Scouts, that return information to their master. One scout found per turn and surrenders to the square owner.',0,-9,'effect_scout.gif',17,0);
INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (4,'Suicidal Scout','Scouts, that return information to their master. One scout found per turn, but commits suicide instead of surrendering.',10,-9,'effect_suicide_scout.gif',18,0);
INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (5,'Kamikaze Scout','Scouts, that return information to their master. One scout kills a unit from the square per turn, and is executed.',20,-9,'effect_kamikaze_scout.gif',19,0);
INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (6,'Plague','A plague on all your houses! Minus 1 unit in all attacks and defence. Lose one unit per turn.',10,-9,'effect_plague.gif',15,0);
INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (7,'Celebration','All you people are happy! Plus 1 to all attacks and defence. Doubles square income and breeding rate.',10,0,'effect_celebration.gif',20,0);
INSERT INTO EFFECT_TYPE_CONST (ID,name,description,money_cost,unit_cost,image,require_tech_ID,require_land_ID) VALUES (8,'Forced Peace','Peace, but I wanted to fight! Cannot attack from, and cannot be attacked for this turn',10,0,'effect_forced_peace.gif',14,0);
INSERT INTO SEQUENCE (table_name,count) VALUES ('EFFECT_TYPE_CONST',9);

-------------------------------------------------------------------------------
-- Table:			GAME_BOARD
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- game_ID              The game this square belongs to
-- across               The offset across of this square (0 based)
-- down                 The offset down of this square   (0 based)
-- owner_ID             The square owner
-- units                The number of units on the square
-- land_type_ID         The square type (e.g. Sea, plains)
-- expansion_type_ID    The expansion on the square
-- expansion_hp         Number of hit points left before destruction
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS GAME_BOARD;
CREATE TABLE GAME_BOARD
(
	ID	                  BIGINT NOT NULL,
   game_ID              BIGINT NOT NULL,
   across               SMALLINT NOT NULL,
   down                 SMALLINT NOT NULL,
   owner_ID             BIGINT NOT NULL,
   units                SMALLINT NOT NULL,
   land_type_ID         BIGINT NOT NULL,
   expansion_type_ID    BIGINT NOT NULL,
   expansion_to_build   INT DEFAULT 1,
   expansion_hp         SMALLINT NOT NULL DEFAULT 0,
	PRIMARY KEY (ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID),
   FOREIGN KEY (owner_ID) REFERENCES GAME_PLAYER(ID),
   FOREIGN KEY (land_type_ID) REFERENCES LAND_TYPE_CONST(ID),
   FOREIGN KEY (expansion_type_ID) REFERENCES EXPANSION_TYPE_CONST(ID),
   UNIQUE (game_ID,across,down),
   INDEX(game_ID), INDEX(across), INDEX(down)
);

-- INSERT INTO GAME_BOARD (ID,game_ID,across,down,owner_ID,units,expansion_type_ID,expansion_hp) VALUES (1,);
INSERT INTO SEQUENCE (table_name,count) VALUES ('GAME_BOARD',1);

-------------------------------------------------------------------------------
-- Table:			PROCESSING_BOARD
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- across               The offset across of this square (0 based)
-- down                 The offset down of this square   (0 based)
-- units                The number of units on the square
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS PROCESSING_BOARD;
CREATE TABLE PROCESSING_BOARD
(
	ID	                  BIGINT NOT NULL,
   across               SMALLINT NOT NULL,
   down                 SMALLINT NOT NULL,
   units                SMALLINT NOT NULL,
	PRIMARY KEY (ID),
   UNIQUE (across,down),
   INDEX(across), INDEX(down)
);
INSERT INTO SEQUENCE (table_name,count) VALUES ('PROCESSING_BOARD',1);

-------------------------------------------------------------------------------
-- Table:			PROCESSING_DETAILS
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- game_ID              The game we are processing
-- stage                The stage of processing game (used to recover)
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS PROCESSING_DETAILS;
CREATE TABLE PROCESSING_DETAILS
(
	ID	                  BIGINT NOT NULL,
   game_ID              BIGINT NOT NULL,
   stage                SMALLINT NOT NULL,
	PRIMARY KEY (ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID)
);
INSERT INTO SEQUENCE (table_name,count) VALUES ('PROCESSING_DETAILS',1);

INSERT INTO PROCESSING_DETAILS (ID,game_ID,stage) VALUES (1,0,0);

-------------------------------------------------------------------------------
-- Table:			TECHNOLOGY_TYPE_CONST
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- name                 The brief description
-- description          The full desctription
-- tech_points          The cost in money to create
-- require_ID           The technology that is required to allow research
-- image                The image to display
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS TECHNOLOGY_TYPE_CONST;
CREATE TABLE TECHNOLOGY_TYPE_CONST
(
	ID	            BIGINT NOT NULL,
   name           VARCHAR(30) NOT NULL,
   description    VARCHAR(255) NOT NULL,
   tech_points    INT NOT NULL,
   require_ID     BIGINT,
   image          VARCHAR(80),
	PRIMARY KEY (ID),
   FOREIGN KEY (require_ID) REFERENCES TECHNOLOGY_TYPE_CONST(ID)
);

INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (1,'Basic Weapons','Increase Attack and Defense',10,0,'tech_basicweapons.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (2,'Gun Powder','Increase Attack and Defense',50,1,'tech_gunpowder.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (3,'Tanks','Increase Attack and Defense',100,2,'tech_tanks.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (4,'Armour','Increase Defense',20,1,'tech_armour.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (5,'Masonry','Allow new Bases',50,0,'tech_masonry.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (6,'Tall Construction','Allow building of Towers',50,8,'tech_tallconstruction.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (7,'Bricks','Allows Fortifications',50,5,'tech_.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (8,'Engineering','Allows Bridges to be built',50,7,'tech_.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (9,'Farming','Allows irragation to be done',20,0,'tech_farming.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (10,'Basic Science','Allows Fires to be started, and technologies Teaching, and Disease',10,0,'tech_basicscience.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (11,'Teaching','Allows Schools to be built',20,10,'tech_teaching.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (12,'Advance Teaching','Allows Universities',50,11,'tech_advancedteaching.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (13,'Basic Diplomacy','Allows alliences',50,1,'tech_basicdiplomacy.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (14,'Advanced Diplomacy','Allows forced Peace',100,13,'tech_advanceddiplomacy.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (15,'Disease','Allows Plague',50,10,'tech_desease.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (16,'Medicine','Allows plague cure',100,12,'tech_medicine.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (17,'Spying','Allows scout',30,13,'tech_spying.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (18,'Espionage','Allows suicidal scout',60,17,'tech_espionage.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (19,'Fanatics','Allows kamakazi scouts',90,18,'tech_fanatics.gif');
INSERT INTO TECHNOLOGY_TYPE_CONST (ID,name,description,tech_points,require_ID,image) VALUES (20,'Entertainment','Allows celebration',100,11,'tech_entertainment.gif');
INSERT INTO SEQUENCE (table_name,count) VALUES ('TECHNOLOGY_TYPE_CONST',21);

-------------------------------------------------------------------------------
-- Table:			GAME_PLAYER_TECHNOLOGY_LINK
-------------------------------------------------------------------------------
-- Description:	Stores the technology a player has in a game
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- game_ID			      The unique identifier for the game (shortcut only)
-- game_player_ID			The unique identifier for the game player
-- tech_points          The number of technology points left to completion
-- technology_ID			The unique identifier for the technology
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS GAME_PLAYER_TECHNOLOGY_LINK;
CREATE TABLE GAME_PLAYER_TECHNOLOGY_LINK
(
	ID	            BIGINT NOT NULL,
	game_ID	      BIGINT NOT NULL,
	game_player_ID	BIGINT NOT NULL,
	tech_points    NOT NULL,
	technology_ID	BIGINT NOT NULL,
	PRIMARY KEY (ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID),
   FOREIGN KEY (game_player_ID) REFERENCES GAME_PLAYER(ID),
   FOREIGN KEY (technology_ID) REFERENCES TECHNOLOGY_TYPE_CONST(ID)
);
INSERT INTO SEQUENCE (table_name,count) VALUES ('GAME_PLAYER_TECHNOLOGY_LINK',1);

-------------------------------------------------------------------------------
-- Table:			MOVE_TYPE_CONST
-------------------------------------------------------------------------------
-- Description:	Stores the move types a player can make
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- name                 The brief description
-- description          The full desctription
-- require_tech_ID      The technology required to be able to do this, 0 = none
-- require_land_ID      The land type this can be done on 0 = Any
--                            -ve means anything except i.e. -1 = Not Sea
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS MOVE_TYPE_CONST;
CREATE TABLE MOVE_TYPE_CONST
(
	ID	               BIGINT NOT NULL,
   name              VARCHAR(30) NOT NULL,
   description       VARCHAR(255) NOT NULL,
   require_tech_ID   BIGINT DEFAULT 0,
   require_land_ID   BIGINT DEFAULT -1,
	PRIMARY KEY (ID),
   FOREIGN KEY (require_tech_ID) REFERENCES TECHNOLOGY_TYPE_CONST(ID),
   FOREIGN KEY (require_land_ID) REFERENCES LAND_TYPE_CONST(ID)
);

INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (1,'Build Base','Build a new Base. And you recruits can start here',5);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (2,'Build Fort','Build a fortification, to defend this square',7);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (3,'Irragate','Irragate the land to support more citizens, and more citizens means more money, and more recuits',9);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID,require_land_ID) VALUES (4,'Build Bridge','Build a bridge, so you can pass water',8,1);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (5,'Build Port','Build a sea Port, and traverse the sea like columbus, the guy in the dirty mac, who discovered America',8);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (6,'Build School','Build a school, and have a more literate society. When they grow up, they will be better at research in the area',11);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (7,'Build University','Build a university, and your research will increase in the area.',12);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (8,'Build Research Center','Build a research center, to maximize your research for the citizens in the area',12);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (9,'Build Tower','Build a tower, and see more of the beutiful country side.',6);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (10,'Start Fire','Start a fire, and the army will be busy trying to put it out.',10);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (12,'Send Scouts','Send scouts to spy on your enemy, spys have a tendancy to get caught, but the more you send, the longer it takes to find them all',17);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (13,'Send Suicidal Scouts','Send scouts to spy, and die for the cause',18);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (14,'Send Kamikaze Scouts','Send scouts to spy, and die for the cause, bring you enemy with them',19);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (15,'Start Plague','Infect with a plague on all their houses. Ill people fight badly, and some die. The more infected people you send, the longer the plague will last',15);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (16,'Have a Celebration','Celebrate good times, come on! A happy citizen will fight hard, pay higher taxes, and more likely enlist for your army',20);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (17,'Force Peace','Peace man. You cannot fight me, we are nice people here. For now.',14);
INSERT INTO MOVE_TYPE_CONST (ID,name,description,require_tech_ID) VALUES (20,'Move','Move units from one square to another, if you meet enemy forces, a battle will ensue.', 0);
INSERT INTO SEQUENCE (table_name,count) VALUES ('MOVE_TYPE_CONST',21);

-------------------------------------------------------------------------------
-- Table:			GAME_BOARD_MOVE
-------------------------------------------------------------------------------
-- Description:	Stores the pending moves for the next turn
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- game_ID              The game this square belongs to
-- owner_ID             The player making the move
-- from_across          The offset across of the from square (0 based)
-- from_down            The offset down of the from square   (0 based)
-- to_across            The offset across of the to square (0 based)
-- to_down              The offset down of the to square   (0 based)
-- units                The number of units to move to the square
-- move_type_ID         The type of move, e.g. Move, build expansion
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS GAME_BOARD_MOVE;
CREATE TABLE GAME_BOARD_MOVE
(
	ID	                  BIGINT NOT NULL,
   game_ID              BIGINT NOT NULL,
   owner_ID             BIGINT NOT NULL,
   from_across          SMALLINT NOT NULL,
   from_down            SMALLINT NOT NULL,
   to_across            SMALLINT NOT NULL,
   to_down              SMALLINT NOT NULL,
   units                SMALLINT NOT NULL,
   move_type_ID         BIGINT NOT NULL,
	PRIMARY KEY (ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID),
   FOREIGN KEY (owner_ID) REFERENCES GAME_PLAYER(ID),
   FOREIGN KEY (move_type_ID) REFERENCES MOVE_TYPE_CONST(ID),
   UNIQUE (game_ID,from_across,from_down,to_across,to_down,move_type_ID),
   INDEX(game_ID), INDEX(from_across), INDEX(from_down), 
   INDEX(to_across), INDEX(to_down), INDEX(move_type_ID)
);

INSERT INTO SEQUENCE (table_name,count) VALUES ('GAME_BOARD_MOVE',1);

-------------------------------------------------------------------------------
-- Table:			SQUARE_EFFECT_DETAILS
-------------------------------------------------------------------------------
-- Description:	This link table stores effects on squares
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- game_ID              The game the effect is in (short cut only)
-- game_board_ID        The square that the effect is on
-- effect_type_ID       The type of effect in place
-- turns_left           The number of turns left to run for the effect
-- owner_ID             The effect creator
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS SQUARE_EFFECT_DETAILS;
CREATE TABLE SQUARE_EFFECT_DETAILS
(
	ID	            BIGINT NOT NULL,
   game_ID        BIGINT NOT NULL,
   game_board_ID  BIGINT NOT NULL,
   effect_type_ID BIGINT NOT NULL,
   turns_left     INT NOT NULL DEFAULT 1,
   owner_ID       BIGINT NOT NULL,
	PRIMARY KEY (ID),
   FOREIGN KEY (game_ID) REFERENCES GAME(ID),
   FOREIGN KEY (game_board_ID) REFERENCES GAME_BOARD(ID),
   FOREIGN KEY (effect_type_ID) REFERENCES EFFECT_TYPE_CONST(ID),
   FOREIGN KEY (owner_ID) REFERENCES GAME_PLAYER(ID),
   INDEX(game_ID), INDEX(game_board_ID)
);

-- INSERT INTO SQUARE_EFFECT_DETAILS (ID,game_ID,game_board_ID,effect_type_ID,turns_left,owner_ID) VALUES (1,);
INSERT INTO SEQUENCE (table_name,count) VALUES ('SQUARE_EFFECT_DETAILS',1);

-------------------------------------------------------------------------------
-- Table:			
-------------------------------------------------------------------------------
-- Description:	
-------------------------------------------------------------------------------
-- Name						Usage
-- -------------------- ------------------------------------------------------- 
-- ID							The unique identifier for the row
-- 
-------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS ;
-- CREATE TABLE 
-- (
-- 	ID	BIGINT NOT NULL,
-- 	PRIMARY KEY (ID)
-- );
-- 
-- INSERT INTO  (ID,) VALUES (1,);
-- INSERT INTO SEQUENCE (table_name,count) VALUES ('',1);
