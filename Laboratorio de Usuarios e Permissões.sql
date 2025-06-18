

CREATE DATABASE blog;
USE blog;


CREATE TABLE autor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);


CREATE TABLE postagens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    texto TEXT NOT NULL,
    autor_id INT NOT NULL,
    FOREIGN KEY (autor_id) REFERENCES autor(id)
);


CREATE TABLE visitantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    visitante_id INT NOT NULL,
    postagem_id INT NOT NULL,
    comentario TEXT NOT NULL,
    nota INT CHECK (nota >= 0 AND nota <= 5),
    aprovado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (visitante_id) REFERENCES visitantes(id),
    FOREIGN KEY (postagem_id) REFERENCES postagens(id)
);

CREATE USER 'clebinho_admin'@'localhost' IDENTIFIED BY 'senha_forte_clebinho';
CREATE USER 'joao_autor'@'localhost' IDENTIFIED BY 'senha_forte_joao';
CREATE USER 'maria_visitante'@'localhost' IDENTIFIED BY 'senha_forte_maria';

GRANT ALL PRIVILEGES ON blog.* TO 'clebinho_admin'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON blog.postagens TO 'joao_autor'@'localhost';
GRANT SELECT, UPDATE ON blog.comentarios TO 'joao_autor'@'localhost';

GRANT SELECT ON blog.postagens TO 'maria_visitante'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON blog.comentarios TO 'maria_visitante'@'localhost';

FLUSH PRIVILEGES;
