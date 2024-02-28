create database ViagemOnibus

use ViagemOnibus

create table motorista(
    codigo          int             not null ,
    nome            varchar(40)     not null ,
    naturalidade    varchar(40)     not null ,
    primary key (codigo)
)
go
create table onibus(
    placa       char(7)         not null ,
    marca       varchar(15)     not null ,
    ano         int             not null ,
    descricao   varchar(20)     not null ,
    primary key (placa)
)
go
create table viagem(
    codigo          int         not null ,
    onibus          char(7)     not null ,
    motorista       int         not null ,
    hora_saida      int         not null check (viagem.hora_saida>=0),
    hora_chegada    int         not null check (viagem.hora_chegada>=0),
    partida         varchar(40) not null ,
    destino         varchar(40) not null ,
    primary key (codigo),
    foreign key (onibus) references onibus(placa),
    foreign key (motorista) references motorista(codigo)
)

-- 1) Criar um Union das tabelas Motorista e ônibus, com as colunas ID (Código e Placa) e Nome (Nome e Marca)

select convert(char(7), codigo) as id,
       nome
from motorista
union
select placa as id,
       marca
from onibus;

-- 2) Criar uma View (Chamada v_motorista_onibus) do Union acima

create view v_motorista_onibus
as
select convert(char(7), codigo) as id,
       nome
from motorista
union
select placa as id,
       marca
from onibus;

-- 3) Criar uma View (Chamada v_descricao_onibus) que mostre o Código da Viagem, o Nome do motorista, a placa do ônibus
-- (Formato XXX-0000), a Marca do ônibus, o Ano do ônibus e a descrição do onibus

create view v_descricao_onibus
as
select v.codigo,
       m.nome,
       substring(o.placa, 1, 3) + '-' + substring(o.placa, 4, 7) as placa_onibus,
       o.marca,
       o.ano,
       o.descricao
from viagem v, motorista m, onibus o
where m.codigo = v.motorista and
      o.placa = v.onibus

-- 4) Criar uma View (Chamada v_descricao_viagem) que mostre o Código da viagem, a placa do ônibus(Formato XXX-0000),
-- a Hora da Saída da viagem (Formato HH:00), a Hora da Chegada da viagem (Formato HH:00), partida e destino

create view v_descricao_viagem
as
select v.codigo,
       substring(o.placa, 1, 3) + '-' + substring(o.placa, 4, 7) as placa_onibus,
       substring(convert(varchar(2), v.hora_saida), 1, 2) + ':00' as hora_saida,
       substring(convert(varchar(2), v.hora_chegada), 1, 2) + ':00' as hora_chegada,
       v.partida,
       v.destino
from viagem v, onibus o;