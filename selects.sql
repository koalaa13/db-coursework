create view FinishedGames as
	select * from Games
	where EndTime is not null;

create or replace function GetAllTeamsPrizes()
	returns table (
		TeamName varchar(200),
		TotalPrizes bigint
	)
as
$$
begin
	return query
	select distinct Teams.TeamName as TeamName, q1.TotalPrize as TotalPrizes from Teams
	natural join (
		select TeamId, sum(Prize) as TotalPrize from Teams
		natural join TeamTournaments
		natural join TournamentPrizes
	group by TeamId) q1;
end;
$$ language plpgsql;

create or replace function AvgGameDuration()
	returns double precision
as
$$
declare
	answer double precision;
begin
	select avg(extract(epoch from (EndTime - StartTime)))
	from FinishedGames
	into answer;
	return answer;
end;
$$ language plpgsql;

create or replace function AllPlayersOfTeam(TeamIdArg integer)
	returns table (Username varchar(200))
as
$$
begin
	return query
	select Users.Username from Teams
	natural join TeamsUsers
	natural join Users
	where TeamId = TeamIdArg;
end;
$$ language plpgsql;

create or replace function AllPlayersKD()
	returns table (UserId integer,
				  KD double precision)
as
$$
begin
	return query
	select UserStat.UserId, (cast(sum(Kills) as double precision) / (cast(sum(Deaths) as double precision) + 1.0)) as KD
	from UserStat
	natural join FinishedGames
	group by UserStat.UserId;
end;
$$ language plpgsql;

create or replace function AllPlayersKDLastNMatches(LastMatchesCount integer)
	returns table (UserId integer,
				  KD double precision)
as
$$
begin
	return query
	select q3.UserId, (cast(sum(q3.Kills) as double precision) / (cast(sum(q3.Deaths) as double precision) + 1.0)) as KD
	from (select q2.UserId, q2.Kills, q2.Deaths from 
			(select row_number() over (partition by q1.UserId order by q1.StartTime) as r, q1.*
			from (select * from UserStat
			natural join FinishedGames) q1
		) q2
		where q2.r <= LastMatchesCount
	) q3
	group by q3.UserId;
end;
$$ language plpgsql;

create or replace function AllPlayersKDInCertainPeriod(PeriodStart timestamp, 
													   PeriodEnd timestamp)
	returns table (UserId integer,
				  KD double precision)
as
$$
begin
	return query
	select q3.UserId, (cast(sum(q3.Kills) as double precision) / (cast(sum(q3.Deaths) as double precision) + 1.0)) as KD
	from (
		select us.UserId, us.Kills, us.Deaths 
		from UserStat us
		natural join FinishedGames
		where PeriodStart <= FinishedGames.StartTime and FinishedGames.StartTime <= PeriodEnd
	) q3
	group by q3.UserId;
end;
$$ language plpgsql;

create or replace function AllPlayersKDOnCertainMap(PlayedMapArg MapEnum)
	returns table (UserId integer,
				  KD double precision)
as
$$
begin
	return query
	select q3.UserId, (cast(sum(q3.Kills) as double precision) / (cast(sum(q3.Deaths) as double precision) + 1.0)) as KD
	from (
		select us.UserId, us.Kills, us.Deaths 
		from UserStat us
		natural join FinishedGames
		where FinishedGames.PlayedMap = PlayedMapArg
	) q3
	group by q3.UserId;
end;
$$ language plpgsql;

create or replace function PlayerWinrate(PlayerId integer)
	returns double precision
as
$$
declare
	Wins double precision;
	TotalGames integer;
begin
	select count(GameId) from UserStat
	where UserId = PlayerId
	into TotalGames;
	if TotalGames = 0
	then
		return 0.0;
	end if;
	select count(GameId) from (
		select GameId from Users
		natural join TeamsUsers
		natural join Teams
		inner join Matches on Teams.TeamId = Matches.PickingSideTeamId
		natural join FinishedGames
		where FinishedGames.WonRoundsTeam1 > FinishedGames.WonRoundsTeam2 and UserId = PlayerId
		union
		select GameId from Users
		natural join TeamsUsers
		natural join Teams
		inner join Matches on Teams.TeamId = Matches.OtherTeam
		natural join FinishedGames
		where FinishedGames.WonRoundsTeam1 < FinishedGames.WonRoundsTeam2 and UserId = PlayerId) q1
	into Wins;
	return cast(Wins as double precision) / TotalGames * 100.0;
end;
$$ language plpgsql;

create or replace function PlayerLastResults(PlayerId integer)
	returns table (GameId integer,
				  Res char(1))
as
$$
begin
	return query
	select q1.GameId, q1.Res 
	from (
		(select FinishedGames.GameId, StartTime, cast('W' as char) as Res from Users
		natural join TeamsUsers
		natural join Teams
		inner join Matches on Teams.TeamId = Matches.PickingSideTeamId
		natural join FinishedGames
		where FinishedGames.WonRoundsTeam1 > FinishedGames.WonRoundsTeam2 and UserId = PlayerId
		union
		select FinishedGames.GameId, StartTime, cast('W' as char) as Res from Users
		natural join TeamsUsers
		natural join Teams
		inner join Matches on Teams.TeamId = Matches.OtherTeam
		natural join FinishedGames
		where FinishedGames.WonRoundsTeam1 < FinishedGames.WonRoundsTeam2 and UserId = PlayerId)		
	union
		(select FinishedGames.GameId, StartTime, cast('L' as char) as Res from Users
		natural join TeamsUsers
		natural join Teams
		inner join Matches on Teams.TeamId = Matches.PickingSideTeamId
		natural join FinishedGames
		where FinishedGames.WonRoundsTeam1 < FinishedGames.WonRoundsTeam2 and UserId = PlayerId
		union
		select FinishedGames.GameId, StartTime, cast('L' as char) as Res from Users
		natural join TeamsUsers
		natural join Teams
		inner join Matches on Teams.TeamId = Matches.OtherTeam
		natural join FinishedGames
		where FinishedGames.WonRoundsTeam1 > FinishedGames.WonRoundsTeam2 and UserId = PlayerId)) q1
	order by StartTime;
end;
$$ language plpgsql;








