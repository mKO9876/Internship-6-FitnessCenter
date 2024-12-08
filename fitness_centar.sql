CREATE TABLE Countries(
	CountryId INT NOT NULL PRIMARY KEY,
	CountryName VARCHAR(100) NOT NULL,
	Population INT NOT NULL,
	AvgSalary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE FitnessCenters(
	FitnessId INT NOT NULL PRIMARY KEY,
	FitnessName VARCHAR(50) NOT NULL
);

CREATE TABLE DaysOfWeek(
	DayId INT PRIMARY KEY,
	DayName VARCHAR(20) NOT NULL
);

CREATE TABLE FitnessWorkingTime(
	DayId INT REFERENCES DaysOfWeek(DayId),
	FitnessId INT REFERENCES FitnessCenters(FitnessId),
	PRIMARY KEY (FitnessId, DayId),
	StartTime TIME NOT NULL,
	EndTime TIME NOT NULL
);

CREATE TABLE Workouts(
	WorkoutId INT NOT NULL PRIMARY KEY,
	WorkoutName VARCHAR(100) NOT NULL,
	WorkoutType Tip ENUM('Trening snage', 'Kardio', 'Yoga', 'Ples', 'Injury rehabilitation'),
);

CREATE TABLE TrainerType(
	TrainerTypeId INT NOT NULL PRIMARY KEY,
	TrainerType VARCHAR(20)
);

CREATE TABLE Trainers(
	TrainerId INT NOT NULL PRIMARY KEY,
	TrainerName VARCHAR(50) NOT NULL,
	TrainerLastName VARCHAR(50) NOT NULL,
	TrainerBDay TIMESTAMP,
	TrainerSex ENUM('M', 'Ž') NOT NULL,
	CountryId INT REFERENCES Countries(CountryId)
);

CREATE TABLE TrainerWorkout(
	TrainerId INT REFERENCES Trainers(TrainerId),
	WorkoutId INT REFERENCES Workouts(WorkoutId),
	TrainerTypeId REFERENCES TrainerType(TrainerTypeId),
	PRIMARY KEY (TrainerId, WorkoutId)
);

CREATE TABLE Schedule(
    Schedule INT PRIMARY KEY,
    WorkoutId INT REFERENCES Workouts(WorkoutId),
    Time DATETIME NOT NULL
);

CREATE TABLE Users(
	UserId INT NOT NULL PRIMARY KEY,
	UserName VARCHAR(50) NOT NULL,
	UserLastName VARCHAR(50) NOT NULL
);