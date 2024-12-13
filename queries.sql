--1 -> Ime, prezime, spol (ispisati ‘MUŠKI’, ‘ŽENSKI’, ‘NEPOZNATO’, ‘OSTALO’), 
--ime države i prosječna plaća u toj državi za svakog trenera.
SELECT t.TrainerName AS IME, 
t.TrainerLastName AS PREZIME, 
CASE 
	 WHEN t.TrainerSex LIKE 'M%' THEN 'MUŠKO'
     WHEN t.TrainerSex LIKE 'Ž%' THEN 'ŽENSKO'
     WHEN t.TrainerSex IS NULL THEN 'NEPOZNATO'
	 ELSE 'OSTALO'
	END as SPOL, 
c.CountryName AS IME_DRZAVE, 
c.AvgSalary AS PROSJEK_PLACA
FROM Trainers t
JOIN Countries c ON c.CountryId = t.CountryId;


--2 -> Naziv i termin održavanja svake sportske igre zajedno s 
--imenima glavnih trenera (u formatu Prezime, I.; npr. Horvat, M.; Petrović, T.).
SELECT w.WorkoutName,
T.TrainerLastName || ' ' || SUBSTRING(T.TrainerName, 1, 1) || '.' AS Trainer,
tw.Time
FROM Workouts w
JOIN TrainerWorkout tw ON tw.WorkoutId = w.WorkoutId
JOIN Trainers t ON tw.TrainerId = t.TrainerId;


--3 -> Top 3 fitness centra s najvećim brojem aktivnosti u rasporedu
SELECT f.FitnessName,
COUNT(w.WorkoutId) AS ActivityCount
FROM FitnessCenters f
JOIN Trainers t ON t.FitnessId = f.FitnessId
JOIN TrainerWorkout tw ON tw.TrainerId = t.TrainerId
JOIN Workouts w ON w.WorkoutId = tw.WorkoutId
GROUP BY f.FitnessId
ORDER BY ActivityCount DESC
LIMIT 3;


--4 -> Po svakom terneru koliko trenutno aktivnosti vodi; 
--ako nema aktivnosti, ispiši “DOSTUPAN”, ako ima do 3 ispiši “AKTIVAN”, a ako je na više ispiši “POTPUNO ZAUZET”.
SELECT t.TrainerName, t.TrainerLastName, COUNT(tw.TrainerId),
CASE
	WHEN COUNT(tw.TrainerId) = 0 THEN 'DOSTUPAN'
    WHEN COUNT(tw.TrainerId) <= 3 THEN 'AKTIVAN'
    ELSE 'POTPUNO ZAUZET'
    END AS Status
FROM Trainers t
JOIN TrainerWorkout tw ON tw.TrainerId = t.TrainerId
GROUP BY t.TrainerName, t.TrainerLastName;


--5 -> Imena svih članova koji trenutno sudjeluju na nekoj aktivnosti.
SELECT u.UserName, u.UserLastName
FROM Users u
JOIN UserActivity ua ON ua.UserId = u.UserId
JOIN TrainerWorkout tw ON tw.WorkoutId = ua.WorkoutId AND tw.TrainerId = ua.TrainerId
WHERE DATE(tw.Time) = CURRENT_DATE;


--6 -> Sve trenere koji su vodili barem jednu aktivnost između 2019. i 2022.
SELECT t.TrainerName, t.TrainerLastName FROM Trainers t
JOIN TrainerWorkout tw ON tw.TrainerId = t.TrainerId
WHERE EXTRACT(YEAR FROM tw.Time) BETWEEN 2019 AND 2022;


--7 -> Prosječan broj sudjelovanja po tipu aktivnosti po svakoj državi.
SELECT c.CountryName, w.WorkoutType, ROUND(AVG(ua.UserIdCount), 2) AS Avg_Sudjelovanje
FROM Countries c
JOIN Trainers t ON t.CountryId = c.CountryId
JOIN TrainerWorkout tw ON tw.TrainerId = t.TrainerId
JOIN Workouts w ON w.WorkoutId = tw.WorkoutId
LEFT JOIN ( 
	SELECT WorkoutId, COUNT(UserId) AS UserIdCount
    FROM UserActivity
    GROUP BY WorkoutId) ua ON ua.WorkoutId = tw.WorkoutId
GROUP BY c.CountryName, w.WorkoutType;


--8 -> Top 10 država s najvećim brojem sudjelovanja u injury rehabilitation tipu aktivnosti
SELECT c.CountryName, COUNT(ua.UserId) AS TotalParticipants
FROM Countries c
JOIN Trainers t ON t.CountryId = c.CountryId
JOIN TrainerWorkout tw ON tw.TrainerId = t.TrainerId
JOIN Workouts w ON tw.WorkoutId = w.WorkoutId
JOIN UserActivity ua ON ua.WorkoutId = tw.WorkoutId
WHERE w.WorkoutType = 'Injury rehabilitation'
GROUP BY c.CountryName
ORDER BY TotalParticipants DESC
LIMIT 10;


--9 -> Ako aktivnost nije popunjena, ispiši uz nju “IMA MJESTA”, a ako je popunjena ispiši “POPUNJENO”
SELECT w.WorkoutName,
CASE 
	WHEN COUNT(*) >= tw.Capacity THEN 'POPUNJENO'
	ELSE 'IMA MJESTA'
    END AS Status
FROM TrainerWorkout tw
JOIN UserActivity ua ON ua.WorkoutId = tw.WorkoutId AND ua.TrainerId = tw.TrainerId
JOIN Workouts w ON w.WorkoutId = tw.WorkoutId
GROUP BY tw.TrainerId, tw.WorkoutId, w.WorkoutName;


--10 -> 10 najplaćenijih trenera, ako po svakoj aktivnosti dobije prihod kao brojSudionika * cijenaPoTerminu
SELECT t.TrainerName, t.TrainerLastName, SUM(ua.Participants * tw.Price) AS TotalEarnings
FROM Trainers t
JOIN TrainerWorkout tw ON tw.TrainerId = t.TrainerId
JOIN (
    SELECT WorkoutId, TrainerId, COUNT(UserId) AS Participants
    FROM UserActivity
    GROUP BY WorkoutId, TrainerId
) ua ON ua.WorkoutId = tw.WorkoutId AND ua.TrainerId = tw.TrainerId
GROUP BY t.TrainerId, t.TrainerName, t.TrainerLastName
ORDER BY TotalEarnings DESC
LIMIT 10;


