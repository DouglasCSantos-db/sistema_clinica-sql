-- =============================================
-- SISTEMA DE GESTÃO DE CLÍNICA MÉDICA
-- Banco de dados: clinica_db
-- Autor: Douglas Correia dos Santos
-- GitHub: https://github.com/DouglasCSantos-db
-- =============================================

CREATE DATABASE clinica_db;

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

INSERT INTO prontuarios (idpaciente, alergias, doencas_anteriores, observacoes) VALUES
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

INSERT INTO receitas (idconsulta, observacoes) VALUES
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    'Tomar medicação conforme prescrito, retorno em 30 dias'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1),
    'Manter dieta e exercícios, retorno em 60 dias'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1),
    'Repouso por 7 dias, aguardar resultado do raio-x'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    'Continuar medicação cardíaca, retorno em 15 dias'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1),
    'Uso de óculos prescrito, retorno em 6 meses'
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

INSERT INTO exames (idconsulta, nome, data_resultado, resultado, observacoes) VALUES
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    'Eletrocardiograma', '2026-08-15', 'Normal', 'Sem alterações'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    'Homograma Completo', '2026-08-15', 'Normal', 'Todos os valores dentro do esperado'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1),
    'Glicemia em Jejum', '2026-08-12', 'Alterado', 'Glicemia 145mg/dL, acima do normal'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1),
    'Raio-x Joelho direito', '2026-08-13', 'Alterado', 'Desgaste leve na Cartilagem'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    'Ecocardiograma', '2026-08-16', 'Normal', 'Função cardíaca preservada'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    'Colesterol Total', '2026-08-16', 'Alterado', 'Colesterol 220mg/dL, acima do ideal'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1),
    'Acuidade Visual', '2026-08-14', 'Alterado', 'Miopia -2.5 em ambos os olhos'
);

INSERT INTO pagamentos (idconsulta, valor, forma_pagamento, status) VALUES
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Maria Silva') LIMIT 1),
    150.00, 'Convênio', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'João Santos') LIMIT 1),
    200.00, 'Convênio', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Carlos Pereira') LIMIT 1),
    180.00, 'Cartão de Crédito', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Roberto Costa') LIMIT 1),
    250.00, 'Convênio', 'A'
),
(
    (SELECT idconsulta FROM consultas WHERE idpaciente = (SELECT idpaciente FROM pacientes WHERE nome = 'Lucas Ferreira') LIMIT 1),
    120.00, 'Dinheiro', 'P'
);

-- =============================================
-- VIEWS
-- =============================================

CREATE OR REPLACE VIEW vm_relatorio_consultas AS
SELECT pacientes.nome AS paciente,
    medicos.nome AS medico,
    especialidades.nome AS especialidade,
    consultas.data_consulta,
    consultas.observacoes
FROM consultas
JOIN pacientes ON consultas.idpaciente = pacientes.idpaciente
JOIN medicos ON consultas.idmedico = medicos.idmedico
JOIN especialidades ON medicos.idespecialidade = especialidades.idespecialidade;

CREATE OR REPLACE VIEW vm_relatorio_financeiro AS
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

QUERIES DE PRÁTICA E RELATÓRIOS
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
LEFT JOIN consultas ON medicos.idmedico = consultas.idmedico
LEFT JOIN agendamentos ON consultas.idagendamento = agendamentos.idagendamento
LEFT JOIN pacientes ON agendamentos.idpaciente = pacientes.idpaciente;
