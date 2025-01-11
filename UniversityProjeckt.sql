DROP TABLE Users CASCADE CONSTRAINTS;
DROP TABLE Games CASCADE CONSTRAINTS;
DROP TABLE GameMoves CASCADE CONSTRAINTS;
DROP TABLE Tournaments CASCADE CONSTRAINTS;
DROP TABLE TournamentParticipants CASCADE CONSTRAINTS;
DROP TABLE Messages CASCADE CONSTRAINTS;
DROP TABLE Friendships CASCADE CONSTRAINTS;
DROP TABLE Rankings CASCADE CONSTRAINTS;
DROP TABLE RankingPlayers CASCADE CONSTRAINTS;
DROP TABLE GameSettings CASCADE CONSTRAINTS;
DROP TABLE GameStatistics CASCADE CONSTRAINTS;
DROP TABLE TrainingSessions CASCADE CONSTRAINTS;
DROP TABLE GameReviews CASCADE CONSTRAINTS;


CREATE TABLE Users
(
    UserID           NUMBER PRIMARY KEY,
    Username         VARCHAR2(50)  NOT NULL UNIQUE,
    Password         VARCHAR2(50)  NOT NULL,
    Email            VARCHAR2(100) NOT NULL UNIQUE,
    RegistrationDate DATE DEFAULT SYSDATE,
    EloRating        NUMBER CHECK (EloRating >= 0),
    Active           Number(1) CHECK (Active in (0, 1))
);

CREATE TABLE GameSettings
(
    SettingID    NUMBER PRIMARY KEY,
    TimeControl  VARCHAR2(20),
    IsRated      CHAR(1)      DEFAULT 'Y' CHECK (IsRated IN ('Y', 'N')),
    Type         varchar2(30) DEFAULT 'Blitz',
    SpecialRules VARCHAR2(200),
    CONSTRAINT chk_Type CHECK (Type in ('Blitz', 'Bullet', 'Rapid', 'Daily'))
);

CREATE TABLE Games
(
    GameID     NUMBER PRIMARY KEY,
    Player1ID  NUMBER NOT NULL,
    Player2ID  NUMBER NOT NULL,
    SettingsId NUMBER NOT NULL,
    WinnerID   NUMBER,
    StartTime  DATE DEFAULT SYSDATE,
    EndTime    DATE,
    CONSTRAINT chk_EndTime CHECK (EndTime > StartTime),
    CONSTRAINT fk_Player1 FOREIGN KEY (Player1ID) REFERENCES Users (UserID) ON DELETE SET NULL,
    CONSTRAINT fk_Player2 FOREIGN KEY (Player2ID) REFERENCES Users (UserID) ON DELETE SET NULL,
    CONSTRAINT fk_Winner FOREIGN KEY (WinnerID) REFERENCES Users (UserID) ON DELETE SET NULL,
    CONSTRAINT fk_Games_Settings FOREIGN KEY (SettingsId) REFERENCES GameSettings (SettingID) ON DELETE SET NULL
);


CREATE TABLE GameMoves
(
    MoveID     NUMBER PRIMARY KEY,
    GameID     NUMBER       NOT NULL,
    MoveNumber NUMBER       NOT NULL,
    PlayerID   NUMBER       NOT NULL,
    Move       VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_Game FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE,
    CONSTRAINT fk_Player FOREIGN KEY (PlayerID) REFERENCES Users (UserID) ON DELETE SET NULL
);

CREATE TABLE Tournaments
(
    TournamentID   NUMBER PRIMARY KEY,
    TournamentName VARCHAR2(100) NOT NULL UNIQUE,
    StartDate      DATE          NOT NULL,
    EndDate        DATE,
    Location       VARCHAR2(100) DEFAULT 'online',
    Type           VARCHAR2(30)  DEFAULT 'Blitz',
    PrizePull      NUMBER        NOT NULL CHECK (PrizePull > 0),
    CONSTRAINT chk_TournamentDates CHECK (EndDate > StartDate),
    CONSTRAINT chk_Type_Tour CHECK (Type in ('Blitz', 'Bullet', 'Rapid', 'Daily'))
);

CREATE TABLE TournamentParticipants
(
    ParticipantID NUMBER PRIMARY KEY,
    TournamentID  NUMBER NOT NULL,
    UserID        NUMBER NOT NULL,
    Score         NUMBER DEFAULT 0,
    JoinDate      DATE   DEFAULT SYSDATE,
    CONSTRAINT chk_Score CHECK (Score >= 0),
    CONSTRAINT fk_Tournament FOREIGN KEY (TournamentID) REFERENCES Tournaments (TournamentID) ON DELETE CASCADE,
    CONSTRAINT fk_User FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE
);

CREATE TABLE Messages
(
    MessageID      NUMBER PRIMARY KEY,
    SenderID       NUMBER        NOT NULL,
    ReceiverID     NUMBER        NOT NULL,
    MessageContent VARCHAR2(200) NOT NULL,
    SentDate       DATE DEFAULT SYSDATE,
    CONSTRAINT fk_Sender FOREIGN KEY (SenderID) REFERENCES Users (UserID) ON DELETE SET NULL,
    CONSTRAINT fk_Receiver FOREIGN KEY (ReceiverID) REFERENCES Users (UserID) ON DELETE SET NULL
);

CREATE TABLE Friendships
(
    FriendshipID   NUMBER PRIMARY KEY,
    UserID1        NUMBER NOT NULL,
    UserID2        NUMBER NOT NULL,
    FriendshipDate DATE         DEFAULT SYSDATE,
    Status         VARCHAR2(10) DEFAULT 'Pending' CHECK (Status in ('Pending', 'Accepted', 'Blocked')),
    CONSTRAINT fk_FriendUser1 FOREIGN KEY (UserID1) REFERENCES Users (UserID) ON DELETE CASCADE,
    CONSTRAINT fk_FriendUser2 FOREIGN KEY (UserID2) REFERENCES Users (UserID) ON DELETE CASCADE,
    CONSTRAINT chk_Friendship CHECK (UserID1 <> UserID2)
);


CREATE TABLE Rankings
(
    RankingID   NUMBER PRIMARY KEY,
    RankingName VARCHAR2(30),
    Capacity    NUMBER,
    LastUpdated DATE         DEFAULT SYSDATE,
    StartDate   DATE         DEFAULT SYSDATE,
    EndDate     DATE,
    Status      VARCHAR2(20) DEFAULT 'active' CHECK ( Status in ('active', 'inactive', 'finished') ),
    Region      VARCHAR2(40),
    CONSTRAINT ch_Capacity CHECK (Capacity > 0),
    CONSTRAINT ch_Start_End CHECK (EndDate > StartDate)

);

CREATE TABLE RankingPlayers
(
    RankingPlayerId NUMBER PRIMARY KEY,
    RakingId        NUMBER NOT NULL,
    UserId          NUMBER,
    Score       NUMBER CHECK (Score >= 0),
    Rank            NUMBER NOT NULL CHECK (Rank >= 1),
    HighestRank     NUMBER,
    CONSTRAINT fk_RakingId FOREIGN KEY (RakingId) REFERENCES Rankings (RankingID) ON DELETE CASCADE,
    CONSTRAINT fk_UserId FOREIGN KEY (UserId) REFERENCES Users (UserID) ON DELETE SET NULL
);

CREATE TABLE GameStatistics
(
    StatID          NUMBER PRIMARY KEY,
    GameID          NUMBER NOT NULL,
    MovesCount      NUMBER CHECK (MovesCount >= 0),
    Player1TimeLeft NUMBER,
    Player2TimeLeft NUMBER,
    AverageMoveTime NUMBER,
    CONSTRAINT fk_GameStatistics_Game FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE
);

CREATE TABLE TrainingSessions
(
    SessionID    NUMBER PRIMARY KEY,
    UserID       NUMBER NOT NULL,
    TrainingType VARCHAR2(50),
    Score        NUMBER DEFAULT 0,
    SessionDate  DATE   DEFAULT SYSDATE,
    CONSTRAINT fk_Training_User FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE,
    CONSTRAINT check_Training_Type check (TrainingType in ('Puzzles', 'Endgame Practice'))
);

CREATE TABLE GameReviews
(
    ReviewID   NUMBER PRIMARY KEY,
    GameID     NUMBER NOT NULL,
    ReviewerID NUMBER,
    Rating     NUMBER CHECK (Rating BETWEEN 1 AND 5),
    Review     VARCHAR2(250),
    ReviewDate DATE DEFAULT SYSDATE,
    CONSTRAINT fk_Review_Game FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE,
    CONSTRAINT fk_Review_User FOREIGN KEY (ReviewerID) REFERENCES Users (UserID) ON DELETE SET NULL
);



INSERT INTO Users (UserID, Username, Password, Email, EloRating, Active)
VALUES (1, 'ChessMaster99', 'pass1', 'chessmaster99@example.com', 1500, 1);
INSERT INTO Users (UserID, Username, Password, Email, EloRating, Active)
VALUES (2, 'QueenGambit', '12344352', 'queengambit@example.com', 1700, 1);
INSERT INTO Users (UserID, Username, Password, Email, EloRating, Active)
VALUES (3, 'PawnToVictory', 'password123', 'pawntovictory@example.com', 1300, 1);
INSERT INTO Users (UserID, Username, Password, Email, EloRating, Active)
VALUES (4, 'BlitzKing', 'superSecurity', 'blitzking@example.com', 2000, 1);
INSERT INTO Users (UserID, Username, Password, Email, EloRating, Active)
VALUES (5, 'EndgameExpert', 'goodPass3', 'endgameexpert@example.com', 1800, 1);
INSERT INTO Users (UserID, Username, Password, Email, EloRating, Active)
VALUES (6, 'CasualPlayer', 'easyWin', 'casualplayer@example.com', 900, 0);
INSERT INTO Users (UserID, Username, Password, Email, EloRating, Active)
VALUES (7, 'RapidRookie', 'esGames123', 'rapidrookie@example.com', 1100, 1);


INSERT INTO GameSettings (SettingID, TimeControl, IsRated, Type, SpecialRules)
VALUES (1, '5+0', 'Y', 'Blitz', 'No special rules');
INSERT INTO GameSettings (SettingID, TimeControl, IsRated, Type, SpecialRules)
VALUES (2, '3+2', 'Y', 'Bullet', 'No special rules');
INSERT INTO GameSettings (SettingID, TimeControl, IsRated, Type, SpecialRules)
VALUES (3, '15+10', 'N', 'Rapid', 'No special rules');
INSERT INTO GameSettings (SettingID, TimeControl, IsRated, Type, SpecialRules)
VALUES (4, '1+0', 'Y', 'Bullet', 'No special rules');
INSERT INTO GameSettings (SettingID, TimeControl, IsRated, Type, SpecialRules)
VALUES (5, '10+0', 'Y', 'Blitz', 'Handicap: Player1 starts without a knight');
INSERT INTO GameSettings (SettingID, TimeControl, IsRated, Type, SpecialRules)
VALUES (6, '30+30', 'N', 'Daily', 'Custom time control for correspondence games');
INSERT INTO GameSettings (SettingID, TimeControl, IsRated, Type, SpecialRules)
VALUES (7, '2+1', 'Y', 'Bullet', 'Ultra-fast mode');


INSERT INTO Games (GameID, Player1ID, Player2ID, SettingsId, WinnerID, StartTime, EndTime)
VALUES (1, 1, 2, 1, 2, SYSDATE - 5, SYSDATE - 4.9);
INSERT INTO Games (GameID, Player1ID, Player2ID, SettingsId, WinnerID, StartTime, EndTime)
VALUES (2, 3, 4, 3, 4, SYSDATE - 10, SYSDATE - 9.8);
INSERT INTO Games (GameID, Player1ID, Player2ID, SettingsId, WinnerID, StartTime, EndTime)
VALUES (3, 5, 6, 4, 5, SYSDATE - 2, SYSDATE - 1.95);
INSERT INTO Games (GameID, Player1ID, Player2ID, SettingsId, WinnerID, StartTime, EndTime)
VALUES (4, 1, 7, 2, 1, SYSDATE - 7, SYSDATE - 6.95);
INSERT INTO Games (GameID, Player1ID, Player2ID, SettingsId, WinnerID, StartTime, EndTime)
VALUES (5, 2, 3, 5, 3, SYSDATE - 15, SYSDATE - 14.9);
INSERT INTO Games (GameID, Player1ID, Player2ID, SettingsId, WinnerID, StartTime, EndTime)
VALUES (6, 4, 7, 1, 4, SYSDATE - 20, SYSDATE - 19.8);
INSERT INTO Games (GameID, Player1ID, Player2ID, SettingsId, WinnerID, StartTime, EndTime)
VALUES (7, 6, 5, 7, 5, SYSDATE - 30, SYSDATE - 29.8);


INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (1, 1, 1, 1, 'e4');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (2, 1, 2, 2, 'e5');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (3, 1, 3, 1, 'Nf3');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (4, 2, 1, 3, 'd4');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (5, 2, 2, 4, 'd5');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (6, 2, 3, 3, 'c4');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (7, 3, 1, 5, 'g3');


INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (1, 'Blitz Championship 2025', SYSDATE - 30, SYSDATE - 28, 'New York', 'Blitz', 10000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (2, 'Rapid Open 2025', SYSDATE - 20, SYSDATE - 18, 'Online', 'Rapid', 5000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (3, 'Bullet Masters', SYSDATE - 60, SYSDATE - 58, 'Los Angeles', 'Bullet', 8000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (4, 'Daily Cup 2025', SYSDATE - 15, SYSDATE - 14, 'Online', 'Daily', 3000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (5, 'Chess Marathon', SYSDATE - 100, SYSDATE - 90, 'London', 'Rapid', 20000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (6, 'Endgame Challenge', SYSDATE - 45, SYSDATE - 44, 'Paris', 'Blitz', 15000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (7, 'Beginner Cup', SYSDATE - 10, SYSDATE - 9, 'Berlin', 'Bullet', 2000);


INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (1, 1, 1, 5, SYSDATE - 29);
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (2, 1, 2, 6, SYSDATE - 28);
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (3, 1, 3, 4, SYSDATE - 27);
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (4, 2, 4, 8, SYSDATE - 18);
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (5, 2, 5, 7, SYSDATE - 19);
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (6, 3, 6, 3, SYSDATE - 59);
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (7, 3, 7, 5, SYSDATE - 58);


INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (1, 1, 2, 'Good game!', SYSDATE - 1);
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (2, 2, 3, 'Do you want a rematch?', SYSDATE - 2);
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (3, 3, 4, 'Let’s play later today.', SYSDATE - 3);
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (4, 4, 5, 'Congratulations on your win!', SYSDATE - 4);
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (5, 5, 6, 'I need some advice for Blitz.', SYSDATE - 5);
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (6, 6, 7, 'Thanks for the training game!', SYSDATE - 6);
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (7, 7, 1, 'Looking forward to our match!', SYSDATE - 7);


INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (1, 1, 2, SYSDATE - 100, 'Accepted');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (2, 1, 3, SYSDATE - 90, 'Pending');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (3, 2, 4, SYSDATE - 80, 'Accepted');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (4, 3, 5, SYSDATE - 70, 'Blocked');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (5, 4, 6, SYSDATE - 60, 'Accepted');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (6, 5, 7, SYSDATE - 50, 'Accepted');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (7, 6, 1, SYSDATE - 40, 'Pending');


INSERT INTO Rankings(RankingID, RankingName, Capacity, EndDate, Region)
VALUES (1, 'Bullet', 100, SYSDATE + 10, 'Poland');
INSERT INTO Rankings(RankingID, RankingName, Capacity, EndDate, Region)
VALUES (2, 'Blitz', 1000, SYSDATE + 10, 'USA');
INSERT INTO Rankings(RankingID, RankingName, Capacity, EndDate, Region)
VALUES (3, 'Daily', 100, SYSDATE + 10, 'Poland');
INSERT INTO Rankings(RankingID, RankingName, Capacity, EndDate, Region)
VALUES (4, 'Bullet', 400, SYSDATE + 10, 'Germany');
INSERT INTO Rankings(RankingID, RankingName, Capacity, EndDate, Region)
VALUES (5, 'Bullet', 300, SYSDATE + 10, 'Russia');
INSERT INTO Rankings(RankingID, RankingName, Capacity, EndDate, Region)
VALUES (6, 'Rapid', 20, SYSDATE + 10, 'Poland');
INSERT INTO Rankings(RankingID, RankingName, Capacity, EndDate, Region)
VALUES (7, 'Blitz', 200, SYSDATE + 10, 'Poland');


INSERT INTO RankingPlayers(RankingPlayerId, RakingId, UserId, Score, Rank, HighestRank)
VALUES (1, 1, 1, 300, 1, 1);
INSERT INTO RankingPlayers(RankingPlayerId, RakingId, UserId, Score, Rank, HighestRank)
VALUES (2, 1, 2, 250, 2, 1);
INSERT INTO RankingPlayers(RankingPlayerId, RakingId, UserId, Score, Rank, HighestRank)
VALUES (3, 2, 3, 3000, 1, 1);
INSERT INTO RankingPlayers(RankingPlayerId, RakingId, UserId, Score, Rank, HighestRank)
VALUES (4, 3, 1, 200, 10, 1);
INSERT INTO RankingPlayers(RankingPlayerId, RakingId, UserId, Score, Rank, HighestRank)
VALUES (5, 4, 7, 2300, 10, 5);
INSERT INTO RankingPlayers(RankingPlayerId, RakingId, UserId, Score, Rank, HighestRank)
VALUES (6, 5, 4, 3030, 3, 2);
INSERT INTO RankingPlayers(RankingPlayerId, RakingId, UserId, Score, Rank, HighestRank)
VALUES (7, 6, 6, 3002, 4, 3);

INSERT INTO GameStatistics (StatID, GameID, MovesCount, Player1TimeLeft, Player2TimeLeft, AverageMoveTime)
VALUES (1, 1, 42, 120, 110, 5);
INSERT INTO GameStatistics (StatID, GameID, MovesCount, Player1TimeLeft, Player2TimeLeft, AverageMoveTime)
VALUES (2, 2, 35, 100, 90, 6);
INSERT INTO GameStatistics (StatID, GameID, MovesCount, Player1TimeLeft, Player2TimeLeft, AverageMoveTime)
VALUES (3, 3, 50, 140, 130, 4);
INSERT INTO GameStatistics (StatID, GameID, MovesCount, Player1TimeLeft, Player2TimeLeft, AverageMoveTime)
VALUES (4, 4, 60, 200, 190, 3);
INSERT INTO GameStatistics (StatID, GameID, MovesCount, Player1TimeLeft, Player2TimeLeft, AverageMoveTime)
VALUES (5, 5, 20, 50, 45, 8);
INSERT INTO GameStatistics (StatID, GameID, MovesCount, Player1TimeLeft, Player2TimeLeft, AverageMoveTime)
VALUES (6, 6, 55, 180, 170, 5);
INSERT INTO GameStatistics (StatID, GameID, MovesCount, Player1TimeLeft, Player2TimeLeft, AverageMoveTime)
VALUES (7, 7, 30, 120, 100, 7);


INSERT INTO TrainingSessions (SessionID, UserID, TrainingType, Score, SessionDate)
VALUES (1, 1, 'Puzzles', 95, SYSDATE - 1);
INSERT INTO TrainingSessions (SessionID, UserID, TrainingType, Score, SessionDate)
VALUES (2, 2, 'Endgame Practice', 85, SYSDATE - 2);
INSERT INTO TrainingSessions (SessionID, UserID, TrainingType, Score, SessionDate)
VALUES (3, 3, 'Puzzles', 70, SYSDATE - 3);
INSERT INTO TrainingSessions (SessionID, UserID, TrainingType, Score, SessionDate)
VALUES (4, 4, 'Endgame Practice', 90, SYSDATE - 4);
INSERT INTO TrainingSessions (SessionID, UserID, TrainingType, Score, SessionDate)
VALUES (5, 5, 'Puzzles', 88, SYSDATE - 5);
INSERT INTO TrainingSessions (SessionID, UserID, TrainingType, Score, SessionDate)
VALUES (6, 6, 'Endgame Practice', 72, SYSDATE - 6);
INSERT INTO TrainingSessions (SessionID, UserID, TrainingType, Score, SessionDate)
VALUES (7, 7, 'Puzzles', 99, SYSDATE - 7);


INSERT INTO GameReviews (ReviewID, GameID, ReviewerID, Rating, Review, ReviewDate)
VALUES (1, 1, 1, 5, 'Excellent game!', SYSDATE - 1);
INSERT INTO GameReviews (ReviewID, GameID, ReviewerID, Rating, Review, ReviewDate)
VALUES (2, 2, 2, 4, 'Good match.', SYSDATE - 2);
INSERT INTO GameReviews (ReviewID, GameID, ReviewerID, Rating, Review, ReviewDate)
VALUES (3, 3, 3, 3, 'Could be better.', SYSDATE - 3);
INSERT INTO GameReviews (ReviewID, GameID, ReviewerID, Rating, Review, ReviewDate)
VALUES (4, 4, 4, 5, 'Loved the tactics!', SYSDATE - 4);
INSERT INTO GameReviews (ReviewID, GameID, ReviewerID, Rating, Review, ReviewDate)
VALUES (5, 5, 5, 4, 'Interesting endgame.', SYSDATE - 5);
INSERT INTO GameReviews (ReviewID, GameID, ReviewerID, Rating, Review, ReviewDate)
VALUES (6, 6, 6, 5, 'Fast-paced and fun!', SYSDATE - 6);
INSERT INTO GameReviews (ReviewID, GameID, ReviewerID, Rating, Review, ReviewDate)
VALUES (7, 7, 7, 4, 'Great opponent.', SYSDATE - 7);

