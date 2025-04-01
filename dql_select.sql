🎓 Campers


-- 1. Obtener todos los campers inscritos actualmente.
SELECT c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, c.estado, c.nivel_riesgo, s.nombre_sede, s.ciudad, r.nombre_ruta, i.fecha_inscripcion 
FROM campers c 
JOIN sedes s ON c.id_sede = s.id_sede
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
WHERE c.estado = 'Inscrito'
ORDER BY c.nombres, c.apellidos;

-- 2. Listar los campers con estado "Aprobado".
SELECT c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, c.estado,
c.nivel_riesgo, s.nombre_sede, s.ciudad, r.nombre_ruta, i.fecha_inscripcion, e.nota_final, m.nombre_modulo
FROM campers c 
JOIN sedes s ON c.id_sede = s.id_sede
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
LEFT JOIN evaluaciones e ON c.id_camper = e.id_camper
LEFT JOIN modulos m ON e.id_modulo = m.id_modulo
WHERE c.estado = 'Aprobado'
ORDER BY c.nombres, c.apellidos;

-- 3. Mostrar los campers que ya están cursando alguna ruta
SELECT c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, c.estado, s.nombre_sede, s.ciudad, r.nombre_ruta, i.fecha_inscripcion, t.nombres as trainer_nombre, t.apellidos as trainer_apellidos, h.hora_inicio, h.hora_fin
FROM campers c 
JOIN sedes s ON c.id_sede = s.id_sede
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
JOIN asignaciones_trainer_ruta atr ON r.id_ruta = atr.id_ruta
JOIN trainers t ON atr.id_trainer = t.id_trainer
JOIN areas_entrenamiento ae ON c.id_sede = ae.id_sede
JOIN horarios h ON ae.id_area =h.id_area AND t.id_trainer = h.id_trainer
WHERE c.estado = 'Cursando'
ORDER BY c.nombres, c.apellidos;

-- 4. Consultar los campers graduados por cada ruta.
SELECT r.nombre_ruta, COUNT(e.id_egresado) as total_gradudados, c.nombres, c.apellidos, c.numero_identificacion, e.fecha_graduacion, e.promedio_final, s.nombre_sede, s.ciudad
FROM rutas r 
JOIN egresados e ON r.id_ruta = e.ruta_completada
JOIN campers c ON e.id_camper = c.id_camper
JOIN sedes s ON c.id_sede =s.id_sede
GROUP BY r.nombre_ruta, c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, e.fecha_graduacion, e.promedio_final, s.nombre_sede, s.ciudad
ORDER BY r.nombre_ruta, e.fecha_graduacion DESC;

-- 5. Obtener los campers que se encuentran en estado "Expulsado" o "Retirado".
SELECT c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, c.estado, c.nivel_riesgo, s.nombre_sede, s.ciudad, r.nombre_ruta, i.fecha_inscripcion, hce.motivo, hce.estado_anterior, hce.estado_nuevo
FROM campers c 
JOIN sedes s ON c.id_sede = s.id_sede 
JOIN inscripciones i ON c.id_camper = i.id_camper 
JOIN rutas r ON i.id_ruta = r.id_ruta
LEFT JOIN historial_cambios_estado hce ON c.id_camper = hce.id_camper
WHERE c.estado IN ('Expulsado','Retirado')
ORDER BY c.estado, c.nombres, c.apellidos;

-- 6. Listar campers con nivel de riesgo “Alto”.
SELECT c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, c.estado, c.nivel_riesgo, s.nombre_sede, s.ciudad, r.nombre_ruta, i.fecha_inscripcion, m.nombre_modulo
FROM campers c 
JOIN sedes s ON c.id_sede = s.id_sede
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
LEFT JOIN evaluaciones e ON c.id_camper = e.id_camper
LEFT JOIN modulos m ON e.id_modulo = m.id_modulo
WHERE c.nivel_riesgo = 'Alto'
ORDER BY c.nombres, c.apellidos;

-- 7. Mostrar el total de campers por cada nivel de riesgo.
SELECT c.nivel_riesgo,
    COUNT(*) as total_campers,
    COUNT(CASE WHEN c.estado = 'Inscrito' THEN 1 END) as inscritos,
    COUNT(CASE WHEN c.estado = 'Cursando' THEN 1 END) as cursando,
    COUNT(CASE WHEN c.estado = 'Aprobado' THEN 1 END) as aprobados,
    COUNT(CASE WHEN c.estado = 'Expulsado' THEN 1 END) as expulsados,
    COUNT(CASE WHEN c.estado = 'Retirado' THEN 1 END) as iretirados
FROM campers c 
GROUP BY c.nivel_riesgo
ORDER BY
    CASE c.nivel_riesgo
        WHEN 'Alto' THEN 1
        WHEN 'Medio' THEN 2
        WHEN 'Bajo' THEN 3
    END;

-- 8. Obtener campers con más de un número telefónico registrado.
SELECT c.nombres, c.apellidos,
    COUNT(tc.id_telefono) as total_telefonos
FROM campers c 
JOIN telefonos_campers tc ON c.id_camper = tc.id_camper
GROUP BY c.id_camper, c.nombres, c.apellidos
HAVING COUNT(tc.id_telefono) > 1
ORDER BY c.nombres, c.apellidos;

-- 9. Listar los campers y sus respectivos acudientes y teléfonos.
SELECT c.nombres, c.apellidos, c.acudiente, c.telefono_contacto as telefono_acudiente, GROUP_CONCAT(tc.numero_telefono SEPARATOR ', ') as telefonos_camper
FROM campers c 
LEFT JOIN telefonos_campers tc ON c.id_camper = tc.id_camper
GROUP BY c.id_camper, c.nombres, c.apellidos, c.acudiente, c.telefono_contacto 
ORDER BY c.nombres, c.apellidos;

-- 10. Mostrar campers que aún no han sido asignados a una ruta.
SELECT c.nombres, c.apellidos, c.estado, s.nombre_sede
FROM campers c 
JOIN sedes s ON c.id_sede = s.id_sede
LEFT JOIN inscripciones i ON c.id_camper = i.id_camper
WHERE i.id_inscripcion IS NULL
ORDER BY c.nombres, c.apellidos;



📊 Evaluaciones


-- 1. Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo.
SELECT c.nombres, c.apellidos, m.nombre_modulo, e.evaluacion_teorica, e.evaluacion_practica, e.evaluacion_trabajos, e.nota_final
FROM campers c 
JOIN evaluaciones e ON c.id_camper = e.id_camper
JOIN modulos m ON e.id_modulo = m.id_modulo
ORDER BY c.nombres, c.apellidos, m.nombre_modulo;

-- 2. Calcular la nota final de cada camper por módulo.
SELECT c.nombres, c.apellidos, m.nombre_modulo, e.evaluacion_teorica, e.evaluacion_practica, e.evaluacion_trabajos,
ROUND(
    (e.evaluacion_teorica * 0.3) + 
    (e.evaluacion_practica * 0.6) +
    (e.evaluacion_trabajos * 0.1),
2) as nota_final,
CASE 
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) >= 60 THEN 'Aprobado'
    ELSE 'Bajo Rendimiento'
END as estado
FROM campers c 
JOIN evaluaciones e ON c.id_camper = e.id_camper
JOIN modulos m ON e.id_modulo = m.id_modulo
ORDER BY c.nombres, c.apellidos, m.nombre_modulo;

-- 3. Mostrar los campers que reprobaron algún módulo (nota < 60).
SELECT c.nombres, c.apellidos, m.nombre_modulo, e.evaluacion_teorica, e.evaluacion_practica, e.evaluacion_trabajos,
ROUND(
    (e.evaluacion_teorica * 0.3) +
    (e.evaluacion_practica * 0.6) +
    (e.evaluacion_trabajos * 0.1),
2) as nota_final
FROM campers c 
JOIN evaluaciones e ON c.id_camper = e.id_camper
JOIN modulos m ON e.id_modulo = m.id_modulo
WHERE ROUND(
    (e.evaluacion_teorica * 0.3) +
    (e.evaluacion_practica * 0.6) +
    (e.evaluacion_trabajos * 0.1),
2) < 60 
ORDER BY nota_final ASC; 

-- 4. Listar los módulos con más campers en bajo rendimiento.
SELECT m.nombre_modulo,
COUNT(*) as total_campers,
COUNT(CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) < 60 THEN 1
END) as campers_bajo_rendimiento,
ROUND(
    (COUNT(CASE
        WHEN ROUND(
            (e.evaluacion_teorica * 0.3) +
            (e.evaluacion_practica * 0.6) +
            (e.evaluacion_trabajos * 0.1),
        2) < 60 THEN 1
    END) * 100.0 / COUNT(*)),
2) as porcentaje_bajo_rendimiento
FROM modulos m 
JOIN evaluaciones e ON m.id_modulo = e.id_modulo
GROUP BY m.nombre_modulo
HAVING COUNT(CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) < 60 THEN 1
END) > 0
ORDER BY campers_bajo_rendimiento DESC;

-- 5. Obtener el promedio de notas finales por cada módulo.
SELECT m.nombre_modulo,
COUNT(*) as total_evaluaciones,
ROUND(AVG(
    (e.evaluacion_teorica * 0.3) +
    (e.evaluacion_practica * 0.6) +
    (e.evaluacion_trabajos * 0.1)
),2) as promedio_nota_final,
ROUND(AVG(e.evaluacion_teorica), 2) as promedio_teorica,
ROUND(AVG(e.evaluacion_practica), 2) as promedio_practica,
ROUND(AVG(e.evaluacion_trabajos), 2) as promedio_trabajos
FROM modulos m 
JOIN evaluaciones e ON m.id_modulo = e.id_modulo
GROUP BY m.nombre_modulo
ORDER BY promedio_nota_final DESC;

-- 6. Consultar el rendimiento general por ruta de entrenamiento.
SELECT r.nombre_ruta,
COUNT(DISTINCT c.id_camper) as total_campers,
COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) >= 60 THEN c.id_camper
END) as campers_aprobados,
COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) < 60 THEN c.id_camper
END) as campers_bajo_rendimiento,
ROUND(AVG(
    (e.evaluacion_teorica * 0.3) +
    (e.evaluacion_practica * 0.6) +
    (e.evaluacion_trabajos * 0.1)
), 2) as promedio_nota_final,
ROUND(
    (COUNT(DISTINCT CASE
        WHEN ROUND(
            (e.evaluacion_teorica * 0.3) +
            (e.evaluacion_practica * 0.6) +
            (e.evaluacion_trabajos * 0.1),
        2) >= 60 THEN c.id_camper
    END) * 100.0 / COUNT(DISTINCT c.id_camper)),
2) as porcentaje_aprobacion
FROM rutas r 
JOIN inscripciones i ON r.id_ruta = i.id_ruta
JOIN campers c ON i.id_camper = c.id_camper
JOIN evaluaciones e ON c.id_camper = e.id_camper
GROUP BY r.nombre_ruta
ORDER BY promedio_nota_final DESC;

-- 7. Mostrar los trainers responsables de campers con bajo rendimiento.
SELECT t.nombres as nombre_trainer, t.apellidos as apellido_trainer, r.nombre_ruta
COUNT(DISTINCT c.id_camper) as total_campers,
COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) < 60 THEN c.id_camper
END) as campers_bajo_rendimiento,
ROUND(
    (COUNT(DISTINCT CASE
        WHEN ROUND(
            (e.evaluacion_teorica * 0.3) +
            (e.evaluacion_practica * 0.6) +
            (e.evaluacion_trabajos * 0.1),
        2) < 60 THEN c.id_camper
    END) * 100.0 / COUNT(DISTINCT c.id_camper)),
2) as porcentaje_bajo_rendimiento
FROM trainers t
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.trainer
JOIN rutas r ON atr.id_ruta = r.id_ruta
JOIN inscripciones i ON r.id_ruta = i.id_ruta
JOIN campers c ON i.id_camper = c.id_camper
JOIN evaluaciones e ON c.id_camper = e.id_camper
GROUP BY t.id_trainer, t.nombres, t.apellidos, r.nombre_ruta
HAVING COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) < 60 THEN c.id_camper
END) > 0
ORDER BY campers_bajo_rendimiento DESC;

-- 8. Comparar el promedio de rendimiento por trainer.
SELECT t.nombres as nombre_trainer, t.apellidos as apellido_trainer,
COUNT(DISTINCT c.id_camper) as total_campers,
ROUND(AVG(
    (e.evaluacion_teorica * 0.3) +
    (e.evaluacion_practica * 0.6) +
    (e.evaluacion_trabajos * 0.1)
), 2) as promedio_nota_final,
COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) >= 60 THEN c.id_camper
END) as campers_aprobados,
COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) +
        (e.evaluacion_practica * 0.6) +
        (e.evaluacion_trabajos * 0.1),
    2) < 60 THEN c.id_camper
END) as campers_bajo_rendimiento,
ROUND(
    (COUNT(DISTINCT CASE
        WHEN ROUND(
            (e.evaluacion_teorica * 0.3) +
            (e.evaluacion_practica * 0.6) +
            (e.evaluacion_trabajos * 0.1),
        2) >= 60 THEN c.id_camper
    END) * 100.0 / COUNT(DISTINCT c.id_camper)),
2) as porcentaje_aprobacion
FROM trainers t 
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
JOIN rutas r ON atr.id_ruta = r.id_ruta
JOIN inscripciones i ON r.id_ruta = i.id_ruta
JOIN campers c ON i.id_camper = c.id_camper
JOIN evaluaciones e ON c.id_camper = e.id_camper
GROUP BY t.id_trainer, t.nombres, t.apellidos 
ORDER BY promedio_nota_final DESC;

-- 9. Listar los mejores 5 campers por nota final en cada ruta.
WITH RankedCampers AS (
    SELECT c.nombres, c.apellidos, r.nombre_ruta,
        ROUND(
            (e.evaluacion_teorica * 0.3) + 
            (e.evaluacion_practica * 0.6) + 
            (e.evaluacion_trabajos * 0.1), 
        2) as nota_final,
        ROW_NUMBER() OVER (PARTITION BY r.nombre_ruta ORDER BY 
            ROUND(
                (e.evaluacion_teorica * 0.3) + 
                (e.evaluacion_practica * 0.6) + 
                (e.evaluacion_trabajos * 0.1), 
            2) DESC) as ranking
    FROM campers c
    JOIN inscripciones i ON c.id_camper = i.id_camper
    JOIN rutas r ON i.id_ruta = r.id_ruta
    JOIN evaluaciones e ON c.id_camper = e.id_camper
)
SELECT 
    nombres, apellidos, nombre_ruta, nota_final, ranking
FROM RankedCampers
WHERE ranking <= 5
ORDER BY nombre_ruta, ranking;

-- 10. Mostrar cuántos campers pasaron cada módulo por ruta.
SELECT r.nombre_ruta, m.nombre_modulo,
COUNT(DISTINCT c.id_camper) as total_campers,
COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) + 
        (e.evaluacion_practica * 0.6) + 
        (e.evaluacion_trabajos * 0.1), 
    2) >= 60 then c.id_camper
END) as campers_aprobados,
COUNT(DISTINCT CASE
    WHEN ROUND(
        (e.evaluacion_teorica * 0.3) + 
        (e.evaluacion_practica * 0.6) + 
        (e.evaluacion_trabajos * 0.1), 
    2) < 60 THEN c.id_camper
END) as campers_bajo_rendimiento,
ROUND(
    (COUNT(DISTINCT CASE
        WHEN ROUND(
            (e.evaluacion_teorica * 0.3) + 
            (e.evaluacion_practica * 0.6) + 
            (e.evaluacion_trabajos * 0.1), 
        2) >= 60 THEN c.id_camper
    END) * 100.0 / COUNT(DISTINCT c.id_camper)),
2) as porcentaje_aprobacion
FROM rutas r 
JOIN inscripciones i ON r.id_ruta = i.id_ruta
JOIN campers c ON i.id_camper = c.id_camper
JOIN evaluaciones e ON c.id_camper = e.id_camper
JOIN modulos m ON e.id_modulo = m.id_modulo
GROUP BY r.nombre_ruta, m.nombre_modulo
ORDER BY r.nombre_ruta, m.nombre_modulo;



🧭 Rutas y Áreas de Entrenamiento

-- 1. Mostrar todas las rutas de entrenamiento disponibles.
SELECT r.id_ruta, r.nombre_ruta, r.descripcion, r.duracion_meses, r.estado,
    COUNT(DISTINCT i.id_camper) as total_campers_inscritos,
    COUNT(DISTINCT atr.id_trainer) as total_trainers_asignados
FROM rutas r
LEFT JOIN inscripciones i ON r.id_ruta = i.id_ruta
LEFT JOIN asignaciones_trainer_ruta atr ON r.id_ruta = atr.id_ruta
GROUP BY r.id_ruta, r.nombre_ruta, r.descripcion, r.duracion_meses, r.estado
ORDER BY r.nombre_ruta;

-- 2. Obtener las rutas con su SGDB principal y alternativo.
SELECT r.nombre_ruta, bd1.nombre_bd as sgbd_principal, bd2.nombre_bd as sgbd_alternativo
FROM rutas r
JOIN rutas_bases_datos rbd1 ON r.id_ruta = rbd1.id_ruta
JOIN bases_datos bd1 ON rbd1.id_bd = bd1.id_bd
LEFT JOIN rutas_bases_datos rbd2 ON r.id_ruta = rbd2.id_ruta AND rbd2.id_bd != rbd1.id_bd
LEFT JOIN bases_datos bd2 ON rbd2.id_bd = bd2.id_bd
ORDER BY r.nombre_ruta;

-- 3. Listar los módulos asociados a cada ruta.
SELECT r.nombre_ruta, m.nombre_modulo, m.descripcion as descripcion_modulo
FROM rutas r
JOIN modulos m ON r.id_ruta = m.id_ruta
ORDER BY r.nombre_ruta, m.nombre_modulo;

-- 4. Consultar cuántos campers hay en cada ruta.
SELECT r.nombre_ruta,
    COUNT(DISTINCT i.id_camper) as total_campers
FROM rutas r
LEFT JOIN inscripciones i ON r.id_ruta = i.id_ruta
LEFT JOIN campers c ON i.id_camper = c.id_camper
GROUP BY r.nombre_ruta
ORDER BY total_campers DESC;

-- 5. Mostrar las áreas de entrenamiento y su capacidad máxima.
SELECT ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad
FROM areas_entrenamiento ae
JOIN sedes s ON ae.id_sede = s.id_sede
ORDER BY s.nombre_sede, ae.nombre_area;

-- 6. Obtener las áreas que están ocupadas al 100%.
SELECT ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT i.id_camper) as campers_actuales
FROM areas_entrenamiento ae
JOIN sedes s ON ae.id_sede = s.id_sede
JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
JOIN inscripciones i ON aa.id_ruta = i.id_ruta
GROUP BY ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad
HAVING COUNT(DISTINCT i.id_camper) >= ae.capacidad_maxima
ORDER BY ae.nombre_area;

-- 7. Verificar la ocupación actual de cada área.
SELECT ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT i.id_camper) as campers_actuales,
    ROUND((COUNT(DISTINCT i.id_camper) * 100.0 / ae.capacidad_maxima), 2) as porcentaje_ocupacion
FROM areas_entrenamiento ae
JOIN sedes s ON ae.id_sede = s.id_sede
LEFT JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
LEFT JOIN inscripciones i ON aa.id_ruta = i.id_ruta
GROUP BY ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad
ORDER BY porcentaje_ocupacion DESC;

-- 8. Consultar los horarios disponibles por cada área.
SELECT ae.nombre_area, s.nombre_sede, s.ciudad, h.dia_semana, h.hora_inicio, h.hora_fin, t.nombres as nombre_trainer, t.apellidos as apellido_trainer, r.nombre_ruta
FROM areas_entrenamiento ae 
JOIN sedes s ON ae.id_sede = s.id_sede
JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
JOIN rutas r ON aa.id_ruta  = r.id_ruta
JOIN asignaciones_trainer_ruta atr ON r.id_ruta = atr.id_ruta
JOIN trainers t ON atr.id_trainer = t.id_trainer
JOIN horarios h ON t.id_trainer = h.id_trainer
ORDER BY ae.nombre_area, h.dia_semana, h.hora_inicio;

-- 9. Mostrar las áreas con más campers asignados.
SELECT ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT i.id_camper) as total_campers,
    ROUND((COUNT(DISTINCT i.id_camper) * 100.0 / ae.capacidad_maxima), 2) as porcentaje_ocupacion
FROM areas_entrenamiento ae
JOIN sedes s ON ae.id_sede = s.id_sede
LEFT JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
LEFT JOIN inscripciones i ON aa.id_ruta = i.id_ruta
GROUP BY ae.id_area, ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad
ORDER BY total_campers DESC;

-- 10. Listar las rutas con sus respectivos trainers y áreas asignadas.
SELECT r.nombre_ruta, t.nombres as nombre_trainer, t.apellidos as apellido_trainer, ae.nombre_area, s.nombre_sede, s.ciudad
FROM rutas r
JOIN asignaciones_trainer_ruta atr ON r.id_ruta = atr.id_ruta
JOIN trainers t ON atr.id_trainer = t.id_trainer
JOIN asignaciones_areas aa ON r.id_ruta = aa.id_ruta
JOIN areas_entrenamiento ae ON aa.id_area = ae.id_area
JOIN sedes s ON ae.id_sede = s.id_sede
ORDER BY r.nombre_ruta, t.nombres, ae.nombre_area;



 Trainers

 -- 1. Listar todos los entrenadores registrados.
SELECT t.id_trainer, t.nombres, t.apellidos, t.email, t.telefono, s.nombre_sede, s.ciudad,
COUNT(DISTINCT atr.id_ruta) as total_rutas_asignadas
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
LEFT JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, t.telefono, s.nombre_sede
ORDER BY t.nombres, t.apellidos;

-- 2. Mostrar los trainers con sus horarios asignados.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad, h.dia_semana, h.hora_inicio, h.hora_fin, r.nombre_ruta
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
JOIN horarios h ON t.id_trainer = h.id_trainer
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
JOIN rutas r ON atr.id_ruta = r.id_ruta
ORDER BY t.nombres, t.apellidos, h.dia_semana, h.hora_inicio;

-- 3. Consultar los trainers asignados a más de una ruta.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad,
COUNT(DISTINCT atr.id_ruta) as total_rutas 
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad
HAVING COUNT(DISTINCT atr.id_ruta) > 1
ORDER BY total_rutas DESC;

-- 4. Obtener el número de campers por trainer.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad,
COUNT(DISTINCT i.id_camper) as total_campers
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
JOIN inscripciones i ON atr.id_ruta = i.id_ruta
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad
ORDER BY total_campers DESC;

-- 5. Mostrar las áreas en las que trabaja cada trainer.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad, ae.nombre_area
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
JOIN asignaciones_areas aa ON atr.id_ruta = aa.id_ruta
JOIN areas_entrenamiento ae ON aa.id_area = ae.id_area
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad, ae.nombre_area
ORDER BY t.nombres, t.apellidos, ae.nombre_area;

-- 6. Listar los trainers sin asignación de área o ruta.
SELECT t.nombres, t.apellidos, t.email, t.telefono, s.nombre_sede, s.ciudad
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
LEFT JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
WHERE atr.id_trainer IS NULL
ORDER BY t.nombres, t.apellidos;

-- 7. Mostrar cuántos módulos están a cargo de cada trainer.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad,
COUNT(DISTINCT m.id_modulo) as total_modulos
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
LEFT JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
LEFT JOIN modulos m ON atr.id_ruta = m.id_ruta
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad
ORDER BY t.nombres, t.apellidos;

-- 8. Obtener el trainer con mejor rendimiento promedio de campers.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad,
COUNT(DISTINCT i.id_camper) as total_campers,
ROUND(AVG(
    (e.evaluacion_teorica * 0.3) + 
    (e.evaluacion_practica * 0.6) + 
    (e.evaluacion_trabajos * 0.1)    
), 2) as promedio_rendimiento
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
JOIN inscripciones i ON atr.id_ruta = i.id_ruta
JOIN evaluaciones e ON i.id_camper = e.id_camper
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad
ORDER BY promedio_rendimiento DESC;

-- 9. Consultar los horarios ocupados por cada trainer.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad, h.dia_semana, h.hora_inicio, h.hora_fin, r.nombre_ruta, ae.nombre_area
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
JOIN horarios h ON t.id_trainer = h.id_trainer
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
JOIN rutas r ON atr.id_ruta = r.id_ruta
JOIN asignaciones_areas aa ON atr.id_ruta = aa.id_ruta
JOIN areas_entrenamiento ae ON aa.id_area = ae.id_area
ORDER BY t.nombres, t.apellidos, h.dia_semana, h.hora_inicio;

-- 10. Mostrar la disponibilidad semanal de cada trainer.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad, h.dia_semana, h.hora_inicio, h.hora_fin
FROM trainers t 
JOIN sedes s ON t.id_sede = s.id_sede
JOIN horarios h ON t.id_trainer = h.id_trainer
ORDER BY t.nombres, t.apellidos, h.dia_semana, h.hora_inicio;



🔍 Consultas con Subconsultas y Cálculos Avanzados (20
ejemplos)


-- 1. Obtener los campers con la nota más alta en cada módulo.
SELECT m.nombre_modulo, c.nombres, c.apellidos,
ROUND(
    (e.evaluacion_teorica * 0.3) + 
    (e.evaluacion_practica * 0.6) + 
    (e.evaluacion_trabajos * 0.1),    
2) as nota_final
FROM modulos m 
JOIN evaluaciones e ON m.id_modulo = e.id_modulo
JOIN campers c ON e.id_camper = c.id_camper
WHERE ROUND(
    (e.evaluacion_teorica * 0.3) + 
    (e.evaluacion_practica * 0.6) + 
    (e.evaluacion_trabajos * 0.1),    
2) = (
    SELECT MAX(ROUND(
        (e2.evaluacion_teorica * 0.3) + 
        (e2.evaluacion_practica * 0.6) + 
        (e2.evaluacion_trabajos * 0.1), 
    2))
    FROM evaluaciones e2
    WHERE e2.id_modulo = m.id_modulo
)
ORDER BY m.nombre_modulo;

-- 2. Mostrar el promedio general de notas por ruta y comparar con el promedio global.
SELECT r.nombre_ruta,
    COUNT(DISTINCT i.id_camper) as total_campers,
    ROUND(AVG(
        (e.evaluacion_teorica * 0.3) + 
        (e.evaluacion_practica * 0.6) + 
        (e.evaluacion_trabajos * 0.1)
    ), 2) as promedio_ruta,
    ROUND(
        (SELECT AVG(
            (e2.evaluacion_teorica * 0.3) + 
            (e2.evaluacion_practica * 0.6) + 
            (e2.evaluacion_trabajos * 0.1)
        )
        FROM evaluaciones e2), 
    2) as promedio_global,
    ROUND(
        (AVG(
            (e.evaluacion_teorica * 0.3) + 
            (e.evaluacion_practica * 0.6) + 
            (e.evaluacion_trabajos * 0.1)
        ) - 
        (SELECT AVG(
            (e2.evaluacion_teorica * 0.3) + 
            (e2.evaluacion_practica * 0.6) + 
            (e2.evaluacion_trabajos * 0.1)
        )
        FROM evaluaciones e2)), 
    2) as diferencia_promedio
FROM rutas r
JOIN inscripciones i ON r.id_ruta = i.id_ruta
JOIN evaluaciones e ON i.id_camper = e.id_camper
GROUP BY r.id_ruta, r.nombre_ruta
ORDER BY promedio_ruta DESC;

-- 3. Listar las áreas con más del 80% de ocupación.
SELECT ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT i.id_camper) as campers_actuales,
    ROUND((COUNT(DISTINCT i.id_camper) * 100.0 / ae.capacidad_maxima), 2) as porcentaje_ocupacion
FROM areas_entrenamiento ae
JOIN sedes s ON ae.id_sede = s.id_sede
LEFT JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
LEFT JOIN inscripciones i ON aa.id_ruta = i.id_ruta
GROUP BY ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad
HAVING ROUND((COUNT(DISTINCT i.id_camper) * 100.0 / ae.capacidad_maxima), 2) > 80
ORDER BY porcentaje_ocupacion DESC;

-- 4. Mostrar los trainers con menos del 70% de rendimiento promedio.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT i.id_camper) as total_campers,
    ROUND(AVG(
        (e.evaluacion_teorica * 0.3 + 
         e.evaluacion_practica * 0.4 + 
         e.evaluacion_trabajos * 0.3)
    ), 2) as promedio_rendimiento
FROM trainers t
JOIN sedes s ON t.id_sede = s.id_sede
LEFT JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
LEFT JOIN inscripciones i ON atr.id_ruta = i.id_ruta
LEFT JOIN evaluaciones e ON i.id_camper = e.id_camper
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad
HAVING promedio_rendimiento < 70
ORDER BY promedio_rendimiento ASC;

-- 5. Consultar los campers cuyo promedio está por debajo del promedio general.
WITH promedio_general AS (
    SELECT 
        AVG(
            (evaluacion_teorica * 0.3 + 
             evaluacion_practica * 0.4 + 
             evaluacion_trabajos * 0.3)
        ) as promedio_global
    FROM evaluaciones
)
SELECT c.nombres, c.apellidos, c.numero_identificacion, r.nombre_ruta, s.nombre_sede, s.ciudad,
    COUNT(e.id_evaluacion) as total_evaluaciones,
    ROUND(AVG(
        (e.evaluacion_teorica * 0.3 + 
         e.evaluacion_practica * 0.4 + 
         e.evaluacion_trabajos * 0.3)
    ), 2) as promedio_camper,
    (SELECT promedio_global FROM promedio_general) as promedio_general
FROM campers c
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
JOIN sedes s ON r.id_sede = s.id_sede
LEFT JOIN evaluaciones e ON c.id_camper = e.id_camper
GROUP BY c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, r.nombre_ruta, s.nombre_sede, s.ciudad
HAVING promedio_camper < (SELECT promedio_global FROM promedio_general)
ORDER BY promedio_camper ASC;

-- 6. Obtener los módulos con la menor tasa de aprobación.
SELECT m.nombre_modulo, m.descripcion,
    COUNT(e.id_evaluacion) as total_evaluaciones,
    COUNT(CASE WHEN e.nota_final >= 60 THEN 1 END) as evaluaciones_aprobadas,
    ROUND((COUNT(CASE WHEN e.nota_final >= 60 THEN 1 END) * 100.0 / COUNT(e.id_evaluacion)), 2) as tasa_aprobacion
FROM modulos m
LEFT JOIN evaluaciones e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo, m.nombre_modulo, m.descripcion
HAVING total_evaluaciones > 0
ORDER BY tasa_aprobacion ASC;

-- 7. Listar los campers que han aprobado todos los módulos de su ruta.
SELECT c.nombres, c.apellidos, c.numero_identificacion, r.nombre_ruta, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT m.id_modulo) as total_modulos_ruta,
    COUNT(DISTINCT CASE WHEN e.nota_final >= 60 THEN m.id_modulo END) as modulos_aprobados,
    ROUND((COUNT(DISTINCT CASE WHEN e.nota_final >= 60 THEN m.id_modulo END) * 100.0 / COUNT(DISTINCT m.id_modulo)), 2) as porcentaje_aprobacion
FROM campers c
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
JOIN sedes s ON r.id_sede = s.id_sede
JOIN modulos m ON r.id_ruta = m.id_ruta
LEFT JOIN evaluaciones e ON c.id_camper = e.id_camper AND m.id_modulo = e.id_modulo
GROUP BY c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, r.nombre_ruta, s.nombre_sede, s.ciudad
HAVING total_modulos_ruta > 0
ORDER BY porcentaje_aprobacion DESC;

-- 8. Mostrar rutas con más de 10 campers en bajo rendimiento.
SELECT r.nombre_ruta, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT c.id_camper) as total_campers,
    COUNT(DISTINCT CASE 
        WHEN (e.evaluacion_teorica * 0.3 + 
              e.evaluacion_practica * 0.4 + 
              e.evaluacion_trabajos * 0.3) < 60 
        THEN c.id_camper 
    END) as campers_bajo_rendimiento,
    ROUND(AVG(
        (e.evaluacion_teorica * 0.3 + 
         e.evaluacion_practica * 0.4 + 
         e.evaluacion_trabajos * 0.3)
    ), 2) as promedio_rendimiento
FROM rutas r
JOIN sedes s ON r.id_sede = s.id_sede
JOIN inscripciones i ON r.id_ruta = i.id_ruta
JOIN campers c ON i.id_camper = c.id_camper
LEFT JOIN evaluaciones e ON c.id_camper = e.id_camper
GROUP BY r.id_ruta, r.nombre_ruta, s.nombre_sede, s.ciudad
HAVING campers_bajo_rendimiento > 10
ORDER BY campers_bajo_rendimiento DESC;

-- 9. Calcular el promedio de rendimiento por SGDB principal.
SELECT bd.nombre_bd,
    COUNT(DISTINCT e.id_evaluacion) as total_evaluaciones,
    ROUND(AVG(
        (e.evaluacion_teorica * 0.3 + 
         e.evaluacion_practica * 0.4 + 
         e.evaluacion_trabajos * 0.3)
    ), 2) as promedio_rendimiento
FROM bases_datos bd
JOIN rutas_bases_datos rbd ON bd.id_bd = rbd.id_bd
JOIN rutas r ON rbd.id_ruta = r.id_ruta
JOIN inscripciones i ON r.id_ruta = i.id_ruta
JOIN evaluaciones e ON i.id_camper = e.id_camper
GROUP BY bd.id_bd, bd.nombre_bd
ORDER BY promedio_rendimiento DESC;

-- 10. Listar los módulos con al menos un 30% de campers reprobados.
SELECT m.nombre_modulo, m.descripcion,
    COUNT(DISTINCT e.id_evaluacion) as total_evaluaciones,
    COUNT(DISTINCT CASE WHEN e.nota_final < 60 THEN e.id_evaluacion END) as evaluaciones_reprobadas,
    ROUND((COUNT(DISTINCT CASE WHEN e.nota_final < 60 THEN e.id_evaluacion END) * 100.0 / COUNT(DISTINCT e.id_evaluacion)), 2) as porcentaje_reprobados
FROM modulos m
JOIN evaluaciones e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo, m.nombre_modulo, m.descripcion
HAVING porcentaje_reprobados >= 30
ORDER BY porcentaje_reprobados DESC;

-- 11. Mostrar el módulo más cursado por campers con riesgo alto.
SELECT m.nombre_modulo, m.descripcion,
    COUNT(DISTINCT c.id_camper) as total_campers_riesgo_alto,
    ROUND(AVG(
        (e.evaluacion_teorica * 0.3 + 
         e.evaluacion_practica * 0.4 + 
         e.evaluacion_trabajos * 0.3)
    ), 2) as promedio_rendimiento
FROM modulos m
JOIN evaluaciones e ON m.id_modulo = e.id_modulo
JOIN inscripciones i ON e.id_camper = i.id_camper
JOIN campers c ON i.id_camper = c.id_camper
WHERE c.nivel_riesgo = 'Alto'
GROUP BY m.id_modulo, m.nombre_modulo, m.descripcion
ORDER BY total_campers_riesgo_alto DESC
LIMIT 1;

-- 12. Consultar los trainers con más de 3 rutas asignadas.
SELECT t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT atr.id_ruta) as total_rutas_asignadas
FROM trainers t
JOIN sedes s ON t.id_sede = s.id_sede
JOIN asignaciones_trainer_ruta atr ON t.id_trainer = atr.id_trainer
GROUP BY t.id_trainer, t.nombres, t.apellidos, t.email, s.nombre_sede, s.ciudad
HAVING total_rutas_asignadas > 3
ORDER BY total_rutas_asignadas DESC;

-- 13. Listar los horarios más ocupados por áreas.
SELECT ae.nombre_area, s.nombre_sede, s.ciudad, h.dia_semana, h.hora_inicio, h.hora_fin,
    COUNT(DISTINCT atr.id_ruta) as total_rutas_asignadas
FROM areas_entrenamiento ae
JOIN sedes s ON ae.id_sede = s.id_sede
JOIN horarios h ON ae.id_area = h.id_area
JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
JOIN asignaciones_trainer_ruta atr ON aa.id_ruta = atr.id_ruta
GROUP BY ae.id_area,ae.nombre_area, s.nombre_sede, s.ciudad, h.dia_semana, h.hora_inicio, h.hora_fin
ORDER BY total_rutas_asignadas DESC;

-- 14. Consultar las rutas con el mayor número de módulos.
SELECT r.nombre_ruta, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT m.id_modulo) as total_modulos
FROM rutas r
JOIN sedes s ON r.id_sede = s.id_sede
JOIN modulos m ON r.id_ruta = m.id_ruta
GROUP BY r.id_ruta, r.nombre_ruta, s.nombre_sede, s.ciudad
ORDER BY total_modulos DESC;

-- 15. Obtener los campers que han cambiado de estado más de una vez.
SELECT c.nombres, c.apellidos, c.numero_identificacion, r.nombre_ruta, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT hce.estado_nuevo) as total_cambios_estado
FROM campers c
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
JOIN sedes s ON r.id_sede = s.id_sede
JOIN historial_cambios_estado hce ON c.id_camper = hce.id_camper
GROUP BY c.id_camper, c.nombres, c.apellidos, c.numero_identificacion, r.nombre_ruta, s.nombre_sede, s.ciudad
HAVING total_cambios_estado > 1
ORDER BY total_cambios_estado DESC;

-- 16. Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica.
SELECT c.nombres, c.apellidos, m.nombre_modulo, e.evaluacion_teorica, e.evaluacion_practica, e.evaluacion_trabajos, e.nota_final
FROM campers c
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
JOIN modulos m ON r.id_ruta = m.id_ruta
JOIN evaluaciones e ON c.id_camper = e.id_camper AND m.id_modulo = e.id_modulo
WHERE e.evaluacion_teorica > e.evaluacion_practica
ORDER BY (e.evaluacion_teorica - e.evaluacion_practica) DESC;

-- 17. Listar los módulos donde la media de quizzes supera el 9.
SELECT m.nombre_modulo, m.descripcion, r.nombre_ruta, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT e.id_evaluacion) as total_quizzes
FROM modulos m
JOIN rutas r ON m.id_ruta = r.id_ruta
JOIN sedes s ON r.id_sede = s.id_sede
JOIN evaluaciones e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo, m.nombre_modulo, m.descripcion, r.nombre_ruta, s.nombre_sede, s.ciudad
HAVING total_quizzes > 9
ORDER BY total_quizzes DESC;

-- 18. Consultar la ruta con mayor tasa de graduación.
SELECT r.nombre_ruta, r.descripcion, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT e.id_camper) as total_egresados,
    COUNT(DISTINCT i.id_camper) as total_inscritos,
    ROUND((COUNT(DISTINCT e.id_camper) * 100.0 / COUNT(DISTINCT i.id_camper)), 2) as tasa_graduacion
FROM rutas r
JOIN sedes s ON r.id_sede = s.id_sede
LEFT JOIN inscripciones i ON r.id_ruta = i.id_ruta
LEFT JOIN egresados e ON r.id_ruta = e.ruta_completada
GROUP BY r.id_ruta, r.nombre_ruta, r.descripcion, s.nombre_sede, s.ciudad
ORDER BY tasa_graduacion DESC;

-- 19. Mostrar los módulos cursados por campers de nivel de riesgo medio o alto.
SELECT c.nombres, c.apellidos, c.nivel_riesgo, m.nombre_modulo, m.descripcion, r.nombre_ruta, s.nombre_sede, s.ciudad, e.evaluacion_teorica, e.evaluacion_practica, e.evaluacion_trabajos, e.nota_final
FROM campers c
JOIN inscripciones i ON c.id_camper = i.id_camper
JOIN rutas r ON i.id_ruta = r.id_ruta
JOIN sedes s ON r.id_sede = s.id_sede
JOIN modulos m ON r.id_ruta = m.id_ruta
JOIN evaluaciones e ON c.id_camper = e.id_camper AND m.id_modulo = e.id_modulo
WHERE c.nivel_riesgo IN ('Medio', 'Alto')
ORDER BY c.nivel_riesgo DESC, c.nombres, c.apellidos, m.nombre_modulo;

-- 20. Obtener la diferencia entre capacidad y ocupación en cada área.
SELECT ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad,
    COUNT(DISTINCT i.id_camper) as campers_actuales,
    (ae.capacidad_maxima - COUNT(DISTINCT i.id_camper)) as espacios_disponibles,
    ROUND((COUNT(DISTINCT i.id_camper) * 100.0 / ae.capacidad_maxima), 2) as porcentaje_ocupacion
FROM areas_entrenamiento ae
JOIN sedes s ON ae.id_sede = s.id_sede
LEFT JOIN asignaciones_areas aa ON ae.id_area = aa.id_area
LEFT JOIN inscripciones i ON aa.id_ruta = i.id_ruta
GROUP BY ae.id_area, ae.nombre_area, ae.capacidad_maxima, s.nombre_sede, s.ciudad
ORDER BY porcentaje_ocupacion DESC;



🔁 JOINs Básicos (INNER JOIN, LEFT JOIN, etc.)


-- 1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que estan inscritos.

