# Proyecto SQL - CampusLands ERP

Este proyecto es un sistema de gestión para el programa de CampusLands, que incluye la gestión de campers, trainers, modulos, rutas, sedes, evaluciones, asistencias, areas.

## Estructura de la base de datos

El sistema está compuesto por las siguientes tablas principales:

- `sedes`: Gestiona las sedes donde se imparten las rutas de aprendizaje.
- `rutas`: Define las rutas de aprendizaje disponibles.
- `trainers`: Registra los entrenadores que dictan las rutas.
- `areas_entrenamiento`: Representa los espacios físicos donde se imparten clases.
- `campers`: Almacena la información de los estudiantes en formación.
- `asignaciones_sedes`: Registra la asignación de rutas a sedes.
- `historial_cambios_sedes`: Mantiene un registro de los cambios de sede de los campers.
- `modulos`: Define los módulos dentro de cada ruta de aprendizaje.
- `bases_datos`: Lista de bases de datos utilizadas en la formación.
- `rutas_bases_datos`: Relación entre rutas y bases de datos utilizadas.
- `horarios`: Horarios asignados a los entrenadores y áreas de entrenamiento.
- `asignaciones_trainer_ruta`: Registra qué entrenadores dictan qué rutas.
- `inscripciones`: Almacena las inscripciones de los campers a las rutas.
- `evaluaciones`: Registra las calificaciones de los campers en cada módulo.
- `asistencia`: Registro de asistencia de los campers en las áreas de entrenamiento.
- `telefonos_campers`: Permite almacenar múltiples teléfonos para cada camper.
- `historial_cambios_estado`: Mantiene un historial de cambios de estado de los campers.
- `egresados`: Registro de campers que han completado su formación.
- `plantillas_rutas`: Plantillas predefinidas de rutas de aprendizaje.
- `plantillas_modulos`: Plantillas de módulos dentro de cada ruta.
- `notificacion_trainers`: Sistema de notificaciones para entrenadores.
- `conocimientos_trainers`: Registro de conocimientos y nivel de experiencia de los trainers.
- `reportes_mensuales`: Genera reportes de desempeño de cada ruta mensualmente.
- `asignaciones_areas`: Registra la asignación de áreas de entrenamiento a rutas.
- `historial_horarios`: Historial de cambios en los horarios de trainers y áreas.
- `estadisticas_rendimiento`: Registra estadísticas sobre el rendimiento académico.
- `sesiones`: Almacena información sobre sesiones de clases en cada módulo.
- `asistencia_sesiones`: Registro detallado de asistencia de campers en sesiones específicas.


## Requisitos

- MySQL 8.0 o superior
- Acceso a un servidor MySQL

## Caracteristicas Principales

- Gestión completa de campers y su información personal
- Control de rutas de aprendizaje y módulos
- Sistema de evaluación con ponderación (teórica 30%, práctica 60%, trabajos 10%)
- Gestión de áreas de entrenamiento con capacidad máxima de 33 campers
- Control de horarios y asignaciones de trainers
- Seguimiento del estado académico de los campers

## Normalización

La base de datos está normalizada hasta la Tercera Forma Normal (3FN) para garantizar la integridad de los datos y evitar redundancias.

## Creacion Base de datos

```
CREATE DATABASE IF NOT EXISTS campuslands_ERP;
USE campuslands_ERP;
```


## Estructura del Proyecto

- **/tablas**: Contiene las tablas de la base de datos.
- [DQL Select](ddl.sql)
- **/inserts**: Contiene los scripts de inserción de datos iniciales.
- [DQL Select](dml.sql)
- **/diagrama**: Contiene el diagrama.
- [DQL Select](Diagrama.png)
- **/consultas**: Contiene las consultas SQL utilizadas en el proyecto.
- [DQL Select](dql_select.sql): Consultas de selección de datos.
- **/triggers**: Contiene los triggers SQL para la gestión de eventos en la base de datos.
- [DQL Select](dql.triggers.sql): Triggers
- **/procedimientos**: Contiene los procedimientos almacenados utilizados en el sistema.
- [DQL Select](dql_procedimientos.sql): Procedimientos
- **/funciones**: Contiene las funciones utilizados en el sistema.
- [DQL Select](dql_funciones.sql): Funciones