🧮 FUNCIONES SQL (20)


-- 1. Calcular el promedio ponderado de evaluaciones de un camper.
DELIMITER //
CREATE FUNCTION calcular_promedio_ponderado_camper(p_id_camper INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(
        (evaluacion_teorica * 0.3) + 
        (evaluacion_practica * 0.4) + 
        (evaluacion_trabajos * 0.3)
    ) INTO promedio
    FROM evaluaciones
    WHERE id_camper = p_id_camper;
    
    RETURN COALESCE(promedio, 0);
END //
DELIMITER ;

-- 2. Determinar si un camper aprueba o no un módulo específico.
DELIMITER //
CREATE FUNCTION verificar_aprobacion_modulo(p_id_camper INT, p_id_modulo INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE aprobado BOOLEAN;
    
    SELECT nota_final >= 60 INTO aprobado
    FROM evaluaciones
    WHERE id_camper = p_id_camper AND id_modulo = p_id_modulo;
    
    RETURN COALESCE(aprobado, FALSE);
END //
DELIMITER ;

-- 3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.
DELIMITER //
CREATE FUNCTION evaluar_nivel_riesgo(p_id_camper INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE nivel VARCHAR(20);
    
    SELECT AVG(nota_final) INTO promedio
    FROM evaluaciones
    WHERE id_camper = p_id_camper;
    
    IF promedio >= 80 THEN
        SET nivel = 'Bajo';
    ELSEIF promedio >= 60 THEN
        SET nivel = 'Medio';
    ELSE
        SET nivel = 'Alto';
    END IF;
    
    RETURN nivel;
END //
DELIMITER ;

-- 4. Obtener el total de campers asignados a una ruta específica.
DELIMITER //
CREATE FUNCTION contar_campers_ruta(p_id_ruta INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT id_camper) INTO total
    FROM inscripciones
    WHERE id_ruta = p_id_ruta;
    
    RETURN COALESCE(total, 0);
END //
DELIMITER ;

-- 5. Consultar la cantidad de módulos que ha aprobado un camper.
DELIMITER //
CREATE FUNCTION contar_modulos_aprobados(p_id_camper INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM evaluaciones
    WHERE id_camper = p_id_camper AND nota_final >= 60;
    
    RETURN COALESCE(total, 0);
END //
DELIMITER ;

-- 6. Validar si hay cupos disponibles en una determinada área.
DELIMITER //
CREATE FUNCTION verificar_cupos_area(p_id_area INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupados INT;
    DECLARE disponible BOOLEAN;
    
    SELECT capacidad_maxima INTO capacidad
    FROM areas_entrenamiento
    WHERE id_area = p_id_area;
    
    SELECT COUNT(*) INTO ocupados
    FROM asignaciones_areas
    WHERE id_area = p_id_area;
    
    SET disponible = (ocupados < capacidad);
    
    RETURN disponible;
END //
DELIMITER ;

-- 7. Calcular el porcentaje de ocupación de un área de entrenamiento.
DELIMITER //
CREATE FUNCTION calcular_ocupacion_area(p_id_area INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupados INT;
    DECLARE porcentaje DECIMAL(5,2);
    
    SELECT capacidad_maxima INTO capacidad
    FROM areas_entrenamiento
    WHERE id_area = p_id_area;
    
    SELECT COUNT(*) INTO ocupados
    FROM asignaciones_areas
    WHERE id_area = p_id_area;
    
    SET porcentaje = (ocupados * 100.0 / capacidad);
    
    RETURN porcentaje;
END //
DELIMITER ;

-- 8. Determinar la nota más alta obtenida en un módulo.
DELIMITER //
CREATE FUNCTION obtener_nota_maxima_modulo(p_id_modulo INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE nota_maxima DECIMAL(5,2);
    
    SELECT MAX(nota_final) INTO nota_maxima
    FROM evaluaciones
    WHERE id_modulo = p_id_modulo;
    
    RETURN COALESCE(nota_maxima, 0);
END //
DELIMITER ;

-- 9. Calcular la tasa de aprobación de una ruta.
DELIMITER //
CREATE FUNCTION calcular_tasa_aprobacion_ruta(p_id_ruta INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total_campers INT;
    DECLARE aprobados INT;
    DECLARE tasa DECIMAL(5,2);
    
    SELECT COUNT(DISTINCT e.id_camper) INTO total_campers
    FROM evaluaciones e
    JOIN modulos m ON e.id_modulo = m.id_modulo
    WHERE m.id_ruta = p_id_ruta;
    
    SELECT COUNT(DISTINCT e.id_camper) INTO aprobados
    FROM evaluaciones e
    JOIN modulos m ON e.id_modulo = m.id_modulo
    WHERE m.id_ruta = p_id_ruta AND e.nota_final >= 60;
    
    SET tasa = (aprobados * 100.0 / NULLIF(total_campers, 0));
    
    RETURN COALESCE(tasa, 0);
END //
DELIMITER ;

-- 10. Verificar si un trainer tiene horario disponible.
DELIMITER //
CREATE FUNCTION verificar_disponibilidad_trainer(p_id_trainer INT, p_id_horario INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE disponible BOOLEAN;
    
    SELECT COUNT(*) = 0 INTO disponible
    FROM asignaciones_trainer_ruta
    WHERE id_trainer = p_id_trainer AND id_horario = p_id_horario;
    
    RETURN disponible;
END //
DELIMITER ;

-- 11. Obtener el promedio de notas por ruta.
DELIMITER //
CREATE FUNCTION calcular_promedio_ruta(p_id_ruta INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(e.nota_final) INTO promedio
    FROM evaluaciones e
    JOIN modulos m ON e.id_modulo = m.id_modulo
    WHERE m.id_ruta = p_id_ruta;
    
    RETURN COALESCE(promedio, 0);
END //
DELIMITER ;

-- 12. Calcular cuántas rutas tiene asignadas un trainer.
DELIMITER //
CREATE FUNCTION contar_rutas_trainer(p_id_trainer INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT id_ruta) INTO total
    FROM asignaciones_trainer_ruta
    WHERE id_trainer = p_id_trainer;
    
    RETURN COALESCE(total, 0);
END //
DELIMITER ;

-- 13. Verificar si un camper puede ser graduado.
DELIMITER //
CREATE FUNCTION verificar_graduacion_camper(p_id_camper INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total_modulos INT;
    DECLARE modulos_aprobados INT;
    DECLARE puede_graduarse BOOLEAN;
    
    SELECT COUNT(*) INTO total_modulos
    FROM modulos m
    JOIN inscripciones i ON m.id_ruta = i.id_ruta
    WHERE i.id_camper = p_id_camper;
    
    SELECT COUNT(*) INTO modulos_aprobados
    FROM evaluaciones
    WHERE id_camper = p_id_camper AND nota_final >= 60;
    
    SET puede_graduarse = (modulos_aprobados = total_modulos);
    
    RETURN puede_graduarse;
END //
DELIMITER ;

-- 14. Obtener el estado actual de un camper en función de sus evaluaciones.
DELIMITER //
CREATE FUNCTION obtener_estado_camper(p_id_camper INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE estado VARCHAR(20);
    
    SELECT AVG(nota_final) INTO promedio
    FROM evaluaciones
    WHERE id_camper = p_id_camper;
    
    IF promedio >= 80 THEN
        SET estado = 'Excelente';
    ELSEIF promedio >= 60 THEN
        SET estado = 'Aprobado';
    ELSE
        SET estado = 'Reprobado';
    END IF;
    
    RETURN estado;
END //
DELIMITER ;

-- 15. Calcular la carga horaria semanal de un trainer.
DELIMITER //
CREATE FUNCTION calcular_carga_horaria_trainer(p_id_trainer INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE horas_totales INT;
    
    SELECT COUNT(*) * 4 INTO horas_totales
    FROM asignaciones_trainer_ruta
    WHERE id_trainer = p_id_trainer;
    
    RETURN COALESCE(horas_totales, 0);
END //
DELIMITER ;

-- 16. Determinar si una ruta tiene módulos pendientes por evaluación.
DELIMITER //
CREATE FUNCTION verificar_modulos_pendientes(p_id_ruta INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_modulos INT;
    DECLARE modulos_evaluados INT;
    DECLARE pendientes INT;
    
    SELECT COUNT(*) INTO total_modulos
    FROM modulos
    WHERE id_ruta = p_id_ruta;
    
    SELECT COUNT(DISTINCT id_modulo) INTO modulos_evaluados
    FROM evaluaciones e
    JOIN modulos m ON e.id_modulo = m.id_modulo
    WHERE m.id_ruta = p_id_ruta;
    
    SET pendientes = total_modulos - modulos_evaluados;
    
    RETURN pendientes;
END //
DELIMITER ;

-- 17. Calcular el promedio general del programa.
DELIMITER //
CREATE FUNCTION calcular_promedio_general()
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(nota_final) INTO promedio
    FROM evaluaciones;
    
    RETURN COALESCE(promedio, 0);
END //
DELIMITER ;

-- 18. Verificar si un horario choca con otros entrenadores en el área.
DELIMITER //
CREATE FUNCTION verificar_choque_horario(p_id_area INT, p_id_horario INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE hay_choque BOOLEAN;
    
    SELECT COUNT(*) > 0 INTO hay_choque
    FROM asignaciones_trainer_ruta atr
    JOIN asignaciones_areas aa ON atr.id_ruta = aa.id_ruta
    WHERE aa.id_area = p_id_area AND atr.id_horario = p_id_horario;
    
    RETURN hay_choque;
END //
DELIMITER ;

-- 19. Calcular cuántos campers están en riesgo en una ruta específica.
DELIMITER //
CREATE FUNCTION contar_campers_riesgo_ruta(p_id_ruta INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_riesgo INT;
    
    SELECT COUNT(DISTINCT e.id_camper) INTO total_riesgo
    FROM evaluaciones e
    JOIN modulos m ON e.id_modulo = m.id_modulo
    WHERE m.id_ruta = p_id_ruta AND e.nota_final < 60;
    
    RETURN COALESCE(total_riesgo, 0);
END //
DELIMITER ;

-- 20. Consultar el número de módulos evaluados por un camper.
DELIMITER //
CREATE FUNCTION contar_modulos_evaluados(p_id_camper INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT id_modulo) INTO total
    FROM evaluaciones
    WHERE id_camper = p_id_camper;
    
    RETURN COALESCE(total, 0);
END //
DELIMITER ;