-- =====================================================
-- BANCO DE DADOS COMPLETO - MINDHEALTH
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0; -- Desativa as travas de segurança

DROP DATABASE IF EXISTS mindhealth; -- DELETA o banco antigo inteiro com todas as tabelas dentro
CREATE DATABASE mindhealth;         -- Cria um banco 100% limpo do zero
USE mindhealth;

SET FOREIGN_KEY_CHECKS = 1; -- Reativa a segurança

-- =====================================================
-- USUÁRIOS
-- =====================================================

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20) UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    data_nascimento DATE,
    genero VARCHAR(30),
    foto_perfil TEXT,
    bio TEXT,
    tipo_usuario ENUM('admin', 'funcionario', 'cliente') NOT NULL,
    status_conta ENUM('ativo', 'bloqueado', 'inativo') DEFAULT 'ativo',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ultimo_login DATETIME
);

-- =====================================================
-- PROFISSIONAIS
-- =====================================================

CREATE TABLE profissionais (
    id_profissional INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    crm VARCHAR(30) UNIQUE,
    especialidade VARCHAR(100),
    descricao TEXT,
    aprovado BOOLEAN DEFAULT FALSE,
    
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- TOKENS DE RECUPERAÇÃO
-- =====================================================

CREATE TABLE tokens_recuperacao (
    id_token INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expiracao DATETIME NOT NULL,
    utilizado BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- TENTATIVAS LOGIN
-- =====================================================

CREATE TABLE tentativas_login (
    id_tentativa INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(150),
    sucesso BOOLEAN,
    ip VARCHAR(50),
    data_tentativa TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- LOGS DO SISTEMA
-- =====================================================

CREATE TABLE logs_sistema (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    acao VARCHAR(255),
    ip VARCHAR(50),
    dispositivo VARCHAR(150),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- SAÚDE INDICADORES
-- =====================================================

CREATE TABLE saude_indicadores (
    id_indicador INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,

    peso DECIMAL(5,2),
    altura DECIMAL(4,2),
    pressao_arterial VARCHAR(20),
    glicemia INT,
    colesterol INT,
    frequencia_cardiaca INT,
    spo2 DECIMAL(5,2),
    qualidade_sono INT,
    nivel_estresse INT,
    calorias INT,
    passos INT,

    registrado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- ATIVIDADES FÍSICAS
-- =====================================================

CREATE TABLE atividades_fisicas (
    id_atividade INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,

    tipo_atividade VARCHAR(100),
    duracao_minutos INT,
    calorias_gastas INT,

    intensidade ENUM('leve', 'moderada', 'intensa'),

    observacoes TEXT,
    data_atividade DATETIME,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- METAS USUÁRIO
-- =====================================================

CREATE TABLE metas_usuario (
    id_meta INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,

    tipo_meta VARCHAR(100),
    valor_meta DECIMAL(10,2),
    progresso DECIMAL(10,2),

    status ENUM('ativa', 'concluida') DEFAULT 'ativa',

    data_inicio DATE,
    data_fim DATE,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- HUMOR
-- =====================================================

CREATE TABLE humor_registros (
    id_humor INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,

    emocao VARCHAR(50),
    intensidade INT,
    observacao TEXT,

    risco_emocional BOOLEAN DEFAULT FALSE,

    registrado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- SMARTWATCHES
-- =====================================================

CREATE TABLE smartwatches (
    id_dispositivo INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,

    marca VARCHAR(100),
    modelo VARCHAR(100),

    token_api TEXT,

    conectado BOOLEAN DEFAULT FALSE,

    sincronizado_em DATETIME,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- RECOMENDAÇÕES IA
-- =====================================================

CREATE TABLE recomendacoes_ia (
    id_recomendacao INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,

    tipo VARCHAR(100),
    recomendacao TEXT,

    nivel_risco VARCHAR(50),

    gerada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- ANÁLISES IA
-- =====================================================

CREATE TABLE ia_analises (
    id_analise INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,

    dados_utilizados TEXT,
    resultado TEXT,

    score_risco DECIMAL(5,2),

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- SERVIÇOS SAÚDE
-- =====================================================

CREATE TABLE servicos_saude (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(150),
    tipo VARCHAR(100),

    endereco TEXT,

    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),

    telefone VARCHAR(20),

    descricao TEXT,

    avaliacao_media DECIMAL(4,2)
);

-- =====================================================
-- HISTÓRICO GEOLOCALIZAÇÃO
-- =====================================================

CREATE TABLE historico_localizacao (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,

    id_usuario INT NOT NULL,

    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),

    pesquisado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- DISPONIBILIDADE PROFISSIONAL
-- =====================================================

CREATE TABLE disponibilidade (
    id_disponibilidade INT PRIMARY KEY AUTO_INCREMENT,

    id_profissional INT NOT NULL,

    dia_semana VARCHAR(20),

    horario_inicio TIME,
    horario_fim TIME,

    FOREIGN KEY (id_profissional)
    REFERENCES profissionais(id_profissional)
);

-- =====================================================
-- AGENDAMENTOS
-- =====================================================

CREATE TABLE agendamentos (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT,

    id_usuario INT NOT NULL,
    id_profissional INT NOT NULL,

    data_agendamento DATETIME,

    status ENUM(
        'pendente',
        'confirmado',
        'cancelado',
        'concluido'
    ) DEFAULT 'pendente',

    observacoes TEXT,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario),

    FOREIGN KEY (id_profissional)
    REFERENCES profissionais(id_profissional)
);

-- =====================================================
-- ATENDIMENTOS
-- =====================================================

CREATE TABLE atendimentos (
    id_atendimento INT PRIMARY KEY AUTO_INCREMENT,

    id_agendamento INT NOT NULL,

    anotacoes TEXT,
    diagnostico TEXT,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_agendamento)
    REFERENCES agendamentos(id_agendamento)
);

-- =====================================================
-- NOTIFICAÇÕES
-- =====================================================

CREATE TABLE notificacoes (
    id_notificacao INT PRIMARY KEY AUTO_INCREMENT,

    id_usuario INT NOT NULL,

    titulo VARCHAR(150),
    mensagem TEXT,

    tipo VARCHAR(100),

    lida BOOLEAN DEFAULT FALSE,

    enviada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- POSTS COMUNIDADE
-- =====================================================

CREATE TABLE posts (
    id_post INT PRIMARY KEY AUTO_INCREMENT,

    id_usuario INT NOT NULL,

    conteudo TEXT,
    imagem TEXT,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- COMENTÁRIOS
-- =====================================================

CREATE TABLE comentarios (
    id_comentario INT PRIMARY KEY AUTO_INCREMENT,

    id_post INT NOT NULL,
    id_usuario INT NOT NULL,

    comentario TEXT,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_post)
    REFERENCES posts(id_post),

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- CURTIDAS
-- =====================================================

CREATE TABLE curtidas (
    id_curtida INT PRIMARY KEY AUTO_INCREMENT,

    id_post INT NOT NULL,
    id_usuario INT NOT NULL,

    FOREIGN KEY (id_post)
    REFERENCES posts(id_post),

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- MENSAGENS
-- =====================================================

CREATE TABLE mensagens (
    id_mensagem INT PRIMARY KEY AUTO_INCREMENT,

    remetente_id INT NOT NULL,
    destinatario_id INT NOT NULL,

    mensagem TEXT,

    lida BOOLEAN DEFAULT FALSE,

    enviada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (remetente_id)
    REFERENCES usuarios(id_usuario),

    FOREIGN KEY (destinatario_id)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- CONTEÚDOS
-- =====================================================

CREATE TABLE conteudos (
    id_conteudo INT PRIMARY KEY AUTO_INCREMENT,

    titulo VARCHAR(150),
    descricao TEXT,

    categoria VARCHAR(100),

    tipo ENUM(
        'video',
        'artigo',
        'podcast'
    ),

    url_conteudo TEXT,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- HISTÓRICO CONTEÚDOS
-- =====================================================

CREATE TABLE usuario_conteudo (
    id INT PRIMARY KEY AUTO_INCREMENT,

    id_usuario INT NOT NULL,
    id_conteudo INT NOT NULL,

    visualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario),

    FOREIGN KEY (id_conteudo)
    REFERENCES conteudos(id_conteudo)
);

-- =====================================================
-- AVALIAÇÕES
-- =====================================================

CREATE TABLE avaliacoes (
    id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,

    id_usuario INT NOT NULL,

    nota INT,

    comentario TEXT,

    tipo VARCHAR(100),

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

-- =====================================================
-- MEDITAÇÕES
-- =====================================================

CREATE TABLE meditacoes (
    id_meditacao INT PRIMARY KEY AUTO_INCREMENT,

    titulo VARCHAR(150),
    descricao TEXT,

    duracao INT,

    categoria VARCHAR(100),

    url_audio TEXT
);

-- =====================================================
-- HISTÓRICO MEDITAÇÕES
-- =====================================================

CREATE TABLE usuario_meditacao (
    id INT PRIMARY KEY AUTO_INCREMENT,

    id_usuario INT NOT NULL,
    id_meditacao INT NOT NULL,

    concluida BOOLEAN DEFAULT FALSE,

    tempo_escutado INT,

    data_execucao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario),

    FOREIGN KEY (id_meditacao)
    REFERENCES meditacoes(id_meditacao)
);

-- =====================================================
-- BACKUPS
-- =====================================================

CREATE TABLE backups (
    id_backup INT PRIMARY KEY AUTO_INCREMENT,

    tipo_backup VARCHAR(100),

    local_arquivo TEXT,

    realizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ÍNDICES PERFORMANCE
-- =====================================================

CREATE INDEX idx_usuario_email
ON usuarios(email);

CREATE INDEX idx_usuario_cpf
ON usuarios(cpf);

CREATE INDEX idx_agendamento_data
ON agendamentos(data_agendamento);

CREATE INDEX idx_humor_data
ON humor_registros(registrado_em);

CREATE INDEX idx_saude_data
ON saude_indicadores(registrado_em);

CREATE INDEX idx_notificacao_usuario
ON notificacoes(id_usuario);

CREATE INDEX idx_logs_usuario
ON logs_sistema(id_usuario);

CREATE INDEX idx_post_usuario
ON posts(id_usuario);

CREATE INDEX idx_mensagem_remetente
ON mensagens(remetente_id);

CREATE INDEX idx_mensagem_destinatario
ON mensagens(destinatario_id);

CREATE UNIQUE INDEX idx_curtida_unica ON curtidas(id_post, id_usuario);

-- =====================================================
-- BANCO DE DADOS COMPLETO
-- =====================================================

-- =====================================================
-- INSERTS
-- =====================================================
-- USUÁRIOS
INSERT INTO usuarios(nome,email,cpf,telefone,senha_hash,tipo_usuario)
VALUES
('Victor','victor@email.com','11111111111','11999999999','123','admin'),
('Gabriel','gabriel@email.com','22222222222','11988888888','123','funcionario'),
('Maria','maria@email.com','33333333333','11977777777','123','cliente');

-- PROFISSIONAIS
INSERT INTO profissionais(id_usuario, crm, especialidade, descricao, aprovado)
VALUES
(2,'12345-SP','Psicologia','Atendimento clínico',TRUE),
(3,'67890-SP','Nutrição','Acompanhamento nutricional',TRUE),
(1,'11111-SP','Medicina','Clínico geral',TRUE);

-- TOKENS DE RECUPERAÇÃO
INSERT INTO tokens_recuperacao(id_usuario,token,expiracao,utilizado)
VALUES
(1,'abc123','2026-06-10 12:00:00',FALSE),
(2,'def456','2026-06-11 12:00:00',FALSE),
(3,'ghi789','2026-06-12 12:00:00',TRUE);

-- TENTATIVAS LOGIN
INSERT INTO tentativas_login(email,sucesso,ip)
VALUES
('victor@email.com',TRUE,'192.168.0.1'),
('gabriel@email.com',FALSE,'192.168.0.2'),
('maria@email.com',TRUE,'192.168.0.3');

-- LOGS DO SISTEMA
INSERT INTO logs_sistema(id_usuario,acao,ip,dispositivo)
VALUES
(1,'Login realizado','192.168.0.1','Chrome'),
(2,'Cadastro atualizado','192.168.0.2','Firefox'),
(3,'Senha alterada','192.168.0.3','Edge');

-- SAÚDE INDICADORES
INSERT INTO saude_indicadores(id_usuario,peso,altura,pressao_arterial,glicemia,colesterol,frequencia_cardiaca,spo2,qualidade_sono,nivel_estresse,calorias,passos)
VALUES
(1,80,1.75,'120/80',90,180,70,98,7,5,2000,8000),
(2,65,1.68,'110/70',85,170,72,97,8,4,1800,9000),
(3,90,1.80,'130/85',95,200,75,96,6,7,2200,7000);


-- ATIVIDADES FÍSICAS
INSERT INTO atividades_fisicas(id_usuario,tipo_atividade,duracao_minutos,calorias_gastas,intensidade,observacoes,data_atividade)
VALUES
(1,'Corrida',30,250,'intensa','Treino matinal','2026-06-01 07:00:00'),
(2,'Caminhada',45,180,'moderada','Passeio no parque','2026-06-02 08:00:00'),
(3,'Yoga',60,120,'leve','Sessão relaxante','2026-06-03 19:00:00');

-- METAS USUÁRIO
INSERT INTO metas_usuario(id_usuario,tipo_meta,valor_meta,progresso,status,data_inicio,data_fim)
VALUES
(1,'Perder peso',5,2,'ativa','2026-05-01','2026-07-01'),
(2,'Dormir melhor',8,4,'ativa','2026-05-15','2026-06-30'),
(3,'Reduzir estresse',10,10,'concluida','2026-04-01','2026-06-01');

-- HUMOR
INSERT INTO humor_registros(id_usuario,emocao,intensidade,observacao,risco_emocional)
VALUES
(1,'Ansiedade',7,'Semana de provas',TRUE),
(2,'Feliz',9,'Consegui concluir sprint',FALSE),
(3,'Cansado',5,'Dia longo de trabalho',FALSE);

-- SMARTWATCHES
INSERT INTO smartwatches(id_usuario,marca,modelo,token_api,conectado,sincronizado_em)
VALUES
(1,'Samsung','Galaxy Watch','token123',TRUE,'2026-06-01 10:00:00'),
(2,'Apple','Apple Watch','token456',TRUE,'2026-06-02 11:00:00'),
(3,'Xiaomi','Mi Band','token789',FALSE,NULL);

-- RECOMENDAÇÕES IA
INSERT INTO recomendacoes_ia(id_usuario,tipo,recomendacao,nivel_risco)
VALUES
(1,'Exercício','Faça uma caminhada leve','moderado'),
(2,'Sono','Durma pelo menos 7h','baixo'),
(3,'Alimentação','Reduza consumo de açúcar','alto');

-- ANÁLISES IA
INSERT INTO ia_analises(id_usuario,dados_utilizados,resultado,score_risco)
VALUES
(1,'Indicadores físicos','Risco moderado',5.5),
(2,'Humor e sono','Risco baixo',3.2),
(3,'Atividades e saúde','Risco alto',7.8);

-- SERVIÇOS SAÚDE
INSERT INTO servicos_saude(nome,tipo,endereco,latitude,longitude,telefone,descricao,avaliacao_media)
VALUES
('Clínica Vida','Psicologia','Rua A, 123',-23.5200,-46.1900,'11999999999','Atendimento psicológico',4.5),
('Hospital Bem Estar','Hospital','Av. B, 456',-23.5300,-46.2000,'11888888888','Emergências gerais',4.0),
('Academia Saúde','Academia','Rua C, 789',-23.5400,-46.2100,'11777777777','Treinos funcionais',3.8);

-- HISTÓRICO GEOLOCALIZAÇÃO
INSERT INTO historico_localizacao(id_usuario,latitude,longitude)
VALUES
(1,-23.5200,-46.1900),
(2,-23.5300,-46.2000),
(3,-23.5400,-46.2100);

-- DISPONIBILIDADE PROFISSIONAL
INSERT INTO disponibilidade(id_profissional,dia_semana,horario_inicio,horario_fim)
VALUES
(1,'Segunda','08:00:00','12:00:00'),
(2,'Terça','09:00:00','13:00:00'),
(3,'Quarta','14:00:00','18:00:00');

-- AGENDAMENTOS
INSERT INTO agendamentos(id_usuario,id_profissional,data_agendamento,status,observacoes)
VALUES
(1,1,'2026-06-10 14:00:00','pendente','Primeira consulta'),
(2,2,'2026-06-11 09:00:00','confirmado','Retorno nutricional'),
(3,3,'2026-06-12 16:00:00','cancelado','Paciente desmarcou');

-- ATENDIMENTOS
INSERT INTO atendimentos(id_agendamento,anotacoes,diagnostico)
VALUES
(1,'Paciente ansioso','Ansiedade leve'),
(2,'Boa evolução','Manter dieta'),
(3,'Consulta cancelada','Sem diagnóstico');

-- NOTIFICAÇÕES
INSERT INTO notificacoes(id_usuario,titulo,mensagem,tipo)
VALUES
(1,'Lembrete','Agendamento amanhã','agenda'),
(2,'Aviso','Meta próxima do fim','meta'),
(3,'Alerta','Indicador de estresse elevado','saude');

-- POSTS COMUNIDADE
INSERT INTO posts(id_usuario,conteudo,imagem)
VALUES
(1,'Hoje consegui meditar 20 minutos!','img1.png'),
(2,'Alguém recomenda exercícios para ansiedade?','img2.png'),
(3,'Compartilhando dicas de alimentação saudável','img3.png');

-- COMENTÁRIOS
INSERT INTO comentarios(id_post,id_usuario,comentario)
VALUES
(1,2,'Parabéns! Continue assim'),
(2,3,'Eu faço yoga, ajuda bastante'),
(3,1,'Ótima dica, obrigado');

-- CURTIDAS
INSERT INTO curtidas(id_post,id_usuario)
VALUES
(1,1),
(2,2),
(3,3);

-- MENSAGENS
INSERT INTO mensagens(remetente_id,destinatario_id,mensagem)
VALUES
(1,2,'Olá, tudo bem?'),
(2,3,'Boa tarde, como está?'),
(3,1,'Preciso de ajuda com a meta');

-- CONTEÚDOS
INSERT INTO conteudos(titulo,descricao,categoria,tipo,url_conteudo)
VALUES
('Guia de Meditação','Artigo sobre técnicas de relaxamento','bem-estar','artigo','conteudo1.html'),
('Exercícios para Ansiedade','Vídeo explicativo','saúde mental','video','conteudo2.mp4'),
('Podcast Saúde','Podcast sobre qualidade de vida','saúde','podcast','conteudo3.mp3');

-- HISTÓRICO CONTEÚDOS
INSERT INTO usuario_conteudo(id_usuario,id_conteudo)
VALUES
(1,1),
(2,2),
(3,3);

-- AVALIAÇÕES
INSERT INTO avaliacoes(id_usuario,nota,comentario,tipo)
VALUES
(1,5,'Ótimo atendimento','servico'),
(2,4,'Boa experiência','servico'),
(3,3,'Precisa melhorar','servico');

-- MEDITAÇÕES
INSERT INTO meditacoes(titulo,descricao,duracao,categoria,url_audio)
VALUES
('Relaxamento','Meditação guiada para relaxar',15,'bem-estar','audio1.mp3'),
('Sono tranquilo','Meditação para dormir melhor',20,'sono','audio2.mp3'),
('Foco','Meditação para concentração',10,'produtividade','audio3.mp3');

-- HISTÓRICO MEDITAÇÕES
INSERT INTO usuario_meditacao(id_usuario,id_meditacao,concluida,tempo_escutado)
VALUES
(1,1,TRUE,15),
(2,2,FALSE,10),
(3,3,TRUE,10);

-- BACKUPS
INSERT INTO backups(tipo_backup,local_arquivo)
VALUES
('Completo','/backups/mindhealth_full.sql'),
('Incremental','/backups/mindhealth_inc.sql'),
('Diário','/backups/mindhealth_daily.sql');

-- =====================================================
-- BACKUPS
-- =====================================================

CREATE TABLE usuarios_backup AS SELECT * FROM usuarios;
CREATE TABLE profissionais_backup AS SELECT * FROM profissionais;
CREATE TABLE tokens_recuperacao_backup AS SELECT * FROM tokens_recuperacao;
CREATE TABLE tentativas_login_backup AS SELECT * FROM tentativas_login;
CREATE TABLE logs_sistema_backup AS SELECT * FROM logs_sistema;
CREATE TABLE saude_indicadores_backup AS SELECT * FROM saude_indicadores;
CREATE TABLE atividades_fisicas_backup AS SELECT * FROM atividades_fisicas;
CREATE TABLE metas_usuario_backup AS SELECT * FROM metas_usuario;
CREATE TABLE humor_registros_backup AS SELECT * FROM humor_registros;
CREATE TABLE smartwatches_backup AS SELECT * FROM smartwatches;
CREATE TABLE recomendacoes_ia_backup AS SELECT * FROM recomendacoes_ia;
CREATE TABLE ia_analises_backup AS SELECT * FROM ia_analises;
CREATE TABLE servicos_saude_backup AS SELECT * FROM servicos_saude;
CREATE TABLE historico_localizacao_backup AS SELECT * FROM historico_localizacao;
CREATE TABLE disponibilidade_backup AS SELECT * FROM disponibilidade;
CREATE TABLE agendamentos_backup AS SELECT * FROM agendamentos;
CREATE TABLE atendimentos_backup AS SELECT * FROM atendimentos;
CREATE TABLE notificacoes_backup AS SELECT * FROM notificacoes;
CREATE TABLE posts_backup AS SELECT * FROM posts;
CREATE TABLE comentarios_backup AS SELECT * FROM comentarios;
CREATE TABLE curtidas_backup AS SELECT * FROM curtidas;
CREATE TABLE mensagens_backup AS SELECT * FROM mensagens;
CREATE TABLE conteudos_backup AS SELECT * FROM conteudos;
CREATE TABLE usuario_conteudo_backup AS SELECT * FROM usuario_conteudo;
CREATE TABLE avaliacoes_backup AS SELECT * FROM avaliacoes;
CREATE TABLE meditacoes_backup AS SELECT * FROM meditacoes;
CREATE TABLE usuario_meditacao_backup AS SELECT * FROM usuario_meditacao;
CREATE TABLE backups_backup AS SELECT * FROM backups;

-- =====================================================
-- VIEWS
-- =====================================================

-- 1. Profissionais aprovados
CREATE VIEW vw_profissionais_aprovados AS
SELECT id_profissional, especialidade, descricao
FROM profissionais
WHERE aprovado = TRUE;

-- 2. Usuários com risco emocional
CREATE VIEW vw_usuarios_risco_emocional AS
SELECT u.nome, h.emocao, h.intensidade, h.registrado_em
FROM usuarios u
INNER JOIN humor_registros h ON u.id_usuario = h.id_usuario
WHERE h.risco_emocional = TRUE;

-- 3. Metas concluídas
CREATE VIEW vw_metas_concluidas AS
SELECT id_meta, id_usuario, tipo_meta, valor_meta, progresso, data_inicio, data_fim
FROM metas_usuario
WHERE status = 'concluida';

-- 4. Conteúdos por categoria
CREATE VIEW vw_conteudos_categoria AS
SELECT categoria, COUNT(*) AS total_conteudos
FROM conteudos
GROUP BY categoria;

-- 5. Agendamentos confirmados
CREATE VIEW vw_agendamentos_confirmados AS
SELECT a.id_agendamento, u.nome AS usuario, p.especialidade, a.data_agendamento
FROM agendamentos a
INNER JOIN usuarios u ON a.id_usuario = u.id_usuario
INNER JOIN profissionais p ON a.id_profissional = p.id_profissional
WHERE a.status = 'confirmado';

-- =====================================================
-- FUNÇÕES
-- =====================================================
DELIMITER //

-- 1. Total de usuários
CREATE FUNCTION fn_total_usuarios() RETURNS INT
DETERMINISTIC
BEGIN
  RETURN (SELECT COUNT(*) FROM usuarios);
END //

-- 2. Total de profissionais
CREATE FUNCTION fn_total_profissionais() RETURNS INT
DETERMINISTIC
BEGIN
  RETURN (SELECT COUNT(*) FROM profissionais);
END //

-- 3. Média de avaliações
CREATE FUNCTION fn_media_avaliacoes() RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  RETURN (SELECT AVG(nota) FROM avaliacoes);
END //

-- 4. Total de posts
CREATE FUNCTION fn_total_posts() RETURNS INT
DETERMINISTIC
BEGIN
  RETURN (SELECT COUNT(*) FROM posts);
END //

-- 5. Total de agendamentos confirmados
CREATE FUNCTION fn_agendamentos_confirmados() RETURNS INT
DETERMINISTIC
BEGIN
  RETURN (SELECT COUNT(*) FROM agendamentos WHERE status='confirmado');
END //

DELIMITER ;

-- =====================================================
-- PROCEDIMENTOS
-- =====================================================
DELIMITER //

-- 1. Listar todos os usuários
CREATE PROCEDURE sp_listar_usuarios()
BEGIN
  SELECT * FROM usuarios;
END //

-- 2. Buscar usuário por ID (com parâmetro)
CREATE PROCEDURE sp_buscar_usuario(IN idU INT)
BEGIN
  SELECT * FROM usuarios WHERE id_usuario = idU;
END //

-- 3. Inserir avaliação (com parâmetros)
CREATE PROCEDURE sp_inserir_avaliacao(IN idU INT, IN notaU INT, IN comentarioU TEXT)
BEGIN
  INSERT INTO avaliacoes(id_usuario,nota,comentario,tipo)
  VALUES(idU,notaU,comentarioU,'servico');
END //

-- 4. Listar profissionais aprovados
CREATE PROCEDURE sp_listar_profissionais_aprovados()
BEGIN
  SELECT * FROM profissionais WHERE aprovado = TRUE;
END //

-- 5. Listar conteúdos por categoria (com parâmetro)
CREATE PROCEDURE sp_listar_conteudos_categoria(IN cat VARCHAR(100))
BEGIN
  SELECT * FROM conteudos WHERE categoria = cat;
END //

DELIMITER ;

-- =====================================================
-- PROCEDIMENTOS COM COMMIT/ROLLBACK
-- =====================================================
DELIMITER //

-- 1. Inserir usuário com controle transacional
CREATE PROCEDURE sp_inserir_usuario(IN nomeU VARCHAR(150), IN emailU VARCHAR(150), IN cpfU VARCHAR(14))
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
  START TRANSACTION;
  INSERT INTO usuarios(nome,email,cpf,senha_hash,tipo_usuario)
  VALUES(nomeU,emailU,cpfU,'123','cliente');
  COMMIT;
END //

-- 2. Inserir profissional
CREATE PROCEDURE sp_inserir_profissional(IN idU INT, IN crmU VARCHAR(30), IN espU VARCHAR(100))
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
  START TRANSACTION;
  INSERT INTO profissionais(id_usuario,crm,especialidade,aprovado)
  VALUES(idU,crmU,espU,FALSE);
  COMMIT;
END //

-- 3. Inserir humor
CREATE PROCEDURE sp_inserir_humor(IN idU INT, IN emocaoU VARCHAR(50), IN intensidadeU INT)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
  START TRANSACTION;
  INSERT INTO humor_registros(id_usuario,emocao,intensidade)
  VALUES(idU,emocaoU,intensidadeU);
  COMMIT;
END //

-- 4. Inserir atividade física
CREATE PROCEDURE sp_inserir_atividade(IN idU INT, IN tipoU VARCHAR(100), IN duracaoU INT)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
  START TRANSACTION;
  INSERT INTO atividades_fisicas(id_usuario,tipo_atividade,duracao_minutos)
  VALUES(idU,tipoU,duracaoU);
  COMMIT;
END //

-- 5. Inserir avaliação
CREATE PROCEDURE sp_inserir_avaliacao_tx(IN idU INT, IN notaU INT, IN comentarioU TEXT)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
  START TRANSACTION;
  INSERT INTO avaliacoes(id_usuario,nota,comentario,tipo)
  VALUES(idU,notaU,comentarioU,'servico');
  COMMIT;
END //

DELIMITER ;

-- =====================================================
-- TRIGGERS
-- =====================================================
DELIMITER //

-- 1. Logar novo usuário
CREATE TRIGGER trg_log_usuario AFTER INSERT ON usuarios
FOR EACH ROW
INSERT INTO logs_sistema(id_usuario,acao) VALUES(NEW.id_usuario,'Novo usuário cadastrado');

-- 2. Atualizar último login
CREATE TRIGGER trg_update_login AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
  IF NEW.ultimo_login IS NOT NULL THEN
    INSERT INTO logs_sistema(id_usuario,acao) VALUES(NEW.id_usuario,'Login realizado');
  END IF;
END;

-- 3. Atualizar média de avaliações em serviços
CREATE TRIGGER trg_avaliacao_servico AFTER INSERT ON avaliacoes
FOR EACH ROW
UPDATE servicos_saude
SET avaliacao_media = (SELECT AVG(nota) FROM avaliacoes WHERE tipo='servico');

-- 4. Notificação ao concluir meta
CREATE TRIGGER trg_meta_concluida AFTER UPDATE ON metas_usuario
FOR EACH ROW
BEGIN
  IF NEW.status='concluida' THEN
    INSERT INTO notificacoes(id_usuario,titulo,mensagem,tipo)
    VALUES(NEW.id_usuario,'Meta concluída','Parabéns pela conquista!','meta');
  END IF;
END;

-- 5. Impedir exclusão de profissional com agendamento
CREATE TRIGGER trg_delete_profissional BEFORE DELETE ON profissionais
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM agendamentos WHERE id_profissional=OLD.id_profissional) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Não é permitido excluir profissional com agendamentos ativos';
  END IF;
END;

DELIMITER ;

-- =====================================================
-- SELECTS
-- =====================================================

-- 1. SELECT * de todas as tabela
SELECT * FROM usuarios;
SELECT * FROM profissionais;
SELECT * FROM humor_registros;
SELECT * FROM atividades_fisicas;
SELECT * FROM metas_usuario;
SELECT * FROM smartwatches;
SELECT * FROM recomendacoes_ia;
SELECT * FROM ia_analises;
SELECT * FROM servicos_saude;
SELECT * FROM historico_localizacao;
SELECT * FROM disponibilidade;
SELECT * FROM agendamentos;
SELECT * FROM atendimentos;
SELECT * FROM notificacoes;
SELECT * FROM posts;
SELECT * FROM comentarios;
SELECT * FROM curtidas;
SELECT * FROM mensagens;
SELECT * FROM conteudos;
SELECT * FROM usuario_conteudo;
SELECT * FROM avaliacoes;
SELECT * FROM meditacoes;
SELECT * FROM usuario_meditacao;
SELECT * FROM backups;

-- 2. SELECT de campos específicos 
SELECT nome, email FROM usuarios;
SELECT especialidade, aprovado FROM profissionais;
SELECT emocao, intensidade FROM humor_registros;
SELECT tipo_atividade, duracao_minutos FROM atividades_fisicas;
SELECT titulo, categoria FROM conteudos;

-- 3. SELECT com junções 
SELECT u.nome, p.especialidade
FROM usuarios u
JOIN profissionais p ON u.id_usuario = p.id_usuario;

SELECT u.nome, h.emocao, h.intensidade
FROM usuarios u
JOIN humor_registros h ON u.id_usuario = h.id_usuario;

SELECT u.nome, a.tipo_atividade, a.duracao_minutos
FROM usuarios u
JOIN atividades_fisicas a ON u.id_usuario = a.id_usuario;

SELECT u.nome, m.titulo, um.concluida
FROM usuarios u
JOIN usuario_meditacao um ON u.id_usuario = um.id_usuario
JOIN meditacoes m ON um.id_meditacao = m.id_meditacao;

SELECT u.nome, s.nome AS servico, s.tipo
FROM usuarios u
JOIN historico_localizacao hl ON u.id_usuario = hl.id_usuario
JOIN servicos_saude s ON s.latitude = hl.latitude AND s.longitude = hl.longitude;

-- 4. SELECT com INNER JOIN explícito 
SELECT u.nome, a.data_agendamento, p.especialidade
FROM agendamentos a
INNER JOIN usuarios u ON a.id_usuario = u.id_usuario
INNER JOIN profissionais p ON a.id_profissional = p.id_profissional;

SELECT u.nome, n.titulo, n.mensagem
FROM notificacoes n
INNER JOIN usuarios u ON n.id_usuario = u.id_usuario;

SELECT u.nome, po.conteudo, c.comentario
FROM comentarios c
INNER JOIN posts po ON c.id_post = po.id_post
INNER JOIN usuarios u ON c.id_usuario = u.id_usuario;

SELECT u.nome, me.mensagem
FROM mensagens me
INNER JOIN usuarios u ON me.remetente_id = u.id_usuario;

SELECT u.nome, av.nota, av.comentario
FROM avaliacoes av
INNER JOIN usuarios u ON av.id_usuario = u.id_usuario;

-- 5. SELECT com subselect 
SELECT nome FROM usuarios
WHERE id_usuario IN (SELECT id_usuario FROM humor_registros WHERE risco_emocional = TRUE);

SELECT nome FROM usuarios
WHERE id_usuario IN (SELECT id_usuario FROM metas_usuario WHERE status = 'concluida');

SELECT titulo FROM conteudos
WHERE id_conteudo IN (SELECT id_conteudo FROM usuario_conteudo WHERE id_usuario = 1);

SELECT nome FROM usuarios
WHERE id_usuario IN (SELECT id_usuario FROM agendamentos WHERE status = 'confirmado');

SELECT nome FROM usuarios
WHERE id_usuario IN (SELECT id_usuario FROM avaliacoes WHERE nota < 4);