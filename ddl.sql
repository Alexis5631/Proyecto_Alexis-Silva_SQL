CREATE DATABASE IF NOT EXISTS campuslands_ERP;
USE campuslands_ERP; 

-- Tabla de Sedes (Movida al inicio)
CREATE TABLE sedes (
    id_sede INT PRIMARY KEY AUTO_INCREMENT,
    nombre_sede VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa'
);

-- Tabla de Rutas
CREATE TABLE rutas (
    id_ruta INT PRIMARY KEY AUTO_INCREMENT,
    nombre_ruta VARCHAR(100) NOT NULL,
    descripcion TEXT,
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa',
    duracion_meses INT,
    id_sede INT,
    FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
);

-- Tabla de Trainers
CREATE TABLE trainers (
    id_trainer INT PRIMARY KEY AUTO_INCREMENT,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo',
    id_sede INT,
    FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
);

-- Tabla de Áreas de Entrenamiento
CREATE TABLE areas_entrenamiento (
    id_area INT PRIMARY KEY AUTO_INCREMENT,
    nombre_area VARCHAR(50) NOT NULL,
    capacidad_maxima INT DEFAULT 33,
    estado ENUM('Disponible', 'Ocupada', 'Mantenimiento') DEFAULT 'Disponible',
    id_sede INT,
    FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
);

-- Tabla de Campers
CREATE TABLE campers (
    id_camper INT PRIMARY KEY AUTO_INCREMENT,
    numero_identificacion VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    direccion TEXT NOT NULL,
    acudiente VARCHAR(100) NOT NULL,
    telefono_contacto VARCHAR(20) NOT NULL,
    estado ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado') NOT NULL,
    nivel_riesgo ENUM('Alto', 'Medio', 'Bajo') NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_sede INT,
    FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
);

-- Tabla de Asignaciones de Sedes
CREATE TABLE asignaciones_sedes (
    id_asignacion INT PRIMARY KEY AUTO_INCREMENT,
    id_sede INT,
    id_ruta INT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado ENUM('Activa', 'Finalizada', 'Cancelada') DEFAULT 'Activa',
    FOREIGN KEY (id_sede) REFERENCES sedes(id_sede),
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta)
);

-- Tabla de Historial de Cambios de Sede
CREATE TABLE historial_cambios_sede (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_camper INT,
    sede_anterior INT,
    sede_nueva INT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo TEXT,
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper),
    FOREIGN KEY (sede_anterior) REFERENCES sedes(id_sede),
    FOREIGN KEY (sede_nueva) REFERENCES sedes(id_sede)
);

-- Tabla de Módulos
CREATE TABLE modulos (
    id_modulo INT PRIMARY KEY AUTO_INCREMENT,
    id_ruta INT,
    nombre_modulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    orden INT NOT NULL,
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta)
);

-- Tabla de Bases de Datos
CREATE TABLE bases_datos (
    id_bd INT PRIMARY KEY AUTO_INCREMENT,
    nombre_bd VARCHAR(50) NOT NULL,
    tipo ENUM('Principal', 'Alternativo') NOT NULL
);

-- Tabla de relación Rutas-Bases de Datos
CREATE TABLE rutas_bases_datos (
    id_ruta INT,
    id_bd INT,
    PRIMARY KEY (id_ruta, id_bd),
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta),
    FOREIGN KEY (id_bd) REFERENCES bases_datos(id_bd)
);

-- Tabla de Asignaciones Trainer-Ruta
CREATE TABLE asignaciones_trainer_ruta (
    id_asignacion INT PRIMARY KEY AUTO_INCREMENT,
    id_trainer INT,
    id_ruta INT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer),
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta)
);

-- Tabla de Horarios
CREATE TABLE horarios (
    id_horario INT PRIMARY KEY AUTO_INCREMENT,
    id_area INT,
    id_trainer INT,
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (id_area) REFERENCES areas_entrenamiento(id_area),
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer)
);

-- Tabla de Inscripciones
CREATE TABLE inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_camper INT,
    id_ruta INT,
    fecha_inscripcion DATE NOT NULL,
    estado ENUM('Activa', 'Finalizada', 'Cancelada') DEFAULT 'Activa',
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper),
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta)
);

-- Tabla de Evaluaciones
CREATE TABLE evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_camper INT,
    id_modulo INT,
    evaluacion_teorica DECIMAL(5,2),
    evaluacion_practica DECIMAL(5,2),
    evaluacion_trabajos DECIMAL(5,2),
    nota_final DECIMAL(5,2),
    fecha_evaluacion DATE NOT NULL,
    estado ENUM('Aprobado', 'Reprobado') NOT NULL,
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper),
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
);

-- Tabla de Asistencia
CREATE TABLE asistencia (
    id_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    id_camper INT,
    id_area INT,
    fecha DATE NOT NULL,
    estado ENUM('Presente', 'Ausente', 'Justificado') NOT NULL,
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper),
    FOREIGN KEY (id_area) REFERENCES areas_entrenamiento(id_area)
);

-- Tabla de Teléfonos de Campers (para múltiples teléfonos)
CREATE TABLE telefonos_campers (
    id_telefono INT PRIMARY KEY AUTO_INCREMENT,
    id_camper INT,
    numero_telefono VARCHAR(20) NOT NULL,
    tipo_telefono ENUM('Principal', 'Secundario', 'Emergencia') DEFAULT 'Principal',
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper)
);

-- Tabla de Historial de Cambios de Estado
CREATE TABLE historial_cambios_estado (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_camper INT,
    estado_anterior ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado'),
    estado_nuevo ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado'),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo TEXT,
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper)
);

-- Tabla de Egresados
CREATE TABLE egresados (
    id_egresado INT PRIMARY KEY AUTO_INCREMENT,
    id_camper INT,
    fecha_graduacion DATE NOT NULL,
    promedio_final DECIMAL(5,2),
    ruta_completada INT,
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper),
    FOREIGN KEY (ruta_completada) REFERENCES rutas(id_ruta)
);

-- Tabla de Plantillas de Rutas
CREATE TABLE plantillas_rutas (
    id_plantilla INT PRIMARY KEY AUTO_INCREMENT,
    nombre_plantilla VARCHAR(100) NOT NULL,
    descripcion TEXT,
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa'
);

-- Tabla de Plantillas de Módulos
CREATE TABLE plantillas_modulos (
    id_plantilla_modulo INT PRIMARY KEY AUTO_INCREMENT,
    id_plantilla INT,
    nombre_modulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    orden INT NOT NULL,
    FOREIGN KEY (id_plantilla) REFERENCES plantillas_rutas(id_plantilla)
);

-- Tabla de Notificaciones a Trainers
CREATE TABLE notificaciones_trainers (
    id_notificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_trainer INT,
    tipo_notificacion ENUM('Cambio de Horario', 'Nuevo Camper', 'Bajo Rendimiento', 'General') NOT NULL,
    mensaje TEXT NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('No leída', 'Leída', 'Archivada') DEFAULT 'No leída',
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer)
);

-- Tabla de Conocimientos de Trainers
CREATE TABLE conocimientos_trainers (
    id_conocimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_trainer INT,
    tecnologia VARCHAR(100) NOT NULL,
    nivel ENUM('Básico', 'Intermedio', 'Avanzado', 'Experto') NOT NULL,
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer)
);

-- Tabla de Reportes Mensuales
CREATE TABLE reportes_mensuales (
    id_reporte INT PRIMARY KEY AUTO_INCREMENT,
    id_ruta INT,
    mes INT NOT NULL,
    año INT NOT NULL,
    total_campers INT,
    promedio_general DECIMAL(5,2),
    campers_aprobados INT,
    campers_reprobados INT,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta)
);

-- Tabla de Asignaciones de Áreas
CREATE TABLE asignaciones_areas (
    id_asignacion INT PRIMARY KEY AUTO_INCREMENT,
    id_area INT,
    id_ruta INT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado ENUM('Activa', 'Finalizada', 'Cancelada') DEFAULT 'Activa',
    FOREIGN KEY (id_area) REFERENCES areas_entrenamiento(id_area),
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta)
);

-- Tabla de Historial de Horarios
CREATE TABLE historial_horarios (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_trainer INT,
    id_area INT,
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    motivo_cambio TEXT,
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer),
    FOREIGN KEY (id_area) REFERENCES areas_entrenamiento(id_area)
);

-- Tabla de Estadísticas de Rendimiento
CREATE TABLE estadisticas_rendimiento (
    id_estadistica INT PRIMARY KEY AUTO_INCREMENT,
    id_ruta INT,
    id_modulo INT,
    fecha DATE NOT NULL,
    promedio_teorico DECIMAL(5,2),
    promedio_practico DECIMAL(5,2),
    promedio_quizzes DECIMAL(5,2),
    promedio_final DECIMAL(5,2),
    tasa_aprobacion DECIMAL(5,2),
    FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta),
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
);

-- Tabla de Sesiones
CREATE TABLE sesiones (
    id_sesion INT PRIMARY KEY AUTO_INCREMENT,
    id_modulo INT,
    id_trainer INT,
    id_area INT,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    tema VARCHAR(200) NOT NULL,
    descripcion TEXT,
    estado ENUM('Programada', 'En curso', 'Finalizada', 'Cancelada') DEFAULT 'Programada',
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo),
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer),
    FOREIGN KEY (id_area) REFERENCES areas_entrenamiento(id_area)
);

-- Tabla de Registro de Asistencia por Sesión
CREATE TABLE asistencia_sesiones (
    id_registro INT PRIMARY KEY AUTO_INCREMENT,
    id_sesion INT,
    id_camper INT,
    fecha DATE NOT NULL,
    estado ENUM('Presente', 'Ausente', 'Justificado', 'Tardanza') NOT NULL,
    hora_llegada TIME,
    FOREIGN KEY (id_sesion) REFERENCES sesiones(id_sesion),
    FOREIGN KEY (id_camper) REFERENCES campers(id_camper)
);