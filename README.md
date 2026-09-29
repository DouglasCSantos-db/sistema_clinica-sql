# 🏥 Sistema de Gestão de Clínica Médica

Sistema de banco de dados desenvolvido em **PostgreSQL** para gestão completa de uma clínica médica, incluindo pacientes, médicos, consultas, exames, receitas e pagamentos.

> Projeto desenvolvido como portfólio pessoal durante minha transição de carreira para a área de Banco de Dados e SQL.

---

## 📋 Sobre o Projeto

Este projeto foi construído do zero com o objetivo de praticar e demonstrar conhecimentos em SQL e modelagem de banco de dados relacional. O sistema simula o funcionamento real de uma clínica médica, com tabelas relacionadas entre si através de chaves primárias e estrangeiras.

---

## 🗄️ Estrutura do Banco de Dados

O banco de dados **clinica_db** é composto por **11 tabelas**:

| Tabela | Descrição |
|--------|-----------|
| `especialidades` | Especialidades médicas disponíveis |
| `convenios` | Planos de saúde conveniados |
| `medicos` | Cadastro de médicos e suas especialidades |
| `pacientes` | Cadastro de pacientes e convênios |
| `prontuarios` | Histórico médico dos pacientes |
| `agendamentos` | Agenda de consultas futuras |
| `consultas` | Registro de consultas realizadas |
| `receitas` | Receitas médicas emitidas |
| `medicamentos` | Medicamentos prescritos nas receitas |
| `exames` | Exames solicitados nas consultas |
| `pagamentos` | Controle financeiro das consultas |

---

## 📈 Volume de Dados

| Tabela | Registros |
|--------|-----------|
| `especialidades` | 13 |
| `convenios` | 11 |
| `medicos` | 17 |
| `pacientes` | 65 (incluindo crianças) |
| `prontuarios` | 65 |
| `agendamentos` | 116 (julho a outubro de 2026) |
| `consultas` | 70 |
| `receitas` | 49 |
| `medicamentos` | 50 |
| `exames` | 87 |
| `pagamentos` | 70 |

Os dados são fictícios, mas coerentes entre si: crianças são atendidas na Pediatria, nenhum paciente recebe um medicamento ao qual é alérgico, consultas só existem para agendamentos confirmados e exames recentes aparecem como aguardando resultado.

---

## 🔍 Funcionalidades

- ✅ Cadastro completo de pacientes e médicos
- ✅ Controle de agendamentos com status (confirmado, pendente, cancelado)
- ✅ Registro de consultas com observações médicas
- ✅ Emissão de receitas e controle de medicamentos
- ✅ Solicitação e registro de resultados de exames
- ✅ Controle financeiro de pagamentos por consulta
- ✅ Relatórios prontos via Views

---

## 📊 Views (Relatórios)

| View | Descrição |
|------|-----------|
| `vw_relatorio_consultas` | Relatório completo de consultas com médico e especialidade |
| `vw_relatorio_financeiro` | Relatório financeiro por paciente |
| `vw_relatorio_exames` | Relatório de exames com resultados |
| `vw_pacientes_convenio` | Lista de pacientes com plano de saúde |

---

## ⚡ Índices

Índices criados para otimizar as buscas mais frequentes:

- `idx_pacientes_nome` — busca por nome de paciente
- `idx_medicos_nome` — busca por nome de médico
- `idx_consultas_data` — busca por data de consulta
- `idx_agendamentos_status` — filtro por status de agendamento

---

## 🛠️ Tecnologias Utilizadas

- **PostgreSQL 18**
- **DBeaver** — interface de administração
- **SQL** — DDL, DML, consultas com JOIN, GROUP BY, HAVING, Views e Index

---

## 📚 Conceitos Aplicados

- Modelagem de banco de dados relacional
- Chaves primárias (PRIMARY KEY) e estrangeiras (FOREIGN KEY)
- Subqueries e subqueries aninhadas
- INSERT ... SELECT com VALUES e JOIN para carga de dados em massa
- INNER JOIN e LEFT JOIN com múltiplas tabelas
- Funções de agregação (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY e HAVING
- Views para relatórios
- Índices para otimização

---

## 🚀 Como Executar

1. Certifique-se de ter o **PostgreSQL** instalado
2. Clone este repositório
3. Crie o banco de dados: `CREATE DATABASE clinica_db;`
4. Conecte no banco `clinica_db` (no DBeaver, selecione-o como banco ativo)
5. Execute o arquivo `clinica_db.sql` — o script cria as tabelas, insere os dados e cria as views e índices

---

## 👨‍💻 Autor

**Douglas Correia dos Santos**  
Cursando Banco de Dados — Uniasselvi  
Formado em Gestão de Serviços — FATEC  

[![GitHub](https://img.shields.io/badge/GitHub-DouglasCSantos--db-black?logo=github)](https://github.com/DouglasCSantos-db)
