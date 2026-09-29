-- =============================================
-- SISTEMA DE GESTÃO DE CLÍNICA MÉDICA
-- Banco de dados: clinica_db
-- Autor: Douglas Correia dos Santos
-- GitHub: https://github.com/DouglasCSantos-db
-- =============================================

-- ANTES DE EXECUTAR: crie o banco e conecte nele
-- CREATE DATABASE clinica_db;
-- (no DBeaver, selecione clinica_db como banco ativo antes de rodar este script)

-- =============================================
-- TABELAS
-- =============================================

CREATE TABLE especialidades (
    idespecialidade SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE 
);

CREATE TABLE convenios (
    idconvenio SERIAL PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE medicos (
    idmedico SERIAL PRIMARY KEY,
    idespecialidade INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    CONSTRAINT fk_med_especialidade FOREIGN KEY (idespecialidade)
    REFERENCES especialidades(idespecialidade)
);

CREATE TABLE pacientes (
    idpaciente SERIAL PRIMARY KEY,
    idconvenio INT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE,
    data_nascimento DATE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    genero CHAR(1),
    CONSTRAINT fk_paciente_convenio FOREIGN KEY (idconvenio)
    REFERENCES convenios(idconvenio)
);

CREATE TABLE prontuarios (
    idprontuario SERIAL PRIMARY KEY,
    idpaciente INT NOT NULL,
    data_abertura DATE NOT NULL DEFAULT CURRENT_DATE,
    alergias TEXT,
    doencas_anteriores TEXT,
    observacoes TEXT,
    CONSTRAINT fk_pront_idpaciente FOREIGN KEY (idpaciente)
    REFERENCES pacientes(idpaciente)
);

CREATE TABLE agendamentos (
    idagendamento SERIAL PRIMARY KEY,
    idpaciente INT NOT NULL,
    idmedico INT NOT NULL,
    data_agendamento DATE NOT NULL,
    horario TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pendente',
    CONSTRAINT fk_age_idpaciente FOREIGN KEY (idpaciente)
    REFERENCES pacientes(idpaciente),
    CONSTRAINT fk_age_idmedico FOREIGN KEY (idmedico)
    REFERENCES medicos(idmedico)
);

CREATE TABLE consultas (
    idconsulta SERIAL PRIMARY KEY,
    idmedico INT NOT NULL,
    idpaciente INT NOT NULL,
    idagendamento INT,
    data_consulta DATE NOT NULL DEFAULT CURRENT_DATE,
    horario TIME NOT NULL DEFAULT CURRENT_TIME,
    observacoes TEXT,
    CONSTRAINT fk_con_idmedico FOREIGN KEY (idmedico) REFERENCES medicos(idmedico),
    CONSTRAINT fk_con_idpaciente FOREIGN KEY (idpaciente) REFERENCES pacientes(idpaciente),
    CONSTRAINT fk_con_idagendamento FOREIGN KEY (idagendamento) REFERENCES agendamentos(idagendamento)
);

CREATE TABLE receitas (
    idreceita SERIAL PRIMARY KEY,
    idconsulta INT NOT NULL,
    data_emissao DATE NOT NULL DEFAULT CURRENT_DATE,
    observacoes TEXT,
    CONSTRAINT fk_rec_idconsulta FOREIGN KEY (idconsulta) REFERENCES consultas(idconsulta)
);

CREATE TABLE medicamentos (
    idmedicamento SERIAL PRIMARY KEY,
    idreceita INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    instrucoes TEXT,
    CONSTRAINT fk_med_idreceita FOREIGN KEY (idreceita) REFERENCES receitas(idreceita)
);

CREATE TABLE exames (
    idexame SERIAL PRIMARY KEY,
    idconsulta INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_solicitacao DATE NOT NULL DEFAULT CURRENT_DATE,
    data_resultado DATE,
    resultado TEXT,
    observacoes TEXT,
    CONSTRAINT fk_exam_idconsulta FOREIGN KEY (idconsulta) REFERENCES consultas(idconsulta)
);

CREATE TABLE pagamentos (
    idpagamento SERIAL PRIMARY KEY,
    idconsulta INT NOT NULL,
    data_pagamento DATE NOT NULL DEFAULT CURRENT_DATE,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    status CHAR(1) NOT NULL DEFAULT 'P',
    -- P = Pendente, C = Cancelado, A = Aprovado
    CONSTRAINT fk_pag_idconsulta FOREIGN KEY (idconsulta) REFERENCES consultas(idconsulta)
);

-- =============================================
-- INSERÇÃO DE DADOS
-- =============================================

INSERT INTO especialidades (nome) VALUES
('Cardiologia'),
('Pediatria'),
('Ortopedia'),
('Dermatologia'),
('Neurologia'),
('Ginecologia'),
('Oftalmologia'),
('Psiquiatria'),
('Endocrinologia'),
('Urologia');

INSERT INTO convenios (nome, telefone, email) VALUES
('Unimed', '(11) 3003-1234', 'contato@unimed.com.br'),
('Bradesco Saúde', '(11) 3003-5678', 'contato@bradescosaude.com.br'),
('Amil', '(11) 3003-9012', 'contato@amil.com.br'),
('SulAmérica', '(11) 3003-3456', 'contato@sulamerica.com.br'),
('Porto Seguro Saúde', '(11) 3003-7890', 'contato@portoseguro.com.br'),
('Hapvida', '(85) 3003-1234', 'contato@hapvida.com.br'),
('NotreDame Intermédica', '(11) 3003-4567', 'contato@intermedica.com.br'),
('Golden Cross', '(21) 3003-8901', 'contato@goldencross.com.br');

INSERT INTO medicos (idespecialidade, nome, crm, telefone, email) VALUES
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Cardiologia'),
    'Dr. Ricardo Oliveira', 'CRM-SP 12345', '(11) 98765-1234', 'ricardo.oliveira@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Pediatria'),
    'Dra. Ana Paula Silva', 'CRM-SP 23456', '(11) 98765-2345', 'ana.silva@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Ortopedia'),
    'Dr. Carlos Mendes', 'CRM-SP 34567', '(11) 98765-3456', 'carlos.mendes@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Dermatologia'),
    'Dra. Fernanda Costa', 'CRM-SP 45678', '(11) 98765-4567', 'fernanda.costa@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Neurologia'),
    'Dr. Marcos Souza', 'CRM-SP 56789', '(11) 98765-5678', 'marcos.souza@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Ginecologia'),
    'Dra. Juliana Santos', 'CRM-SP 67890', '(11) 98765-6789', 'juliana.santos@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Oftalmologia'),
    'Dr. Paulo Rodrigues', 'CRM-SP 78901', '(11) 98765-7890', 'paulo.rodrigues@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Psiquiatria'),
    'Dra. Camila Ferreira', 'CRM-SP 89012', '(11) 98765-8901', 'camila.ferreira@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Endocrinologia'),
    'Dr. Bruno Lima', 'CRM-SP 90123', '(11) 98765-9012', 'bruno.lima@clinica.com'
),
(
    (SELECT idespecialidade FROM especialidades WHERE nome = 'Urologia'),
    'Dr. Felipe Alves', 'CRM-SP 01234', '(11) 98765-0123', 'felipe.alves@clinica.com'
);

INSERT INTO pacientes (idconvenio, nome, cpf, data_nascimento, telefone, email, genero) VALUES
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

INSERT INTO prontuarios (idpaciente, data_abertura, alergias, doencas_anteriores, observacoes) VALUES
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva'),
    '2026-08-01', 'Dipirona', 'Hipertensão', 'Paciente controlada com medicamento'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos'),
    '2026-08-01', 'Penicilina', 'Diabetes Tipo 2', 'Faz uso de insulina diariamente'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Ana Oliveira'),
    '2026-08-01', NULL, 'Asma', 'Usa bombinha quando necessário'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira'),
    '2026-08-01', 'Aspirina', NULL, 'Sem doenças anteriores relevantes'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Fernanda Lima'),
    '2026-08-01', NULL, NULL, 'Paciente saudável, consulta de rotina'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa'),
    '2026-08-01', 'Amoxicilina', 'Colesterol alto', 'Em acompanhamento cardiológico'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Juliana Souza'),
    '2026-08-01', NULL, 'Enxaqueca', 'Crises frequentes de dor de cabeça'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Marcelo Rodrigues'),
    '2026-08-01', 'Sulfas', 'Gastrite', 'Dieta controlada'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Patrícia Alves'),
    '2026-08-01', NULL, NULL, 'Primeira consulta'
),
(
    (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira'),
    '2026-08-01', NULL, NULL, 'Primeira consulta'
);

INSERT INTO agendamentos (idpaciente, idmedico, data_agendamento, horario, status) VALUES
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
    (SELECT idmedico FROM medicos WHERE nome = 'Dra. Juliana Santos'),
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

INSERT INTO receitas (idconsulta, data_emissao, observacoes) VALUES
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    '2026-08-10', 'Tomar medicação conforme prescrito, retorno em 30 dias'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1),
    '2026-08-10', 'Manter dieta e exercícios, retorno em 60 dias'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1),
    '2026-08-11', 'Repouso por 7 dias, aguardar resultado do raio-x'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    '2026-08-12', 'Continuar medicação cardíaca, retorno em 15 dias'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1),
    '2026-08-14', 'Uso de óculos prescrito, retorno em 6 meses'
);

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

INSERT INTO exames (idconsulta, data_solicitacao, nome, data_resultado, resultado, observacoes) VALUES
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    '2026-08-10', 'Eletrocardiograma', '2026-08-15', 'Normal', 'Sem alterações'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    '2026-08-10', 'Hemograma Completo', '2026-08-15', 'Normal', 'Todos os valores dentro do esperado'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1),
    '2026-08-10', 'Glicemia em Jejum', '2026-08-12', 'Alterado', 'Glicemia 145mg/dL, acima do normal'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1),
    '2026-08-11', 'Raio-x Joelho direito', '2026-08-13', 'Alterado', 'Desgaste leve na Cartilagem'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    '2026-08-12', 'Ecocardiograma', '2026-08-16', 'Normal', 'Função cardíaca preservada'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    '2026-08-12', 'Colesterol Total', '2026-08-16', 'Alterado', 'Colesterol 220mg/dL, acima do ideal'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1),
    '2026-08-14', 'Acuidade Visual', '2026-08-14', 'Alterado', 'Miopia -2.5 em ambos os olhos'
);

INSERT INTO pagamentos (idconsulta, data_pagamento, valor, forma_pagamento, status) VALUES
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    '2026-08-10', 150.00, 'Convênio', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1),
    '2026-08-10', 200.00, 'Convênio', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1),
    '2026-08-11', 180.00, 'Cartão de Crédito', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    '2026-08-12', 250.00, 'Convênio', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1),
    '2026-08-14', 120.00, 'Dinheiro', 'P'
);

-- =============================================
-- DADOS COMPLEMENTARES
-- Os inserts abaixo usam INSERT ... SELECT com uma lista VALUES
-- ligada às tabelas pelo nome (JOIN), em vez de uma subquery por linha.
-- =============================================


-- ---------------------------------------------
-- Novas especialidades
-- ---------------------------------------------

INSERT INTO especialidades (nome) VALUES
('Clínica Geral'),
('Otorrinolaringologia'),
('Gastroenterologia');


-- ---------------------------------------------
-- Novos convênios
-- ---------------------------------------------

INSERT INTO convenios (nome, telefone, email) VALUES
('Prevent Senior', '(11) 3003-2468', 'contato@preventsenior.com.br'),
('São Francisco Saúde', '(16) 3003-1357', 'contato@saofrancisco.com.br'),
('Care Plus', '(11) 3003-9753', 'contato@careplus.com.br');


-- ---------------------------------------------
-- Novos médicos
-- ---------------------------------------------

INSERT INTO medicos (idespecialidade, nome, crm, telefone, email)
SELECT e.idespecialidade, v.nome, v.crm, v.telefone, v.email
FROM (VALUES
    ('Clínica Geral', 'Dra. Beatriz Moura', 'CRM-SP 11223', '(11) 98765-1122', 'beatriz.moura@clinica.com'),
    ('Clínica Geral', 'Dr. Henrique Tavares', 'CRM-SP 22334', '(11) 98765-2233', 'henrique.tavares@clinica.com'),
    ('Otorrinolaringologia', 'Dr. Rafael Nogueira', 'CRM-SP 33445', '(11) 98765-3344', 'rafael.nogueira@clinica.com'),
    ('Gastroenterologia', 'Dra. Larissa Campos', 'CRM-SP 44556', '(11) 98765-4455', 'larissa.campos@clinica.com'),
    ('Cardiologia', 'Dra. Mariana Duarte', 'CRM-SP 55667', '(11) 98765-5566', 'mariana.duarte@clinica.com'),
    ('Pediatria', 'Dr. Thiago Barros', 'CRM-SP 66778', '(11) 98765-6677', 'thiago.barros@clinica.com'),
    ('Dermatologia', 'Dra. Renata Cardoso', 'CRM-SP 77889', '(11) 98765-7788', 'renata.cardoso@clinica.com')
) AS v(especialidade, nome, crm, telefone, email)
JOIN especialidades e ON e.nome = v.especialidade;


-- ---------------------------------------------
-- Novos pacientes
-- ---------------------------------------------

INSERT INTO pacientes (idconvenio, nome, cpf, data_nascimento, telefone, email, genero)
SELECT c.idconvenio, v.nome, v.cpf, v.data_nascimento::DATE, v.telefone, v.email, v.genero
FROM (VALUES
    (NULL, 'Letícia Moreira', '81399869841', '2001-12-25', '(11) 98402-8226', 'leticia.moreira@email.com', 'F'),
    (NULL, 'Aline Araújo', '11417075350', '1973-05-12', '(11) 99297-7166', 'aline.araujo@email.com', 'F'),
    ('NotreDame Intermédica', 'Letícia Cardoso', '88447294072', '2002-12-12', '(11) 98271-9166', 'leticia.cardoso75@email.com', 'F'),
    ('Amil', 'Sofia Moreira', '97684697811', '2021-01-19', '(11) 99943-9572', NULL, 'F'),
    ('Porto Seguro Saúde', 'Yasmin Araújo', '67273177806', '1964-09-13', '(11) 98649-9223', 'yasmin.araujo@email.com', 'F'),
    ('Golden Cross', 'Mateus Ribeiro', '34400297861', '1979-06-07', '(11) 99140-9145', 'mateus.ribeiro@email.com', 'M'),
    ('Bradesco Saúde', 'Sérgio Batista', '04571784775', '1959-07-27', '(11) 99699-9166', 'sergio.batista@email.com', 'M'),
    (NULL, 'Caio Gomes', '62701079896', '2001-02-20', '(11) 96182-9953', 'caio.gomes80@email.com', 'M'),
    (NULL, 'Leonardo Esteves', '05997283704', '1985-03-20', '(11) 96345-7844', 'leonardo.esteves@email.com', 'M'),
    (NULL, 'Cláudia Siqueira', '94866283602', '1948-02-13', '(11) 98647-6790', 'claudia.siqueira45@email.com', 'F'),
    ('SulAmérica', 'Alice Moreira', '75475177902', '2022-03-05', '(11) 97377-8517', NULL, 'F'),
    ('Care Plus', 'Vera Correia', '18603208050', '1976-11-07', '(11) 96528-9682', 'vera.correia@email.com', 'F'),
    ('Golden Cross', 'Rosângela Esteves', '22646861621', '1967-03-12', '(11) 99195-7811', 'rosangela.esteves@email.com', 'F'),
    ('Bradesco Saúde', 'Otávio Freitas', '58771884106', '2002-04-08', '(11) 98644-6413', 'otavio.freitas@email.com', 'M'),
    ('São Francisco Saúde', 'Sérgio Siqueira', '20525898301', '1955-10-23', '(11) 98334-5828', 'sergio.siqueira@email.com', 'M'),
    ('Porto Seguro Saúde', 'Sérgio Esteves', '14162105200', '1989-11-04', '(11) 96261-5768', 'sergio.esteves@email.com', 'M'),
    ('Care Plus', 'Eduardo Lopes', '41064600174', '1963-01-10', '(11) 99834-6739', 'eduardo.lopes@email.com', 'M'),
    (NULL, 'Heitor Araújo', '90659397684', '2014-11-12', '(11) 99783-5121', NULL, 'M'),
    ('Hapvida', 'Igor Pinto', '06045414659', '1968-10-01', '(11) 98955-2844', 'igor.pinto8@email.com', 'M'),
    ('NotreDame Intermédica', 'Tatiane Dias', '10285940627', '1985-03-12', '(11) 98713-4597', 'tatiane.dias54@email.com', 'F'),
    ('Hapvida', 'Daniela Rocha', '08864230076', '1965-09-16', '(11) 98431-2465', 'daniela.rocha81@email.com', 'F'),
    ('Amil', 'Sabrina Barbosa', '84585003703', '1951-04-22', '(11) 99711-7538', 'sabrina.barbosa@email.com', 'F'),
    ('Amil', 'Fábio Rocha', '45355778704', '2005-11-19', '(11) 96629-8943', 'fabio.rocha@email.com', 'M'),
    (NULL, 'Luana Moreira', '60214584275', '1993-12-04', '(11) 99480-6025', 'luana.moreira28@email.com', 'F'),
    ('São Francisco Saúde', 'Sofia Queiroz', '88281126540', '2021-05-10', '(11) 96777-3657', NULL, 'F'),
    ('Unimed', 'Igor Rocha', '45263097611', '1970-09-06', '(11) 96592-3685', 'igor.rocha70@email.com', 'M'),
    ('Hapvida', 'Carla Moreira', '05154382943', '1987-04-05', '(11) 99579-2198', 'carla.moreira@email.com', 'F'),
    (NULL, 'Gustavo Araújo', '41577188365', '2001-06-22', '(11) 97413-2352', 'gustavo.araujo@email.com', 'M'),
    ('Golden Cross', 'Bruna Siqueira', '74432568844', '1969-06-24', '(11) 96723-4219', 'bruna.siqueira@email.com', 'F'),
    ('Hapvida', 'Fábio Correia', '55696327940', '1990-12-05', '(11) 97310-5365', 'fabio.correia@email.com', 'M'),
    ('Unimed', 'Gustavo Esteves', '84352814423', '1984-08-21', '(11) 97348-7711', 'gustavo.esteves@email.com', 'M'),
    ('Porto Seguro Saúde', 'Arthur Batista', '78836550606', '2015-01-09', '(11) 98639-7793', NULL, 'M'),
    ('Bradesco Saúde', 'Pedro Nascimento', '00314503773', '1980-05-20', '(11) 96768-9830', 'pedro.nascimento@email.com', 'M'),
    ('Amil', 'Carla Esteves', '53739241993', '1974-12-17', '(11) 97109-7873', 'carla.esteves4@email.com', 'F'),
    ('Amil', 'Raquel Batista', '55559747521', '2001-05-02', '(11) 97039-8636', 'raquel.batista47@email.com', 'F'),
    (NULL, 'Luana Lopes', '86439061828', '1991-09-25', '(11) 98524-2486', 'luana.lopes@email.com', 'F'),
    ('NotreDame Intermédica', 'Leonardo Freitas', '18248861953', '1961-01-15', '(11) 98156-3072', 'leonardo.freitas@email.com', 'M'),
    ('Amil', 'Isabela Machado', '72855689880', '1960-03-20', '(11) 96537-2000', 'isabela.machado@email.com', 'F'),
    (NULL, 'Laura Siqueira', '42248527217', '2015-12-02', '(11) 97695-9023', NULL, 'F'),
    ('Unimed', 'Jéssica Henriques', '85817625229', '1993-09-02', '(11) 99456-5214', 'jessica.henriques76@email.com', 'F'),
    ('Amil', 'André Freitas', '83166323309', '1990-08-07', '(11) 97728-7933', 'andre.freitas@email.com', 'M'),
    ('São Francisco Saúde', 'Leonardo Correia', '34789713300', '1955-02-12', '(11) 96471-3820', 'leonardo.correia@email.com', 'M'),
    ('Porto Seguro Saúde', 'Vanessa Ribeiro', '36082445651', '1948-08-17', '(11) 97999-3260', 'vanessa.ribeiro@email.com', 'F'),
    ('Golden Cross', 'Cláudia Rocha', '35769908521', '1996-05-22', '(11) 99383-9608', 'claudia.rocha@email.com', 'F'),
    ('Golden Cross', 'Isabela Martins', '01901879135', '1972-11-26', '(11) 98215-1359', 'isabela.martins@email.com', 'F'),
    ('Hapvida', 'Laura Esteves', '01612840000', '2014-10-17', '(11) 97257-8713', NULL, 'F'),
    ('Bradesco Saúde', 'Letícia Correia', '73638560791', '1963-10-06', '(11) 98418-7252', 'leticia.correia@email.com', 'F'),
    ('NotreDame Intermédica', 'Renato Almeida', '73608724303', '2003-09-11', '(11) 98377-1430', 'renato.almeida@email.com', 'M'),
    (NULL, 'Wagner Moreira', '28195391818', '1958-08-13', '(11) 99298-7814', 'wagner.moreira@email.com', 'M'),
    ('Care Plus', 'André Henriques', '30428451411', '1958-01-07', '(11) 98303-2895', 'andre.henriques@email.com', 'M'),
    ('Porto Seguro Saúde', 'Luana Correia', '78037041239', '1989-02-09', '(11) 96178-8723', 'luana.correia@email.com', 'F'),
    ('Golden Cross', 'Bernardo Correia', '82889837076', '1982-06-08', '(11) 96061-7774', 'bernardo.correia5@email.com', 'M'),
    (NULL, 'Miguel Cardoso', '79223283892', '2018-07-09', '(11) 97917-2514', NULL, 'M'),
    ('NotreDame Intermédica', 'Luana Cardoso', '29837252782', '1983-02-05', '(11) 98039-7858', 'luana.cardoso90@email.com', 'F'),
    ('São Francisco Saúde', 'Renato Pinto', '19043163449', '1986-11-19', '(11) 98176-1171', 'renato.pinto96@email.com', 'M')
) AS v(convenio, nome, cpf, data_nascimento, telefone, email, genero)
LEFT JOIN convenios c ON c.nome = v.convenio;


-- ---------------------------------------------
-- Prontuários dos novos pacientes
-- ---------------------------------------------

INSERT INTO prontuarios (idpaciente, data_abertura, alergias, doencas_anteriores, observacoes)
SELECT p.idpaciente, v.data_abertura::DATE, v.alergias, v.doencas_anteriores, v.observacoes
FROM (VALUES
    ('Letícia Moreira', '2026-07-15', NULL, 'Gastrite', 'Faz uso de medicação contínua'),
    ('Aline Araújo', '2026-05-20', NULL, 'Rinite alérgica', 'Retorno periódico recomendado'),
    ('Letícia Cardoso', '2026-05-05', NULL, 'Hipotireoidismo', 'Em acompanhamento'),
    ('Sofia Moreira', '2026-05-14', 'Lactose', 'Bronquite', 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Yasmin Araújo', '2026-07-10', NULL, 'Hipertensão', 'Retorno periódico recomendado'),
    ('Mateus Ribeiro', '2026-06-19', NULL, 'Enxaqueca', 'Em acompanhamento'),
    ('Sérgio Batista', '2026-05-28', 'Ibuprofeno', 'Artrose', 'Retorno periódico recomendado'),
    ('Caio Gomes', '2026-06-24', NULL, 'Ansiedade', 'Retorno periódico recomendado'),
    ('Leonardo Esteves', '2026-06-24', NULL, 'Ansiedade', 'Quadro estável'),
    ('Cláudia Siqueira', '2026-06-27', NULL, 'Colesterol alto', 'Quadro estável'),
    ('Alice Moreira', '2026-05-07', 'Lactose', NULL, 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Vera Correia', '2026-05-28', NULL, 'Ansiedade', 'Retorno periódico recomendado'),
    ('Rosângela Esteves', '2026-05-08', NULL, 'Gastrite', 'Faz uso de medicação contínua'),
    ('Otávio Freitas', '2026-05-20', NULL, 'Gastrite', 'Retorno periódico recomendado'),
    ('Sérgio Siqueira', '2026-07-09', NULL, 'Hipertensão e Diabetes Tipo 2', 'Retorno periódico recomendado'),
    ('Sérgio Esteves', '2026-07-10', 'Frutos do mar', 'Rinite alérgica', 'Faz uso de medicação contínua'),
    ('Eduardo Lopes', '2026-06-22', 'Ibuprofeno', 'Artrose', 'Faz uso de medicação contínua'),
    ('Heitor Araújo', '2026-06-21', NULL, 'Rinite alérgica', 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Igor Pinto', '2026-06-24', NULL, NULL, 'Check-up anual'),
    ('Tatiane Dias', '2026-06-08', 'Lactose', 'Gastrite', 'Quadro estável'),
    ('Daniela Rocha', '2026-07-10', NULL, NULL, 'Check-up anual'),
    ('Sabrina Barbosa', '2026-06-25', NULL, 'Hipertensão e Diabetes Tipo 2', 'Quadro estável'),
    ('Fábio Rocha', '2026-06-17', NULL, 'Rinite alérgica', 'Em acompanhamento'),
    ('Luana Moreira', '2026-07-19', NULL, 'Gastrite', 'Faz uso de medicação contínua'),
    ('Sofia Queiroz', '2026-05-08', NULL, NULL, 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Igor Rocha', '2026-05-14', 'Frutos do mar', 'Enxaqueca', 'Retorno periódico recomendado'),
    ('Carla Moreira', '2026-07-03', NULL, 'Gastrite', 'Em acompanhamento'),
    ('Gustavo Araújo', '2026-06-04', NULL, NULL, 'Paciente saudável'),
    ('Bruna Siqueira', '2026-06-08', NULL, 'Gastrite', 'Em acompanhamento'),
    ('Fábio Correia', '2026-06-22', 'Dipirona', NULL, 'Paciente saudável'),
    ('Gustavo Esteves', '2026-05-27', 'Látex', NULL, 'Check-up anual'),
    ('Arthur Batista', '2026-06-11', NULL, 'Otite de repetição', 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Pedro Nascimento', '2026-06-08', NULL, NULL, 'Paciente saudável'),
    ('Carla Esteves', '2026-06-25', 'Frutos do mar', NULL, 'Check-up anual'),
    ('Raquel Batista', '2026-07-15', NULL, NULL, 'Paciente saudável'),
    ('Luana Lopes', '2026-06-02', NULL, NULL, 'Primeira consulta'),
    ('Leonardo Freitas', '2026-05-14', NULL, 'Artrose', 'Em acompanhamento'),
    ('Isabela Machado', '2026-06-04', 'Penicilina', 'Artrose', 'Faz uso de medicação contínua'),
    ('Laura Siqueira', '2026-05-28', NULL, NULL, 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Jéssica Henriques', '2026-05-23', 'Sulfas', 'Ansiedade', 'Retorno periódico recomendado'),
    ('André Freitas', '2026-07-25', 'Penicilina', 'Enxaqueca', 'Em acompanhamento'),
    ('Leonardo Correia', '2026-07-28', NULL, 'Artrose', 'Retorno periódico recomendado'),
    ('Vanessa Ribeiro', '2026-07-14', NULL, 'Diabetes Tipo 2', 'Faz uso de medicação contínua'),
    ('Cláudia Rocha', '2026-06-14', 'Lactose', 'Ansiedade', 'Retorno periódico recomendado'),
    ('Isabela Martins', '2026-07-25', NULL, 'Ansiedade', 'Faz uso de medicação contínua'),
    ('Laura Esteves', '2026-05-12', NULL, 'Rinite alérgica', 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Letícia Correia', '2026-06-04', NULL, 'Artrose', 'Quadro estável'),
    ('Renato Almeida', '2026-05-20', NULL, 'Rinite alérgica', 'Em acompanhamento'),
    ('Wagner Moreira', '2026-07-21', NULL, NULL, 'Primeira consulta'),
    ('André Henriques', '2026-07-15', 'Aspirina', 'Colesterol alto', 'Retorno periódico recomendado'),
    ('Luana Correia', '2026-06-25', NULL, NULL, 'Primeira consulta'),
    ('Bernardo Correia', '2026-06-01', NULL, 'Gastrite', 'Retorno periódico recomendado'),
    ('Miguel Cardoso', '2026-07-12', NULL, 'Rinite alérgica', 'Acompanhamento pediátrico, responsável presente nas consultas'),
    ('Luana Cardoso', '2026-06-14', NULL, 'Hipotireoidismo', 'Em acompanhamento'),
    ('Renato Pinto', '2026-06-18', NULL, NULL, 'Check-up anual')
) AS v(paciente, data_abertura, alergias, doencas_anteriores, observacoes)
JOIN pacientes p ON p.nome = v.paciente;


-- ---------------------------------------------
-- Novos agendamentos (julho a outubro de 2026)
-- ---------------------------------------------

INSERT INTO agendamentos (idpaciente, idmedico, data_agendamento, horario, status)
SELECT p.idpaciente, m.idmedico, v.data_agendamento::DATE, v.horario::TIME, v.status
FROM (VALUES
    ('Renato Pinto', 'Dr. Henrique Tavares', '2026-07-01', '09:30', 'confirmado'),
    ('Gustavo Araújo', 'Dr. Carlos Mendes', '2026-07-02', '15:00', 'cancelado'),
    ('Bruna Siqueira', 'Dr. Henrique Tavares', '2026-07-03', '08:30', 'confirmado'),
    ('Luana Cardoso', 'Dra. Larissa Campos', '2026-07-03', '14:00', 'confirmado'),
    ('Mateus Ribeiro', 'Dra. Fernanda Costa', '2026-07-06', '11:00', 'confirmado'),
    ('Fábio Correia', 'Dr. Rafael Nogueira', '2026-07-07', '08:30', 'confirmado'),
    ('Luana Correia', 'Dr. Paulo Rodrigues', '2026-07-07', '11:00', 'cancelado'),
    ('Leonardo Freitas', 'Dr. Carlos Mendes', '2026-07-08', '10:00', 'confirmado'),
    ('Bernardo Correia', 'Dra. Larissa Campos', '2026-07-09', '11:00', 'cancelado'),
    ('Bruna Siqueira', 'Dra. Larissa Campos', '2026-07-10', '08:30', 'confirmado'),
    ('Luana Moreira', 'Dr. Paulo Rodrigues', '2026-07-13', '17:00', 'confirmado'),
    ('Luana Cardoso', 'Dr. Bruno Lima', '2026-07-14', '11:00', 'cancelado'),
    ('Sérgio Batista', 'Dr. Carlos Mendes', '2026-07-14', '14:30', 'confirmado'),
    ('Heitor Araújo', 'Dra. Ana Paula Silva', '2026-07-15', '15:30', 'confirmado'),
    ('Luana Moreira', 'Dra. Fernanda Costa', '2026-07-16', '13:00', 'confirmado'),
    ('Sabrina Barbosa', 'Dra. Mariana Duarte', '2026-07-16', '15:00', 'confirmado'),
    ('Yasmin Araújo', 'Dra. Fernanda Costa', '2026-07-17', '15:30', 'confirmado'),
    ('Bruna Siqueira', 'Dra. Larissa Campos', '2026-07-20', '08:30', 'confirmado'),
    ('Aline Araújo', 'Dr. Rafael Nogueira', '2026-07-20', '13:30', 'confirmado'),
    ('Aline Araújo', 'Dra. Beatriz Moura', '2026-07-21', '09:30', 'confirmado'),
    ('Leonardo Esteves', 'Dra. Camila Ferreira', '2026-07-21', '11:30', 'confirmado'),
    ('Letícia Correia', 'Dra. Mariana Duarte', '2026-07-22', '08:00', 'confirmado'),
    ('Igor Pinto', 'Dr. Carlos Mendes', '2026-07-22', '09:30', 'confirmado'),
    ('Jéssica Henriques', 'Dra. Camila Ferreira', '2026-07-22', '09:30', 'cancelado'),
    ('Rosângela Esteves', 'Dra. Larissa Campos', '2026-07-22', '15:30', 'confirmado'),
    ('Otávio Freitas', 'Dra. Larissa Campos', '2026-07-23', '09:00', 'confirmado'),
    ('Laura Siqueira', 'Dr. Thiago Barros', '2026-07-23', '09:30', 'confirmado'),
    ('Daniela Rocha', 'Dr. Ricardo Oliveira', '2026-07-23', '13:30', 'confirmado'),
    ('André Henriques', 'Dr. Ricardo Oliveira', '2026-07-23', '17:30', 'confirmado'),
    ('Renato Pinto', 'Dra. Larissa Campos', '2026-07-24', '09:30', 'confirmado'),
    ('Leonardo Esteves', 'Dra. Camila Ferreira', '2026-07-24', '10:00', 'confirmado'),
    ('Wagner Moreira', 'Dr. Felipe Alves', '2026-07-24', '15:00', 'confirmado'),
    ('Cláudia Rocha', 'Dra. Camila Ferreira', '2026-07-28', '08:00', 'cancelado'),
    ('Isabela Martins', 'Dra. Fernanda Costa', '2026-07-28', '08:00', 'confirmado'),
    ('Mateus Ribeiro', 'Dr. Marcos Souza', '2026-07-28', '14:00', 'confirmado'),
    ('Vanessa Ribeiro', 'Dra. Mariana Duarte', '2026-07-29', '13:00', 'confirmado'),
    ('Carla Esteves', 'Dra. Renata Cardoso', '2026-07-30', '11:00', 'confirmado'),
    ('Luana Cardoso', 'Dr. Henrique Tavares', '2026-07-31', '08:00', 'confirmado'),
    ('Fábio Rocha', 'Dr. Rafael Nogueira', '2026-07-31', '11:30', 'cancelado'),
    ('Letícia Moreira', 'Dra. Larissa Campos', '2026-07-31', '14:30', 'cancelado'),
    ('Cláudia Rocha', 'Dra. Juliana Santos', '2026-07-31', '17:00', 'confirmado'),
    ('Letícia Cardoso', 'Dr. Rafael Nogueira', '2026-08-04', '15:30', 'confirmado'),
    ('Wagner Moreira', 'Dr. Felipe Alves', '2026-08-04', '17:00', 'cancelado'),
    ('Otávio Freitas', 'Dra. Larissa Campos', '2026-08-05', '17:30', 'confirmado'),
    ('Caio Gomes', 'Dra. Camila Ferreira', '2026-08-10', '14:00', 'confirmado'),
    ('Miguel Cardoso', 'Dra. Ana Paula Silva', '2026-08-10', '14:30', 'confirmado'),
    ('Alice Moreira', 'Dr. Thiago Barros', '2026-08-10', '16:30', 'confirmado'),
    ('Luana Lopes', 'Dr. Marcos Souza', '2026-08-13', '09:00', 'cancelado'),
    ('Letícia Moreira', 'Dra. Juliana Santos', '2026-08-14', '11:00', 'confirmado'),
    ('Cláudia Siqueira', 'Dr. Carlos Mendes', '2026-08-14', '14:30', 'confirmado'),
    ('Vera Correia', 'Dr. Henrique Tavares', '2026-08-18', '15:00', 'cancelado'),
    ('Vanessa Ribeiro', 'Dra. Beatriz Moura', '2026-08-18', '16:00', 'cancelado'),
    ('Sofia Queiroz', 'Dra. Ana Paula Silva', '2026-08-19', '08:30', 'confirmado'),
    ('Carla Moreira', 'Dra. Larissa Campos', '2026-08-20', '13:00', 'confirmado'),
    ('Letícia Cardoso', 'Dra. Juliana Santos', '2026-08-20', '14:30', 'confirmado'),
    ('Ana Oliveira', 'Dr. Marcos Souza', '2026-08-25', '09:00', 'confirmado'),
    ('Vanessa Ribeiro', 'Dr. Bruno Lima', '2026-08-26', '11:00', 'confirmado'),
    ('André Freitas', 'Dr. Marcos Souza', '2026-08-26', '15:30', 'confirmado'),
    ('Roberto Costa', 'Dr. Ricardo Oliveira', '2026-08-27', '11:00', 'confirmado'),
    ('Igor Rocha', 'Dr. Marcos Souza', '2026-08-27', '11:30', 'confirmado'),
    ('Sabrina Barbosa', 'Dra. Beatriz Moura', '2026-08-28', '11:00', 'confirmado'),
    ('Letícia Moreira', 'Dr. Henrique Tavares', '2026-08-28', '13:00', 'confirmado'),
    ('Miguel Cardoso', 'Dr. Thiago Barros', '2026-08-31', '08:30', 'confirmado'),
    ('Isabela Machado', 'Dr. Carlos Mendes', '2026-08-31', '10:30', 'confirmado'),
    ('Renato Almeida', 'Dra. Beatriz Moura', '2026-08-31', '15:00', 'confirmado'),
    ('André Henriques', 'Dra. Mariana Duarte', '2026-09-01', '08:30', 'confirmado'),
    ('Daniela Rocha', 'Dr. Rafael Nogueira', '2026-09-01', '15:00', 'cancelado'),
    ('Arthur Batista', 'Dra. Ana Paula Silva', '2026-09-02', '09:00', 'confirmado'),
    ('Eduardo Lopes', 'Dr. Paulo Rodrigues', '2026-09-03', '17:30', 'cancelado'),
    ('Gustavo Araújo', 'Dr. Marcos Souza', '2026-09-04', '17:30', 'confirmado'),
    ('Maria Silva', 'Dr. Ricardo Oliveira', '2026-09-09', '13:30', 'confirmado'),
    ('Leonardo Correia', 'Dr. Henrique Tavares', '2026-09-09', '15:30', 'confirmado'),
    ('Gustavo Esteves', 'Dr. Carlos Mendes', '2026-09-10', '09:30', 'confirmado'),
    ('André Freitas', 'Dra. Mariana Duarte', '2026-09-10', '14:00', 'confirmado'),
    ('Laura Esteves', 'Dra. Ana Paula Silva', '2026-09-10', '17:00', 'confirmado'),
    ('Sofia Queiroz', 'Dra. Ana Paula Silva', '2026-09-14', '09:30', 'confirmado'),
    ('Igor Pinto', 'Dra. Beatriz Moura', '2026-09-15', '11:00', 'confirmado'),
    ('Daniela Rocha', 'Dra. Juliana Santos', '2026-09-16', '15:30', 'confirmado'),
    ('Luana Moreira', 'Dra. Larissa Campos', '2026-09-21', '13:00', 'cancelado'),
    ('Sofia Moreira', 'Dr. Thiago Barros', '2026-09-21', '16:30', 'confirmado'),
    ('Bernardo Correia', 'Dra. Beatriz Moura', '2026-09-23', '09:30', 'confirmado'),
    ('Cláudia Siqueira', 'Dr. Paulo Rodrigues', '2026-09-23', '10:00', 'confirmado'),
    ('Fábio Correia', 'Dra. Larissa Campos', '2026-09-24', '17:00', 'confirmado'),
    ('Luana Correia', 'Dr. Henrique Tavares', '2026-09-25', '15:00', 'cancelado'),
    ('Fábio Correia', 'Dra. Beatriz Moura', '2026-09-28', '11:30', 'confirmado'),
    ('Raquel Batista', 'Dr. Carlos Mendes', '2026-09-28', '14:00', 'cancelado'),
    ('Pedro Nascimento', 'Dra. Beatriz Moura', '2026-09-30', '08:30', 'pendente'),
    ('Carla Moreira', 'Dra. Larissa Campos', '2026-10-01', '17:30', 'pendente'),
    ('Renato Almeida', 'Dr. Rafael Nogueira', '2026-10-05', '09:30', 'pendente'),
    ('Letícia Cardoso', 'Dr. Bruno Lima', '2026-10-05', '15:00', 'confirmado'),
    ('Alice Moreira', 'Dra. Ana Paula Silva', '2026-10-05', '17:30', 'pendente'),
    ('Sabrina Barbosa', 'Dr. Marcos Souza', '2026-10-06', '13:00', 'confirmado'),
    ('João Santos', 'Dr. Bruno Lima', '2026-10-09', '08:00', 'pendente'),
    ('Aline Araújo', 'Dr. Rafael Nogueira', '2026-10-14', '08:30', 'pendente'),
    ('André Henriques', 'Dra. Mariana Duarte', '2026-10-14', '09:30', 'pendente'),
    ('Isabela Machado', 'Dra. Beatriz Moura', '2026-10-15', '11:00', 'pendente'),
    ('Luana Correia', 'Dr. Carlos Mendes', '2026-10-15', '11:00', 'pendente'),
    ('Juliana Souza', 'Dra. Camila Ferreira', '2026-10-15', '14:30', 'pendente'),
    ('Carla Esteves', 'Dra. Beatriz Moura', '2026-10-21', '08:00', 'confirmado'),
    ('Sérgio Siqueira', 'Dra. Mariana Duarte', '2026-10-21', '09:30', 'pendente'),
    ('Heitor Araújo', 'Dr. Thiago Barros', '2026-10-22', '15:00', 'pendente'),
    ('Sérgio Esteves', 'Dr. Rafael Nogueira', '2026-10-29', '16:30', 'confirmado'),
    ('Heitor Araújo', 'Dra. Ana Paula Silva', '2026-10-30', '08:30', 'pendente'),
    ('Letícia Correia', 'Dr. Henrique Tavares', '2026-10-30', '08:30', 'pendente'),
    ('Tatiane Dias', 'Dra. Larissa Campos', '2026-10-30', '09:30', 'pendente'),
    ('Sérgio Siqueira', 'Dr. Carlos Mendes', '2026-10-30', '17:30', 'confirmado')
) AS v(paciente, medico, data_agendamento, horario, status)
JOIN pacientes p ON p.nome = v.paciente
JOIN medicos m ON m.nome = v.medico;


-- ---------------------------------------------
-- Novas consultas (agendamentos confirmados que já aconteceram)
-- ---------------------------------------------

INSERT INTO consultas (idpaciente, idmedico, idagendamento, data_consulta, horario, observacoes)
SELECT a.idpaciente, a.idmedico, a.idagendamento, a.data_agendamento, a.horario, v.observacoes
FROM (VALUES
    ('Renato Pinto', '2026-07-01', 'Check-up anual'),
    ('Bruna Siqueira', '2026-07-03', 'Gripe com febre e dor no corpo'),
    ('Luana Cardoso', '2026-07-03', 'Azia e queimação frequentes'),
    ('Mateus Ribeiro', '2026-07-06', 'Dermatite de contato'),
    ('Fábio Correia', '2026-07-07', 'Perda auditiva leve'),
    ('Leonardo Freitas', '2026-07-08', 'Entorse de tornozelo'),
    ('Bruna Siqueira', '2026-07-10', 'Dor abdominal e intestino irregular'),
    ('Luana Moreira', '2026-07-13', 'Dificuldade para enxergar de longe'),
    ('Sérgio Batista', '2026-07-14', 'Dor lombar após esforço físico'),
    ('Heitor Araújo', '2026-07-15', 'Febre e dor de garganta há 2 dias'),
    ('Luana Moreira', '2026-07-16', 'Mancha na pele, avaliação de lesão'),
    ('Sabrina Barbosa', '2026-07-16', 'Palpitações ocasionais, investigar arritmia'),
    ('Yasmin Araújo', '2026-07-17', 'Acne moderada'),
    ('Bruna Siqueira', '2026-07-20', 'Dor abdominal e intestino irregular'),
    ('Aline Araújo', '2026-07-20', 'Rinite alérgica'),
    ('Aline Araújo', '2026-07-21', 'Gripe com febre e dor no corpo'),
    ('Leonardo Esteves', '2026-07-21', 'Retorno, paciente com melhora do quadro'),
    ('Letícia Correia', '2026-07-22', 'Palpitações ocasionais, investigar arritmia'),
    ('Igor Pinto', '2026-07-22', 'Dor no joelho, suspeita de artrose'),
    ('Rosângela Esteves', '2026-07-22', 'Dor abdominal e intestino irregular'),
    ('Otávio Freitas', '2026-07-23', 'Dor abdominal e intestino irregular'),
    ('Laura Siqueira', '2026-07-23', 'Febre e dor de garganta há 2 dias'),
    ('Daniela Rocha', '2026-07-23', 'Pressão arterial elevada, ajuste de medicação'),
    ('André Henriques', '2026-07-23', 'Palpitações ocasionais, investigar arritmia'),
    ('Renato Pinto', '2026-07-24', 'Dor abdominal e intestino irregular'),
    ('Leonardo Esteves', '2026-07-24', 'Insônia persistente'),
    ('Wagner Moreira', '2026-07-24', 'Infecção urinária'),
    ('Isabela Martins', '2026-07-28', 'Mancha na pele, avaliação de lesão'),
    ('Mateus Ribeiro', '2026-07-28', 'Enxaqueca frequente'),
    ('Vanessa Ribeiro', '2026-07-29', 'Colesterol elevado, orientação de dieta'),
    ('Luana Cardoso', '2026-07-31', 'Cansaço, solicitar exames gerais'),
    ('Cláudia Rocha', '2026-07-31', 'Cólicas intensas no período menstrual'),
    ('Letícia Cardoso', '2026-08-04', 'Dor de ouvido, otite externa'),
    ('Otávio Freitas', '2026-08-05', 'Dor abdominal e intestino irregular'),
    ('Caio Gomes', '2026-08-10', 'Insônia persistente'),
    ('Miguel Cardoso', '2026-08-10', 'Tosse e coriza, quadro viral'),
    ('Alice Moreira', '2026-08-10', 'Consulta de puericultura, desenvolvimento adequado'),
    ('Letícia Moreira', '2026-08-14', 'Exames preventivos anuais'),
    ('Cláudia Siqueira', '2026-08-14', 'Entorse de tornozelo'),
    ('Sofia Queiroz', '2026-08-19', 'Febre e dor de garganta há 2 dias'),
    ('Carla Moreira', '2026-08-20', 'Azia e queimação frequentes'),
    ('Letícia Cardoso', '2026-08-20', 'Exames preventivos anuais'),
    ('Vanessa Ribeiro', '2026-08-26', 'Cansaço e ganho de peso, investigar tireoide'),
    ('André Freitas', '2026-08-26', 'Tontura e formigamento nas mãos'),
    ('Roberto Costa', '2026-08-27', 'Retorno, colesterol em queda'),
    ('Igor Rocha', '2026-08-27', 'Enxaqueca frequente'),
    ('Sabrina Barbosa', '2026-08-28', 'Cansaço, solicitar exames gerais'),
    ('Letícia Moreira', '2026-08-28', 'Gripe com febre e dor no corpo'),
    ('Miguel Cardoso', '2026-08-31', 'Febre e dor de garganta há 2 dias'),
    ('Isabela Machado', '2026-08-31', 'Dor lombar após esforço físico'),
    ('Renato Almeida', '2026-08-31', 'Cansaço, solicitar exames gerais'),
    ('André Henriques', '2026-09-01', 'Colesterol elevado, orientação de dieta'),
    ('Arthur Batista', '2026-09-02', 'Febre e dor de garganta há 2 dias'),
    ('Gustavo Araújo', '2026-09-04', 'Tontura e formigamento nas mãos'),
    ('Maria Silva', '2026-09-09', 'Retorno, pressão controlada com a medicação'),
    ('Leonardo Correia', '2026-09-09', 'Cansaço, solicitar exames gerais'),
    ('Gustavo Esteves', '2026-09-10', 'Entorse de tornozelo'),
    ('André Freitas', '2026-09-10', 'Pressão arterial elevada, ajuste de medicação'),
    ('Laura Esteves', '2026-09-10', 'Febre e dor de garganta há 2 dias'),
    ('Sofia Queiroz', '2026-09-14', 'Consulta de puericultura, desenvolvimento adequado'),
    ('Igor Pinto', '2026-09-15', 'Check-up anual'),
    ('Sofia Moreira', '2026-09-21', 'Crise leve de bronquite'),
    ('Cláudia Siqueira', '2026-09-23', 'Exame de rotina para renovação de óculos'),
    ('Fábio Correia', '2026-09-24', 'Dor abdominal e intestino irregular'),
    ('Fábio Correia', '2026-09-28', 'Crise de asma leve')
) AS v(paciente, data_consulta, observacoes)
JOIN pacientes p ON p.nome = v.paciente
JOIN agendamentos a ON a.idpaciente = p.idpaciente AND a.data_agendamento = v.data_consulta::DATE;


-- ---------------------------------------------
-- Novas receitas
-- ---------------------------------------------

INSERT INTO receitas (idconsulta, data_emissao, observacoes)
SELECT c.idconsulta, c.data_consulta, v.observacoes
FROM (VALUES
    ('Bruna Siqueira', '2026-07-03', 'Tomar medicação conforme prescrito. Retorno em 90 dias'),
    ('Luana Cardoso', '2026-07-03', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Mateus Ribeiro', '2026-07-06', 'Tomar medicação conforme prescrito. Retorno em 30 dias'),
    ('Leonardo Freitas', '2026-07-08', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Bruna Siqueira', '2026-07-10', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Sérgio Batista', '2026-07-14', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Heitor Araújo', '2026-07-15', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Yasmin Araújo', '2026-07-17', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Bruna Siqueira', '2026-07-20', 'Tomar medicação conforme prescrito. Retorno em 30 dias'),
    ('Aline Araújo', '2026-07-20', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Aline Araújo', '2026-07-21', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Leonardo Esteves', '2026-07-21', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Igor Pinto', '2026-07-22', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Rosângela Esteves', '2026-07-22', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Otávio Freitas', '2026-07-23', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Laura Siqueira', '2026-07-23', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Daniela Rocha', '2026-07-23', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Renato Pinto', '2026-07-24', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Leonardo Esteves', '2026-07-24', 'Tomar medicação conforme prescrito. Retorno em 30 dias'),
    ('Wagner Moreira', '2026-07-24', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Mateus Ribeiro', '2026-07-28', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Vanessa Ribeiro', '2026-07-29', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Cláudia Rocha', '2026-07-31', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Letícia Cardoso', '2026-08-04', 'Tomar medicação conforme prescrito. Retorno em 90 dias'),
    ('Otávio Freitas', '2026-08-05', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Caio Gomes', '2026-08-10', 'Tomar medicação conforme prescrito. Retorno em 30 dias'),
    ('Miguel Cardoso', '2026-08-10', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Cláudia Siqueira', '2026-08-14', 'Tomar medicação conforme prescrito. Retorno em 30 dias'),
    ('Sofia Queiroz', '2026-08-19', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Carla Moreira', '2026-08-20', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Roberto Costa', '2026-08-27', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Igor Rocha', '2026-08-27', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Letícia Moreira', '2026-08-28', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Miguel Cardoso', '2026-08-31', 'Tomar medicação conforme prescrito. Retorno em 90 dias'),
    ('Isabela Machado', '2026-08-31', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('André Henriques', '2026-09-01', 'Tomar medicação conforme prescrito. Retorno se não houver melhora'),
    ('Arthur Batista', '2026-09-02', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('Maria Silva', '2026-09-09', 'Tomar medicação conforme prescrito. Retorno em 60 dias'),
    ('Gustavo Esteves', '2026-09-10', 'Tomar medicação conforme prescrito. Retorno em 15 dias'),
    ('André Freitas', '2026-09-10', 'Tomar medicação conforme prescrito. Retorno em 30 dias'),
    ('Laura Esteves', '2026-09-10', 'Tomar medicação conforme prescrito. Retorno em 90 dias'),
    ('Sofia Moreira', '2026-09-21', 'Tomar medicação conforme prescrito. Retorno em 90 dias'),
    ('Fábio Correia', '2026-09-24', 'Tomar medicação conforme prescrito. Retorno em 90 dias'),
    ('Fábio Correia', '2026-09-28', 'Tomar medicação conforme prescrito. Retorno em 30 dias')
) AS v(paciente, data_consulta, observacoes)
JOIN pacientes p ON p.nome = v.paciente
JOIN consultas c ON c.idpaciente = p.idpaciente AND c.data_consulta = v.data_consulta::DATE;


-- ---------------------------------------------
-- Medicamentos das novas receitas
-- ---------------------------------------------

INSERT INTO medicamentos (idreceita, nome, dosagem, quantidade, instrucoes)
SELECT r.idreceita, v.nome, v.dosagem, v.quantidade, v.instrucoes
FROM (VALUES
    ('Bruna Siqueira', '2026-07-03', 'Paracetamol', '750mg', 1, 'Tomar 1 comprimido de 6 em 6 horas se febre'),
    ('Luana Cardoso', '2026-07-03', 'Omeprazol', '20mg', 2, 'Tomar 1 cápsula em jejum'),
    ('Mateus Ribeiro', '2026-07-06', 'Hidrocortisona creme', '1%', 1, 'Aplicar 2 vezes ao dia por 7 dias'),
    ('Leonardo Freitas', '2026-07-08', 'Paracetamol', '750mg', 1, 'Tomar 1 comprimido de 8 em 8 horas se dor'),
    ('Bruna Siqueira', '2026-07-10', 'Simeticona', '40mg', 1, 'Tomar 1 comprimido após as refeições'),
    ('Sérgio Batista', '2026-07-14', 'Ciclobenzaprina', '5mg', 1, 'Tomar 1 comprimido à noite por 7 dias'),
    ('Heitor Araújo', '2026-07-15', 'Paracetamol gotas', '200mg/ml', 1, 'Dar 1 gota por kg a cada 6 horas se febre'),
    ('Yasmin Araújo', '2026-07-17', 'Adapaleno gel', '0,1%', 1, 'Aplicar à noite no rosto limpo'),
    ('Bruna Siqueira', '2026-07-20', 'Simeticona', '40mg', 1, 'Tomar 1 comprimido após as refeições'),
    ('Aline Araújo', '2026-07-20', 'Budesonida spray', '64mcg', 1, 'Aplicar 1 jato em cada narina 2 vezes ao dia'),
    ('Aline Araújo', '2026-07-21', 'Paracetamol', '750mg', 1, 'Tomar 1 comprimido de 6 em 6 horas se febre'),
    ('Leonardo Esteves', '2026-07-21', 'Sertralina', '50mg', 2, 'Manter 1 comprimido pela manhã'),
    ('Igor Pinto', '2026-07-22', 'Glucosamina', '1500mg', 2, 'Tomar 1 sachê por dia'),
    ('Rosângela Esteves', '2026-07-22', 'Simeticona', '40mg', 1, 'Tomar 1 comprimido após as refeições'),
    ('Otávio Freitas', '2026-07-23', 'Simeticona', '40mg', 1, 'Tomar 1 comprimido após as refeições'),
    ('Laura Siqueira', '2026-07-23', 'Paracetamol gotas', '200mg/ml', 1, 'Dar 1 gota por kg a cada 6 horas se febre'),
    ('Daniela Rocha', '2026-07-23', 'Losartana', '50mg', 1, 'Tomar 1 comprimido por dia pela manhã'),
    ('Renato Pinto', '2026-07-24', 'Simeticona', '40mg', 1, 'Tomar 1 comprimido após as refeições'),
    ('Leonardo Esteves', '2026-07-24', 'Melatonina', '3mg', 1, 'Tomar 1 comprimido 30 minutos antes de dormir'),
    ('Wagner Moreira', '2026-07-24', 'Nitrofurantoína', '100mg', 1, 'Tomar 1 cápsula de 6 em 6 horas por 7 dias'),
    ('Mateus Ribeiro', '2026-07-28', 'Topiramato', '25mg', 2, 'Tomar 1 comprimido à noite'),
    ('Vanessa Ribeiro', '2026-07-29', 'Atorvastatina', '20mg', 1, 'Tomar 1 comprimido à noite'),
    ('Cláudia Rocha', '2026-07-31', 'Ácido Mefenâmico', '500mg', 1, 'Tomar 1 comprimido de 8 em 8 horas durante a menstruação'),
    ('Letícia Cardoso', '2026-08-04', 'Ciprofloxacino otológico', '0,3%', 1, 'Pingar 3 gotas no ouvido 2 vezes ao dia por 7 dias'),
    ('Otávio Freitas', '2026-08-05', 'Simeticona', '40mg', 1, 'Tomar 1 comprimido após as refeições'),
    ('Caio Gomes', '2026-08-10', 'Melatonina', '3mg', 1, 'Tomar 1 comprimido 30 minutos antes de dormir'),
    ('Miguel Cardoso', '2026-08-10', 'Soro fisiológico nasal', '0,9%', 2, 'Aplicar 2 jatos em cada narina 4 vezes ao dia'),
    ('Cláudia Siqueira', '2026-08-14', 'Paracetamol', '750mg', 1, 'Tomar 1 comprimido de 8 em 8 horas se dor'),
    ('Sofia Queiroz', '2026-08-19', 'Paracetamol gotas', '200mg/ml', 1, 'Dar 1 gota por kg a cada 6 horas se febre'),
    ('Carla Moreira', '2026-08-20', 'Omeprazol', '20mg', 2, 'Tomar 1 cápsula em jejum'),
    ('Roberto Costa', '2026-08-27', 'Atorvastatina', '20mg', 1, 'Manter 1 comprimido à noite'),
    ('Igor Rocha', '2026-08-27', 'Topiramato', '25mg', 2, 'Tomar 1 comprimido à noite'),
    ('Letícia Moreira', '2026-08-28', 'Paracetamol', '750mg', 1, 'Tomar 1 comprimido de 6 em 6 horas se febre'),
    ('Miguel Cardoso', '2026-08-31', 'Paracetamol gotas', '200mg/ml', 1, 'Dar 1 gota por kg a cada 6 horas se febre'),
    ('Isabela Machado', '2026-08-31', 'Ciclobenzaprina', '5mg', 1, 'Tomar 1 comprimido à noite por 7 dias'),
    ('André Henriques', '2026-09-01', 'Atorvastatina', '20mg', 1, 'Tomar 1 comprimido à noite'),
    ('Arthur Batista', '2026-09-02', 'Paracetamol gotas', '200mg/ml', 1, 'Dar 1 gota por kg a cada 6 horas se febre'),
    ('Maria Silva', '2026-09-09', 'Losartana', '50mg', 1, 'Manter 1 comprimido por dia pela manhã'),
    ('Gustavo Esteves', '2026-09-10', 'Paracetamol', '750mg', 1, 'Tomar 1 comprimido de 8 em 8 horas se dor'),
    ('André Freitas', '2026-09-10', 'Losartana', '50mg', 1, 'Tomar 1 comprimido por dia pela manhã'),
    ('Laura Esteves', '2026-09-10', 'Paracetamol gotas', '200mg/ml', 1, 'Dar 1 gota por kg a cada 6 horas se febre'),
    ('Sofia Moreira', '2026-09-21', 'Salbutamol spray', '100mcg', 1, 'Aplicar 2 jatos com espaçador a cada 6 horas'),
    ('Fábio Correia', '2026-09-24', 'Simeticona', '40mg', 1, 'Tomar 1 comprimido após as refeições'),
    ('Fábio Correia', '2026-09-28', 'Salbutamol spray', '100mcg', 1, 'Aplicar 2 jatos a cada 6 horas se falta de ar')
) AS v(paciente, data_consulta, nome, dosagem, quantidade, instrucoes)
JOIN pacientes p ON p.nome = v.paciente
JOIN consultas c ON c.idpaciente = p.idpaciente AND c.data_consulta = v.data_consulta::DATE
JOIN receitas r ON r.idconsulta = c.idconsulta;


-- ---------------------------------------------
-- Exames das novas consultas
-- ---------------------------------------------

INSERT INTO exames (idconsulta, data_solicitacao, nome, data_resultado, resultado, observacoes)
SELECT c.idconsulta, c.data_consulta, v.nome, v.data_resultado::DATE, v.resultado, v.observacoes
FROM (VALUES
    ('Renato Pinto', '2026-07-01', 'Hemograma Completo', '2026-07-06', 'Alterado', 'Hemoglobina levemente baixa'),
    ('Renato Pinto', '2026-07-01', 'Glicemia em Jejum', '2026-07-04', 'Alterado', 'Glicemia 138mg/dL, acima do normal'),
    ('Renato Pinto', '2026-07-01', 'Colesterol Total', '2026-07-09', 'Normal', 'Colesterol 180mg/dL, dentro do ideal'),
    ('Luana Cardoso', '2026-07-03', 'Endoscopia Digestiva Alta', '2026-07-13', 'Normal', 'Sem alterações'),
    ('Fábio Correia', '2026-07-07', 'Audiometria', '2026-07-11', 'Normal', 'Audição normal'),
    ('Leonardo Freitas', '2026-07-08', 'Raio-x Tornozelo', '2026-07-12', 'Normal', 'Sem fraturas'),
    ('Bruna Siqueira', '2026-07-10', 'Ultrassom Abdominal', '2026-07-13', 'Alterado', 'Esteatose hepática leve'),
    ('Luana Moreira', '2026-07-13', 'Acuidade Visual', '2026-07-18', 'Normal', 'Visão 20/20'),
    ('Luana Moreira', '2026-07-13', 'Mapeamento de Retina', '2026-07-16', 'Alterado', 'Alteração periférica leve'),
    ('Sérgio Batista', '2026-07-14', 'Raio-x Coluna Lombar', '2026-07-20', 'Normal', 'Sem alterações ósseas'),
    ('Heitor Araújo', '2026-07-15', 'Teste rápido Estreptococo', '2026-07-24', 'Alterado', 'Positivo para Estreptococo'),
    ('Luana Moreira', '2026-07-16', 'Dermatoscopia', '2026-07-18', 'Normal', 'Lesão benigna'),
    ('Sabrina Barbosa', '2026-07-16', 'Holter 24h', '2026-07-20', 'Normal', 'Sem arritmias significativas'),
    ('Sabrina Barbosa', '2026-07-16', 'Eletrocardiograma', '2026-07-23', 'Alterado', 'Alteração discreta de repolarização'),
    ('Bruna Siqueira', '2026-07-20', 'Ultrassom Abdominal', '2026-07-24', 'Alterado', 'Esteatose hepática leve'),
    ('Letícia Correia', '2026-07-22', 'Holter 24h', '2026-07-28', 'Alterado', 'Extrassístoles isoladas'),
    ('Letícia Correia', '2026-07-22', 'Eletrocardiograma', '2026-07-30', 'Normal', 'Ritmo sinusal normal'),
    ('Igor Pinto', '2026-07-22', 'Ressonância Magnética Joelho', '2026-07-31', 'Normal', 'Estruturas preservadas'),
    ('Rosângela Esteves', '2026-07-22', 'Ultrassom Abdominal', '2026-07-27', 'Normal', 'Órgãos abdominais normais'),
    ('Otávio Freitas', '2026-07-23', 'Ultrassom Abdominal', '2026-08-01', 'Normal', 'Órgãos abdominais normais'),
    ('Laura Siqueira', '2026-07-23', 'Teste rápido Estreptococo', '2026-07-28', 'Alterado', 'Positivo para Estreptococo'),
    ('Daniela Rocha', '2026-07-23', 'Eletrocardiograma', '2026-07-27', 'Normal', 'Ritmo sinusal normal'),
    ('Daniela Rocha', '2026-07-23', 'MAPA 24h', '2026-07-25', 'Normal', 'Média pressórica dentro do normal'),
    ('André Henriques', '2026-07-23', 'Holter 24h', '2026-07-29', 'Normal', 'Sem arritmias significativas'),
    ('André Henriques', '2026-07-23', 'Eletrocardiograma', '2026-07-26', 'Alterado', 'Alteração discreta de repolarização'),
    ('Renato Pinto', '2026-07-24', 'Ultrassom Abdominal', '2026-07-31', 'Normal', 'Órgãos abdominais normais'),
    ('Wagner Moreira', '2026-07-24', 'Urina Tipo 1', '2026-07-30', 'Normal', 'Sem alterações'),
    ('Wagner Moreira', '2026-07-24', 'Urocultura', '2026-08-01', 'Normal', 'Negativa'),
    ('Isabela Martins', '2026-07-28', 'Dermatoscopia', '2026-08-07', 'Alterado', 'Lesão atípica, recomendada biópsia'),
    ('Mateus Ribeiro', '2026-07-28', 'Ressonância Magnética Crânio', '2026-07-30', 'Alterado', 'Pequenas alterações inespecíficas'),
    ('Vanessa Ribeiro', '2026-07-29', 'Colesterol Total', '2026-08-04', 'Normal', 'Colesterol 180mg/dL, dentro do ideal'),
    ('Vanessa Ribeiro', '2026-07-29', 'Triglicerídeos', '2026-08-05', 'Alterado', 'Triglicerídeos 210mg/dL, elevado'),
    ('Luana Cardoso', '2026-07-31', 'Hemograma Completo', '2026-08-06', 'Normal', 'Todos os valores dentro do esperado'),
    ('Luana Cardoso', '2026-07-31', 'Ferritina', '2026-08-02', 'Alterado', 'Ferritina baixa'),
    ('Luana Cardoso', '2026-07-31', 'Vitamina D', '2026-08-05', 'Alterado', 'Vitamina D 18ng/mL, insuficiente'),
    ('Cláudia Rocha', '2026-07-31', 'Ultrassom Pélvico', '2026-08-07', 'Normal', 'Sem alterações'),
    ('Otávio Freitas', '2026-08-05', 'Ultrassom Abdominal', '2026-08-11', 'Normal', 'Órgãos abdominais normais'),
    ('Alice Moreira', '2026-08-10', 'Hemograma Completo', '2026-08-12', 'Normal', 'Todos os valores dentro do esperado'),
    ('Letícia Moreira', '2026-08-14', 'Mamografia', '2026-08-19', 'Normal', 'BI-RADS 1, sem alterações'),
    ('Letícia Moreira', '2026-08-14', 'Papanicolau', '2026-08-24', 'Normal', 'Sem alterações'),
    ('Cláudia Siqueira', '2026-08-14', 'Raio-x Tornozelo', '2026-08-17', 'Normal', 'Sem fraturas'),
    ('Sofia Queiroz', '2026-08-19', 'Teste rápido Estreptococo', '2026-08-27', 'Alterado', 'Positivo para Estreptococo'),
    ('Carla Moreira', '2026-08-20', 'Endoscopia Digestiva Alta', '2026-08-22', 'Alterado', 'Gastrite enantematosa leve'),
    ('Letícia Cardoso', '2026-08-20', 'Mamografia', '2026-08-23', 'Normal', 'BI-RADS 1, sem alterações'),
    ('Letícia Cardoso', '2026-08-20', 'Papanicolau', '2026-08-27', 'Normal', 'Sem alterações'),
    ('Vanessa Ribeiro', '2026-08-26', 'TSH', '2026-09-01', 'Normal', 'TSH 2,1 mUI/L'),
    ('Vanessa Ribeiro', '2026-08-26', 'T4 Livre', '2026-09-01', 'Normal', 'T4 livre normal'),
    ('André Freitas', '2026-08-26', 'Eletroneuromiografia', '2026-09-02', 'Alterado', 'Compressão leve do nervo mediano'),
    ('André Freitas', '2026-08-26', 'Vitamina B12', '2026-09-02', 'Normal', 'B12 dentro do normal'),
    ('Roberto Costa', '2026-08-27', 'Colesterol Total', '2026-09-03', 'Normal', 'Colesterol 180mg/dL, dentro do ideal'),
    ('Igor Rocha', '2026-08-27', 'Ressonância Magnética Crânio', '2026-09-01', 'Normal', 'Sem alterações'),
    ('Sabrina Barbosa', '2026-08-28', 'Hemograma Completo', '2026-09-01', 'Normal', 'Todos os valores dentro do esperado'),
    ('Sabrina Barbosa', '2026-08-28', 'Ferritina', '2026-08-30', 'Normal', 'Ferritina normal'),
    ('Sabrina Barbosa', '2026-08-28', 'Vitamina D', '2026-09-04', 'Alterado', 'Vitamina D 18ng/mL, insuficiente'),
    ('Miguel Cardoso', '2026-08-31', 'Teste rápido Estreptococo', '2026-09-02', 'Normal', 'Negativo'),
    ('Isabela Machado', '2026-08-31', 'Raio-x Coluna Lombar', '2026-09-04', 'Normal', 'Sem alterações ósseas'),
    ('Renato Almeida', '2026-08-31', 'Hemograma Completo', '2026-09-03', 'Normal', 'Todos os valores dentro do esperado'),
    ('Renato Almeida', '2026-08-31', 'Ferritina', '2026-09-10', 'Normal', 'Ferritina normal'),
    ('Renato Almeida', '2026-08-31', 'Vitamina D', '2026-09-02', 'Alterado', 'Vitamina D 18ng/mL, insuficiente'),
    ('André Henriques', '2026-09-01', 'Colesterol Total', '2026-09-08', 'Alterado', 'Colesterol 235mg/dL, acima do ideal'),
    ('André Henriques', '2026-09-01', 'Triglicerídeos', '2026-09-04', 'Normal', 'Triglicerídeos 120mg/dL'),
    ('Arthur Batista', '2026-09-02', 'Teste rápido Estreptococo', '2026-09-06', 'Alterado', 'Positivo para Estreptococo'),
    ('Gustavo Araújo', '2026-09-04', 'Eletroneuromiografia', '2026-09-09', 'Alterado', 'Compressão leve do nervo mediano'),
    ('Gustavo Araújo', '2026-09-04', 'Vitamina B12', '2026-09-12', 'Normal', 'B12 dentro do normal'),
    ('Maria Silva', '2026-09-09', 'MAPA 24h', '2026-09-18', 'Normal', 'Média pressórica dentro do normal'),
    ('Leonardo Correia', '2026-09-09', 'Hemograma Completo', '2026-09-12', 'Normal', 'Todos os valores dentro do esperado'),
    ('Leonardo Correia', '2026-09-09', 'Ferritina', '2026-09-16', 'Normal', 'Ferritina normal'),
    ('Leonardo Correia', '2026-09-09', 'Vitamina D', '2026-09-15', 'Alterado', 'Vitamina D 18ng/mL, insuficiente'),
    ('Gustavo Esteves', '2026-09-10', 'Raio-x Tornozelo', '2026-09-19', 'Normal', 'Sem fraturas'),
    ('André Freitas', '2026-09-10', 'Eletrocardiograma', '2026-09-20', 'Alterado', 'Alteração discreta de repolarização'),
    ('André Freitas', '2026-09-10', 'MAPA 24h', '2026-09-16', 'Normal', 'Média pressórica dentro do normal'),
    ('Laura Esteves', '2026-09-10', 'Teste rápido Estreptococo', '2026-09-20', 'Alterado', 'Positivo para Estreptococo'),
    ('Sofia Queiroz', '2026-09-14', 'Hemograma Completo', '2026-09-22', 'Normal', 'Todos os valores dentro do esperado'),
    ('Igor Pinto', '2026-09-15', 'Hemograma Completo', '2026-09-25', 'Normal', 'Todos os valores dentro do esperado'),
    ('Igor Pinto', '2026-09-15', 'Glicemia em Jejum', '2026-09-23', 'Normal', 'Glicemia 92mg/dL'),
    ('Igor Pinto', '2026-09-15', 'Colesterol Total', '2026-09-19', 'Normal', 'Colesterol 180mg/dL, dentro do ideal'),
    ('Sofia Moreira', '2026-09-21', 'Raio-x Tórax', '2026-09-25', 'Normal', 'Campos pulmonares limpos'),
    ('Cláudia Siqueira', '2026-09-23', 'Acuidade Visual', NULL, NULL, 'Aguardando resultado'),
    ('Fábio Correia', '2026-09-24', 'Ultrassom Abdominal', NULL, NULL, 'Aguardando resultado'),
    ('Fábio Correia', '2026-09-28', 'Raio-x Tórax', NULL, NULL, 'Aguardando resultado')
) AS v(paciente, data_consulta, nome, data_resultado, resultado, observacoes)
JOIN pacientes p ON p.nome = v.paciente
JOIN consultas c ON c.idpaciente = p.idpaciente AND c.data_consulta = v.data_consulta::DATE;


-- ---------------------------------------------
-- Pagamentos das novas consultas
-- ---------------------------------------------

INSERT INTO pagamentos (idconsulta, data_pagamento, valor, forma_pagamento, status)
SELECT c.idconsulta, c.data_consulta, v.valor, v.forma_pagamento, v.status
FROM (VALUES
    ('Renato Pinto', '2026-07-01', 150.00, 'Cartão de Débito', 'A'),
    ('Bruna Siqueira', '2026-07-03', 150.00, 'Convênio', 'A'),
    ('Luana Cardoso', '2026-07-03', 240.00, 'Convênio', 'A'),
    ('Mateus Ribeiro', '2026-07-06', 200.00, 'Convênio', 'A'),
    ('Fábio Correia', '2026-07-07', 200.00, 'Convênio', 'A'),
    ('Leonardo Freitas', '2026-07-08', 220.00, 'Convênio', 'A'),
    ('Bruna Siqueira', '2026-07-10', 240.00, 'Convênio', 'A'),
    ('Luana Moreira', '2026-07-13', 180.00, 'Cartão de Crédito', 'A'),
    ('Sérgio Batista', '2026-07-14', 220.00, 'Convênio', 'P'),
    ('Heitor Araújo', '2026-07-15', 200.00, 'Pix', 'A'),
    ('Luana Moreira', '2026-07-16', 180.00, 'Pix', 'A'),
    ('Sabrina Barbosa', '2026-07-16', 250.00, 'Convênio', 'A'),
    ('Yasmin Araújo', '2026-07-17', 200.00, 'Convênio', 'A'),
    ('Bruna Siqueira', '2026-07-20', 240.00, 'Convênio', 'A'),
    ('Aline Araújo', '2026-07-20', 200.00, 'Dinheiro', 'A'),
    ('Aline Araújo', '2026-07-21', 170.00, 'Cartão de Crédito', 'A'),
    ('Leonardo Esteves', '2026-07-21', 300.00, 'Cartão de Débito', 'P'),
    ('Letícia Correia', '2026-07-22', 250.00, 'Convênio', 'C'),
    ('Igor Pinto', '2026-07-22', 220.00, 'Convênio', 'C'),
    ('Rosângela Esteves', '2026-07-22', 240.00, 'Convênio', 'A'),
    ('Otávio Freitas', '2026-07-23', 240.00, 'Convênio', 'P'),
    ('Laura Siqueira', '2026-07-23', 200.00, 'Pix', 'A'),
    ('Daniela Rocha', '2026-07-23', 250.00, 'Convênio', 'A'),
    ('André Henriques', '2026-07-23', 250.00, 'Convênio', 'A'),
    ('Renato Pinto', '2026-07-24', 240.00, 'Convênio', 'A'),
    ('Leonardo Esteves', '2026-07-24', 300.00, 'Dinheiro', 'A'),
    ('Wagner Moreira', '2026-07-24', 200.00, 'Cartão de Crédito', 'A'),
    ('Isabela Martins', '2026-07-28', 200.00, 'Convênio', 'A'),
    ('Mateus Ribeiro', '2026-07-28', 260.00, 'Cartão de Crédito', 'A'),
    ('Vanessa Ribeiro', '2026-07-29', 250.00, 'Convênio', 'P'),
    ('Luana Cardoso', '2026-07-31', 150.00, 'Pix', 'A'),
    ('Cláudia Rocha', '2026-07-31', 200.00, 'Convênio', 'A'),
    ('Letícia Cardoso', '2026-08-04', 200.00, 'Convênio', 'A'),
    ('Otávio Freitas', '2026-08-05', 240.00, 'Convênio', 'A'),
    ('Caio Gomes', '2026-08-10', 280.00, 'Cartão de Crédito', 'A'),
    ('Miguel Cardoso', '2026-08-10', 180.00, 'Cartão de Débito', 'A'),
    ('Alice Moreira', '2026-08-10', 180.00, 'Convênio', 'A'),
    ('Letícia Moreira', '2026-08-14', 220.00, 'Dinheiro', 'A'),
    ('Cláudia Siqueira', '2026-08-14', 200.00, 'Dinheiro', 'A'),
    ('Sofia Queiroz', '2026-08-19', 180.00, 'Convênio', 'A'),
    ('Carla Moreira', '2026-08-20', 240.00, 'Convênio', 'P'),
    ('Letícia Cardoso', '2026-08-20', 200.00, 'Convênio', 'A'),
    ('Vanessa Ribeiro', '2026-08-26', 230.00, 'Convênio', 'A'),
    ('André Freitas', '2026-08-26', 280.00, 'Convênio', 'P'),
    ('Roberto Costa', '2026-08-27', 250.00, 'Convênio', 'A'),
    ('Igor Rocha', '2026-08-27', 260.00, 'Cartão de Débito', 'A'),
    ('Sabrina Barbosa', '2026-08-28', 150.00, 'Convênio', 'A'),
    ('Letícia Moreira', '2026-08-28', 150.00, 'Cartão de Crédito', 'A'),
    ('Miguel Cardoso', '2026-08-31', 200.00, 'Pix', 'A'),
    ('Isabela Machado', '2026-08-31', 220.00, 'Cartão de Débito', 'A'),
    ('Renato Almeida', '2026-08-31', 150.00, 'Convênio', 'P'),
    ('André Henriques', '2026-09-01', 250.00, 'Convênio', 'A'),
    ('Arthur Batista', '2026-09-02', 180.00, 'Convênio', 'A'),
    ('Gustavo Araújo', '2026-09-04', 280.00, 'Pix', 'A'),
    ('Maria Silva', '2026-09-09', 250.00, 'Convênio', 'A'),
    ('Leonardo Correia', '2026-09-09', 150.00, 'Convênio', 'A'),
    ('Gustavo Esteves', '2026-09-10', 220.00, 'Convênio', 'A'),
    ('André Freitas', '2026-09-10', 250.00, 'Convênio', 'A'),
    ('Laura Esteves', '2026-09-10', 180.00, 'Convênio', 'A'),
    ('Sofia Queiroz', '2026-09-14', 200.00, 'Cartão de Crédito', 'A'),
    ('Igor Pinto', '2026-09-15', 150.00, 'Convênio', 'A'),
    ('Sofia Moreira', '2026-09-21', 180.00, 'Cartão de Débito', 'P'),
    ('Cláudia Siqueira', '2026-09-23', 180.00, 'Pix', 'P'),
    ('Fábio Correia', '2026-09-24', 240.00, 'Convênio', 'P'),
    ('Fábio Correia', '2026-09-28', 150.00, 'Convênio', 'A')
) AS v(paciente, data_consulta, valor, forma_pagamento, status)
JOIN pacientes p ON p.nome = v.paciente
JOIN consultas c ON c.idpaciente = p.idpaciente AND c.data_consulta = v.data_consulta::DATE;

-- =============================================
-- VIEWS
-- =============================================

CREATE OR REPLACE VIEW vw_relatorio_consultas AS
SELECT pacientes.nome AS paciente,
    medicos.nome AS medico,
    especialidades.nome AS especialidade,
    consultas.data_consulta,
    consultas.observacoes
FROM consultas
JOIN pacientes ON consultas.idpaciente = pacientes.idpaciente
JOIN medicos ON consultas.idmedico = medicos.idmedico
JOIN especialidades ON medicos.idespecialidade = especialidades.idespecialidade;

CREATE OR REPLACE VIEW vw_relatorio_financeiro AS
SELECT pacientes.nome AS paciente,
    pagamentos.valor,
    pagamentos.forma_pagamento,
    pagamentos.status,
    consultas.data_consulta
FROM pagamentos
JOIN consultas ON pagamentos.idconsulta = consultas.idconsulta
JOIN pacientes ON consultas.idpaciente = pacientes.idpaciente;

CREATE OR REPLACE VIEW vw_pacientes_convenio AS
SELECT pacientes.nome AS paciente,
    pacientes.cpf,
    pacientes.telefone,
    pacientes.data_nascimento,
    convenios.nome AS convenio
FROM pacientes
JOIN convenios ON pacientes.idconvenio = convenios.idconvenio;

CREATE OR REPLACE VIEW vw_relatorio_exames AS
SELECT pacientes.nome AS paciente,
    exames.nome AS exame,
    exames.resultado,
    exames.observacoes,
    exames.data_solicitacao,
    exames.data_resultado
FROM exames
JOIN consultas ON exames.idconsulta = consultas.idconsulta
JOIN pacientes ON consultas.idpaciente = pacientes.idpaciente;

-- =============================================
-- INDEXES
-- =============================================

CREATE INDEX idx_pacientes_nome ON pacientes(nome);
CREATE INDEX idx_medicos_nome ON medicos(nome);
CREATE INDEX idx_consultas_data ON consultas(data_consulta);
CREATE INDEX idx_agendamentos_status ON agendamentos(status);

-- =============================================
-- QUERIES DE PRÁTICA E RELATÓRIOS
-- =============================================

-- -----------------------------------------------
-- SELECT, WHERE, ORDER BY
-- -----------------------------------------------

-- Lista todos os pacientes ordenados por nome de A a Z
SELECT nome, cpf, data_nascimento 
FROM pacientes
ORDER BY nome ASC;

-- Lista todos os pacientes ordenados por nome de Z a A
SELECT nome, cpf, data_nascimento 
FROM pacientes
ORDER BY nome DESC;

-- Busca pacientes que o nome começa com 'Maria'
SELECT nome, email
FROM pacientes
WHERE nome LIKE 'Maria%';

-- Busca pacientes que tem 'Silva' em qualquer parte do nome
SELECT nome, email
FROM pacientes
WHERE nome LIKE '%Silva%';

-- -----------------------------------------------
-- BETWEEN
-- -----------------------------------------------

-- Busca pacientes nascidos entre 1980 e 1995
SELECT nome, data_nascimento 
FROM pacientes
WHERE data_nascimento BETWEEN '1980-01-01' AND '1995-12-31';

-- Busca pagamentos com valor entre R$100 e R$200
SELECT idconsulta, valor, forma_pagamento 
FROM pagamentos 
WHERE valor BETWEEN 100 AND 200;

-- Busca pacientes nascidos entre 1990 e 2000 do mais novo ao mais antigo
SELECT nome, data_nascimento 
FROM pacientes
WHERE data_nascimento BETWEEN '1990-01-01' AND '2000-12-31'
ORDER BY data_nascimento DESC;

-- -----------------------------------------------
-- AND / OR / IS NULL
-- -----------------------------------------------

-- Busca pacientes do sexo feminino nascidas depois de 1990
SELECT nome, data_nascimento, genero 
FROM pacientes
WHERE genero = 'F'
AND data_nascimento > '1990-01-01';

-- Busca médicos de Cardiologia ou Pediatria
SELECT nome, idespecialidade 
FROM medicos
WHERE idespecialidade = (SELECT idespecialidade FROM especialidades WHERE nome = 'Cardiologia')
OR idespecialidade = (SELECT idespecialidade FROM especialidades WHERE nome = 'Pediatria');

-- Busca agendamentos confirmados entre 10 e 12 de agosto
SELECT idpaciente, idmedico, data_agendamento, status
FROM agendamentos
WHERE status = 'confirmado'
AND data_agendamento BETWEEN '2026-08-10' AND '2026-08-12';

-- -----------------------------------------------
-- FUNÇÕES DE AGREGAÇÃO
-- -----------------------------------------------

-- Total de pacientes cadastrados
SELECT COUNT(*) AS total_pacientes FROM pacientes;

-- Total de médicos cadastrados
SELECT COUNT(*) AS total_medicos FROM medicos;

-- Total arrecadado pela clínica
SELECT SUM(valor) AS total_arrecadado FROM pagamentos;

-- Média dos valores das consultas
SELECT AVG(valor) AS media_consultas FROM pagamentos;

-- Menor e maior pagamento
SELECT MIN(valor) AS menor_pagamento,
       MAX(valor) AS maior_pagamento 
FROM pagamentos;

-- Total de medicamentos prescritos
SELECT SUM(quantidade) AS total_medicamentos FROM medicamentos;

-- -----------------------------------------------
-- GROUP BY / HAVING
-- -----------------------------------------------

-- Total de agendamentos por status
SELECT status, COUNT(*) AS total 
FROM agendamentos
GROUP BY status;

-- Total de exames por resultado
SELECT resultado, COUNT(*) AS total_exames 
FROM exames
GROUP BY resultado;

-- Total arrecadado por forma de pagamento
SELECT forma_pagamento, COUNT(*) AS total, SUM(valor) AS valor_arrecadado 
FROM pagamentos
GROUP BY forma_pagamento;

-- Formas de pagamento que arrecadaram mais de R$150
SELECT forma_pagamento, SUM(valor) AS total 
FROM pagamentos
GROUP BY forma_pagamento
HAVING SUM(valor) > 150;

-- Resultados de exames que aparecem mais de 2 vezes
SELECT resultado, COUNT(*) AS total 
FROM exames
GROUP BY resultado
HAVING COUNT(*) > 2;

-- Status de agendamentos com mais de 2 registros
SELECT status, COUNT(*) AS total_agendamento 
FROM agendamentos
GROUP BY status
HAVING COUNT(*) > 2;

-- -----------------------------------------------
-- INNER JOIN
-- -----------------------------------------------

-- Nome do paciente e data da consulta
SELECT pacientes.nome,
       consultas.data_consulta,
       consultas.observacoes
FROM consultas
INNER JOIN pacientes ON consultas.idpaciente = pacientes.idpaciente;

-- Nome do médico, data e status do agendamento
SELECT medicos.nome,
       agendamentos.data_agendamento,
       agendamentos.status
FROM agendamentos
INNER JOIN medicos ON agendamentos.idmedico = medicos.idmedico;

-- Nome do paciente e observações do prontuário
SELECT pacientes.nome,
       prontuarios.observacoes
FROM prontuarios
INNER JOIN pacientes ON prontuarios.idpaciente = pacientes.idpaciente;

-- Nome do paciente, valor e forma de pagamento (3 tabelas)
SELECT pacientes.nome,
       consultas.data_consulta,
       pagamentos.valor,
       pagamentos.forma_pagamento
FROM pacientes
INNER JOIN consultas ON pacientes.idpaciente = consultas.idpaciente
INNER JOIN pagamentos ON consultas.idconsulta = pagamentos.idconsulta;

-- Nome do médico, paciente e data da consulta
SELECT medicos.nome AS medico,
       pacientes.nome AS paciente,
       consultas.data_consulta
FROM consultas
INNER JOIN medicos ON consultas.idmedico = medicos.idmedico
INNER JOIN pacientes ON consultas.idpaciente = pacientes.idpaciente;

-- Relatório completo: paciente, médico, especialidade e data (4 tabelas)
SELECT pacientes.nome AS paciente,
       medicos.nome AS medico,
       especialidades.nome AS especialidade,
       c.data_consulta
FROM consultas c
INNER JOIN pacientes ON c.idpaciente = pacientes.idpaciente
INNER JOIN medicos ON c.idmedico = medicos.idmedico
INNER JOIN especialidades ON medicos.idespecialidade = especialidades.idespecialidade;

-- Paciente, medicamento, dosagem e instruções (4 tabelas)
SELECT pacientes.nome AS paciente,
       medicamentos.nome AS medicamento,
       medicamentos.dosagem,
       medicamentos.instrucoes
FROM pacientes
INNER JOIN consultas ON pacientes.idpaciente = consultas.idpaciente
INNER JOIN receitas ON consultas.idconsulta = receitas.idconsulta
INNER JOIN medicamentos ON receitas.idreceita = medicamentos.idreceita;

-- Paciente, exame, resultado e data (ordenado por data)
SELECT pacientes.nome AS paciente,
       exames.nome AS exame,
       exames.resultado,
       exames.data_resultado
FROM pacientes
INNER JOIN consultas ON pacientes.idpaciente = consultas.idpaciente
INNER JOIN exames ON consultas.idconsulta = exames.idconsulta
ORDER BY exames.data_resultado;

-- -----------------------------------------------
-- LEFT JOIN
-- -----------------------------------------------

-- Todos os pacientes e suas consultas (incluindo quem não consultou)
SELECT pacientes.nome,
       consultas.data_consulta
FROM pacientes
LEFT JOIN consultas ON pacientes.idpaciente = consultas.idpaciente;

-- Todos os médicos e seus agendamentos (incluindo quem não tem agendamento)
SELECT medicos.nome AS medico,
       pacientes.nome AS paciente,
       agendamentos.data_agendamento
FROM medicos
LEFT JOIN agendamentos ON medicos.idmedico = agendamentos.idmedico
LEFT JOIN pacientes ON agendamentos.idpaciente = pacientes.idpaciente;
