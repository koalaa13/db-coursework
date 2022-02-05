insert into Users (Username, AuthToken, ELO) values
('s1mple', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4329),
('BoomIb4', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 2510),
('electronic', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3912),
('Perfecto', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3102),
('B1t', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4021);

insert into Users (Username, AuthToken, ELO) values
('Sh1ro', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4329),
('Hobbit', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 2510),
('interz', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3912),
('Ax1Le', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3102),
('nafany', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4021);

insert into Users (Username, AuthToken, ELO) values
('jACKZ', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4329),
('Niko', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 2510),
('huNter-', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3912),
('AMANEK', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3102),
('nexa', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4021);

insert into Users (Username, AuthToken, ELO) values
('apEX', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4329),
('dupreeh', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 2510),
('Magisk', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3912),
('ZywOo', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 3102),
('misutaaa', '$2a$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 4021);

insert into users (Username, AuthToken, ELO) values
('koalaa13', '$06$BESY9y/Srb7Xu87aXhVVle332CedPMqqsEnYkKLKazpUSedC5LjPO', 1500);

insert into Teams (TeamName, CaptainId) values
('Natus Vincere', 2),
('Gambit', 8),
('G2', 15),
('Vitality', 16);

insert into TeamsUsers (TeamId, UserId) values
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 11),
(3, 12),
(3, 13),
(3, 14),
(3, 15),
(4, 16),
(4, 17),
(4, 18),
(4, 19),
(4, 20);

insert into Hubs (ELOLeftBound, ELORightBound, CreatorId) values
(2000, 5000, 1),
(0, 2000, 21);

insert into HubPlayers (UserId, HubId) values
(1, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1);

insert into Tournaments (TournamentName, TournamentYear, TournamentType) values
('PGL Major Stockholm', 2021, 'round robin'),
('PGL Major Stockholm', 2020, 'round robin'),
('IEM Katowice', 2019, 'single elimination');

insert into TournamentPrizes (TournamentId, Place, Prize) values
(1, 1, 100),
(1, 2, 50);

insert into TournamentPrizes (TournamentId, Place, Prize) values
(3, 1, 1000),
(3, 2, 500);

insert into TeamTournaments (TeamId, TournamentId, Place) values
(1, 1, 1),
(2, 1, 2);

insert into TeamTournaments (TeamId, TournamentId, Place) values
(1, 3, 2),
(2, 3, 1);

insert into Matches(PickingSideTeamId, OtherTeam) values
(1, 2),
(2, 1);

insert into Games (PlayedMap, StartTime, EndTime, WonRoundsTeam1, WonRoundsTeam2, MatchId) values
('de_ancient', '2021-03-31 9:30:20', '2021-03-31 10:30:20', 16, 10,  1),
('de_cache', '2020-03-31 9:30:20', '2020-03-31 10:30:20', 25, 23,  2);

insert into UserStat (GameId, UserId, Kills, Assists, Deaths) values
(1, 1, 20, 20, 0),
(1, 2, 27, 7, 28),
(1, 3, 5, 13, 2),
(1, 4, 3, 11, 27),
(1, 5, 14, 8, 2),
(1, 6, 25, 14, 0),
(1, 7, 2, 17, 9),
(1, 8, 29, 3, 5),
(1, 9, 30, 20, 29),
(1, 10, 4, 21, 6);

insert into UserStat (GameId, UserId, Kills, Assists, Deaths) values
(2, 1, 20, 20, 0),
(2, 2, 27, 7, 28),
(2, 3, 5, 13, 2),
(2, 4, 3, 11, 27),
(2, 5, 14, 8, 2),
(2, 6, 25, 14, 0),
(2, 7, 2, 17, 9),
(2, 8, 29, 3, 5),
(2, 9, 30, 20, 29),
(2, 10, 4, 21, 6);

insert into TournamentMatches (TournamentId, MatchId) values
(1, 1),
(2, 2);

insert into Matches(PickingSideTeamId, OtherTeam) values
(1, 2);

insert into Games (PlayedMap, StartTime, EndTime, WonRoundsTeam1, WonRoundsTeam2, MatchId) values
('de_nuke', '2019-03-31 9:30:20', '2019-03-31 10:30:20', 16, 3, 3);

insert into UserStat (GameId, UserId, Kills, Assists, Deaths) values
(3, 1, 19, 24, 4),
(3, 2, 12, 15, 14),
(3, 3, 24, 25, 24),
(3, 4, 21, 19, 15),
(3, 5, 29, 17, 7),
(3, 6, 5, 19, 17),
(3, 7, 6, 14, 23),
(3, 8, 21, 21, 3),
(3, 9, 19, 15, 23),
(3, 10, 12, 11, 19);

insert into HubMatches (HubId, MatchId) values
(1, 3);
