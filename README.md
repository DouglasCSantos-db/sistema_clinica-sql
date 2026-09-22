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
| `vm_relatorio_consultas` | Relatório completo de consultas com médico e especialidade |
| `vm_relatorio_financeiro` | Relatório financeiro por paciente |
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
- INNER JOIN e LEFT JOIN com múltiplas tabelas
- Funções de agregação (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY e HAVING
- Views para relatórios
- Índices para otimização

---

## 🚀 Como Executar

1. Certifique-se de ter o **PostgreSQL** instalado
2. Clone este repositório
3. Execute o arquivo `clinica_db.sql` no seu cliente SQL (DBeaver, pgAdmin, etc.)
4. O script irá criar o banco, as tabelas, inserir os dados e criar as views automaticamente

---

## 👨‍💻 Autor

**Douglas Correia dos Santos**  
Cursando Banco de Dados — Uniasselvi  
Formado em Gestão de Serviços — FATEC  

[![GitHub](https://img.shields.io/badge/GitHub-DouglasCSantos--db-black?logo=github)](https://github.com/DouglasCSantos-db)
