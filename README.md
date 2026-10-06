# Semana 9 · Exploración de Chinook con SQL (PostgreSQL)

**Nombre:** Edgar Oswaldo Quiche Vicente
**Sección:** [base de datos exploracion]

## Requisitos
- PostgreSQL 16 (corriendo en contenedor Docker)
- DataGrip como cliente SQL
- Script oficial Chinook para PostgreSQL

## Variante de Chinook usada
Base **Chinook Database v1.4** (versión PostgreSQL), obtenida del repositorio oficial:
https://github.com/lerocha/chinook-database

## Importación
1. Se creó la base de datos `chinook`.
2. Se ejecutó el script `chinook_postgresql.sql` sobre esa base.
3. Se verificó la carga con `SELECT COUNT(*) FROM Customer;`.

## Conexión
Desde DataGrip:
```text
Host:     localhost
Port:     5433
Database: chinook
User:     postgres
```

## Ejecución de consultas
Todas las consultas están en `consultas.sql`, organizadas en 10 apartados.
Todas las sentencias son de **solo lectura**; no se modifican datos.

## Índice de apartados
| # | Apartado | Pregunta que responde | Sentencias |
|---|----------|-----------------------|-----------|
| 1 | Conexión | ¿Estoy conectado a la base correcta? | 1 |
| 2 | Operadores | ¿Qué pistas pesan >10 MB y su precio/minuto? | 1 |
| 3 | Filtros lógicos | Clientes USA/Canadá con fax registrado | 1 |
| 4 | IN / BETWEEN | Cuentas corporativas por asesor de soporte | 1 |
| 5 | Valores NULL | Listado de clientes sin celdas vacías | 1 |
| 6 | Patrones LIKE | Clientes particulares con apellido que inicia en M | 1 |
| 7 | Ordenamiento | Top 5 pistas caras / top 5 más cortas | 2 |
| 8 | Paginación | Recorrido de clientes de 5 en 5 | 3 |
| 9 | DISTINCT | Países con presencia comercial | 1 |
| 10 | CASE | Reparto de clientes por equipo de soporte | 2 |

## Video
Enlace: [Pegar aquí la URL de tu video]
Capítulos: 00:00 conexión · 02:00 apartados 1-4 · 05:00 apartados 5-7 · 08:00 apartados 8-10
