create table especialidades (
idespecialidades serial primary key,
nome varchar(50) not null unique 
);

create table convenios (
idconvenio serial primary key,
nome varchar(60) not null unique,
telefone varchar(20),
email varchar(100)
);

create table medicos (
idmedico serial primary key,
idespecialidades int not null,
nome varchar(100) not null,
crm varchar(20) not null unique,
telefone varchar(20),
email varchar(100),
constraint fk_med_especialidade foreign key (idespecialidades)
references especialidades(idespecialidades)
);

create table pacientes (
idpaciente serial primary key ,
idconvenio int,
nome varchar(100) not null,
cpf varchar(11) unique,
data_nascimento date,
telefone varchar(20),
email varchar(100),
genero char(1),
constraint fk_paciente_convenio foreign key (idconvenio)
references convenios (idconvenio)
);

create table prontuarios (
idprontuario serial primary key,
idpaciente int not null,
data_abertura date not null default current_date,
alergias text,
doencas_anteriores text,
observacoes text,
constraint fk_pront_idpaciente foreign key (idpaciente)
references pacientes(idpaciente)
);

create table agendamentos (
idagendamento serial primary key,
idpaciente int not null,
idmedico int not null,
data_agendamento date not null,
horario time not null,
status varchar(20) not null default 'pendente',
constraint fk_age_idpaciente foreign key (idpaciente)
references pacientes(idpaciente),
constraint fk_age_idmedico foreign key (idmedico)
references medicos(idmedico)
);

create table consultas (
idconsulta serial primary key,
idmedico int not null,
idpaciente int not null,
idagendamento int,
data_consulta date not null default current_date,
horario time not null default current_time,
observacoes text,
constraint fk_con_idmedico foreign key (idmedico) references medicos(idmedico),
constraint fk_con_idpaciente foreign key (idpaciente) references pacientes(idpaciente),
constraint fk_con_idagendamento foreign key (idagendamento) references agendamentos(idagendamento)
);

create table receitas (
idreceita serial primary key,
idconsulta int not null,
data_emissao date not null default current_date,
observacoes text,
constraint fk_rec_idconsulta foreign key (idconsulta) references consultas(idconsulta)
);


create table medicamentos (
idmedicamento serial primary key,
idreceita int not null,
nome varchar(100) not null,
dosagem varchar(50) not null,
quantidade int not null,
instrucoes text,
constraint fk_med_idreceita foreign key (idreceita) references receitas(idreceita)
);

create table exames(
idexame serial primary key,
idconsulta int not null,
nome varchar(100) not null,
data_solicitacao date not null default current_date,
data_resultado date,
resultado text,
observacoes text,
constraint fk_exam_idconsulta foreign key (idconsulta) references consultas(idconsulta)
);

create table pagamentos (
idpagamento serial primary key,
idconsulta int not null,
data_pagamento date not null default current_date,
valor decimal(10,2) not null,
forma_pagamento varchar(30) not null,
status char(1) not null default 'p',
-- caracter: P = Pendente, C = Cancelado, A = Aprovado.
constraint fk_pag_idconsulta foreign key (idconsulta) references consultas(idconsulta)
);

select * from pacientes;

insert into pacientes (idconvenio, nome, cpf, data_nascimento, telefone, email, genero) values
(
    (SELECT idconvenio FROM convenios WHERE nome = 'Unimed'),
    'Maria Silva', '12345678901', '1990-03-15', '(11) 98765-1111', 'maria.silva@email.com', 'F'
),
(
    (SELECT idconvenio FROM convenios WHERE nome = 'Bradesco Saúde'),
    'João Santos', '23456789012', '1985-07-22', '(11) 98765-2222', 'joao.santos@email.com', 'M'
),
(
    (SELECT idconvenio FROM convenios WHERE nome = 'Amil'),
    'Ana Oliveira', '34567890123', '1992-11-08', '(11) 98765-3333', 'ana.oliveira@email.com', 'F'
),
(
    (SELECT idconvenio FROM convenios WHERE nome = 'SulAmérica'),
    'Carlos Pereira', '45678901234', '1978-05-30', '(11) 98765-4444', 'carlos.pereira@email.com', 'M'
),
(
    (SELECT idconvenio FROM convenios WHERE nome = 'Hapvida'),
    'Fernanda Lima', '56789012345', '1995-09-12', '(11) 98765-5555', 'fernanda.lima@email.com', 'F'
),
(
    (SELECT idconvenio FROM convenios WHERE nome = 'Porto Seguro Saúde'),
    'Roberto Costa', '67890123456', '1970-01-25', '(11) 98765-6666', 'roberto.costa@email.com', 'M'
),
(
    (SELECT idconvenio FROM convenios WHERE nome = 'Golden Cross'),
    'Juliana Souza', '78901234567', '1988-04-17', '(11) 98765-7777', 'juliana.souza@email.com', 'F'
),
(
    (SELECT idconvenio FROM convenios WHERE nome = 'NotreDame Intermédica'),
    'Marcelo Rodrigues', '89012345678', '1982-12-03', '(11) 98765-8888', 'marcelo.rodrigues@email.com', 'M'
),
(
    NULL,
    'Patrícia Alves', '90123456789', '1998-06-20', '(11) 98765-9999', 'patricia.alves@email.com', 'F'
),
(
    NULL,
    'Lucas Ferreira', '01234567890', '2000-08-14', '(11) 98765-0000', 'lucas.ferreira@email.com', 'M'
);


insert into prontuarios (idpaciente, alergias, doencas_anteriores, observacoes) values
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva'),
    'Dipirona', 'Hipertensão', 'Paciente controlada com medicamento'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos'),
    'Penicilina', 'Diabetes Tipo 2', 'Faz uso de insulina diariamente'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Ana Oliveira'),
    NULL, 'Asma', 'Usa bombinha quando necessário'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira'),
    'Ibuprofeno', NULL, 'Sem doenças anteriores relevantes'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Fernanda Lima'),
    NULL, NULL, 'Paciente saudável, consulta de rotina'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa'),
    'Amoxicilina', 'Colesterol alto', 'Em acompanhamento cardiológico'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Juliana Souza'),
    NULL, 'Enxaqueca', 'Crises frequentes de dor de cabeça'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Marcelo Rodrigues'),
    'Sulfas', 'Gastrite', 'Dieta controlada'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Patrícia Alves'),
    NULL, NULL, 'Primeira consulta'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira'),
    NULL, NULL, 'Primeira consulta'
);

insert into agendamentos (idpaciente, idmedico, data_agendamento, horario, status) values	
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Ricardo Oliveira'),
    '2026-08-10', '08:00', 'confirmado'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Bruno Lima'),
    '2026-08-10', '09:00', 'confirmado'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Ana Oliveira'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Marcos Souza'),
    '2026-08-11', '10:00', 'pendente'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Carlos Mendes'),
    '2026-08-11', '14:00', 'confirmado'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Fernanda Lima'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dra. Ana Paula Silva'),
    '2026-08-12', '08:30', 'pendente'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Ricardo Oliveira'),
    '2026-08-12', '15:00', 'confirmado'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Juliana Souza'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dra. Camila Ferreira'),
    '2026-08-13', '09:30', 'cancelado'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Patrícia Alves'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dra. Fernanda Costa'),
    '2026-08-13', '11:00', 'pendente'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Paulo Rodrigues'),
    '2026-08-14', '10:00', 'confirmado'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Marcelo Rodrigues'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Felipe Alves'),
    '2026-08-14', '16:00', 'confirmado'
);




-- 
INSERT INTO consultas (idpaciente, idmedico, idagendamento, data_consulta, horario, observacoes) VALUES
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Ricardo Oliveira'),
    (SELECT idagendamento FROM agendamentos WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    '2026-08-10', '08:00', 'Paciente com pressão elevada, solicitado exame'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Bruno Lima'),
    (SELECT idagendamento FROM agendamentos WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1),
    '2026-08-10', '09:00', 'Consulta de rotina, glicemia controlada'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Carlos Mendes'),
    (SELECT idagendamento FROM agendamentos WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1),
    '2026-08-11', '14:00', 'Dor no joelho direito, solicitado raio-x'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Ricardo Oliveira'),
    (SELECT idagendamento FROM agendamentos WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    '2026-08-12', '15:00', 'Acompanhamento cardíaco, exame solicitado'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira'),
    (SELECT idmedico FROM medicos WHERE nome = 'Dr. Paulo Rodrigues'),
    (SELECT idagendamento FROM agendamentos WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1),
    '2026-08-14', '10:00', 'Primeira consulta oftalmológica'
);

insert into receitas (idconsulta, observacoes) values
((select idconsulta from consultas where idpaciente =(select idpaciente from pacientes where nome = 'Maria Silva')limit 1),
'Tomar medicação conforme prescrito, retorno em 30 dias'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'João Santos') limit 1),
'Manter dieta e exercícios, retorno em 60 dias'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Carlos Pereira')limit 1),
'Repouso por 7 dias, aguardar resultado do raio-x'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Roberto Costa')limit 1),
'Continuar medicação cardíaca, retorno em 15 dias'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Lucas Ferreira')limit 1),
'Uso de óculos prescito, retorno em 6 meses');

INSERT INTO medicamentos (idreceita, nome, dosagem, quantidade, instrucoes) VALUES
(
    (SELECT idreceita FROM receitas WHERE idconsulta = (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1) LIMIT 1),
    'Losartana', '50mg', 1, 'Tomar 1 comprimido por dia pela manhã'
),
(
    (SELECT idreceita FROM receitas WHERE idconsulta = (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1) LIMIT 1),
    'Hidroclorotiazida', '25mg', 1, 'Tomar 1 comprimido por dia'
),
(
    (SELECT idreceita FROM receitas WHERE idconsulta = (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1) LIMIT 1),
    'Metformina', '850mg', 2, 'Tomar 1 comprimido após almoço e jantar'
),
(
    (SELECT idreceita FROM receitas WHERE idconsulta = (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1) LIMIT 1),
    'Ibuprofeno', '600mg', 3, 'Tomar 1 comprimido de 8 em 8 horas por 5 dias'
),
(
    (SELECT idreceita FROM receitas WHERE idconsulta = (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1) LIMIT 1),
    'Atorvastatina', '20mg', 1, 'Tomar 1 comprimido à noite'
),
(
    (SELECT idreceita FROM receitas WHERE idconsulta = (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1) LIMIT 1),
    'Colírio Systane', '0,4mg', 4, 'Pingar 1 gota em cada olho 4 vezes ao dia'
);

insert into exames (idconsulta, nome, data_resultado, resultado, observacoes) values
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Maria Silva') limit 1),
'Eletrocardiograma','2026-08-15','Normal','Sem alterações'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Maria Silva') limit 1),
'Homograma Completo','2026-08-15','Normal','Todos os valores dentro do esperado'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'João Santos')limit 1),
'Glicemia em Jejum','2026-08-12','Alterado','Glicemia 145mg/dL, acima do normal'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Carlos Pereira') limit 1),
'Raio-x Joelho direito','2026-08-13','Alterado','Desgate leve na Cartilagem'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Roberto Costa') limit 1),
'Ecocardiograma','2026-08-16','Normal','Função cardíaca preservada'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Roberto Costa') limit 1),
'Colesterol Total','2026-08-16','Alterado','Colesterol 220mg/dL, acima do ideal'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Lucas Ferreira') limit 1),
'Acuidade Visual','2026-08-14','Alterado','Miopia -2.5 em ambos os olhos');

insert into pagamentos (idconsulta,valor,forma_pagamento,status) values 
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Maria Silva') limit 1),
150.00,'Convênio','A'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'João Santos') limit 1),
200.00,'Convênio','A'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Carlos Pereira') limit 1),
180.00,'Cartão de Crédito','A'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Roberto Costa')limit 1),
250.00,'Convênio','A'),
((select idconsulta from consultas where idpaciente = (select idpaciente from pacientes where nome = 'Lucas Ferreira') limit 1),
120.00, 'Dinheiro','P');


select nome, cpf, data_nascimento from pacientes
order by nome desc;

select nome, email from pacientes
where nome like 'Maria%';


select nome, email from pacientes
where nome like '%Silva%';

select nome, data_nascimento from pacientes
where data_nascimento between '1980-01-01' and '1995-12-31';

select idconsulta, valor, forma_pagamento from pagamentos 
where valor between 100 and 200;

--Busque todos os pagamentos com valor entre 
--R$100 e R$200, mostrando o idconsulta, valor e forma_pagamento.

select idconsulta, valor, forma_pagamento from pagamentos 
where valor between 100 and 200;


--Busque todos os pacientes nascidos entre 1990 e 2000, mostrando apenas o nome e data_nascimento, ordenados por data do mais novo para o mais antigo. 
select nome, data_nascimento from pacientes
where data_nascimento between '1990-01-01' and '2000-12-31'
order by data_nascimento desc;


-- and e or 
-- -- Buscar pacientes do sexo feminino E nascidas depois de 1990


select nome, data_nascimento, genero from pacientes p 
where genero = 'F'
and data_nascimento > '1990-01-01';


--Questão 1:
--Busque todos os médicos que são da especialidade 'Cardiologia' OU 'Pediatria', mostrando o nome e o idespecialidade.

SELECT nome, idespecialidade 
FROM medicos
WHERE idespecialidade = (SELECT idespecialidade FROM especialidades WHERE nome = 'Cardiologia')
OR idespecialidade = (SELECT idespecialidade FROM especialidades WHERE nome = 'Pediatria');


select min(valor) as menor_pagamento,
	   max(valor) as maior_pagamento from pagamentos;


select count(idmedico) from medicos;
select sum(quantidade) from medicamentos;

select status, count(*) as total from agendamentos
group by status;
select * from exames;

select resultado, count(*) as total_exames from exames
group by resultado;

select forma_pagamento, count(*) as total, sum(valor) as valor_arrecadado from pagamentos	
group by forma_pagamento;


select forma_pagamento, sum(valor) as total from pagamentos
group by forma_pagamento
having sum(valor) > 150;


select resultado, count(*) as total from exames
group by resultado	
having count(*) > 2;	

select status, count(*) as total_agendamento from agendamentos
group by status 
having count(*) > 2;

select 
       pacientes.nome,
       consultas.data_consulta,
       consultas.observacoes
from consultas 
inner join pacientes on consultas.idpaciente = pacientes.idpaciente;

-- Mostre o nome do médico e a data e status do agendamento cruzando só medicos e agendamentos!

select 
      medicos.nome, 
      agendamentos.data_agendamento,
      agendamentos.status
from agendamentos
inner join medicos on agendamentos.idmedico = medicos.idmedico;

-- Mostre o nome do paciente e as observacoes do prontuario cruzando as tabelas pacientes e prontuarios!

select pacientes.nome,
       prontuarios.observacoes
from prontuarios
inner join pacientes on prontuarios.idpaciente = pacientes.idpaciente;

-- Mostre o nome do paciente, valor e forma de pagamento passando por paciente -> consultas -> pagamentos.

select pacientes.nome,
       consultas.data_consulta,
       pagamentos.valor,
       pagamentos.forma_pagamento
from pacientes
inner join consultas on pacientes.idpaciente = consultas.idpaciente 
inner join pagamentos on consultas.idconsulta = pagamentos.idconsulta;

select medicos.nome,
       pacientes.nome,
       consultas.data_consulta
from consultas  
inner join medicos on consultas.idmedico = medicos.idmedico 
inner join pacientes on consultas.idpaciente = pacientes.idpaciente;


select pacientes.nome,
       pagamentos.valor,
       consultas.observacoes 
  from consultas 
inner join pacientes on consultas.idpaciente = pacientes.idpaciente
inner join pagamentos on consultas.idconsulta = pagamentos.idconsulta;  

--Mostre o nome do paciente, nome do médico, especialidade e data da consulta cruzando:
select pacientes.nome, 
       medicos.nome,
       especialidades.nome,
       c.data_consulta
       from consultas c
inner join pacientes on c.idpaciente = pacientes.idpaciente 
inner join medicos on c.idmedico = medicos.idmedico
inner join especialidades on medicos.idespecialidade = especialidades.idespecialidade;    
 

--Mostre o nome do paciente, nome do medicamento, dosagem e instruções cruzando:

select pacientes.nome,
       medicamentos.nome,
       medicamentos.dosagem,
       medicamentos.instrucoes
from pacientes 
inner join consultas on pacientes.idpaciente = consultas.idpaciente
inner join receitas on consultas.idconsulta= receitas.idconsulta 
inner join medicamentos on receitas.idreceita = medicamentos.idreceita;

-- Mostre o nome do paciente, nome do exame, resultado e data do resultado cruzando: 

select pacientes.nome,
       exames.nome,
       exames.resultado,
       exames.data_resultado
from pacientes
inner join consultas on pacientes.idpaciente = consultas.idpaciente 
inner join exames on consultas.idconsulta = exames.idconsulta
order by exames.data_resultado;



select * from vw_relatorio_exames;

create index idx_pacientes_nome
on pacientes(nome);

create index idx_medicos_nome
on medicos(nome);
CREATE INDEX idx_consultas_data 
ON consultas(data_consulta);

CREATE INDEX idx_agendamentos_status 
ON agendamentos(status);


select * from pacientes 
where nome = 'Maria Silva';ss














