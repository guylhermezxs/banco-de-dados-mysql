

-- SELECTs para visualizar a obra de arte
-- SELECT * FROM Usuario;
-- SELECT * FROM LogAcoesAddUsuario;
-- SELECT * FROM Produto;
-- SELECT * FROM EntradaItens;
-- SELECT * FROM Setor;
-- SELECT * FROM Usuario_Sector;
-- SELECT * FROM Categoria;
-- SELECT * FROM ProdutoCategoria;
-- SELECT * FROM SolicitacaoItens;
-- SELECT * FROM BaixaAvaria;

-- Criação do Banco de Dados:
CREATE SCHEMA IF NOT EXISTS mydb DEFAULT CHARACTER SET utf8mb4;
USE mydb;

-- Tabela: Usuario
CREATE TABLE IF NOT EXISTS Usuario (
  idUsuario INT NOT NULL AUTO_INCREMENT,
  NomeUsuario VARCHAR(200) NOT NULL,
  cpf CHAR(11) NOT NULL,
  telefone CHAR(11) NOT NULL,
  email VARCHAR(300) NOT NULL,
  login VARCHAR(100) NOT NULL,
  senha VARCHAR(255) NOT NULL,
  IdLider INT NULL,
  idUsuarioFuncao INT NOT NULL,
  IdUsuarioRealizador INT NOT NULL,
  PRIMARY KEY (idUsuario),
  UNIQUE (cpf),
  UNIQUE (email),
  UNIQUE (login),
  CONSTRAINT fk_id_lider
    FOREIGN KEY (IdLider)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_id_usuario_realizador
    FOREIGN KEY (IdUsuarioRealizador)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela: Produto
CREATE TABLE IF NOT EXISTS Produto (
  idProduto INT NOT NULL AUTO_INCREMENT,
  DescricaoProduto VARCHAR(255) NOT NULL,
  NomeProduto VARCHAR(100) NOT NULL,
  CodigoProduto VARCHAR(100) NOT NULL,
  QuantidadeEstoque INT UNSIGNED NOT NULL,
  DataCadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ValorProduto DECIMAL(12,2) NOT NULL,
  idUsuarioResponsavel INT NOT NULL,
  PRIMARY KEY (idProduto),
  UNIQUE (CodigoProduto),
  CONSTRAINT fk_produto_usuario
    FOREIGN KEY (idUsuarioResponsavel)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela: EntradaItens
CREATE TABLE IF NOT EXISTS EntradaItens (
  idEntradaItens INT NOT NULL AUTO_INCREMENT,
  idProduto INT NOT NULL,
  idUsuarioResponsavel INT NOT NULL,
  QuantidadeEntrada INT UNSIGNED NOT NULL,
  DataEntrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Observacao TEXT NOT NULL,
  PRIMARY KEY (idEntradaItens),
  CONSTRAINT fk_entrada_usuario
    FOREIGN KEY (idUsuarioResponsavel)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_entrada_produto
    FOREIGN KEY (idProduto)
    REFERENCES Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela: Setor
CREATE TABLE IF NOT EXISTS Setor (
  idSetor INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(60) NOT NULL,
  telefone CHAR(11) NOT NULL,
  PRIMARY KEY (idSetor)
) ENGINE=InnoDB;

-- Tabela: Usuario_Sector
CREATE TABLE IF NOT EXISTS Usuario_Sector (
  idUsuario INT NOT NULL,
  idSector INT NOT NULL,
  turno ENUM('Manhã', 'Tarde', 'Noturno') NOT NULL,
  PRIMARY KEY (idUsuario, idSector, turno),
  CONSTRAINT fk_sector_usuario
    FOREIGN KEY (idUsuario)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_sector_setor
    FOREIGN KEY (idSector)
    REFERENCES Setor (idSetor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela: Categoria
CREATE TABLE IF NOT EXISTS Categoria (
  idCategoria INT NOT NULL AUTO_INCREMENT,
  NomeCategoria VARCHAR(100) NOT NULL,
  DescricaoCategoria VARCHAR(100) NOT NULL,
  PRIMARY KEY (idCategoria)
) ENGINE=InnoDB;

-- Tabela: ProdutoCategoria
CREATE TABLE IF NOT EXISTS ProdutoCategoria (
  idProduto INT NOT NULL,
  idCategoria INT NOT NULL,
  PRIMARY KEY (idProduto, idCategoria),
  CONSTRAINT fk_produto_categoria
    FOREIGN KEY (idProduto)
    REFERENCES Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_categoria_produto
    FOREIGN KEY (idCategoria)
    REFERENCES Categoria (idCategoria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela: SolicitacaoItens
CREATE TABLE IF NOT EXISTS SolicitacaoItens (
  idSolicitacaoItens INT NOT NULL AUTO_INCREMENT,
  idProduto INT NOT NULL,
  idUsuarioSolicitante INT NOT NULL,
  idUsuarioAprovador INT NOT NULL,
  QuantidadeSolicitada INT UNSIGNED NOT NULL,
  DataSolicitacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Estado ENUM('Aguardando Aprovação', 'Liberado', 'Concluído', 'Cancelado') NOT NULL,
  PRIMARY KEY (idSolicitacaoItens),
  CONSTRAINT fk_solicitacao_produto
    FOREIGN KEY (idProduto)
    REFERENCES Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_solicitacao_solicitante
    FOREIGN KEY (idUsuarioSolicitante)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_solicitacao_aprovador
    FOREIGN KEY (idUsuarioAprovador)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela: LogAcoesAddUsuario
CREATE TABLE IF NOT EXISTS LogAcoesAddUsuario (
  idLog INT NOT NULL AUTO_INCREMENT,
  idUsuarioAdd INT NOT NULL,
  NomeUsuarioAdd VARCHAR(100) NOT NULL,
  DataAcao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  TipoAcao VARCHAR(100) NOT NULL,
  DescricaoAcao TEXT NOT NULL,
  DadosAdicionais TEXT,
  IdUsuarioRealizador INT NOT NULL,
  PRIMARY KEY (idLog),
  CONSTRAINT fk_log_usuario
    FOREIGN KEY (idUsuarioAdd)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_log_usuario_realizador
    FOREIGN KEY (IdUsuarioRealizador)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela: BaixaAvaria
CREATE TABLE IF NOT EXISTS BaixaAvaria (
  idBaixaAvaria INT NOT NULL AUTO_INCREMENT,
  idProduto INT NOT NULL,
  idUsuarioResponsavel INT NOT NULL,
  QuantidadeBaixada INT UNSIGNED NOT NULL,
  DataBaixa DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ExplicacaoMotivo TEXT NOT NULL,
  PRIMARY KEY (idBaixaAvaria),
  CONSTRAINT fk_baixa_usuario
    FOREIGN KEY (idUsuarioResponsavel)
    REFERENCES Usuario (idUsuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_baixa_produto
    FOREIGN KEY (idProduto)
    REFERENCES Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Procedures
DELIMITER //
CREATE PROCEDURE add_entradaItens (
  IN id_produto INT,
  IN quant_entrada INT,
  IN observacao TEXT,
  IN data_entrada DATETIME,
  IN id_usuario_resp INT
)
BEGIN
  INSERT INTO EntradaItens (
    idProduto, QuantidadeEntrada, Observacao, DataEntrada, idUsuarioResponsavel
  ) VALUES (
    id_produto, quant_entrada, observacao, COALESCE(data_entrada, CURRENT_TIMESTAMP), id_usuario_resp
  );
END;//

CREATE PROCEDURE add_Logusuario (
  IN nome_usuario_add VARCHAR(100),
  IN id_usuario INT,
  IN id_realizador INT,
  IN tipo_acao VARCHAR(50),
  IN descricao_acao TEXT,
  IN dados_add TEXT,
  IN data_acao DATETIME
)
BEGIN
  INSERT INTO LogAcoesAddUsuario (
    NomeUsuarioAdd, idUsuarioAdd, IdUsuarioRealizador,
    TipoAcao, DescricaoAcao, DadosAdicionais, DataAcao
  ) VALUES (
    nome_usuario_add, id_usuario, id_realizador,
    tipo_acao, descricao_acao, dados_add, COALESCE(data_acao, CURRENT_TIMESTAMP)
  );
END;//
DELIMITER ;

-- Triggers
DELIMITER //
CREATE TRIGGER trg_addEntrada AFTER INSERT ON Produto
FOR EACH ROW
BEGIN
  DECLARE obs TEXT;
  SET obs = IF(NEW.QuantidadeEstoque = 0, 
               CONCAT('INDISPONÍVEL - Produto cadastrado sem estoque inicial. Código: ', NEW.CodigoProduto), 
               CONCAT('DISPONÍVEL - Estoque inicial: ', NEW.QuantidadeEstoque));
  CALL add_entradaItens (
    NEW.idProduto, NEW.QuantidadeEstoque, obs, NEW.DataCadastro, NEW.idUsuarioResponsavel
  );
END;//

CREATE TRIGGER trg_addUsu AFTER INSERT ON Usuario
FOR EACH ROW
BEGIN
  CALL add_Logusuario (
    NEW.NomeUsuario, NEW.idUsuario, NEW.IdUsuarioRealizador,
    'Adicionar Usuário', 
    CONCAT('Usuário novo no sistema. CPF: ', NEW.cpf), 
    NULL, NOW()
  );
END;//
DELIMITER ;

-- Inserts
-- Tabela: Usuario 
INSERT INTO Usuario (NomeUsuario, cpf, telefone, email, login, senha, IdLider, idUsuarioFuncao, IdUsuarioRealizador) VALUES
('Ana Souza', '11111111111', '11912345678', 'ana.souza@email.com', 'anas', '1234', NULL, 1, 1),
('Bruno Lima', '22222222222', '11987654321', 'bruno.lima@email.com', 'brunol', '2345', 1, 2, 1),
('Carla Mendes', '33333333333', '11976543210', 'carla.mendes@email.com', 'carlam', '3456', 1, 2, 1),
('Diego Ferreira', '44444444444', '11911223344', 'diego.ferreira@email.com', 'diegof', '4567', NULL, 1, 1),
('Elisa Costa', '55555555555', '11999887766', 'elisa.costa@email.com', 'elisac', '5678', 2, 3, 2),
('Fernanda Almeida', '66666666666', '11944556677', 'fernanda.almeida@email.com', 'fernandaa', '6789', 4, 2, 1),
('Gabriel Santos', '77777777777', '11933445566', 'gabriel.santos@email.com', 'gabriels', '7890', 1, 3, 2),
('Helena Pereira', '88888888888', '11922334455', 'helena.pereira@email.com', 'helenap', '8901', NULL, 1, 1);

-- Tabela: Produto 
INSERT INTO Produto (DescricaoProduto, NomeProduto, CodigoProduto, QuantidadeEstoque, DataCadastro, ValorProduto, idUsuarioResponsavel) VALUES
('Mouse sem fio com conexão USB', 'Mouse Wireless', 'P001', 25, NOW(), 49.90, 1),
('Teclado mecânico com iluminação RGB', 'Teclado Gamer', 'P002', 15, NOW(), 199.90, 2),
('Monitor LED 24 polegadas Full HD', 'Monitor 24"', 'P003', 10, NOW(), 599.90, 1),
('Headset com microfone integrado', 'Headset Pro', 'P004', 30, NOW(), 129.90, 3),
('Cabo HDMI 2 metros', 'Cabo HDMI', 'P005', 50, NOW(), 29.90, 2),
('SSD 1TB NVMe', 'SSD 1TB', 'P006', 20, NOW(), 399.90, 4),
('Webcam Full HD 1080p', 'Webcam Pro', 'P007', 15, NOW(), 149.90, 5),
('Impressora Multifuncional', 'Impressora 3 em 1', 'P008', 8, NOW(), 499.90, 3),
('Mouse óptico com fio', 'Mouse Básico', 'P009', 0, NOW(), 29.90, 1),
('Teclado padrão USB', 'Teclado Simples', 'P010', 0, NOW(), 39.90, 2),
('Cabo USB-C 1 metro', 'Cabo USB-C', 'P011', 0, NOW(), 19.90, 3);

-- Tabela: Categoria 
INSERT INTO Categoria (NomeCategoria, DescricaoCategoria) VALUES
('Periféricos', 'Mouse, teclado, etc.'),
('Hardware', 'Componentes físicos'),
('Acessórios', 'Cabos, adaptadores, etc.'),
('Monitores', 'Monitores de diversos tamanhos'),
('Armazenamento', 'Discos rígidos, SSDs, etc.'),
('Impressoras', 'Impressoras e multifuncionais');

-- Tabela: Setor 
INSERT INTO Setor (nome, telefone) VALUES
('TI', '1133224455'),
('RH', '1144556677'),
('Logística', '1155667788'),
('Financeiro', '1166778899'),
('Manutenção', '1177889900'),
('Vendas', '1188990011');

-- Tabela: Usuario_Sector
INSERT INTO Usuario_Sector (idUsuario, idSector, turno) VALUES
(3, 1, 'Manhã'),   
(4, 3, 'Tarde'),   
(5, 2, 'Noturno'), 
(6, 4, 'Tarde'),   
(7, 5, 'Manhã'),   
(8, 6, 'Noturno'); 

-- Tabela: ProdutoCategoria
INSERT INTO ProdutoCategoria (idProduto, idCategoria) VALUES
(3, 3),  
(4, 1),  
(5, 2),  
(6, 5),  
(7, 1),  
(8, 6);  

-- Tabela: SolicitacaoItens
INSERT INTO SolicitacaoItens (idProduto, idUsuarioSolicitante, idUsuarioAprovador, QuantidadeSolicitada, DataSolicitacao, Estado) VALUES
(1, 3, 1, 5, NOW(), 'Aguardando Aprovação'),  
(2, 5, 2, 3, NOW(), 'Liberado'),               
(4, 4, 1, 10, NOW(), 'Concluído'),             
(6, 6, 4, 5, NOW(), 'Aguardando Aprovação'),   
(7, 7, 1, 2, NOW(), 'Liberado'),               
(8, 8, 2, 3, NOW(), 'Concluído');             

-- Tabela: BaixaAvaria
INSERT INTO BaixaAvaria (idProduto, idUsuarioResponsavel, QuantidadeBaixada, DataBaixa, ExplicacaoMotivo) VALUES
(1, 1, 2, NOW(), 'Mouses com defeito de fabricação'),
(2, 2, 1, NOW(), 'Teclado danificado durante transporte'),
(4, 3, 3, NOW(), 'Headsets com microfone não funcional'),
(6, 4, 1, NOW(), 'SSD com defeito detectado durante teste'),
(7, 5, 2, NOW(), 'Webcams com falha na conexão USB'),
(8, 3, 1, NOW(), 'Impressora com problema no sistema de impressão');

