CREATE DATABASE IF NOT EXISTS futebol;

USE futebol;

CREATE TABLE IF NOT EXISTS jogadores (

    jogador_nome   VARCHAR(16)     NOT NULL,
    jogador_idade  INT             NOT NULL,
    jogador_clube  VARCHAR(16)     NOT NULL,
    jogador_pais   VARCHAR(16)     NOT NULL

);

INSERT INTO jogadores VALUES ("Messi",34,"PSG","Argentina");
INSERT INTO jogadores VALUES ("Ronaldo",36,"MANU","Portugal");
INSERT INTO jogadores VALUES ("Neymar",29,"PSG","Brasil");
INSERT INTO jogadores VALUES ("Kane",28,"SPURS","Inglaterra");
INSERT INTO jogadores VALUES ("E Hazard",30,"MADRID","Belgica");