library("DBI")
library("odbc")
library("dplyr")


autismo = read.csv("Facul/3CCO_3_ANO/dw/autistas_na_pandemia_2022-11-23_22-35-44.csv")

conn = dbConnect(
  odbc(), Driver="SQL Server", Server="pi-autism.database.windows.net",
  Database="pi-autism-data-wherehouse", UID="pi-autism-admin",
  PWD="4utism-Data@1", Port=2222
)

dbWriteTable(conn, name="autismoPandemia", value=autismo, 
             row.names=F, overwrite=T)

dbExecute(conn, "insert into dimPais(pais)
      select distinct pais_autistas from autismoPandemia a
      where not exists(
        select 1
        from dimPais d 
        where d.pais = a.pais_autistas
      )
")

dbExecute(conn, "insert into dimIdade(idade, faixaEtaria, maiorIdade)
      select distinct idade, case 
        when idade < 5 then 'Bebê'
        when idade >= 5 and idade < 12 then 'Criança'
        when idade >= 12 and idade < 19 then 'Adolescente'
        when idade >= 19 then 'Adulto' 
        end,
        case when idade >= 18 then 1 else 0 end
        from autismoPandemia a
        where not exists (
          select 1
          from dimIdade d
          where d.idade = a.idade
        )
")

dbExecute(conn, "insert into dimSexo(sexo)
      select distinct sexo 
      from autismoPandemia a
      where not exists (
        select 1
        from dimSexo d
        where d.sexo = a.sexo
      )
          ")

dbExecute(conn, "insert into dimNivelAutismo(nivel)
          select distinct nivel_autismo 
          from autismoPandemia a
          where not exists (
            select 1
            from dimNivelAutismo d
            where d.nivel = a.nivel_autismo
          )
          ")

dbExecute(conn, "insert into dimNivelComunicacao(nivel)
          select distinct nivel_comunicacao
          from autismoPandemia a
          where not exists (
            select 1
            from dimNivelComunicacao d
            where d.nivel = a.nivel_comunicacao
          )
          ")

dbExecute(conn, "insert into dimFuncoesCognitivas(nivel)
          select distinct funcoes_cognitivas
          from autismoPandemia a 
          where not exists (
            select 1
            from dimFuncoesCognitivas d
            where d.nivel = a.funcoes_cognitivas
          )
          ")

dbExecute(conn, "insert into dimStatusComunicacao(status)
          select distinct status_comunicacao
          from autismoPandemia a
          where not exists (
            select 1
            from dimStatusComunicacao d
            where d.status = a.status_comunicacao
          )
          ")

dbExecute(conn, "insert into dimControleEmocional(status)
          select distinct controle_emocional
          from autismoPandemia a 
          where not exists(
            select 1
            from dimControleEmocional d
            where d.status = a.controle_emocional
          )
          ")

dbExecute(conn, "insert into dimInteracaoSocial(status)
          select distinct interacao_social
          from autismoPandemia a
          where not exists (
            select 1
            from dimInteracaoSocial d
            where d.status = a.interacao_social
          )
          ")

dbExecute(conn, "insert into dimComportamentoEsteriotipado(status)
          select distinct comportamento_esteriotipado
          from autismoPandemia a
          where not exists (
            select 1
            from dimComportamentoEsteriotipado d
            where d.status = a.comportamento_esteriotipado
          )
          ")

dbExecute(conn, "insert into dimComportamento(status)
          select distinct comportamento
          from autismoPandemia a
          where not exists (
            select 1
            from dimComportamento d
            where d.status = a.comportamento
          )
          ")

dbExecute(conn, "insert into dimFlexibilidadeInteresses(status)
          select distinct flexibilidade_interesses 
          from autismoPandemia a
          where not exists (
            select 1
            from dimFlexibilidadeInteresses d
            where d.status = a.flexibilidade_interesses
          )
          ")

dbExecute(conn, "insert into dimAutonomia(status)
        select distinct autonomia
        from autismoPandemia a
        where not exists (
          select 1
          from dimAutonomia d
          where d.status = a.autonomia
        )
          ")

dbExecute(conn, "insert into dimFrequenciaTv(frequencia)
        select distinct frequencia_tv
        from autismoPandemia a
        where not exists (
          select 1
          from dimFrequenciaTv d
          where d.frequencia = a.frequencia_tv
        )
          ")

dbExecute(conn, "insert into dimFrequenciaVideoGames(frequencia)
          select distinct [frequencia_video.games]
          from autismoPandemia a
          where not exists(
            select 1
            from dimFrequenciaVideoGames d
            where d.frequencia = a.[frequencia_video.games]
          )
          ")

dbExecute(conn, "insert into dimJogaComAmigos(frequencia)
        select distinct joga_com_amigos_online
        from autismoPandemia a
        where not exists (
          select 1
          from dimJogaComAmigos d
          where d.frequencia = a.joga_com_amigos_online
        )
          ")

dbExecute(conn, "insert into dimRedesSociais(frequencia)
        select distinct redes_sociais
        from autismoPandemia a
        where not exists (
          select 1
          from dimRedesSociais d
          where d.frequencia = a.redes_sociais
        )
          ")

dbExecute(conn, "insert into fatIndividuos(
              qtIndividuos,
              idPais, idIdade, idSexo, idNivelAutismo,
              idNivelComunicacao,
              idFuncoesCognitivas, idStatusComunicacao,
              idControleEmocional, idInteracaoSocial,
              idComportamentoEsteriotipado, idComportamento,
              idFlexibilidadeInteresses, idAutonomia,
              idFrequenciaTv, idFrequenciaVideoGames,
              idJogaComAmigos, idRedesSociais
            )
            select
              count(1) as qtIndividuos,
              dp.id,
              di.id,
              ds.id,
              dna.id,
              dnc.id,
              dfc.id,
              dsc.id,
              dce.id,
              dis.id,
              dce2.id,
              dc.id,
              dfi.id,
              da.id,
              dft.id,
              dfvg.id,
              djca.id,
              drs.id
            from autismoPandemia a
            join dimPais dp on a.pais_autistas = dp.pais
            join dimIdade di on a.idade = di.idade
            join dimSexo ds on a.sexo = ds.sexo
            join dimNivelAutismo dna on a.nivel_autismo = dna.nivel
            join dimNivelComunicacao dnc on a.nivel_comunicacao = dnc.nivel
            join dimFuncoesCognitivas dfc on a.funcoes_cognitivas = dfc.nivel
            join dimStatusComunicacao dsc on a.status_comunicacao = dsc.status
            join dimControleEmocional dce on a.controle_emocional = dce.status
            join dimInteracaoSocial dis on a.interacao_social = dis.status
            join dimComportamentoEsteriotipado dce2 on a.comportamento_esteriotipado = dce2.status
            join dimComportamento dc on a.comportamento = dc.status
            join dimFlexibilidadeInteresses dfi on a.flexibilidade_interesses = dfi.status
            join dimAutonomia da on a.autonomia = da.status
            join dimFrequenciaTv dft on a.frequencia_tv = dft.frequencia
            join dimFrequenciaVideoGames dfvg on a.[frequencia_video.games] = dfvg.frequencia
            join dimJogaComAmigos djca on a.joga_com_amigos_online = djca.frequencia
            join dimRedesSociais drs on a.redes_sociais = drs.frequencia
            group by
              dp.id,
              di.id,
              ds.id,
              dna.id,
              dnc.id,
              dfc.id,
              dsc.id,
              dce.id,
              dis.id,
              dce2.id,
              dc.id,
              dfi.id,
              da.id,
              dft.id,
              dfvg.id,
              djca.id,
              drs.id
          ")

dbDisconnect(conn)
