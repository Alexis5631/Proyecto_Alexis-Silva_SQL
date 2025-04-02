⚙️ PROCEDIMIENTOS ALMACENADOS (20)


-- 1. Registrar nuevo camper
DELIMITER //
CREATE PROCEDURE sp_registrar_camper(
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_estado ENUM('Inscrito', 'Cursando', 'Graduado', 'Retirado'),
    IN p_nivel_riesgo ENUM('Bajo', 'Medio', 'Alto')
)
BEGIN
    INSERT INTO campers (nombres, apellidos, , email, telefono, nivel_riesgo)
    VALUES (p_nombres, p_apellidos, p_email, p_telefono, p_estado, p_nivel_riesgo);
END //

-- 2. Actualizar el estado de un camper luego de completar el proceso de ingreso.
CREATE PROCEDURE sp_actualizar_estado_camper(
    IN p_id_camper INT,
    IN p_nuevo_estado ENUM('Inscrito', 'Cursando', 'Graduado', 'Retirado')
)
BEGIN
    UPDATE campers 
    SET estado = p_nuevo_estado
    WHERE id_camper = p_id_camper;
END //

-- 3. Procesar la inscripción de un camper a una ruta específica.
CREATE PROCEDURE sp_procesar_inscripcion(
    IN p_id_camper INT,
    IN p_id_ruta INT,
    IN p_fecha_inscripcion DATE
)
BEGIN
    DECLARE v_capacidad_disponible INT;
    
    -- Verificar disponibilidad en el área
    SELECT ae.capacidad_maxima - COUNT(DISTINCT i.id_camper)
    INTO v_capacidad_disponible
    FROM areas_entrenamiento ae
    JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
    LEFT JOIN inscripciones i ON aa.id_ruta = i.id_ruta
    WHERE aa.id_ruta = p_id_ruta
    GROUP BY ae.id_area;
    
    IF v_capacidad_disponible > 0 THEN
        INSERT INTO inscripciones (id_camper, id_ruta, fecha_inscripcion)
        VALUES (p_id_camper, p_id_ruta, p_fecha_inscripcion);
        
        UPDATE campers 
        SET estado = 'Cursando'
        WHERE id_camper = p_id_camper;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay capacidad disponible en el área';
    END IF;
END //

-- 4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.
CREATE PROCEDURE sp_registrar_evaluacion(
    IN p_id_camper INT,
    IN p_id_modulo INT,
    IN p_evaluacion_teorica DECIMAL(5,2),
    IN p_evaluacion_practica DECIMAL(5,2),
    IN p_evaluacion_trabajos DECIMAL(5,2)
)
BEGIN
    DECLARE v_nota_final DECIMAL(5,2);
    
    -- Calcular nota final con pesos
    SET v_nota_final = (p_evaluacion_teorica * 0.3) + 
                      (p_evaluacion_practica * 0.4) + 
                      (p_evaluacion_trabajos * 0.3);
    
    INSERT INTO evaluaciones (
        id_camper, id_modulo, 
        evaluacion_teorica, evaluacion_practica, 
        evaluacion_trabajos, nota_final
    )
    VALUES (
        p_id_camper, p_id_modulo,
        p_evaluacion_teorica, p_evaluacion_practica,
        p_evaluacion_trabajos, v_nota_final
    );
END //

-- 5. Calcular y registrar automáticamente la nota final de un módulo.
CREATE PROCEDURE sp_calcular_nota_final_modulo(
    IN p_id_camper INT,
    IN p_id_modulo INT
)
BEGIN
    DECLARE v_nota_final DECIMAL(5,2);
    
    SELECT AVG(nota_final)
    INTO v_nota_final
    FROM evaluaciones
    WHERE id_camper = p_id_camper 
    AND id_modulo = p_id_modulo;
    
    UPDATE evaluaciones
    SET nota_final = v_nota_final
    WHERE id_camper = p_id_camper 
    AND id_modulo = p_id_modulo;
END //

-- 6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.
CREATE PROCEDURE sp_asignar_campers_aprobados(
    IN p_id_ruta INT
)
BEGIN
    DECLARE v_capacidad_disponible INT;
    
    -- Verificar capacidad disponible
    SELECT ae.capacidad_maxima - COUNT(DISTINCT i.id_camper)
    INTO v_capacidad_disponible
    FROM areas_entrenamiento ae
    JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
    LEFT JOIN inscripciones i ON aa.id_ruta = i.id_ruta
    WHERE aa.id_ruta = p_id_ruta
    GROUP BY ae.id_area;
    
    -- Asignar campers aprobados si hay capacidad
    IF v_capacidad_disponible > 0 THEN
        INSERT INTO inscripciones (id_camper, id_ruta, fecha_inscripcion)
        SELECT c.id_camper, p_id_ruta, CURDATE()
        FROM campers c
        JOIN evaluaciones e ON c.id_camper = e.id_camper
        WHERE e.nota_final >= 60
        AND c.estado = 'Cursando'
        LIMIT v_capacidad_disponible;
    END IF;
END //

-- 7. Asignar un trainer a una ruta y área específica, validando el horario.
CREATE PROCEDURE sp_asignar_trainer(
    IN p_id_trainer INT,
    IN p_id_ruta INT,
    IN p_id_area INT
)
BEGIN
    DECLARE v_horario_disponible BOOLEAN;
    
    -- Verificar disponibilidad de horario
    SELECT COUNT(*) = 0 INTO v_horario_disponible
    FROM asignaciones_trainer_ruta atr
    JOIN horarios h ON atr.id_horario = h.id_horario
    WHERE atr.id_trainer = p_id_trainer
    AND h.dia_semana IN (
        SELECT dia_semana 
        FROM horarios 
        WHERE id_horario IN (
            SELECT id_horario 
            FROM asignaciones_areas 
            WHERE id_area = p_id_area
        )
    );
    
    IF v_horario_disponible THEN
        INSERT INTO asignaciones_trainer_ruta (id_trainer, id_ruta, id_horario)
        SELECT p_id_trainer, p_id_ruta, id_horario
        FROM asignaciones_areas
        WHERE id_area = p_id_area;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El trainer no tiene disponibilidad en el horario requerido';
    END IF;
END //

-- 8. Registrar una nueva ruta con sus módulos y SGDB asociados.
CREATE PROCEDURE sp_registrar_ruta(
    IN p_nombre_ruta VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_id_sgdb INT
)
BEGIN
    DECLARE v_id_ruta INT;
    
    -- Insertar ruta
    INSERT INTO rutas (nombre_ruta, descripcion)
    VALUES (p_nombre_ruta, p_descripcion);
    
    SET v_id_ruta = LAST_INSERT_ID();
    
    -- Asociar SGDB
    INSERT INTO rutas_bases_datos (id_ruta, id_bd, tipo)
    VALUES (v_id_ruta, p_id_sgdb, 'Principal');
END //

-- 9. Registrar una nueva área de entrenamiento con su capacidad y horarios.
CREATE PROCEDURE sp_registrar_area(
    IN p_nombre_area VARCHAR(100),
    IN p_capacidad_maxima INT,
    IN p_id_horario INT
)
BEGIN
    DECLARE v_id_area INT;
    
    -- Insertar área
    INSERT INTO areas_entrenamiento (nombre_area, capacidad_maxima)
    VALUES (p_nombre_area, p_capacidad_maxima);
    
    SET v_id_area = LAST_INSERT_ID();
    
    -- Asignar horario
    INSERT INTO asignaciones_areas (id_area, id_horario)
    VALUES (v_id_area, p_id_horario);
END //

-- 10. Consultar disponibilidad de horario en un área determinada.
CREATE PROCEDURE sp_consultar_disponibilidad(
    IN p_id_area INT,
    IN p_dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes')
)
BEGIN
    SELECT h.hora_inicio, h.hora_fin,
           COUNT(DISTINCT atr.id_trainer) as trainers_asignados,
           ae.capacidad_maxima - COUNT(DISTINCT i.id_camper) as espacios_disponibles
    FROM areas_entrenamiento ae
    JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
    JOIN horarios h ON aa.id_horario = h.id_horario
    LEFT JOIN asignaciones_trainer_ruta atr ON h.id_horario = atr.id_horario
    LEFT JOIN inscripciones i ON aa.id_ruta = i.id_ruta
    WHERE ae.id_area = p_id_area
    AND h.dia_semana = p_dia_semana
    GROUP BY h.id_horario, h.hora_inicio, h.hora_fin;
END //

-- 11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.
CREATE PROCEDURE sp_reasignar_camper(
    IN p_id_camper INT,
    IN p_id_ruta_actual INT,
    IN p_id_ruta_nueva INT
)
BEGIN
    -- Verificar bajo rendimiento
    IF EXISTS (
        SELECT 1 
        FROM evaluaciones e
        WHERE e.id_camper = p_id_camper
        AND e.nota_final < 60
    ) THEN
        -- Actualizar inscripción
        UPDATE inscripciones
        SET id_ruta = p_id_ruta_nueva
        WHERE id_camper = p_id_camper
        AND id_ruta = p_id_ruta_actual;
        
        -- Actualizar estado
        UPDATE campers
        SET estado = 'Cursando',
            nivel_riesgo = 'Alto'
        WHERE id_camper = p_id_camper;
    END IF;
END //

-- 12. Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos.
CREATE PROCEDURE sp_graduar_camper(
    IN p_id_camper INT
)
BEGIN
    DECLARE v_total_modulos INT;
    DECLARE v_modulos_aprobados INT;
    
    -- Obtener total de módulos y aprobados
    SELECT 
        COUNT(DISTINCT m.id_modulo),
        COUNT(DISTINCT CASE WHEN e.nota_final >= 60 THEN m.id_modulo END)
    INTO v_total_modulos, v_modulos_aprobados
    FROM inscripciones i
    JOIN rutas r ON i.id_ruta = r.id_ruta
    JOIN modulos m ON r.id_ruta = m.id_ruta
    LEFT JOIN evaluaciones e ON m.id_modulo = e.id_modulo AND i.id_camper = e.id_camper
    WHERE i.id_camper = p_id_camper;
    
    -- Si aprobó todos los módulos, graduar
    IF v_total_modulos = v_modulos_aprobados THEN
        UPDATE campers
        SET estado = 'Graduado'
        WHERE id_camper = p_id_camper;
    END IF;
END //

-- 13. Consultar y exportar todos los datos de rendimiento de un camper.
CREATE PROCEDURE sp_exportar_rendimiento(
    IN p_id_camper INT
)
BEGIN
    SELECT 
        c.nombres, c.apellidos, c.email, c.estado, c.nivel_riesgo, r.nombre_ruta, m.nombre_modulo, e.evaluacion_teorica, e.evaluacion_practica, e.evaluacion_trabajos, e.nota_final
    FROM campers c
    JOIN inscripciones i ON c.id_camper = i.id_camper
    JOIN rutas r ON i.id_ruta = r.id_ruta
    JOIN modulos m ON r.id_ruta = m.id_ruta
    LEFT JOIN evaluaciones e ON m.id_modulo = e.id_modulo AND c.id_camper = e.id_camper
    WHERE c.id_camper = p_id_camper
    ORDER BY m.orden_modulo;
END //

-- 14. Registrar la asistencia a clases por área y horario.
CREATE PROCEDURE sp_registrar_asistencia(
    IN p_id_camper INT,
    IN p_id_area INT,
    IN p_fecha DATE,
    IN p_estado ENUM('Presente', 'Ausente', 'Justificado')
)
BEGIN
    INSERT INTO asistencia (
        id_camper, id_area, fecha, estado
    )
    VALUES (
        p_id_camper, p_id_area, p_fecha, p_estado
    );
END //

-- 15. Generar reporte mensual de notas por ruta.
CREATE PROCEDURE sp_reporte_mensual(
    IN p_id_ruta INT,
    IN p_mes INT,
    IN p_anio INT
)
BEGIN
    SELECT c.nombres, c.apellidos, m.nombre_modulo, e.evaluacion_teorica, e.evaluacion_practica, e.evaluacion_trabajos, e.nota_final
    FROM campers c
    JOIN inscripciones i ON c.id_camper = i.id_camper
    JOIN modulos m ON i.id_ruta = m.id_ruta
    LEFT JOIN evaluaciones e ON m.id_modulo = e.id_modulo AND c.id_camper = e.id_camper
    WHERE i.id_ruta = p_id_ruta
    AND MONTH(e.fecha_evaluacion) = p_mes
    AND YEAR(e.fecha_evaluacion) = p_anio
    ORDER BY c.nombres, m.orden_modulo;
END //

-- 16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad.
CREATE PROCEDURE sp_validar_asignacion_salon(
    IN p_id_area INT,
    IN p_id_ruta INT
)
BEGIN
    DECLARE v_capacidad_disponible INT;   
    -- Verificar capacidad
    SELECT ae.capacidad_maxima - COUNT(DISTINCT i.id_camper)
    INTO v_capacidad_disponible
    FROM areas_entrenamiento ae
    LEFT JOIN inscripciones i ON ae.id_area = i.id_area
    WHERE ae.id_area = p_id_area
    GROUP BY ae.id_area;  
    -- Asignar si hay capacidad
    IF v_capacidad_disponible > 0 THEN
        INSERT INTO asignaciones_areas (id_area, id_ruta)
        VALUES (p_id_area, p_id_ruta);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El salón ha excedido su capacidad máxima';
    END IF;
END //

-- 17. Registrar cambio de horario de un trainer.
CREATE PROCEDURE sp_cambiar_horario_trainer(
    IN p_id_trainer INT,
    IN p_id_horario_actual INT,
    IN p_id_horario_nuevo INT
)
BEGIN
    UPDATE asignaciones_trainer_ruta
    SET id_horario = p_id_horario_nuevo
    WHERE id_trainer = p_id_trainer
    AND id_horario = p_id_horario_actual;
END //

-- 18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).
CREATE PROCEDURE sp_eliminar_inscripcion(
    IN p_id_camper INT,
    IN p_id_ruta INT
)
BEGIN
    -- Actualizar estado del camper
    UPDATE campers
    SET estado = 'Retirado'
    WHERE id_camper = p_id_camper;   
    -- Eliminar inscripción
    DELETE FROM inscripciones
    WHERE id_camper = p_id_camper
    AND id_ruta = p_id_ruta;
END //

-- 19. Recalcular el estado de todos los campers según su rendimiento acumulado.
CREATE PROCEDURE sp_recalcular_estados()
BEGIN
    -- Actualizar estado según rendimiento
    UPDATE campers c
    JOIN (
        SELECT 
            id_camper,
            AVG(nota_final) as promedio_notas,
            COUNT(CASE WHEN nota_final < 60 THEN 1 END) as modulos_reprobados
        FROM evaluaciones
        GROUP BY id_camper
    ) e ON c.id_camper = e.id_camper
    SET 
        c.nivel_riesgo = CASE 
            WHEN e.promedio_notas < 60 OR e.modulos_reprobados > 2 THEN 'Alto'
            WHEN e.promedio_notas < 70 OR e.modulos_reprobados > 1 THEN 'Medio'
            ELSE 'Bajo'
        END;
END //

-- 20. Asignar horarios automáticamente a trainers disponibles según sus áreas.
CREATE PROCEDURE sp_asignar_horarios_automaticos()
BEGIN
    DECLARE v_id_trainer INT;
    DECLARE v_id_area INT;
    DECLARE v_id_horario INT;
    
    -- Cursor para trainers sin horario
    DECLARE trainer_cursor CURSOR FOR
    SELECT t.id_trainer, aa.id_area, h.id_horario
    FROM trainers t
    CROSS JOIN areas_entrenamiento ae
    CROSS JOIN horarios h
    JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
    WHERE NOT EXISTS (
        SELECT 1 
        FROM asignaciones_trainer_ruta atr 
        WHERE atr.id_trainer = t.id_trainer
    )
    LIMIT 1;
    
    -- Asignar horarios
    OPEN trainer_cursor;
    FETCH trainer_cursor INTO v_id_trainer, v_id_area, v_id_horario;
    
    IF v_id_trainer IS NOT NULL THEN
        INSERT INTO asignaciones_trainer_ruta (id_trainer, id_ruta, id_horario)
        SELECT v_id_trainer, id_ruta, v_id_horario
        FROM asignaciones_areas
        WHERE id_area = v_id_area;
    END IF;
    
    CLOSE trainer_cursor;
END //

DELIMITER ;