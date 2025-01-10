DROP TABLE Users;
DROP TABLE Games;
DROP TABLE GameMoves;
DROP TABLE Tournaments;
DROP TABLE TournamentParticipants;
DROP TABLE Messages;
DROP TABLE Friendships;
DROP TABLE Rankings;


CREATE TABLE Users
(
    UserID           NUMBER PRIMARY KEY,
    Username         VARCHAR2(50)  NOT NULL UNIQUE,
    Password         VARCHAR2(50)  NOT NULL,
    Email            VARCHAR2(100) NOT NULL UNIQUE,
    RegistrationDate DATE DEFAULT SYSDATE,
    EloRating        NUMBER CHECK (EloRating >= 0)
);

CREATE TABLE Games
(
    GameID    NUMBER PRIMARY KEY,
    Player1ID NUMBER NOT NULL,
    Player2ID NUMBER NOT NULL,
    WinnerID  NUMBER,
    StartTime DATE         DEFAULT SYSDATE,
    EndTime   DATE,
    Type      varchar2(30) DEFAULT 'Blitz',
    CONSTRAINT chk_EndTime CHECK (EndTime > StartTime),
    CONSTRAINT fk_Player1 FOREIGN KEY (Player1ID) REFERENCES Users (UserID),
    CONSTRAINT fk_Player2 FOREIGN KEY (Player2ID) REFERENCES Users (UserID),
    CONSTRAINT fk_Winner FOREIGN KEY (WinnerID) REFERENCES Users (UserID),
    CONSTRAINT chk_Type CHECK (Type in ('Blitz', 'Bullet', 'Rapid', 'Daily'))
);

CREATE TABLE GameMoves
(
    MoveID     NUMBER PRIMARY KEY,
    GameID     NUMBER       NOT NULL,
    MoveNumber NUMBER       NOT NULL,
    PlayerID   NUMBER       NOT NULL,
    Move       VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_Game FOREIGN KEY (GameID) REFERENCES Games (GameID),
    CONSTRAINT fk_Player FOREIGN KEY (PlayerID) REFERENCES Users (UserID)
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
    CONSTRAINT chk_Type CHECK (Type in ('Blitz', 'Bullet', 'Rapid', 'Daily'))
);

CREATE TABLE TournamentParticipants
(
    ParticipantID NUMBER PRIMARY KEY,
    TournamentID  NUMBER NOT NULL,
    UserID        NUMBER NOT NULL,
    Score         NUMBER DEFAULT 0,
    JoinDate      DATE   DEFAULT SYSDATE,
    CONSTRAINT chk_Score CHECK (Score >= 0),
    CONSTRAINT fk_Tournament FOREIGN KEY (TournamentID) REFERENCES Tournaments (TournamentID),
    CONSTRAINT fk_User FOREIGN KEY (UserID) REFERENCES Users (UserID)
);

CREATE TABLE Messages
(
    MessageID      NUMBER PRIMARY KEY,
    SenderID       NUMBER        NOT NULL,
    ReceiverID     NUMBER        NOT NULL,
    MessageContent VARCHAR2(200) NOT NULL,
    SentDate       DATE DEFAULT SYSDATE,
    CONSTRAINT fk_Sender FOREIGN KEY (SenderID) REFERENCES Users (UserID),
    CONSTRAINT fk_Receiver FOREIGN KEY (ReceiverID) REFERENCES Users (UserID)
);

CREATE TABLE Friendships
(
    FriendshipID   NUMBER PRIMARY KEY,
    UserID1        NUMBER NOT NULL,
    UserID2        NUMBER NOT NULL,
    FriendshipDate DATE         DEFAULT SYSDATE,
    Status         VARCHAR2(10) DEFAULT 'Pending' CHECK (Status in ('Pending', 'Accepted', 'Blocked')),
    CONSTRAINT fk_FriendUser1 FOREIGN KEY (UserID1) REFERENCES Users (UserID),
    CONSTRAINT fk_FriendUser2 FOREIGN KEY (UserID2) REFERENCES Users (UserID),
    CONSTRAINT chk_Friendship CHECK (UserID1 <> UserID2)
);


CREATE TABLE Rankings
(
    RankingID   NUMBER PRIMARY KEY,
    RankingName varchar2(30),
    UserID      NUMBER NOT NULL,
    Rank        NUMBER NOT NULL,
    EloRating   NUMBER CHECK (EloRating >= 0),
    LastUpdated DATE DEFAULT SYSDATE,
    CONSTRAINT chk_Rank CHECK (Rank > 0),
    CONSTRAINT fk_RankUser FOREIGN KEY (UserID) REFERENCES Users (UserID)
);


INSERT INTO Users (UserID, Username, Password, Email, RegistrationDate, EloRating)
VALUES (1, 'Alice', 'pass123', 'alice@example.com', DATE '2023-01-01', 1500);
INSERT INTO Users (UserID, Username, Password, Email, RegistrationDate, EloRating)
VALUES (2, 'Bob', 'secret456', 'bob@example.com', DATE '2023-02-15', 1450);
INSERT INTO Users (UserID, Username, Password, Email, RegistrationDate, EloRating)
VALUES (3, 'Charlie', 'qwerty789', 'charlie@example.com', DATE '2023-03-20', 1600);
INSERT INTO Users (UserID, Username, Password, Email, RegistrationDate, EloRating)
VALUES (4, 'Diana', 'pass987', 'diana@example.com', DATE '2023-04-10', 1700);
INSERT INTO Users (UserID, Username, Password, Email, RegistrationDate, EloRating)
VALUES (5, 'Eve', 'pass654', 'eve@example.com', DATE '2023-05-15', 1400);
INSERT INTO Users (UserID, Username, Password, Email, RegistrationDate, EloRating)
VALUES (6, 'Frank', 'pass321', 'frank@example.com', DATE '2023-06-20', 1550);
INSERT INTO Users (UserID, Username, Password, Email, RegistrationDate, EloRating)
VALUES (7, 'Grace', 'pass1234', 'grace@example.com', DATE '2023-07-25', 1300);


INSERT INTO Games (GameID, Player1ID, Player2ID, WinnerID, StartTime, EndTime, Type)
VALUES (1, 1, 2, 1, TO_DATE('2024-01-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_DATE('2024-01-10 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Blitz');
INSERT INTO Games (GameID, Player1ID, Player2ID, WinnerID, StartTime, EndTime, Type)
VALUES (2, 2, 3, 3, TO_DATE('2024-01-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_DATE('2024-01-11 15:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Blitz');
INSERT INTO Games (GameID, Player1ID, Player2ID, WinnerID, StartTime, EndTime, Type)
VALUES (3, 4, 5, 4, TO_DATE('2024-01-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_DATE('2024-01-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Blitz');
INSERT INTO Games (GameID, Player1ID, Player2ID, WinnerID, StartTime, EndTime, Type)
VALUES (4, 6, 7, 6, TO_DATE('2024-01-13 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_DATE('2024-01-13 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Daily');
INSERT INTO Games (GameID, Player1ID, Player2ID, WinnerID, StartTime, EndTime, Type)
VALUES (5, 1, 3, 1, TO_DATE('2024-01-14 11:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_DATE('2024-01-14 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Rapid');
INSERT INTO Games (GameID, Player1ID, Player2ID, WinnerID, StartTime, EndTime, Type)
VALUES (6, 2, 4, 4, TO_DATE('2024-01-15 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_DATE('2024-01-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Blitz');
INSERT INTO Games (GameID, Player1ID, Player2ID, WinnerID, StartTime, EndTime, Type)
VALUES (7, 5, 7, 5, TO_DATE('2024-01-16 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_DATE('2024-01-16 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Bullet');


INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (1, 1, 1, 1, 'e2-e4');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (2, 1, 2, 2, 'e4-e5');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (3, 2, 1, 2, 'd2-d4');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (4, 2, 2, 3, 'd4-d5');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (5, 3, 1, 4, 'Ng1-Nf3');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (6, 3, 2, 5, 'Nd4-Nc6');
INSERT INTO GameMoves (MoveID, GameID, MoveNumber, PlayerID, Move)
VALUES (7, 4, 1, 6, 'g2-g3');


INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (1, 'Winter Open', DATE '2024-02-01', DATE '2024-02-10', 'New York', 'Blitz', 500000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (2, 'Spring Invitational', DATE '2024-03-15', DATE '2024-03-20', 'Los Angeles', 'Blitz', 300000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (3, 'Summer Cup', DATE '2024-06-01', DATE '2024-06-10', 'Chicago', 'Blitz', 1000000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (4, 'Autumn Challenge', DATE '2024-09-01', DATE '2024-09-10', 'Houston', 'Bullet', 100000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (5, 'Holiday Blitz', DATE '2024-12-20', DATE '2024-12-25', 'Miami', 'Rapid', 200000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (6, 'Weekend Battle', DATE '2024-04-05', DATE '2024-04-07', 'Seattle', 'Blitz', 150000);
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location, Type, PrizePull)
VALUES (7, 'New Year Masters', DATE '2024-01-02', DATE '2024-01-05', 'San Francisco', 'Blitz', 10000000);

INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (1, 1, 1, 2.5, DATE '2024-01-01');
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (2, 1, 2, 3.0, DATE '2024-01-02');
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (3, 2, 3, 1.5, DATE '2024-01-03');
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (4, 3, 4, 4.0, DATE '2024-01-04');
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (5, 4, 5, 2.0, DATE '2024-01-05');
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (6, 5, 6, 5.0, DATE '2024-01-06');
INSERT INTO TournamentParticipants (ParticipantID, TournamentID, UserID, Score, JoinDate)
VALUES (7, 6, 7, 3.5, DATE '2024-01-07');


INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (1, 1, 2, 'Good game!', TO_DATE('2024-01-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (2, 2, 3, 'Well played!', TO_DATE('2024-01-11 15:50:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (3, 3, 1, 'See you at the next tournament!', TO_DATE('2024-01-12 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (4, 4, 5, 'Great match!', TO_DATE('2024-01-13 10:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (5, 6, 7, 'Lets play again soon.', TO_DATE('2024-01-14 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (6, 7, 1, 'Are you free for a rematch?', TO_DATE('2024-01-15 14:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Messages (MessageID, SenderID, ReceiverID, MessageContent, SentDate)
VALUES (7, 5, 6, 'Congratulations on your win!', TO_DATE('2024-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (1, 1, 2, DATE '2024-01-01', 'Accepted');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (2, 3, 4, DATE '2024-01-02', 'Pending');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (3, 2, 3, DATE '2024-01-10', 'Accepted');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (4, 3, 4, DATE '2024-01-12', 'Pending');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (5, 3, 6, DATE '2022-01-01', 'Accepted');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (6, 1, 5, DATE '2023-01-02', 'Pending');
INSERT INTO Friendships (FriendshipID, UserID1, UserID2, FriendshipDate, Status)
VALUES (7, 1, 7, DATE '2023-11-20', 'Blocked');


INSERT INTO Rankings (RankingID, RankingName, UserID, Rank, EloRating, LastUpdated)
VALUES (1, 'Blitz', 1, 1, 1700, TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO Rankings (RankingID, RankingName, UserID, Rank, EloRating, LastUpdated)
VALUES (1, 'Blitz', 4, 2, 1600, TO_DATE('2024-01-11', 'YYYY-MM-DD'));
INSERT INTO Rankings (RankingID, RankingName, UserID, Rank, EloRating, LastUpdated)
VALUES (1, 'Blitz', 3, 3, 1500, TO_DATE('2024-01-12', 'YYYY-MM-DD'));
INSERT INTO Rankings (RankingID, RankingName, UserID, Rank, EloRating, LastUpdated)
VALUES (2, 'Bullet', 6, 1, 1450, TO_DATE('2024-01-13', 'YYYY-MM-DD'));
INSERT INTO Rankings (RankingID, RankingName, UserID, Rank, EloRating, LastUpdated)
VALUES (2, 'Bullet', 2, 2, 1400, TO_DATE('2024-01-14', 'YYYY-MM-DD'));
INSERT INTO Rankings (RankingID, RankingName, UserID, Rank, EloRating, LastUpdated)
VALUES (2, 'Bullet', 5, 3, 1350, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Rankings (RankingID, RankingName, UserID, Rank, EloRating, LastUpdated)
VALUES (2, 'Bullet', 7, 4, 1300, TO_DATE('2024-01-16', 'YYYY-MM-DD'));