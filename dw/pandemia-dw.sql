create table dimPais(
    id int identity primary key,
    pais varchar(40)
)

create table dimIdade(
    id int identity primary key,
    idade int,
    faixaEtaria varchar(50),
    maiorIdade bit
)

create table dimSexo(
    id int identity primary key,
    sexo char(1)
)

create table dimNivelAutismo(
    id int identity primary key,
    nivel varchar(15)
)

create table dimNivelComunicacao(
    id int identity primary key,
    nivel varchar(30)
)

create table dimFuncoesCognitivas(
    id int identity primary key,
    nivel varchar(15)
)

create table dimStatusComunicacao(
    id int identity primary key,
    status varchar(15)
)

create table dimControleEmocional(
    id int identity primary key,
    status varchar(15)
)

create table dimInteracaoSocial(
    id int identity primary key,
    status varchar(15)
)

create table dimComportamentoEsteriotipado(
    id int identity primary key,
    status varchar(15)
)

create table dimComportamento(
    id int identity primary key,
    status varchar(15)
)

create table dimFlexibilidadeInteresses(
    id int identity primary key,
    status varchar(15)
)

create table dimAutonomia(
    id int identity primary key,
    status varchar(15)
)

create table dimFrequenciaTv(
    id int identity primary key,
    frequencia varchar(15)
)

create table dimFrequenciaVideoGames(
    id int identity primary key,
    frequencia varchar(15)
)

create table dimJogaComAmigos(
    id int identity primary key,
    frequencia varchar(15)
)

create table dimRedesSociais(
    id int identity primary key,
    frequencia varchar(15)
)

create table fatIndividuos(
    id int identity primary key,
    qtIndividuos int,
    idPais int,
    idIdade int,
    idSexo int,
    idNivelAutismo int,
    idNivelComunicacao int,
    idFuncoesCognitivas int,
    idStatusComunicacao int,
    idControleEmocional int,
    idInteracaoSocial int,
    idComportamentoEsteriotipado int,
    idComportamento int,
    idFlexibilidadeInteresses int,
    idAutonomia int,
    idFrequenciaTv int,
    idFrequenciaVideoGames int,
    idJogaComAmigos int,
    idRedesSociais int
)