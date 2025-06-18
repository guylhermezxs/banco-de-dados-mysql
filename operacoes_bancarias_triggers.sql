create database banconacional;

create table conta_corrente(
conta int,
agencia int,
usuario int,
saldo double
);

create table operacoes(
usuario int,
valor double,
operacao varchar(50)
);

INSERT INTO conta_corrente (conta, agencia, usuario, saldo)
VALUES
(12345, 1001, 1, 2500.00),
(23456, 1002, 2, 4300.50),
(34567, 1003, 3, 1200.75);

DELIMITER $
create trigger tgr_operacoes_insert after insert
on operacoes
for each row
begin
	if new.operacao = 'deposito' then
		update conta_corrente set saldo = saldo + new.valor
		where usuario = new.usuario;
    elseif new.operacao = 'saque' then
		update conta_corrente set saldo = saldo - new.valor
		where usuario = new.usuario;
	elseif new.operacao = 'transferencia' then
		update conta_corrente set saldo = saldo - new.valor
        where usuario = new.usuario;
        update conta_corrente set saldo = saldo + new.valor
        where usuario = new.usuario_transferencia;
	end if;
end$
DELIMITER ;

drop trigger tgr_operacoes_insert;

INSERT INTO operacoes (usuario, valor, operacao)
VALUES 
(1, 500.00, 'saque'),
(2, 200.00, 'deposito'),
(3, 3500, 'deposito');

alter table operacoes
add column usuario_transferencia int null
;

select * from banconacional.conta_corrente;
select * from banconacional.operacoes;

INSERT INTO operacoes (usuario, valor, operacao,usuario_transferencia)
VALUES 
(2, 500.00, 'transferencia', 1);

