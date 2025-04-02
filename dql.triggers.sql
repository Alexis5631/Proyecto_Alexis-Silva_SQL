🔁 TRIGGERS SQL (20)


-- 1. Al insertar una evaluación, calcular automáticamente la nota final.
DELIMITER //
CREATE TRIGGER calcular_nota_final_insercion
AFTER INSERT ON evaluaciones
FOR EACH ROW
BEGIN
    UPDATE evaluaciones
    SET nota_final = (
        NEW.evaluacion_teorica * 0.3 +
        NEW.evaluacion_practica * 0.4 +
        NEW.evaluacion_trabajos * 0.3
    )
    WHERE id_evaluacion = NEW.id_evaluacion;
END //
DELIMITER ;

-- 2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.
DELIMITER //
CREATE TRIGGER verificar_aprobacion_actualizacion
AFTER UPDATE ON evaluaciones
FOR EACH ROW
BEGIN
    IF NEW.nota_final >= 60 THEN
        UPDATE campers
        SET estado = 'Aprobado'
        WHERE id_camper = NEW.id_camper;
    ELSE
        UPDATE campers
        SET estado = 'Reprobado'
        WHERE id_camper = NEW.id_camper;
    END IF;
END //
DELIMITER ;

-- 3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".
DELIMITER //
CREATE TRIGGER actualizar_estado_inscripcion
AFTER INSERT ON inscripciones
FOR EACH ROW
BEGIN
    UPDATE campers
    SET estado = 'Inscrito'
    WHERE id_camper = NEW.id_camper;
END //
DELIMITER ;

-- 4. Al actualizar una evaluación, recalcular su promedio inmediatamente.
DELIMITER //
CREATE TRIGGER recalcular_promedio_actualizacion
AFTER UPDATE ON evaluaciones
FOR EACH ROW
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(nota_final) INTO promedio
    FROM evaluaciones
    WHERE id_camper = NEW.id_camper;
    
    UPDATE campers
    SET promedio_actual = promedio
    WHERE id_camper = NEW.id_camper;
END //
DELIMITER ;

-- 5. Al eliminar una inscripción, marcar al camper como “Retirado”.
DELIMITER //
CREATE TRIGGER marcar_retirado_eliminacion
AFTER DELETE ON inscripciones
FOR EACH ROW
BEGIN
    UPDATE campers
    SET estado = 'Retirado'
    WHERE id_camper = OLD.id_camper;
END //
DELIMITER ;

-- 6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.
DELIMITER //
CREATE TRIGGER registrar_sgdb_modulo
AFTER INSERT ON modulos
FOR EACH ROW
BEGIN
    INSERT INTO rutas_bases_datos (id_ruta, id_base_datos, tipo)
    SELECT NEW.id_ruta, id_base_datos, 'Secundaria'
    FROM bases_datos
    WHERE tipo = 'Secundaria';
END //
DELIMITER ;

-- 7. Al insertar un nuevo trainer, verificar duplicados por identificación.
DELIMITER //
CREATE TRIGGER verificar_duplicados_trainer
BEFORE INSERT ON trainers
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM trainers 
        WHERE numero_identificacion = NEW.numero_identificacion
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un trainer con esta identificación';
    END IF;
END //
DELIMITER ;

-- 8. Al asignar un área, validar que no exceda su capacidad.
DELIMITER //
CREATE TRIGGER validar_capacidad_area
BEFORE INSERT ON asignaciones_areas
FOR EACH ROW
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupados INT;
    
    SELECT capacidad_maxima INTO capacidad
    FROM areas_entrenamiento
    WHERE id_area = NEW.id_area;
    
    SELECT COUNT(*) INTO ocupados
    FROM asignaciones_areas
    WHERE id_area = NEW.id_area;
    
    IF ocupados >= capacidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El área ha excedido su capacidad máxima';
    END IF;
END //
DELIMITER ;

-- 9. Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”.
DELIMITER //
CREATE TRIGGER marcar_bajo_rendimiento
AFTER INSERT ON evaluaciones
FOR EACH ROW
BEGIN
    IF NEW.nota_final < 60 THEN
        UPDATE campers
        SET estado = 'Bajo rendimiento'
        WHERE id_camper = NEW.id_camper;
    END IF;
END //
DELIMITER ;

-- 10. Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados.
DELIMITER //
CREATE TRIGGER mover_a_egresados
AFTER UPDATE ON campers
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Graduado' AND OLD.estado != 'Graduado' THEN
        INSERT INTO egresados (id_camper, fecha_graduacion, ruta_completada, promedio_final)
        SELECT 
            NEW.id_camper, 
            CURRENT_DATE, 
            r.nombre_ruta, 
            (SELECT AVG(nota_final) 
             FROM evaluaciones 
             WHERE id_camper = NEW.id_camper)
        FROM rutas r
        JOIN inscripciones i ON r.id_ruta = i.id_ruta
        WHERE i.id_camper = NEW.id_camper;
    END IF;
END //
DELIMITER ;

-- 11. Al modificar horarios de trainer, verificar solapamiento con otros.
DELIMITER //
CREATE TRIGGER verificar_solapamiento_horarios
BEFORE INSERT ON asignaciones_trainer_ruta
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM asignaciones_trainer_ruta
        WHERE id_trainer = NEW.id_trainer
        AND id_horario = NEW.id_horario
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El trainer ya tiene asignado este horario';
    END IF;
END //
DELIMITER ;

-- 12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.
DELIMITER //
CREATE TRIGGER liberar_recursos_trainer
AFTER DELETE ON trainers
FOR EACH ROW
BEGIN
    DELETE FROM asignaciones_trainer_ruta
    WHERE id_trainer = OLD.id_trainer;
    
    UPDATE rutas
    SET id_trainer_principal = NULL
    WHERE id_trainer_principal = OLD.id_trainer;
END //
DELIMITER ;

-- 13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.
DELIMITER //
CREATE TRIGGER actualizar_modulos_cambio_ruta
AFTER UPDATE ON inscripciones
FOR EACH ROW
BEGIN
    IF NEW.id_ruta != OLD.id_ruta THEN
        DELETE FROM evaluaciones
        WHERE id_camper = NEW.id_camper;
        
        INSERT INTO evaluaciones (id_camper, id_modulo, fecha_evaluacion)
        SELECT NEW.id_camper, id_modulo, CURRENT_DATE
        FROM modulos
        WHERE id_ruta = NEW.id_ruta;
    END IF;
END //
DELIMITER ;

-- 14. Al insertar un nuevo camper, verificar si ya existe por número de documento.
DELIMITER //
CREATE TRIGGER verificar_duplicados_camper
BEFORE INSERT ON campers
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM campers
        WHERE numero_identificacion = NEW.numero_identificacion
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un camper con este número de documento';
    END IF;
END //
DELIMITER ;

-- 15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.
DELIMITER //
CREATE TRIGGER actualizar_estado_modulo
AFTER UPDATE ON evaluaciones
FOR EACH ROW
BEGIN
    DECLARE estado_modulo VARCHAR(20);
    
    IF NEW.nota_final >= 60 THEN
        SET estado_modulo = 'Aprobado';
    ELSE
        SET estado_modulo = 'Reprobado';
    END IF;
    
    UPDATE modulos
    SET estado = estado_modulo
    WHERE id_modulo = NEW.id_modulo;
END //
DELIMITER ;

-- 16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.
DELIMITER //
CREATE TRIGGER verificar_conocimiento_trainer
BEFORE INSERT ON asignaciones_trainer_ruta
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM conocimientos_trainer
        WHERE id_trainer = NEW.id_trainer
        AND id_ruta = NEW.id_ruta
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El trainer no tiene conocimiento de esta ruta';
    END IF;
END //
DELIMITER ;

-- 17. Al cambiar el estado de un área a inactiva, liberar campers asignados.
DELIMITER //
CREATE TRIGGER liberar_campers_area_inactiva
AFTER UPDATE ON areas_entrenamiento
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Inactiva' AND OLD.estado != 'Inactiva' THEN
        DELETE FROM asignaciones_areas
        WHERE id_area = NEW.id_area;
    END IF;
END //
DELIMITER ;

-- 18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.
DELIMITER //
CREATE TRIGGER clonar_plantilla_ruta
AFTER INSERT ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO modulos (nombre_modulo, descripcion, duracion_horas, orden, id_ruta)
    SELECT nombre_modulo, descripcion, duracion_horas, orden, NEW.id_ruta
    FROM plantillas_rutas
    WHERE id_plantilla = 1;
    
    INSERT INTO rutas_bases_datos (id_ruta, id_base_datos, tipo)
    SELECT NEW.id_ruta, id_base_datos, tipo
    FROM bases_datos
    WHERE tipo = 'Principal';
END //
DELIMITER ;

-- 19. Al registrar la nota práctica, verificar que no supere 60% del total.
DELIMITER //
CREATE TRIGGER validar_nota_practica
BEFORE INSERT ON evaluaciones
FOR EACH ROW
BEGIN
    IF NEW.evaluacion_practica > 60 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La nota práctica no puede superar el 60% del total';
    END IF;
END //
DELIMITER ;

-- 20. Al modificar una ruta, notificar cambios a los trainers asignados.
DELIMITER //
CREATE TRIGGER notificar_cambios_ruta
AFTER UPDATE ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO notificaciones (id_trainer, mensaje)
    SELECT id_trainer, 
           CONCAT('La ruta ', NEW.nombre_ruta, ' ha sido modificada')
    FROM asignaciones_trainer_ruta
    WHERE id_ruta = NEW.id_ruta;
END //
DELIMITER ;