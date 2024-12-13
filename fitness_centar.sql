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
	DayName VARCHAR(4) NOT NULL
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
	WorkoutType VARCHAR(50) NOT NULL
);

CREATE TABLE TrainerType(
	TrainerTypeId INT NOT NULL PRIMARY KEY,
	TrainerType VARCHAR(20)
);

CREATE TABLE Trainers(
	TrainerId INT NOT NULL PRIMARY KEY,
	FitnessId INT REFERENCES FitnessCenters(FitnessId),
	TrainerName VARCHAR(50) NOT NULL,
	TrainerLastName VARCHAR(50) NOT NULL,
	TrainerBDay TIMESTAMP,
	TrainerSex VARCHAR(30),
	CountryId INT REFERENCES Countries(CountryId)
);

CREATE TABLE TrainerWorkout(
	TrainerId INT REFERENCES Trainers(TrainerId),
	WorkoutId INT REFERENCES Workouts(WorkoutId),
	TrainerTypeId INT REFERENCES TrainerType(TrainerTypeId),
	Time TIMESTAMP NOT NULL,
	Capacity INT NOT NULL,
	Price DECIMAL(2, 2) NOT NULL,
	PRIMARY KEY (TrainerId, WorkoutId)
);

CREATE TABLE Users(
	UserId INT NOT NULL PRIMARY KEY,
	UserName VARCHAR(50) NOT NULL,
	UserLastName VARCHAR(50) NOT NULL
);

CREATE TABLE UserActivity(
    UserId INT REFERENCES Users(UserId),
   	TrainerId INT,
    WorkoutId INT,
    FOREIGN KEY (TrainerId, WorkoutId) REFERENCES TrainerWorkout (TrainerId, WorkoutId),
	PRIMARY KEY (UserId, TrainerId, WorkoutId)
);