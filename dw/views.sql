create view vwPais as select 
    id,
    pais
    from dimPais
go


create view vwIdade as select 
    id,
    idade,
    faixaEtaria,
    maiorIdade
    from dimIdade
go


create view vwSexo as select 
    id,
    sexo
    from dimSexo
go


create view vwNivelAutismo as select 
    id,
    nivel
    from dimNivelAutismo
go


create view vwNivelComunicacao as select 
    id,
    nivel
    from dimNivelComunicacao
go


create view vwFuncoesCognitivas as select 
    id,
    nivel
    from dimFuncoesCognitivas
go


create view vwStatusComunicacao as select 
    id,
    status
    from dimStatusComunicacao
go


create view vwControleEmocional as select 
    id,
    status
    from dimControleEmocional
go


create view vwInteracaoSocial as select 
    id,
    status
    from dimInteracaoSocial
go


create view vwComportamentoEsteriotipado as select 
    id,
    status
    from dimComportamentoEsteriotipado
go


create view vwComportamento as select 
    id,
    status
    from dimComportamento
go


create view vwFlexibilidadeInteresses as select 
    id,
    status
    from dimFlexibilidadeInteresses
go


create view vwAutonomia as select 
    id,
    status
    from dimAutonomia
go


create view vwFrequenciaTv as select 
    id,
    frequencia
    from dimFrequenciaTv
go


create view vwFrequenciaVideoGames as select 
    id,
    frequencia
    from dimFrequenciaVideoGames
go


create view vwJogaComAmigos as select 
    id,
    frequencia
    from dimJogaComAmigos
go


create view vwRedesSociais as select 
    id,
    frequencia
    from dimRedesSociais
go


create view vwIndividuo as select 
    id,
    qtIndividuos,
    idPais,
    idIdade,
    idSexo,
    idNivelAutismo,
    idNivelComunicacao,
    idFuncoesCognitivas,
    idStatusComunicacao,
    idControleEmocional,
    idInteracaoSocial,
    idComportamentoEsteriotipado,
    idComportamento,
    idFlexibilidadeInteresses,
    idAutonomia,
    idFrequenciaTv,
    idFrequenciaVideoGames,
    idJogaComAmigos,
    idRedesSociais
    from fatIndividuos
go
