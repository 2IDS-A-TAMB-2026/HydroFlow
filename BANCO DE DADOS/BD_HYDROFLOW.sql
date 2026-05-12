CREATE DATABASE BD_HYDROFLOW;
USE BD_HYDROFLOW;

CREATE TABLE IF NOT EXISTS USUARIO(
	USU_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
    USU_BAIRRO VARCHAR(255),
    USU_NUM VARCHAR(11) NOT NULL,
    USU_NOME VARCHAR(255) NOT NULL,
    USU_STATUS VARCHAR(7) NOT NULL,
    USU_CPF VARCHAR(11) NOT NULL UNIQUE,
    USU_EMAIL VARCHAR(255) NOT NULL,
    USU_SENHA VARCHAR(255) NOT NULL,
    USU_CIDADE VARCHAR(255) NOT NULL,
    USU_UF VARCHAR(2) NOT NULL,
    USU_CEP VARCHAR(8) NOT NULL
);

CREATE TABLE IF NOT EXISTS  DISPOSITIVO(
	DIS_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
	DIS_NOME VARCHAR(255) NOT NULL,
    DIS_DESCRICAO VARCHAR(255) NOT NULL,
    DIS_STATUS VARCHAR(7) NOT NULL,
	DIS_NIVEL_TANQUE FLOAT NOT NULL,
    DIS_ENDERECO VARCHAR(200),
	DIS_CEP VARCHAR(8) NOT NULL,
	DIS_RUA VARCHAR(50),
    DIS_NUM VARCHAR(10) NOT NULL,
    DIS_CIDADE VARCHAR(100) NOT NULL,
    DIS_UF VARCHAR(2) NOT NULL,
    DIS_LATITUDE VARCHAR(5) NOT NULL,
    DIS_LONGITUDE VARCHAR(5) NOT NULL,
    FK_USU_ID INTEGER NOT NULL,
    FOREIGN KEY(FK_USU_ID) REFERENCES USUARIO(USU_ID)
);

CREATE TABLE IF NOT EXISTS PLANTA(
	PLANTA_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
	PLANTA_NOME VARCHAR(255) NOT NULL,
    PLANTA_TIPO VARCHAR(20) NOT NULL,
    PLANTA_QTD_AGUA DOUBLE,
    PLANTA_PERIDIOCIDADE INTEGER NOT NULL,
    PLANTA_CULTURA VARCHAR(20),
    FK_USU_ID INTEGER NOT NULL,
    FK_DIS_ID INTEGER NOT NULL,
    FOREIGN KEY(FK_USU_ID) REFERENCES USUARIO(USU_ID),
    FOREIGN KEY(FK_DIS_ID) REFERENCES DISPOSITIVO(DIS_ID)
);

CREATE TABLE IF NOT EXISTS SENSOR(
	SEN_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
    SEN_NOME VARCHAR(50) NOT NULL,
    SEN_STATUS VARCHAR(7) NOT NULL,
    SEN_TIPO VARCHAR(30) NOT NULL,
    FK_DIS_ID INTEGER NOT NULL,
    FOREIGN KEY(FK_DIS_ID) REFERENCES DISPOSITIVO(DIS_ID)
);

CREATE TABLE IF NOT EXISTS DADOS_SENSORES(
	DDS_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
    DDS_HORA TIME,
	DDS_DATA DATE,
    DDS_UMIDADE DECIMAL(4 , 2) NOT NULL,
    FK_SEN_ID INTEGER NOT NULL,
    FOREIGN KEY(FK_SEN_ID) REFERENCES SENSOR(SEN_ID)
);

/*INSERTS*/ 
INSERT INTO USUARIO (USU_BAIRRO, USU_NUM, USU_NOME, USU_STATUS, USU_CPF, USU_EMAIL, USU_SENHA, USU_CIDADE, USU_UF, USU_CEP) 
VALUES
	('Centro', '101', 'Ana Silva', 'ATIVO', '12345678901', 'ana.silva@email.com', 'senha123', 'São Paulo', 'SP', '01001000'),
	('Copacabana', '202', 'Bruno Souza', 'ATIVO', '23456789012', 'bruno.souza@email.com', 'bruno@2024', 'Rio de Janeiro', 'RJ', '22041001'),
	('Savassi', '303', 'Carla Oliveira', 'INATIVO', '34567890123', 'carla.oli@email.com', 'carla!303', 'Belo Horizonte', 'MG', '30140010'),
	('Batista Campos', '404', 'Diego Santos', 'ATIVO', '45678901234', 'diego.santos@email.com', 'd@123456', 'Belém', 'PA', '66033000'),
	('Meireles', '505', 'Elena Costa', 'ATIVO', '56789012345', 'elena.c@email.com', 'elena9988', 'Fortaleza', 'CE', '60160230'),
	('Boa Viagem', '606', 'Fábio Junior', 'ATIVO', '67890123456', 'fabio.jr@email.com', 'fabio#pass', 'Recife', 'PE', '51020000'),
	('Asa Sul', '707', 'Gisele Rocha', 'ATIVO', '78901234567', 'gisele.r@email.com', 'gis_1234', 'Brasília', 'DF', '70300000'),
	('Moinhos de Vento', '808', 'Hugo Almeida', 'INATIVO', '89012345678', 'hugo.alm@email.com', 'hugo_pass', 'Porto Alegre', 'RS', '90570000'),
	('Batel', '909', 'Iara Martins', 'ATIVO', '90123456789', 'iara.m@email.com', 'iara!2024', 'Curitiba', 'PR', '80420000'),
	('Setor Bueno', '1010', 'João Pereira', 'ATIVO', '01234567890', 'joao.p@email.com', 'joao@1010', 'Goiânia', 'GO', '74210000'),
	('Gruta de Lourdes', '111', 'Kátia Lima', 'ATIVO', '11223344556', 'katia.lima@email.com', 'katia@321', 'Maceió', 'AL', '57052400'),
	('Ponta Negra', '222', 'Lucas Mendes', 'ATIVO', '22334455667', 'lucas.m@email.com', 'lucas_99', 'Manaus', 'AM', '69037000'),
	('Barra', '333', 'Mariana Neves', 'ATIVO', '33445566778', 'mari.neves@email.com', 'mari#789', 'Salvador', 'BA', '40140650'),
	('Jardim Camburi', '444', 'Nivaldo Reis', 'INATIVO', '44556677889', 'nivaldo@email.com', 'niv_pass', 'Vitória', 'ES', '29090000'),
	('Calhau', '555', 'Otávio Borges', 'ATIVO', '55667788990', 'otavio.b@email.com', 'otavio!01', 'São Luís', 'MA', '65071350'),
	('Santa Rosa', '666', 'Paula Diniz', 'ATIVO', '66778899001', 'paula.d@email.com', 'paula_666', 'Cuiabá', 'MT', '78040400'),
	('Vilhena', '777', 'Ricardo Vaz', 'ATIVO', '77889900112', 'ricardo.vaz@email.com', 'ric_vaz7', 'Porto Velho', 'RO', '76801000'),
	('Atalaia', '888', 'Soraia Luz', 'ATIVO', '88990011223', 'soraia.l@email.com', 'soraia!88', 'Aracaju', 'SE', '49035000'),
	('Tirol', '999', 'Tiago Abreu', 'ATIVO', '99001122334', 'tiago.abreu@email.com', 'tiago#00', 'Natal', 'RN', '59020000'),
	('Trindade', '1020', 'Ursula Dias', 'INATIVO', '10111213141', 'ursula.d@email.com', 'ursu_2024', 'Florianópolis', 'SC', '88036000'),
	('Jatiúca', '2121', 'Vitor Hugo', 'ATIVO', '21222324252', 'vitor.h@email.com', 'vitor#21', 'Maceió', 'AL', '57036000'),
	('Adrianópolis', '2222', 'Wanda Nara', 'ATIVO', '31323334353', 'wanda.n@email.com', 'wanda_sec', 'Manaus', 'AM', '69057000'),
	('Itapuã', '2323', 'Xavier Cruz', 'ATIVO', '41424344454', 'xavier.c@email.com', 'xav_cruz1', 'Salvador', 'BA', '41610000'),
	('Praia do Canto', '2424', 'Yara Farias', 'ATIVO', '51525354555', 'yara.f@email.com', 'yara@2024', 'Vitória', 'ES', '29055000'),
	('Cohama', '2525', 'Zeca Pagode', 'ATIVO', '61626364656', 'zeca.p@email.com', 'zeca_samba', 'São Luís', 'MA', '65074115'),
	('Boa Vista', '2626', 'Arthur Aguiar', 'ATIVO', '71727374757', 'arthur.a@email.com', 'art_2626', 'Curitiba', 'PR', '82540000'),
	('Ipanema', '2727', 'Beatriz Rosa', 'ATIVO', '81828384858', 'bia.rosa@email.com', 'beatriz!r', 'Rio de Janeiro', 'RJ', '22410003'),
	('Higienópolis', '2828', 'Caio Castro', 'INATIVO', '91929394959', 'caio.c@email.com', 'caio_pass', 'São Paulo', 'SP', '01238000'),
	('Pampulha', '2929', 'Daniela Mel', 'ATIVO', '02030405060', 'dani.mel@email.com', 'dani@2929', 'Belo Horizonte', 'MG', '31270000'),
	('Umarizal', '3030', 'Eduardo Paes', 'ATIVO', '12131415161', 'edu.paes@email.com', 'edu_bel30', 'Belém', 'PA', '66050000');
	

INSERT INTO DISPOSITIVO (DIS_NOME, DIS_DESCRICAO, DIS_STATUS, DIS_NIVEL_TANQUE, DIS_ENDERECO, DIS_CEP, DIS_RUA, DIS_NUM, DIS_CIDADE, DIS_UF, DIS_LATITUDE, DIS_LONGITUDE, FK_USU_ID)
VALUES
	('Sensor Alpha', 'Monitor de diesel', 'ATIVO', 85.5, 'Av. Paulista', '01310100', 'Paulista', '1000', 'São Paulo', 'SP', '-23.5', '-46.6', 1),
	('Beta 02', 'Tanque reserva', 'ATIVO', 40.0, 'Rua Barata Ribeiro', '22040000', 'Barata Ribeiro', '50', 'Rio de Janeiro', 'RJ', '-22.9', '-43.1', 2),
	('Gamma Residencial', 'Medidor de água', 'INATIVO', 12.3, 'Rua Alagoas', '30130160', 'Alagoas', '200', 'Belo Horizonte', 'MG', '-19.9', '-43.9', 4),
	('Delta Industrial', 'Combustível gerador', 'ATIVO', 98.0, 'Av. Nazaré', '66035000', 'Nazaré', '404', 'Belém', 'PA', '-1.45', '-48.4', 4),
	('Epsilon 5', 'Tanque principal', 'ATIVO', 65.2, 'Rua Silva Jatahy', '60165070', 'Silva Jatahy', '505', 'Fortaleza', 'CE', '-3.72', '-38.4', 5),
	('Zeta Smart', 'Sensor de nível', 'ATIVO', 33.7, 'Av. Boa Viagem', '51011000', 'Boa Viagem', '606', 'Recife', 'PE', '-8.12', '-34.8', 6),
	('Eta Control', 'Monitoramento SQS', 'ATIVO', 55.0, 'SQS 305', '70352000', 'Asa Sul', '707', 'Brasília', 'DF', '-15.7', '-47.8', 7),
	('Theta West', 'Reservatório sul', 'INATIVO', 0.0, 'Rua Padre Chagas', '90570080', 'Padre Chagas', '808', 'Porto Alegre', 'RS', '-30.0', '-51.2', 8),
	('Iota Curitiba', 'Nível de óleo', 'ATIVO', 77.4, 'Av. Batel', '80420010', 'Batel', '909', 'Curitiba', 'PR', '-25.4', '-49.2', 4),
	('Kappa Goiania', 'Caixa d\'água', 'ATIVO', 88.9, 'Av. T-10', '74223060', 'Setor Bueno', '1010', 'Goiânia', 'GO', '-16.7', '-49.2', 10),
	('Lambda Maceió', 'Sensor térmico', 'ATIVO', 45.0, 'Rua Dep. José Lages', '57035330', 'Ponta Verde', '111', 'Maceió', 'AL', '-9.66', '-35.7', 11),
	('Mu Manaus', 'Tanque barco', 'ATIVO', 92.1, 'Av. do Turismo', '69037005', 'Tarumã', '222', 'Manaus', 'AM', '-3.11', '-60.0', 12),
	('Nu Salvador', 'Gerador condomínio', 'ATIVO', 60.5, 'Rua Chile', '40020000', 'Centro', '333', 'Salvador', 'BA', '-12.9', '-38.5', 13),
	('Xi Vitória', 'Nível químico', 'INATIVO', 10.0, 'Av. Dante Michelini', '29060000', 'Jardim da Penha', '444', 'Vitória', 'ES', '-20.2', '-40.2', 12),
	('Omicron SLZ', 'Reservatório 15', 'ATIVO', 25.8, 'Av. dos Holandeses', '65071380', 'Calhau', '555', 'São Luís', 'MA', '-2.53', '-44.3', 15),
	('Pi Cuiabá', 'Monitor rural', 'ATIVO', 50.0, 'Av. Hist. Rubens de Mendonça', '78000000', 'Centro', '666', 'Cuiabá', 'MT', '-15.6', '-56.0', 16),
	('Rho PVH', 'Nível combustível', 'ATIVO', 70.2, 'Av. Jorge Teixeira', '76804000', 'Liberdade', '777', 'Porto Velho', 'RO', '-8.76', '-63.9', 17),
	('Sigma AJU', 'Tanque Atalaia', 'ATIVO', 82.3, 'Av. Santos Dumont', '49035000', 'Atalaia', '888', 'Aracaju', 'SE', '-10.9', '-37.0', 18),
	('Tau Natal', 'Sensor beira mar', 'ATIVO', 15.6, 'Av. Hermes da Fonseca', '59020000', 'Tirol', '999', 'Natal', 'RN', '-5.79', '-35.2', 19),
	('Upsilon Floripa', 'Gerador ilha', 'INATIVO', 5.0, 'Rua Lauro Linhares', '88036002', 'Trindade', '1020', 'Florianópolis', 'SC', '-27.5', '-48.5', 23),
	('Phi Alagoas', 'Tanque reserva 2', 'ATIVO', 99.9, 'Av. Álvaro Otacílio', '57035180', 'Ponta Verde', '2121', 'Maceió', 'AL', '-9.66', '-35.7', 21),
	('Chi Amazon', 'Flutuante nível', 'ATIVO', 44.2, 'Rua Teresina', '69057070', 'Adrianópolis', '2222', 'Manaus', 'AM', '-3.10', '-60.0', 22),
	('Psi Bahia', 'Monitor de poço', 'ATIVO', 67.8, 'Largo do Farol', '41610010', 'Itapuã', '2323', 'Salvador', 'BA', '-12.9', '-38.3', 23),
	('Omega Capixaba', 'Tanque oficina', 'ATIVO', 31.4, 'Rua Aleixo Neto', '29055000', 'Praia do Canto', '2424', 'Vitória', 'ES', '-20.3', '-40.2', 24),
	('Z-25 Maranhão', 'Silo líquido', 'ATIVO', 55.5, 'Rua do Aririzal', '65067190', 'Cohama', '2525', 'São Luís', 'MA', '-2.51', '-44.2', 25),
	('S-26 Paraná', 'Gerador TI', 'ATIVO', 88.0, 'Rua Holanda', '82510190', 'Boa Vista', '2626', 'Curitiba', 'PR', '-25.3', '-49.2', 26),
	('S-27 Carioca', 'Reservatório prédio', 'ATIVO', 12.5, 'Rua Vinícius de Moraes', '22411010', 'Ipanema', '2727', 'Rio de Janeiro', 'RJ', '-22.9', '-43.2', 8),
	('S-28 Paulista', 'Tanque subsolo', 'INATIVO', 0.5, 'Rua Maranhão', '01240000', 'Higienópolis', '2828', 'São Paulo', 'SP', '-23.5', '-46.6', 8),
	('S-29 Mineiro', 'Sensor lagoa', 'ATIVO', 42.1, 'Av. Otacílio Negrão de Lima', '31365450', 'Pampulha', '2929', 'Belo Horizonte', 'MG', '-19.8', '-43.9', 19),
	('S-30 Belém', 'Gerador hospital', 'ATIVO', 95.0, 'Rua Domingos Marreiros', '66050380', 'Umarizal', '3030', 'Belém', 'PA', '-1.44', '-48.4', 3);
	
    INSERT INTO DISPOSITIVO (DIS_NOME, DIS_DESCRICAO, DIS_STATUS, DIS_NIVEL_TANQUE, DIS_ENDERECO, DIS_CEP, DIS_RUA, DIS_NUM, DIS_CIDADE, DIS_UF, DIS_LATITUDE, DIS_LONGITUDE, FK_USU_ID)
    VALUES
    ('Xi Vitória', 'Nível químico', 'INATIVO', 10.0, 'Av. Dante Michelini', '29060000', 'Jardim da Penha', '444', 'Vitória', 'ES', '-20.2', '-40.3', 14),
    ('Sigma AJU', 'Tanque Atalaia', 'ATIVO', 82.3, 'Av. Santos Dumont', '49035000', 'Atalaia', '888', 'Aracaju', 'SE', '-10.9', '-37.1', 9),
    ('S-27 Carioca', 'Reservatório prédio', 'ATIVO', 12.5, 'Rua Vinícius de Moraes', '22411010', 'Ipanema', '2727', 'Rio de Janeiro', 'RJ', '-22.9', '-43.8', 20),
    ('S-31 Carioca', 'Reservatório prédio', 'ATIVO', 12.5, 'Rua Vinícius de Moraes', '22411010', 'Ipanema', '2727', 'Rio de Janeiro', 'RJ', '-22.9', '-43.2', 27),
	('S-32 Paulista', 'Tanque subsolo', 'INATIVO', 0.5, 'Rua Maranhão', '01240000', 'Higienópolis', '2828', 'São Paulo', 'SP', '-23.5', '-46.6', 28),
	('S-33 Mineiro', 'Sensor lagoa', 'ATIVO', 42.1, 'Av. Otacílio Negrão de Lima', '31365450', 'Pampulha', '2929', 'Belo Horizonte', 'MG', '-19.8', '-43.9', 29),
	('S-34 Belém', 'Gerador hospital', 'ATIVO', 95.0, 'Rua Domingos Marreiros', '66050380', 'Umarizal', '3030', 'Belém', 'PA', '-1.44', '-48.4', 30),
    ('Gamma Residencial', 'Medidor de água', 'INATIVO', 12.3, 'Rua Alagoas', '30130160', 'Alagoas', '200', 'Belo Horizonte', 'MG', '-19.9', '-43.9', 3);
    
    
SELECT * FROM DISPOSITIVO;
SELECT * FROM DISPOSITIVO WHERE FK_USU_ID = 4;

INSERT INTO PLANTA (PLANTA_NOME, PLANTA_TIPO, PLANTA_QTD_AGUA, PLANTA_PERIDIOCIDADE, PLANTA_CULTURA, FK_USU_ID, FK_DIS_ID)
VALUES
	('Samambaia Real', 'Ornamental', 0.5, 2, 'Doméstica', 1, 1),
	('Tomate Cereja', 'Frutífera', 0.8, 1, 'Horta', 2, 2),
	('Cacto Bola', 'Suculenta', 0.1, 15, 'Desértica', 3, 3),
	('Manjericão', 'Hortaliça', 0.3, 1, 'Horta', 4, 4),
	('Orquídea Phalaenopsis', 'Flor', 0.2, 7, 'Ornamental', 5, 5),
	('Pimenteira Malagueta', 'Condimento', 0.4, 2, 'Horta', 6, 6),
	('Espada de São Jorge', 'Ornamental', 0.3, 10, 'Doméstica', 7, 7),
	('Alecrim', 'Erva', 0.2, 3, 'Horta', 8, 8),
	('Girassol', 'Flor', 1.2, 1, 'Agrícola', 9, 9),
	('Babosa', 'Medicinal', 0.4, 12, 'Doméstica', 10, 10),
	('Alface Crespa', 'Hortaliça', 0.5, 1, 'Hidroponia', 11, 11),
	('Morango', 'Frutífera', 0.6, 2, 'Horta', 12, 12),
	('Jiboia', 'Ornamental', 0.4, 4, 'Doméstica', 13, 13),
	('Lavanda', 'Aromática', 0.3, 3, 'Ornamental', 14, 14),
	('Limoeiro Siciliano', 'Árvore', 5.0, 3, 'Frutífera', 15, 15),
	('Cebolinha', 'Hortaliça', 0.2, 1, 'Horta', 16, 16),
	('Suculenta Rosa', 'Suculenta', 0.1, 20, 'Ornamental', 17, 17),
	('Hortelã', 'Erva', 0.4, 1, 'Horta', 18, 18),
	('Bonsai Ficus', 'Árvore', 0.3, 2, 'Ornamental', 19, 19),
	('Zamioculca', 'Ornamental', 0.5, 15, 'Doméstica', 20, 20),
	('Arruda', 'Medicinal', 0.3, 3, 'Doméstica', 21, 21),
	('Gengibre', 'Raiz', 0.6, 5, 'Horta', 22, 22),
	('Lírio da Paz', 'Flor', 0.7, 3, 'Doméstica', 23, 23),
	('Ipê Amarelo', 'Árvore', 10.0, 7, 'Reflorestamento', 24, 24),
	('Salsa', 'Hortaliça', 0.2, 1, 'Horta', 25, 25),
	('Antúrio', 'Flor', 0.5, 4, 'Ornamental', 26, 26),
	('Couve Manteiga', 'Hortaliça', 0.8, 1, 'Horta', 27, 27),
	('Jasmin Manga', 'Flor', 1.5, 5, 'Ornamental', 28, 28),
	('Jabuticabeira', 'Árvore', 8.0, 1, 'Frutífera', 29, 29),
	('Coentro', 'Hortaliça', 0.2, 1, 'Horta', 30, 30);
SELECT * FROM PLANTA;

INSERT INTO SENSOR (SEN_NOME, SEN_STATUS, SEN_TIPO, FK_DIS_ID)
VALUES
	('Higrômetro Solo A1', 'ATIVO', 'Umidade do Solo', 1),
	('Termômetro Ar B2', 'ATIVO', 'Temperatura', 2),
	('Ultrassônico Nível', 'ATIVO', 'Nível de Tanque', 3),
	('Sensor Umidade Relativa', 'ATIVO', 'Umidade do Ar', 4),
	('Sonda de Solo Profunda', 'ATIVO', 'Umidade do Solo', 5),
	('Termostato Ambiente', 'ATIVO', 'Temperatura', 6),
	('Boia Eletrônica Digital', 'ATIVO', 'Nível de Tanque', 7),
	('Higrômetro Solo A8', 'INATIVO', 'Umidade do Solo', 8),
	('Sensor Vazão Óleo', 'ATIVO', 'Fluxo de Líquido', 9),
	('Sensor Pressão Hidráulica', 'ATIVO', 'Pressão', 10),
	('Termômetro Tanque 11', 'ATIVO', 'Temperatura', 11),
	('Ultrassônico Rio', 'ATIVO', 'Nível de Tanque', 12),
	('Sensor Umidade 13', 'ATIVO', 'Umidade do Solo', 13),
	('Sensor Ph Solo', 'INATIVO', 'Acidez/Ph', 14),
	('Sonda Nível Água', 'ATIVO', 'Nível de Tanque', 15),
	('Termômetro Estufa', 'ATIVO', 'Temperatura', 16),
	('Higrômetro Campo', 'ATIVO', 'Umidade do Solo', 17),
	('Sensor Condutividade', 'ATIVO', 'Salinidade', 18),
	('Sensor Radiação UV', 'ATIVO', 'Luminosidade', 19),
	('Sensor Nível Crítico', 'INATIVO', 'Nível de Tanque', 20),
	('Sonda Umidade Alta', 'ATIVO', 'Umidade do Solo', 21),
	('Termômetro Água', 'ATIVO', 'Temperatura', 22),
	('Sensor Fluxo 23', 'ATIVO', 'Fluxo de Líquido', 23),
	('Higrômetro Solo 24', 'ATIVO', 'Umidade do Solo', 24),
	('Sensor Turbidez', 'ATIVO', 'Qualidade da Água', 25),
	('Sensor Térmico CPU', 'ATIVO', 'Temperatura', 26),
	('Sonda Nível Predial', 'ATIVO', 'Nível de Tanque', 27),
	('Sensor Umidade Porão', 'INATIVO', 'Umidade do Ar', 28),
	('Termômetro Solo Lagoa', 'ATIVO', 'Temperatura', 29),
	('Sensor Nível Hospitalar', 'ATIVO', 'Nível de Tanque', 30);

INSERT INTO DADOS_SENSORES (DDS_HORA, DDS_DATA, DDS_UMIDADE, FK_SEN_ID) 
VALUES
	('08:00:00','2022-12-12', 45.50, 1),
	('08:15:00', '2021-11-11', 42.30, 2),
	('08:30:00', '2020-10-10', 88.00, 3),
	('08:45:00', '2023-10-01', 60.15, 4),
	('09:00:00', '2023-10-02', 35.40, 5),
	('09:15:00', '2023-10-03', 22.10, 6),
	('09:30:00', '2023-10-04', 75.00, 7),
	('09:45:00', '2023-10-05', 10.50, 8),
	('10:00:00', '2023-10-06', 55.80, 9),
	('10:15:00', '2023-10-07', 92.33, 10),
	('10:30:00', '2023-10-08', 40.00, 11),
	('10:45:00', '2023-10-09', 66.75, 12),
	('11:00:00', '2023-10-09', 30.20, 13),
	('11:15:00', '2023-10-10', 15.00, 14),
	('11:30:00', '2023-10-11', 82.40, 15),
	('11:45:00', '2023-10-12', 48.90, 16),
	('12:00:00', '2023-10-13', 50.00, 17),
	('12:15:00', '2023-10-14', 12.00, 18),
	('12:30:00', '2023-10-15', 25.60, 19),
	('12:45:00', '2023-10-16', 05.50, 20),
	('13:00:00', '2023-10-17', 99.10, 21),
	('13:15:00', '2023-10-18', 33.33, 22),
	('13:30:00', '2023-10-19', 44.50, 23),
	('13:45:00', '2023-10-20', 61.20, 24),
	('14:00:00', '2023-10-21', 77.80, 25),
	('14:15:00', '2023-10-22', 19.90, 26),
	('14:30:00', '2023-10-23', 85.00, 27),
	('14:45:00', '2023-10-24', 30.00, 28),
	('15:00:00', '2023-10-25', 41.25, 29),
	('15:15:00', '2023-10-26', 95.00, 30);
/*SELECTS :O*/

	/*SELECTS DOS USUÁRIOS*/
/*1*/
SELECT * FROM USUARIO;
/*2*/
SELECT USU_NOME AS "NOME DO USUÁRIO", USU_STATUS AS "STATUS" FROM USUARIO;
/*3*/
SELECT 
    USU_STATUS AS "Status", 
    COUNT(*) AS "Quantidade"
FROM USUARIO
GROUP BY USU_STATUS;
/*4*/
SELECT USU_NOME AS "NOME DO USUÁRIO", USU_UF AS "Unidade Federativa(UF)"
FROM USUARIO;
/*5*/
SELECT
	USU_UF AS "Unidadide Federativa (UF)",
    COUNT(*) AS "Quantidade"
FROM USUARIO
GROUP BY USU_UF;
/*6*/
SELECT 
	USU_CIDADE AS "Cidade", 
	COUNT(*) AS "Total por cidade"
FROM USUARIO 
GROUP BY USU_CIDADE;
/*7*/
SELECT USU_NOME AS "Usuário", USU_EMAIL as "Email" 
FROM USUARIO 
WHERE USU_EMAIL LIKE '%@email.com';
/*8*/
SELECT 
	USU_NOME AS "Nome", 
    USU_CIDADE AS "Cidade", 
    USU_UF AS "Unidade Federativa (UF)"
FROM USUARIO 
WHERE USU_CIDADE IN ('São Paulo', 'Rio de Janeiro', 'Belo Horizonte')
ORDER BY USU_UF, USU_CIDADE;
/*9*/
SELECT USU_BAIRRO, COUNT(*) AS total_usuarios
FROM USUARIO 
WHERE USU_CIDADE IN ('São Paulo', "Rio de Janeiro", "Belo Horizonte")
GROUP BY USU_BAIRRO
ORDER BY total_usuarios DESC;
/*10*/
SELECT 
    USU_ID, 
    USU_NOME, 
    USU_EMAIL, 
    USU_STATUS
FROM USUARIO 
WHERE USU_BAIRRO IS NULL 
   OR USU_STATUS = 'INATIVO'
ORDER BY USU_STATUS DESC;

/*SELECTS DISPOSITIVOS*/

/*1*/ 
SELECT 
	DIS_ID AS "ID do dispositivo",
	DIS_NOME AS "Nome do dispositivo", 
    DIS_NIVEL_TANQUE AS "Nivel do Tanque",
    DIS_CIDADE  AS "Cidade"
FROM DISPOSITIVO 
WHERE DIS_NIVEL_TANQUE < 20.0;

/*2*/
SELECT DIS_UF, COUNT(*) AS total_dispositivos
FROM DISPOSITIVO 
GROUP BY DIS_UF 
ORDER BY total_dispositivos DESC;

/*3*/
SELECT DIS_NOME, DIS_ENDERECO, DIS_STATUS 
FROM DISPOSITIVO 
WHERE DIS_CIDADE = 'São Paulo' AND DIS_STATUS = 'ATIVO';

/*4*/
SELECT DIS_NOME, DIS_RUA, DIS_NUM 
FROM DISPOSITIVO 
WHERE DIS_CEP = '01310100';

/*5*/
SELECT DIS_NOME, DIS_NIVEL_TANQUE 
FROM DISPOSITIVO 
WHERE DIS_NIVEL_TANQUE >= 90.0;

/*6*/
SELECT DIS_NOME, DIS_STATUS, DIS_NIVEL_TANQUE 
FROM DISPOSITIVO 
WHERE FK_USU_ID = 8;
/*7*/
SELECT DIS_NOME, DIS_CIDADE, DIS_UF 
FROM DISPOSITIVO 
WHERE DIS_STATUS = 'INATIVO';
/*8*/
SELECT DIS_NOME AS"Nome do Dispositivo", DIS_LATITUDE AS "Latitude", DIS_LONGITUDE AS "Longitude"
FROM DISPOSITIVO 
WHERE DIS_LATITUDE LIKE '-23%' AND DIS_LONGITUDE LIKE '-46%';
/*9*/
SELECT DIS_CIDADE AS "Cidade", ROUND(AVG(DIS_NIVEL_TANQUE),2) AS "Média dos Tanques"
FROM DISPOSITIVO 
GROUP BY DIS_CIDADE;
/*10*/ 
SELECT DIS_CIDADE, DIS_RUA, COUNT(*) AS qtd_dispositivos
FROM DISPOSITIVO 
GROUP BY DIS_CIDADE, DIS_RUA 
ORDER BY qtd_dispositivos DESC;

/*SELECTS DAS PLANTA*/

/*1*/
SELECT PLANTA_NOME AS "Nome da planta", PLANTA_QTD_AGUA "Consumo" 
FROM PLANTA 
ORDER BY PLANTA_QTD_AGUA DESC 
LIMIT 5;
/*2*/
SELECT PLANTA_NOME AS "Nome da planta" , PLANTA_TIPO AS "Tipo de Planta", PLANTA_CULTURA AS "Cultura" 
FROM PLANTA 
WHERE PLANTA_PERIDIOCIDADE = 1;
/*3*/ 
SELECT PLANTA_TIPO AS "Tipo de Planta", COUNT(*) AS "total" 
FROM PLANTA 
GROUP BY PLANTA_TIPO;
/*4*/
SELECT PLANTA_CULTURA AS "Cultura", ROUND(AVG(PLANTA_QTD_AGUA), 2) AS "Média de Consumo"
FROM PLANTA 
GROUP BY PLANTA_CULTURA;
/*5*/ 
SELECT PLANTA_NOME AS "Nome da Planta", PLANTA_PERIDIOCIDADE "Peridiocidade" 
FROM PLANTA 
WHERE PLANTA_PERIDIOCIDADE > 10;
/*6*/
SELECT PLANTA_NOME, PLANTA_TIPO 
FROM PLANTA 
WHERE PLANTA_CULTURA = 'Horta'
ORDER BY PLANTA_NOME ASC;
/*7*/
SELECT
    FK_DIS_ID AS "ID do Dispositivo",
    SUM(PLANTA_QTD_AGUA) AS "Volume necessário para o dispositivo"
FROM PLANTA 
WHERE FK_DIS_ID = 1; 
/*8*/
SELECT 
    FK_DIS_ID AS "ID doDispositivo",
    COUNT(*) AS "Total de plantas",
    ROUND(SUM(PLANTA_QTD_AGUA), 2) AS volume_total_agua
FROM PLANTA 
GROUP BY FK_DIS_ID
ORDER BY volume_total_agua DESC;

/*9*/
SELECT PLANTA_NOME, PLANTA_QTD_AGUA 
FROM PLANTA 
WHERE PLANTA_TIPO = 'Árvore' AND PLANTA_QTD_AGUA > 2.0;

/*10*/ 
SELECT PLANTA_NOME, PLANTA_TIPO, PLANTA_CULTURA 
FROM PLANTA 
WHERE FK_USU_ID = 1;

/*SELECTS SENSORES*/

/*1*/
SELECT SEN_NOME AS "Nome do Sensor", SEN_STATUS as "STATUS" 
FROM SENSOR 
WHERE SEN_TIPO = 'Umidade do Solo';

/*2*/
SELECT SEN_STATUS AS "Status", COUNT(*) AS total
FROM SENSOR 
GROUP BY SEN_STATUS;

/*3*/
SELECT SEN_TIPO, COUNT(*) AS quantidade
FROM SENSOR 
GROUP BY SEN_TIPO
ORDER BY quantidade DESC;

/*4*/
SELECT SEN_NOME AS "NOME DO SENSOR", SEN_TIPO AS "TIPO DE SENSOR" 
FROM SENSOR 
WHERE FK_DIS_ID = 1;

/*5*/
SELECT * FROM SENSOR 
WHERE SEN_NOME LIKE 'Termômetro%';

/*6*/
SELECT SEN_NOME, SEN_TIPO 
FROM SENSOR 
WHERE SEN_STATUS = 'INATIVO' AND FK_DIS_ID = 8;

/*7*/ 
SELECT SEN_NOME, FK_DIS_ID 
FROM SENSOR 
WHERE SEN_TIPO LIKE '%Nível%';

/*8*/
SELECT FK_DIS_ID, COUNT(*) AS num_sensores
FROM SENSOR 
GROUP BY FK_DIS_ID
ORDER BY num_sensores DESC;

/*9*/ 
SELECT * FROM SENSOR 
WHERE SEN_ID = 15;

/*10*/ 
SELECT FK_DIS_ID, SEN_STATUS, COUNT(*) AS total
FROM SENSOR 
GROUP BY FK_DIS_ID, SEN_STATUS;

/*SELECTS DADOS SENSORES*/

/*1*/
SELECT * FROM DADOS_SENSORES 
ORDER BY DDS_UMIDADE DESC 
LIMIT 5;

/*2*/ 
SELECT 
    COUNT(*) AS total_leituras,
    ROUND(AVG(DDS_UMIDADE), 2) AS umidade_media,
    MIN(DDS_UMIDADE) AS umidade_minima_registrada,
    MAX(DDS_UMIDADE) AS umidade_maxima_registrada
FROM DADOS_SENSORES;
/*3*/
SELECT * FROM DADOS_SENSORES 
WHERE DDS_HORA BETWEEN '08:00:00' AND '12:00:00';
/*4*/
SELECT DDS_HORA, DDS_UMIDADE 
FROM DADOS_SENSORES 
WHERE FK_SEN_ID = 1 
ORDER BY DDS_HORA ASC;
/*5*/
SELECT COUNT(*) AS leituras_altas 
FROM DADOS_SENSORES 
WHERE DDS_UMIDADE > 80.00;
/*6*/ 
SELECT FK_SEN_ID, MIN(DDS_UMIDADE) AS umidade_minima 
FROM DADOS_SENSORES 
GROUP BY FK_SEN_ID;
/*7*/
SELECT * FROM DADOS_SENSORES 
WHERE DDS_UMIDADE LIKE '%.00';
/*8*/
SELECT FK_SEN_ID, ROUND(AVG(DDS_UMIDADE), 2) AS media_sensor 
FROM DADOS_SENSORES 
GROUP BY FK_SEN_ID;
/*9*/
SELECT * FROM DADOS_SENSORES 
WHERE DDS_HORA LIKE '%:00:00';
/*10*/
SELECT FK_SEN_ID, DDS_UMIDADE, DDS_HORA 
FROM DADOS_SENSORES 
WHERE DDS_UMIDADE < 10.00;

/*JOINS :o*/

/*1*/
SELECT 
    U.USU_NOME AS "Proprietario",
    D.DIS_NOME AS "Dispositivo",
    D.DIS_CIDADE AS "Localizacao",
    P.PLANTA_NOME AS "Planta",
    S.SEN_NOME AS "Sensor",
    DS.DDS_UMIDADE AS "Umidade Lida",
    DS.DDS_HORA AS "Horario da Leitura"
FROM USUARIO U
INNER JOIN DISPOSITIVO D ON U.USU_ID = D.FK_USU_ID
INNER JOIN PLANTA P ON D.DIS_ID = P.FK_DIS_ID
INNER JOIN SENSOR S ON D.DIS_ID = S.FK_DIS_ID
INNER JOIN DADOS_SENSORES DS ON S.SEN_ID = DS.FK_SEN_ID
ORDER BY DS.DDS_HORA DESC;

/*2*/
SELECT 
    U.USU_NOME AS "Proprietario",
    D.DIS_NOME AS "Dispositivo",
    P.PLANTA_NOME AS "Planta",
    S.SEN_NOME AS "Sensor",
    DS.DDS_UMIDADE AS "Umidade Atual",
    DS.DDS_HORA AS "Horario Critico"
FROM USUARIO U
INNER JOIN DISPOSITIVO D ON U.USU_ID = D.FK_USU_ID
INNER JOIN PLANTA P ON D.DIS_ID = P.FK_DIS_ID
INNER JOIN SENSOR S ON D.DIS_ID = S.FK_DIS_ID
INNER JOIN DADOS_SENSORES DS ON S.SEN_ID = DS.FK_SEN_ID
WHERE DS.DDS_UMIDADE < 30.00
ORDER BY DS.DDS_UMIDADE ASC;

/*3*/
SELECT U.USU_NOME AS "Nome do usuário", COUNT(P.PLANTA_ID) AS "total de plantas"
FROM USUARIO U
INNER JOIN PLANTA P ON U.USU_ID = P.FK_USU_ID
GROUP BY U.USU_NOME;

/*4*/
SELECT D.DIS_NOME AS "Dispositivos sem planta "
FROM DISPOSITIVO D
LEFT JOIN PLANTA P ON D.DIS_ID = P.FK_DIS_ID
WHERE P.PLANTA_ID IS NULL;

/*5*/
SELECT P.PLANTA_NOME AS "Nome da Planta", ROUND(AVG(DS.DDS_UMIDADE), 2) AS "Umidade média"
FROM PLANTA P
INNER JOIN SENSOR S ON P.FK_DIS_ID = S.FK_DIS_ID
INNER JOIN DADOS_SENSORES DS ON S.SEN_ID = DS.FK_SEN_ID
GROUP BY P.PLANTA_NOME;

/*6*/
SELECT S.SEN_NOME AS "NOME DO SENSOR", D.DIS_RUA "RUA DO DISPOSITIVO", D.DIS_NUM "NÚMERO DO DISPOSITIVO", D.DIS_CIDADE "CIDADE DO DISPOSITIVO"
FROM SENSOR S
INNER JOIN DISPOSITIVO D ON S.FK_DIS_ID = D.DIS_ID
WHERE S.SEN_STATUS = 'INATIVO';

/*7*/ 
SELECT U.USU_NOME AS "NOME DO USUÁRIO", SUM(P.PLANTA_QTD_AGUA) AS "CONSUMO TOTAL DE ÁGUA"
FROM USUARIO U
INNER JOIN PLANTA P ON U.USU_ID = P.FK_USU_ID
GROUP BY U.USU_NOME;

/*8*/
SELECT P.PLANTA_NOME AS "NOME DA PLANTA", S.SEN_NOME AS "NOME DO SENSOR", S.SEN_TIPO AS "TIPO DE SENSOR"
FROM PLANTA P
INNER JOIN SENSOR S ON P.FK_DIS_ID = S.FK_DIS_ID;

/*9*/
SELECT U.USU_NOME, D.DIS_NOME, CONCAT(D.DIS_RUA, ', ', D.DIS_NUM, ' - ', D.DIS_CIDADE, '/', D.DIS_UF) AS endereco_completo
FROM USUARIO U
INNER JOIN DISPOSITIVO D ON U.USU_ID = D.FK_USU_ID;

/*10*/
SELECT P.PLANTA_NOME, P.PLANTA_QTD_AGUA, D.DIS_NOME, D.DIS_NIVEL_TANQUE
FROM PLANTA P
INNER JOIN DISPOSITIVO D ON P.FK_DIS_ID = D.DIS_ID;

/*11*/
SELECT U.USU_NOME, U.USU_EMAIL
FROM USUARIO U
LEFT JOIN DISPOSITIVO D ON U.USU_ID = D.FK_USU_ID
WHERE D.DIS_ID IS NULL;

/*12*/ 
SELECT D.DIS_CIDADE, ROUND(AVG(DS.DDS_UMIDADE), 2) AS umidade_media_cidade
FROM DISPOSITIVO D
INNER JOIN SENSOR S ON D.DIS_ID = S.FK_DIS_ID
INNER JOIN DADOS_SENSORES DS ON S.SEN_ID = DS.FK_SEN_ID
GROUP BY D.DIS_CIDADE;

/*13*/
SELECT S.SEN_NOME, S.SEN_TIPO, D.DIS_NOME
FROM SENSOR S
INNER JOIN DISPOSITIVO D ON S.FK_DIS_ID = D.DIS_ID
WHERE D.DIS_STATUS = 'INATIVO';

/*14*/
SELECT U.USU_NOME, S.SEN_NOME, S.SEN_STATUS
FROM USUARIO U
INNER JOIN DISPOSITIVO D ON U.USU_ID = D.FK_USU_ID
INNER JOIN SENSOR S ON D.DIS_ID = S.FK_DIS_ID;

/*15*/
SELECT U.USU_NOME, COUNT(DS.DDS_ID) AS total_leituras_geradas
FROM USUARIO U
INNER JOIN DISPOSITIVO D ON U.USU_ID = D.FK_USU_ID
INNER JOIN SENSOR S ON D.DIS_ID = S.FK_DIS_ID
INNER JOIN DADOS_SENSORES DS ON S.SEN_ID = DS.FK_SEN_ID
GROUP BY U.USU_NOME; 

/*16*/
SELECT P.PLANTA_CULTURA, D.DIS_CIDADE, D.DIS_UF
FROM PLANTA P
INNER JOIN DISPOSITIVO D ON P.FK_DIS_ID = D.DIS_ID;

/*17*/
SELECT U.USU_NOME, P.PLANTA_NOME, P.PLANTA_QTD_AGUA
FROM USUARIO U
INNER JOIN PLANTA P ON U.USU_ID = P.FK_USU_ID
WHERE U.USU_ID = 1 AND P.PLANTA_QTD_AGUA > 1.0;

/*17*/
SELECT U.USU_UF, COUNT(S.SEN_ID) AS total_sensores_uf
FROM USUARIO U
INNER JOIN DISPOSITIVO D ON U.USU_ID = D.FK_USU_ID
INNER JOIN SENSOR S ON D.DIS_ID = S.FK_DIS_ID
GROUP BY U.USU_UF
ORDER BY total_sensores_uf DESC;

/*19*/
SELECT P.PLANTA_NOME, DS.DDS_UMIDADE, DS.DDS_HORA
FROM PLANTA P
INNER JOIN SENSOR S ON P.FK_DIS_ID = S.FK_DIS_ID
INNER JOIN DADOS_SENSORES DS ON S.SEN_ID = DS.FK_SEN_ID
ORDER BY DS.DDS_HORA DESC;

/*20*/
SELECT 
    COUNT(*) AS total_leituras,
    ROUND(AVG(DDS_UMIDADE), 2) AS umidade_media,
    MIN(DDS_UMIDADE) AS umidade_minima_registrada,
    MAX(DDS_UMIDADE) AS umidade_maxima_registrada
FROM DADOS_SENSORES;
