-- Insertar Sedes
INSERT INTO sedes (nombre_sede, ciudad, direccion, telefono, email) VALUES
('CampusLands Bucaramanga', 'Bucaramanga', 'Km 4, Anillo vial', '+57 7 6345678', 'bucaramanga@campuslands.edu.co'),
('CampusLands Cúcuta', 'Cúcuta', 'Avenida 5 # 12-34', '+57 7 5789012', 'cucuta@campuslands.edu.co'),
('CampusLands Bogotá', 'Bogotá', 'Carrera 68 # 90-45', '+57 1 2345678', 'bogota@campuslands.edu.co');

-- Insertar Rutas
INSERT INTO rutas (nombre_ruta, descripcion, duracion_meses, id_sede) VALUES
('Desarrollo Full Stack C#', 'Ruta completa con C#',12, 1),
('Desarrollo Full Stack Java', 'Ruta completa con Java',12, 1),
('Desarrollo Full Stack PHP', 'Ruta completa con PHP',12, 1),
('Desarrollo Full Stack Node.js', 'Ruta completa con .NET',12, 1),
('Desarrollo Full Stack C#', 'Ruta completa con C#',12, 2),
('Desarrollo Full Stack Java', 'Ruta completa con Java',12, 2),
('Desarrollo Full Stack PHP', 'Ruta completa con PHP',12, 2),
('Desarrollo Full Stack Node.js', 'Ruta completa con Node.js',12, 2),
('Desarrollo Full Stack C#', 'Ruta completa con C#',12, 3),
('Desarrollo Full Stack Java', 'Ruta completa con Java',12, 3),
('Desarrollo Full Stack PHP', 'Ruta completa con PHP',12, 3),
('Desarrollo Full Stack Node.js', 'Ruta completa con .NET',12, 3);

-- Insertar Trainers
INSERT INTO trainers (nombres, apellidos, email, telefono, id_sede) VALUES
('Jholver', 'Pardo', 'jholver.pardo@campuslands.edu.co', '3001234567', 1),
('Pedro', 'González', 'maria.gonzalez@campuslands.edu.co', '3002345678', 1),
('Juan Carlos', 'Rodríguez', 'carlos.rodriguez@campuslands.edu.co', '3003456789', 1),
('Adrian', 'Martínez', 'ana.martinez@campuslands.edu.co', '3004567890', 1),
('Oscar', 'López', 'pedro.lopez@campuslands.edu.co', '3005678901', 2),
('Diego', 'Ramírez', 'diego.ramirez@campuslands.edu.co', '3007890123', 2),
('Roberto', 'Flores', 'roberto.flores@campuslands.edu.co', '3009012345', 2),
('Carmen', 'Ruiz', 'carmen.ruiz@campuslands.edu.co', '3000123456', 2),
('José', 'Hernández', 'jose.hernandez@campuslands.edu.co', '3001234567', 3),
('Miguel', 'Moreno', 'miguel.moreno@campuslands.edu.co', '3003456789', 3),
('Alberto', 'Jiménez', 'elena.jimenez@campuslands.edu.co', '3004567890', 3),
('Francisco', 'García', 'francisco.garcia@campuslands.edu.co', '3005678901', 3);

-- Insertar Áreas de Entrenamiento
INSERT INTO areas_entrenamiento (nombre_area, capacidad_maxima, id_sede) VALUES
('Apolo', 33, 1),
('Sputnik', 33, 1),
('Artemis', 33, 1),
('Apolo', 33, 2),
('Sputnik', 33, 2),
('Artemis', 33, 2),
('Apolo', 33, 2),
('Sputnik', 33, 3),
('Artemis', 33, 3);


-- Insertar Campers
INSERT INTO campers (numero_identificacion, nombres, apellidos, direccion, acudiente, telefono_contacto, estado, nivel_riesgo, id_sede) VALUES
('1001234567', 'Andrés', 'García', 'Calle 123 #45-67', 'María García', '3001234567', 'Inscrito', 'Bajo', 1),
('1002345678', 'Laura', 'Martínez', 'Carrera 89 #12-34', 'Juan Martínez', '3002345678', 'Cursando', 'Bajo', 1),
('1003456789', 'Carlos', 'Rodríguez', 'Avenida 56 #78-90', 'Ana Rodríguez', '3003456789', 'Aprobado', 'Medio', 1),
('1004567890', 'Sofia', 'López', 'Calle 34 #56-78', 'Pedro López', '3004567890', 'Cursando', 'Alto', 1),
('1005678901', 'Diego', 'Pérez', 'Carrera 12 #34-56', 'Carmen Pérez', '3005678901', 'Inscrito', 'Bajo', 2),
('1006789012', 'María', 'Sánchez', 'Avenida 78 #90-12', 'José Sánchez', '3006789012', 'Cursando', 'Medio', 2),
('1007890123', 'Juan', 'Ramírez', 'Calle 90 #12-34', 'Isabel Ramírez', '3007890123', 'Aprobado', 'Bajo', 2),
('1008901234', 'Ana', 'Torres', 'Carrera 45 #67-89', 'Miguel Torres', '3008901234', 'Cursando', 'Alto', 2),
('1009012345', 'Pedro', 'Flores', 'Avenida 23 #45-67', 'Elena Flores', '3009012345', 'Inscrito', 'Bajo', 3),
('1010123456', 'Carmen', 'Ruiz', 'Calle 67 #89-01', 'Francisco Ruiz', '3000123456', 'Cursando', 'Medio', 3),
('1011234567', 'José', 'Hernández', 'Carrera 34 #56-78', 'Laura Hernández', '3001234567', 'Aprobado', 'Bajo', 3),
('1012345678', 'Isabel', 'Díaz', 'Avenida 12 #34-56', 'Carlos Díaz', '3002345678', 'Cursando', 'Alto', 2),
('1013456789', 'Miguel', 'Moreno', 'Calle 45 #67-89', 'Sofia Moreno', '3003456789', 'Inscrito', 'Bajo', 1),
('1014567890', 'Elena', 'Jiménez', 'Carrera 78 #90-12', 'Diego Jiménez', '3004567890', 'Cursando', 'Medio', 2),
('1015678901', 'Francisco', 'García', 'Avenida 56 #78-90', 'María García', '3005678901', 'Aprobado', 'Bajo', 1);

-- Insertar Módulos
INSERT INTO modulos (id_ruta, nombre_modulo, descripcion, orden) VALUES
(1, 'Fundamentos de Programación', 'Introducción a la programación', 1),
(1, 'HTML y CSS', 'Desarrollo web frontend básico', 2),
(1, 'JavaScript', 'Programación frontend avanzada', 3),
(1, 'Node.js', 'Desarrollo backend con Node.js', 4),
(2, 'Bases de Datos', 'Gestión de bases de datos', 5),
(2, 'Fundamentos de Programación', 'Introducción a la programación', 1),
(3, 'Java', 'Programación backend con Java', 2),
(3, 'Spring Boot', 'Framework backend Java', 3),
(3, 'Bases de Datos', 'Gestión de bases de datos', 4);

-- Insertar Bases de Datos
INSERT INTO bases_datos (nombre_bd, tipo) VALUES
('MySQL', 'Principal'),
('PostgreSQL', 'Principal'),
('MongoDB', 'Principal'),
('SQLite', 'Alternativo'),
('MariaDB', 'Alternativo'),
('Redis', 'Alternativo'),
('Oracle', 'Principal'),
('SQL Server', 'Principal'),
('Firebase', 'Alternativo'),
('DynamoDB', 'Alternativo'),
('CouchDB', 'Alternativo'),
('Elasticsearch', 'Alternativo'),
('InfluxDB', 'Alternativo');

-- Insertar relación Rutas-Bases de Datos
INSERT INTO rutas_bases_datos (id_ruta, id_bd) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7), (4, 8),
(5, 9), (5, 10),
(6, 11), (6, 12),
(7, 13), (7, 1),
(8, 2), (8, 3),
(9, 4), (9, 5),
(10, 6), (10, 7),
(11, 8), (11, 9),
(12, 10), (12, 11);

-- Insertar Asignaciones Trainer-Ruta
INSERT INTO asignaciones_trainer_ruta (id_trainer, id_ruta, fecha_inicio) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-01'),
(3, 3, '2024-01-01'),
(4, 4, '2024-01-01'),
(5, 5, '2024-02-01'),
(6, 6, '2024-02-01'),
(7, 7, '2024-02-01'),
(8, 8, '2024-02-01'),
(9, 9, '2024-03-01'),
(10, 10, '2024-03-01'),
(11, 11, '2024-03-01'),
(12, 12, '2024-03-01');

-- Insertar Horarios
INSERT INTO horarios (id_area, id_trainer, dia_semana, hora_inicio, hora_fin) VALUES
(1, 1, 'Lunes', '06:00:00', '09:00:00'),
(2, 2, 'Lunes', '13:00:00', '17:00:00'),
(3, 3, 'Martes', '06:00:00', '09:00:00'),
(4, 4, 'Martes', '13:00:00', '17:00:00'),
(5, 5, 'Miércoles', '06:00:00', '09:00:00'),
(6, 6, 'Miércoles', '13:00:00', '17:00:00'),
(7, 7, 'Jueves', '06:00:00', '09:00:00'),
(8, 8, 'Jueves', '13:00:00', '17:00:00'),
(9, 9, 'Viernes', '06:00:00', '09:00:00'),
(10, 10, 'Viernes', '13:00:00', '17:00:00'),
(11, 11, 'Lunes', '06:00:00', '09:00:00'),
(12, 12, 'Martes', '13:00:00', '17:00:00');

-- Insertar Inscripciones
INSERT INTO inscripciones (id_camper, id_ruta, fecha_inscripcion) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-17'),
(3, 3, '2024-02-12'),
(4, 4, '2024-02-28'),
(5, 5, '2024-03-01'),
(6, 6, '2024-03-01'),
(7, 7, '2024-03-09'),
(8, 8, '2024-03-17'),
(9, 9, '2024-03-22'),
(10, 10, '2024-04-04'),
(11, 11, '2024-04-08'),
(12, 12, '2024-04-21');

-- Insertar Evaluaciones
INSERT INTO evaluaciones (id_camper, id_modulo, evaluacion_teorica, evaluacion_practica, evaluacion_trabajos, nota_final, fecha_evaluacion, estado) VALUES
(1, 1, 85.00, 90.00, 95.00, 90.00, '2024-01-15', 'Aprobado'),
(2, 2, 75.00, 80.00, 85.00, 80.00, '2024-01-15', 'Aprobado'),
(3, 3, 65.00, 70.00, 75.00, 70.00, '2024-01-15', 'Aprobado'),
(4, 4, 55.00, 60.00, 65.00, 60.00, '2024-01-15', 'Aprobado'),
(5, 5, 45.00, 50.00, 55.00, 50.00, '2024-01-15', 'Reprobado'),
(6, 1, 95.00, 90.00, 85.00, 90.00, '2024-01-15', 'Aprobado'),
(7, 2, 85.00, 80.00, 75.00, 80.00, '2024-02-15', 'Aprobado'),
(8, 3, 75.00, 70.00, 65.00, 70.00, '2024-02-15', 'Aprobado'),
(9, 4, 65.00, 60.00, 55.00, 60.00, '2024-02-15', 'Aprobado'),
(10, 5, 55.00, 50.00, 45.00, 50.00, '2024-02-15', 'Reprobado'),
(11, 1, 90.00, 85.00, 80.00, 85.00, '2024-02-15', 'Aprobado'),
(12, 2, 80.00, 75.00, 70.00, 75.00, '2024-04-15', 'Aprobado'),
(13, 3, 70.00, 65.00, 60.00, 65.00, '2024-04-15', 'Aprobado'),
(14, 4, 60.00, 55.00, 50.00, 55.00, '2024-04-15', 'Reprobado'),
(15, 5, 50.00, 45.00, 40.00, 45.00, '2024-04-15', 'Reprobado');

-- Insertar Asistencia
INSERT INTO asistencia (id_camper, id_area, fecha, estado) VALUES
(1, 1, '2024-01-15', 'Presente'),
(2, 2, '2024-01-15', 'Presente'),
(3, 3, '2024-01-15', 'Ausente'),
(4, 4, '2024-01-15', 'Presente'),
(5, 5, '2024-01-15', 'Justificado'),
(6, 6, '2024-01-15', 'Presente'),
(7, 7, '2024-01-15', 'Presente'),
(8, 8, '2024-01-15', 'Ausente'),
(9, 9, '2024-01-15', 'Presente'),
(10, 10, '2024-01-15', 'Justificado'),
(11, 11, '2024-01-15', 'Presente'),
(12, 12, '2024-01-15', 'Presente');

-- Insertar Teléfonos de Campers
INSERT INTO telefonos_campers (id_camper, numero_telefono, tipo_telefono) VALUES
(1, '3001234567', 'Principal'),
(1, '3002345678', 'Secundario'),
(2, '3003456789', 'Principal'),
(2, '3004567890', 'Emergencia'),
(3, '3005678901', 'Principal'),
(3, '3006789012', 'Secundario'),
(4, '3007890123', 'Principal'),
(4, '3008901234', 'Emergencia'),
(5, '3009012345', 'Principal'),
(5, '3010123456', 'Secundario'),
(6, '3011234567', 'Principal'),
(6, '3012345678', 'Emergencia'),
(7, '3013456789', 'Principal'),
(7, '3014567890', 'Secundario'),
(8, '3015678901', 'Principal');

-- Insertar Historial de Cambios de Estado
INSERT INTO historial_cambios_estado (id_camper, estado_anterior, estado_nuevo, motivo) VALUES
(1, 'En proceso de ingreso', 'Inscrito', 'Proceso de inscripción completado'),
(2, 'Inscrito', 'Cursando', 'Inicio de clases'),
(3, 'Cursando', 'Aprobado', 'Aprobación de módulo'),
(4, 'Aprobado', 'Cursando', 'Inicio de nuevo módulo'),
(5, 'Cursando', 'Retirado', 'Solicitud de retiro'),
(6, 'En proceso de ingreso', 'Inscrito', 'Proceso de inscripción completado'),
(7, 'Inscrito', 'Cursando', 'Inicio de clases'),
(8, 'Cursando', 'Aprobado', 'Aprobación de módulo'),
(9, 'Aprobado', 'Cursando', 'Inicio de nuevo módulo'),
(10, 'Cursando', 'Expulsado', 'Violación de normas'),
(11, 'En proceso de ingreso', 'Inscrito', 'Proceso de inscripción completado'),
(12, 'Inscrito', 'Cursando', 'Inicio de clases'),
(13, 'Cursando', 'Aprobado', 'Aprobación de módulo'),
(14, 'Cursando', 'Expulsado', 'Bajo rendimiento académico y múltiples inasistencias'),
(15, 'Inscrito', 'Retirado', '2024-01-20', 'Decisión personal - Cambio de carrera');

-- Insertar Egresados
INSERT INTO egresados (id_camper, fecha_graduacion, promedio_final, ruta_completada) VALUES
(15, '2024-01-15', 85.00, 3),
(14, '2024-01-15', 80.00, 2),
(13, '2024-01-15', 75.00, 1),
(12, '2024-01-15', 70.00, 12),
(11, '2024-01-15', 65.00, 11),
(10, '2024-01-15', 60.00, 10),
(9, '2024-01-15', 55.00, 9),
(8, '2024-01-15', 50.00, 8),
(7, '2025-01-15', 45.00, 7),
(6, '2025-01-15', 40.00, 6),
(5, '2025-01-15', 35.00, 5),
(4, '2025-01-15', 30.00, 4),
(3, '2025-01-15', 25.00, 3),
(2, '2025-01-15', 20.00, 2),
(1, '2025-01-15', 15.00, 1);

-- Insertar Plantillas de Rutas
INSERT INTO plantillas_rutas (nombre_plantilla, descripcion) VALUES
('Plantilla Full Stack', 'Estructura base para desarrollo Full Stack'),
('Plantilla Frontend', 'Estructura base para desarrollo Frontend'),
('Plantilla Backend', 'Estructura base para desarrollo Backend');

-- Insertar Plantillas de Módulos
INSERT INTO plantillas_modulos (id_plantilla, nombre_modulo, descripcion, orden) VALUES
(1, 'Fundamentos de Programación', 'Introducción a la programación', 1),
(2, 'HTML y CSS', 'Desarrollo web frontend básico', 2),
(2, 'JavaScript', 'Programación frontend avanzada', 3),
(3, 'Node.js', 'Desarrollo backend con Node.js', 4),
(1, 'Bases de Datos', 'Gestión de bases de datos', 5),
(2, 'HTML y CSS', 'Desarrollo web frontend básico', 1),
(2, 'JavaScript', 'Programación frontend avanzada', 2),
(1, 'Fundamentos de Programación', 'Introducción a la programación', 1),
(3, 'Java', 'Programación backend con Java', 2),
(3, 'Python', 'Programación backend con Python', 3),
(3, 'Node.js', 'Desarrollo backend con Node.js', 4),
(3, 'Bases de Datos', 'Gestión de bases de datos', 5);

-- Insertar Notificaciones a Trainers
INSERT INTO notificaciones_trainers (id_trainer, tipo_notificacion, mensaje) VALUES
(1, 'Cambio de Horario', 'Se ha modificado el horario de la clase'),
(2, 'Nuevo Camper', 'Se ha inscrito un nuevo camper en su ruta'),
(3, 'Bajo Rendimiento', 'Hay campers con bajo rendimiento en su ruta'),
(4, 'General', 'Reunión de trainers programada'),
(5, 'Cambio de Horario', 'Se ha modificado el horario de la clase'),
(6, 'Nuevo Camper', 'Se ha inscrito un nuevo camper en su ruta'),
(7, 'Bajo Rendimiento', 'Hay campers con bajo rendimiento en su ruta'),
(8, 'General', 'Reunión de trainers programada'),
(9, 'Cambio de Horario', 'Se ha modificado el horario de la clase'),
(10, 'Nuevo Camper', 'Se ha inscrito un nuevo camper en su ruta'),
(11, 'Bajo Rendimiento', 'Hay campers con bajo rendimiento en su ruta'),
(12, 'General', 'Reunión de trainers programada');

-- Insertar Conocimientos de Trainers
INSERT INTO conocimientos_trainers (id_trainer, tecnologia, nivel) VALUES
(1, 'JavaScript', 'Experto'),
(1, 'React', 'Avanzado'),
(2, 'Python', 'Experto'),
(2, 'Django', 'Avanzado'),
(3, 'Java', 'Experto'),
(3, 'Spring Boot', 'Avanzado'),
(4, 'Node.js', 'Experto'),
(4, 'Express', 'Avanzado'),
(5, 'PHP', 'Experto'),
(5, 'Laravel', 'Avanzado'),
(6, 'Ruby', 'Experto'),
(6, 'Rails', 'Avanzado'),
(7, 'Go', 'Experto'),
(7, 'Gin', 'Avanzado'),
(8, 'Rust', 'Experto');

-- Insertar Reportes Mensuales
INSERT INTO reportes_mensuales (id_ruta, mes, año, total_campers, promedio_general, campers_aprobados, campers_reprobados) VALUES
(1, 1, 2024, 30, 75.50, 25, 5),
(2, 1, 2024, 28, 78.30, 23, 5),
(3, 1, 2024, 32, 72.80, 27, 5),
(4, 1, 2024, 29, 76.20, 24, 5),
(5, 2, 2024, 31, 74.90, 26, 5),
(6, 2, 2024, 27, 77.60, 22, 5),
(7, 2, 2024, 33, 71.40, 28, 5),
(8, 2, 2024, 30, 75.80, 25, 5),
(9, 3, 2024, 28, 78.50, 23, 5),
(10, 3, 2024, 32, 73.20, 27, 5),
(11, 3, 2024, 29, 76.80, 24, 5),
(12, 3, 2024, 31, 74.30, 26, 5);

-- Insertar Asignaciones de Áreas
INSERT INTO asignaciones_areas (id_area, id_ruta, fecha_inicio) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-02-01'),
(3, 3, '2024-03-01'),
(4, 4, '2024-04-01'),
(5, 5, '2024-05-01'),
(6, 6, '2024-06-01'),
(7, 7, '2024-07-01'),
(8, 8, '2024-08-01'),
(9, 9, '2024-09-01'),
(10, 10, '2024-10-01'),
(11, 11, '2024-11-01'),
(12, 12, '2024-12-01');

-- Insertar Historial de Horarios
INSERT INTO historial_horarios (id_trainer, id_area, dia_semana, hora_inicio, hora_fin, fecha_inicio, motivo_cambio) VALUES
(1, 1, 'Lunes', '08:00:00', '12:00:00', '2024-01-15', 'Cambio de horario regular'),
(2, 2, 'Martes', '13:00:00', '17:00:00', '2024-01-18', 'Cambio de horario regular'),
(3, 3, 'Miércoles', '08:00:00', '12:00:00', '2024-02-15', 'Cambio de horario regular'),
(4, 4, 'Jueves', '13:00:00', '17:00:00', '2024-02-18', 'Cambio de horario regular'),
(5, 5, 'Viernes', '08:00:00', '12:00:00', '2024-03-15', 'Cambio de horario regular'),
(6, 6, 'Lunes', '08:00:00', '12:00:00', '2024-03-18', 'Cambio de horario regular'),
(7, 7, 'Martes', '13:00:00', '17:00:00', '2024-04-15', 'Cambio de horario regular'),
(8, 8, 'Miércoles', '08:00:00', '12:00:00', '2024-04-18', 'Cambio de horario regular'),
(9, 9, 'Jueves', '13:00:00', '17:00:00', '2024-05-15', 'Cambio de horario regular'),
(10, 10, 'Viernes', '08:00:00', '12:00:00', '2024-05-18', 'Cambio de horario regular'),
(11, 11, 'Lunes', '08:00:00', '12:00:00', '2024-06-15', 'Cambio de horario regular'),
(12, 12, 'Martes', '13:00:00', '17:00:00', '2024-06-18', 'Cambio de horario regular');

-- Insertar Estadísticas de Rendimiento
INSERT INTO estadisticas_rendimiento (id_ruta, id_modulo, fecha, promedio_teorico, promedio_practico, promedio_quizzes, promedio_final, tasa_aprobacion) VALUES
(1, 1, '2024-01-15', 75.50, 80.30, 85.20, 80.33, 85.00),
(2, 2, '2024-01-18', 78.30, 82.50, 88.40, 83.07, 88.00),
(3, 3, '2024-01-25', 72.80, 77.60, 82.30, 77.57, 82.00),
(4, 4, '2024-02-18', 76.20, 81.40, 86.50, 81.37, 86.00),
(5, 5, '2024-03-15', 74.90, 79.80, 84.60, 79.77, 84.00),
(6, 1, '2024-04-27', 77.60, 82.70, 87.80, 82.70, 87.00),
(7, 2, '2025-01-15', 71.40, 76.20, 81.30, 76.30, 81.00),
(8, 3, '2025-01-19', 75.80, 80.90, 86.00, 80.90, 85.00),
(9, 4, '2025-02-15', 78.50, 83.60, 88.70, 83.60, 88.00),
(10, 5, '2025-02-20', 73.20, 78.10, 83.20, 78.17, 83.00),
(11, 1, '2025-03-10', 76.80, 81.90, 87.00, 81.90, 86.00),
(12, 2, '2025-03-15', 74.30, 79.20, 84.30, 79.27, 84.00);

-- Insertar Sesiones
INSERT INTO sesiones (id_modulo, id_trainer, id_area, fecha, hora_inicio, hora_fin, tema, descripcion, estado) VALUES
(1, 1, 1, '2024-01-15', '08:00:00', '12:00:00', 'Introducción a la Programación', 'Conceptos básicos de programación', 'Finalizada'),
(2, 2, 2, '2024-01-17', '13:00:00', '17:00:00', 'HTML y CSS Básico', 'Estructura HTML y estilos CSS', 'Finalizada'),
(3, 3, 3, '2024-02-18', '08:00:00', '12:00:00', 'JavaScript Fundamentos', 'Conceptos básicos de JavaScript', 'Programada'),
(4, 4, 4, '2024-02-19', '13:00:00', '17:00:00', 'Node.js Básico', 'Introducción a Node.js', 'Programada'),
(5, 5, 5, '2024-02-24', '08:00:00', '12:00:00', 'Bases de Datos SQL', 'Conceptos de bases de datos SQL', 'Programada');

-- Insertar Asistencia por Sesión (usando los IDs correctos de sesiones)
INSERT INTO asistencia_sesiones (id_sesion, id_camper, fecha, estado, hora_llegada) VALUES
(13, 1, '2024-01-15', 'Presente', '07:55:00'),
(13, 2, '2024-01-15', 'Presente', '07:50:00'),
(13, 3, '2024-01-15', 'Tardanza', '08:15:00'),
(13, 4, '2024-01-15', 'Ausente', NULL),
(13, 5, '2024-01-15', 'Justificado', NULL),
(14, 6, '2024-01-17', 'Presente', '12:55:00'),
(14, 7, '2024-01-17', 'Presente', '12:50:00'),
(14, 8, '2024-01-17', 'Tardanza', '13:10:00'),
(14, 9, '2024-01-17', 'Ausente', NULL),
(14, 10, '2024-01-17', 'Justificado', NULL),
(15, 11, '2024-02-18', 'Presente', '07:55:00'),
(15, 12, '2024-02-18', 'Presente', '07:50:00'),
(15, 13, '2024-02-18', 'Tardanza', '08:20:00'),
(15, 14, '2024-02-18', 'Ausente', NULL),
(15, 15, '2024-02-18', 'Justificado', NULL);