CREATE USER IF NOT EXISTS 'utente'@'localhost' IDENTIFIED BY 'pass';
DROP DATABASE IF EXISTS fumetteria;
CREATE DATABASE fumetteria DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT DELETE, INSERT, SELECT, UPDATE ON fumetteria.* to 'utente'@'localhost';
USE fumetteria;

DROP TABLE IF EXISTS Utente;
CREATE TABLE Utente (
	Email VARCHAR(255) NOT NULL,
	Cognome VARCHAR(25) NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Via VARCHAR(40) NOT NULL,
	Civico VARCHAR(3) NOT NULL,
	CAP CHAR(5) NOT NULL,
	Citta VARCHAR(50) NOT NULL,
	Provincia CHAR(2) NOT NULL,
	Password VARCHAR(255) NOT NULL,
	Ruolo ENUM('admin','user') NOT NULL,
	PRIMARY KEY (Email)
);

DROP TABLE IF EXISTS Ordine;
CREATE TABLE Ordine (
	Numero INT AUTO_INCREMENT NOT NULL,
	DataEmissione DATE NOT NULL,
	DataConsegna DATE DEFAULT NULL,
	Totale FLOAT NOT NULL,
	Utente VARCHAR(255) NOT NULL,
	PRIMARY KEY(Numero),
	FOREIGN KEY(Utente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Articolo;
CREATE TABLE Articolo (
	Codice INT AUTO_INCREMENT NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	isFumetto BOOL NOT NULL,
	Prezzo DECIMAL(6,2) NOT NULL,
	Sconto INTEGER DEFAULT 0 NOT NULL,
	Categoria VARCHAR(30) NOT NULL,
	Giacenza INTEGER DEFAULT 0 NOT NULL,
	Descrizione VARCHAR(1000) NOT NULL,
	DataInserimento DATE NOT NULL,
	PRIMARY KEY(Codice)
);

DROP TABLE IF EXISTS Serie;
CREATE TABLE Serie (
	Nome VARCHAR(50) NOT NULL,
	Periodicita VARCHAR(20) NOT NULL,
	PRIMARY KEY(Nome)
);

DROP TABLE IF EXISTS Fumetto;
CREATE TABLE Fumetto (
	Articolo INT NOT NULL,
	Genere VARCHAR(50) NOT NULL,
	Interni ENUM('b/n','col.') NOT NULL,
	NumPagine INTEGER NOT NULL,
	Formato VARCHAR(10) NOT NULL,
	
	PRIMARY KEY(Articolo),
	FOREIGN KEY(Articolo) REFERENCES Articolo(Codice) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Appartiene;
CREATE TABLE Appartiene (
	Fumetto INT NOT NULL,
	Serie VARCHAR(50) NOT NULL,
	Numero INT NOT NULL,
	
	PRIMARY KEY(Fumetto),
	FOREIGN KEY(Fumetto) REFERENCES Fumetto(Articolo) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(Serie) REFERENCES Serie(Nome) ON DELETE CASCADE ON UPDATE CASCADE
);
DROP TABLE IF EXISTS Segue;
CREATE TABLE Segue (
	Utente  VARCHAR(255) NOT NULL,
	Serie VARCHAR(50) NOT NULL,
	
	PRIMARY KEY(Utente, Serie),
	FOREIGN KEY(Utente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(Serie) REFERENCES Serie(Nome) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS SiRiferisce;
CREATE TABLE SiRiferisce (
	Ordine INT NOT NULL,
	Articolo INT NOT NULL,
	Costo DECIMAL(6,2) NOT NULL,
	Quantita INT NOT NULL DEFAULT 1,
	
	PRIMARY KEY(Ordine, Articolo),
	FOREIGN KEY(Articolo) REFERENCES Articolo(Codice) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(Ordine) REFERENCES Ordine(Numero) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Utente VALUES('admin@email.it','','','',0,00000,'','SA',SHA1('rootpass'),1);

