create extension pgcrypto;

create or replace function RegisterUser(NameArg varchar(200),
								  PassArg text)
	returns boolean
as
$$
declare
	AffectedRows integer;
begin
	insert into Users (Username, AuthToken, ELO)
	values (NameArg, crypt(PassArg, gen_salt('bf')), 1000);
	get diagnostics AffectedRows = row_count;
	return AffectedRows > 0;
end;
$$ language plpgsql;

create or replace function ChangeNickname(IdArg integer,
										 NewNick varchar(200))
	returns boolean
as
$$
declare
	AffectedRows integer;
begin
	update Users set Username = NewNick
	where UserId = IdArg;
	get diagnostics AffectedRows = row_count;
	return AffectedRows > 0;
end;
$$ language plpgsql;

create or replace function GameStarted(PlayedMapArg MapEnum,
									  MatchIdArg integer)
	returns integer
as
$$
declare
	NewId integer;
begin
	insert into Games (PlayedMap, StartTime, EndTime, WonRoundsTeam1, WonRoundsTeam2, MatchId) values
	(PlayedMapArg, now(), null, 0, 0, MatchIdArg)
	returning GameId into NewId;
	return NewId;
end;
$$ language plpgsql;

create or replace function GameFinished(GameIdArg integer,
										Team1RoundsWon integer,
										Team2RoundsWon integer,
										PlayerIds integer[],
									    PlayerKills integer[],
									    PlayerAssists integer[],
									    PlayerDeaths integer[])
	returns integer
as
$$
declare
	AffectedRows integer;
	PlayersCount integer := array_length(PlayerIds, 1);
begin
	update Games set EndTime = now(), WonRoundsTeam1 = Team1RoundsWon, WonRoundsTeam2 = Team2RoundsWon
	where GameId = GameIdArg;
	for i in 1..PlayersCount loop
		insert into UserStat (UserId, GameId, Kills, Assists, Deaths) values
		(PlayerIds[i], GameIdArg, PlayerKills[i], PlayerAssists[i], PlayerDeaths[i]);
	end loop;
	get diagnostics AffectedRows = row_count;
	return AffectedRows; 
end;
$$ language plpgsql;

-- Ограничения по рейтингу для игры в хабе
create or replace function CheckPlayerELO()
	returns trigger
as
$$
declare PlayerELO integer;
declare LeftBound integer;
declare RightBound integer;
begin
	select ELO
	from Users
	where UserId = new.UserId
	into PlayerELO;
	select ELOLeftBound, ELORightBound
	from Hubs
	where HubId = new.HubId
	into LeftBound, RightBound;
	if LeftBound <= PlayerELO and PlayerELO <= RightBound
	then
		return new;
	else
		raise exception 'ELO of user is not in bounds of hub bounds';
	end if;
end;
$$ language plpgsql;

create trigger UserCanPlayInHub
	before insert on HubPlayers
	for each row
	execute procedure CheckPlayerELO();


-- Матч может быть либо в рамках хаба, либо в рамках турнира, 
-- либо в рамках ни того и ни другого, но не в обоих сразу
create or replace function IsMatchNotInHub()
	returns trigger
as
$$
begin
	if not exists (select MatchId from HubMatches where MatchId = new.MatchId)
	then
		return new;
	else
		raise exception 'Match is not in hub';
	end if;
end;
$$ language plpgsql;

create or replace function IsMatchNotInTournament()
	returns trigger
as
$$
begin
	if not exists (select MatchId from TournamentMatches where MatchId = new.MatchId)
	then
		return new;
	else
		raise exception 'Match is not in tournament';
	end if;
end;
$$ language plpgsql;

create trigger CheckHubMatchAdd
	before insert on HubMatches
	for each row
	execute procedure IsMatchNotInTournament();

create trigger CheckTournamentMatchAdd
	before insert on TournamentMatches
	for each row
	execute procedure IsMatchNotInHub();

-- Пользователь должен был играть в этом матче, чтобы иметь статистику по нему
create or replace function UserPlayedInTeamCheck()
	returns trigger
as
$$
begin
	if new.UserId in (select UserId from Games
				natural join Matches
				inner join Teams on Teams.TeamId = Matches.PickingSideTeamId or Teams.TeamId = Matches.OtherTeam
				natural join TeamsUsers
				where GameId = new.GameId)
	then
		return new;
	else
		raise exception 'User did not play in this game';
	end if;
end;
$$ language plpgsql;

create trigger UserPlayedInTeam
	before insert on UserStat
	for each row
	execute procedure UserPlayedInTeamCheck();

-- Если матч прошел в рамках хаба, то все его участники должны быть в таблице HubPlayers
create or replace function AllPlayersOfMatchInHubCheck()
	returns trigger
as
$$
begin
	if not exists (select HubPlayers.UserId from HubPlayers
		left join (select UserId from Matches
	 		inner join Teams t1 on t1.TeamId = Matches.PickingSideTeamId
			natural join TeamsUsers
			where MatchId = new.MatchId
			union
			select UserId from Matches
			inner join Teams t1 on t1.TeamId = Matches.OtherTeam
			natural join TeamsUsers
			where MatchId = new.MatchId) MatchPlayers on HubPlayers.UserId = MatchPlayers.UserId 
		where HubId = new.HubId and HubPlayers.UserId is null)
	then
		return new;
	else
		raise exception 'Not all players of match in hub';
	end if;
end;
$$ language plpgsql;

create trigger AllPlayersOfMatchInHubCheck
	before insert on HubMatches
	for each row
	execute procedure AllPlayersOfMatchInHubCheck();