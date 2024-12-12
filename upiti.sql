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
JOIN Countries c ON c.Id = t.CountryId;


--2 -> Naziv i termin održavanja svake sportske igre zajedno s 
--imenima glavnih trenera (u formatu Prezime, I.; npr. Horvat, M.; Petrović, T.).
SELECT w.WorkoutName,
T.TrainerLastName || ' ' || SUBSTRING(T.TrainerName, 1, 1) || '.' AS Trainer,
tw.Time
FROM Workouts w
JOIN TrainerWorkout tw ON tw.WorkoutId = w.Id
JOIN Trainers t ON tw.TrainerId = t.Id


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
SELECT t.TrainerName,
t.TrainerLastName,
COUNT(tw.TrainerId) AS Sum_Activity,
CASE
	WHEN COUNT(tw.TrainerId) = 0 THEN 'DOSTUPAN'
	WHEN COUNT(tw.TrainerId) <= 3 THEN 'AKTIVAN'
	ELSE 'POTPUNO ZAUZET'
	END AS Status
FROM Trainers t
JOIN TrainerWorkout tw ON tw.WorkoutId = T.Id


--5 -> Imena svih članova koji trenutno sudjeluju na nekoj aktivnosti.
SELECT u.UserName, u.UserLastName
FROM Users u
JOIN UerActivity ua ON ua.UserId = u.UserId
JOIN TrainerWorkout tw ON tw.WorkoutId = ua.WorkoutId AND tw.TrainerId = ua.TrainerId
WHERE DATE(tw.Time) = CURRENT_DATE;


--6 -> Sve trenere koji su vodili barem jednu aktivnost između 2019. i 2022.
SELECT * FROM Trainers t
--TABLICA RASPORED UMISTO DA STOJI U trainerworkout










