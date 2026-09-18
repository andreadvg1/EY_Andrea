CREATE DATABASE TikTokDB;
USE TikTokDB;

CREATE TABLE Usuarios (
UsuarioID INT AUTO_INCREMENT PRIMARY KEY,
NombreUsuario VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE,
FechaRegistro DATE,
Pais VARCHAR(50) NOT NULL
);
CREATE TABLE Videos (
    VideoID INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT,
    Titulo VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    FechaPublicacion DATE,
    DuracionSegundos INT,
    FOREIGN KEY (UsuarioID)
        REFERENCES Usuarios(UsuarioID)
);
CREATE TABLE Comentarios (
    ComentarioID INT AUTO_INCREMENT PRIMARY KEY,
    VideoID INT,
    UsuarioID INT,
    TextoComentario TEXT NOT NULL,
    FechaComentario DATE,
    FOREIGN KEY (VideoID)
        REFERENCES Videos(VideoID),
    FOREIGN KEY (UsuarioID)
        REFERENCES Usuarios(UsuarioID)
);
CREATE TABLE Likes (
    LikeID INT AUTO_INCREMENT PRIMARY KEY,
    VideoID INT,
    UsuarioID INT,
    FechaLike DATE,
    FOREIGN KEY (VideoID)
        REFERENCES Videos(VideoID),
    FOREIGN KEY (UsuarioID)
        REFERENCES Usuarios(UsuarioID)
);
CREATE TABLE Seguidores (
    SeguidorID INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioSeguidor INT,
    UsuarioSeguido INT,
    FechaSeguimiento DATE,
    FOREIGN KEY (UsuarioSeguidor)
        REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (UsuarioSeguido)
        REFERENCES Usuarios(UsuarioID)
);

INSERT INTO Usuarios (NombreUsuario, Email, FechaRegistro, Pais)
VALUES
('ana23', 'ana@email.com', '2024-01-15', 'España'),
('carlos99', 'carlos@email.com', '2024-02-01', 'México'),
('laura_fit', 'laura@email.com', '2024-03-10', 'Argentina'),
('davidgamer', 'david@email.com', '2024-04-05', 'España');

SELECT * FROM USUARIOS;

INSERT INTO Videos (UsuarioID, Titulo, Descripcion, FechaPublicacion, DuracionSegundos)
VALUES
(1, 'Mi primer TikTok', 'Presentación personal', '2024-05-01', 30),
(2, 'Receta rápida', 'Cómo hacer tacos', '2024-05-03', 60),
(3, 'Rutina fitness', 'Ejercicios para casa', '2024-05-05', 45),
(4, 'Gameplay FIFA', 'Partida online', '2024-05-07', 120);

INSERT INTO Comentarios (VideoID, UsuarioID, TextoComentario, FechaComentario)
VALUES
(1, 2, 'Muy buen video!', '2024-05-02'),
(2, 1, 'Voy a probar la receta', '2024-05-04'),
(3, 4, 'Excelente rutina', '2024-05-06'),
(4, 3, 'Buen gameplay', '2024-05-08');

INSERT INTO Likes (VideoID, UsuarioID, FechaLike)
VALUES
(1, 2, '2024-05-02'),
(1, 3, '2024-05-02'),
(2, 1, '2024-05-04'),
(3, 2, '2024-05-06'),
(4, 1, '2024-05-08');

INSERT INTO Seguidores (UsuarioSeguidor, UsuarioSeguido, FechaSeguimiento)
VALUES
(1, 2, '2024-04-01'),
(2, 1, '2024-04-02'),
(3, 1, '2024-04-03'),
(4, 3, '2024-04-04');

SELECT * FROM USUARIOS;
SELECT * FROM VIDEOS;
SELECT * FROM COMENTARIOS;
SELECT * FROM LIKES;
SELECT * FROM SEGUIDORES;
SELECT TEXTOCOMENTARIO FROM COMENTARIOS;

SELECT COUNT(*) AS TotalLikes FROM Likes;

# Mostrar cada video con el usuario que lo publicó
SELECT v.Titulo, u.NombreUsuario FROM Videos v
INNER JOIN Usuarios u
    ON v.UsuarioID = u.UsuarioID; 
    
# Número de videos publicados por cada usuario
SELECT u.NombreUsuario, COUNT(v.VideoID) AS TotalVideos FROM Usuarios u
LEFT JOIN Videos v
    ON u.UsuarioID = v.UsuarioID
GROUP BY u.NombreUsuario;





