# 🩺 SQL_diabetes
Análisis de Datos Clínicos para Predicción de Diabetes con SQL
Este proyecto consiste en un análisis exploratorio de una base de datos relacional con información clínica sobre pacientes y factores asociados a la diabetes. Utilizando consultas SQL, se extraen insights relevantes que podrían ayudar en la detección temprana de esta enfermedad.

# 🧹 Limpieza y preparación de datos
El proyecto parte de un único archivo CSV original con datos clínicos de pacientes.

Realicé un proceso de limpieza local del archivo:

Eliminación y tratamiento de valores nulos o inconsistentes

Corrección de outliers evidentes

Conversión de tipos de datos

Posteriormente, en DBeaver, normalicé el dataset dividiéndolo en varias tablas relacionales que permitieran realizar un análisis más estructurado y consultas SQL avanzadas.

# 🎯 Objetivos del proyecto
Explorar la base de datos y entender los patrones asociados al diagnóstico de diabetes.

Aplicar consultas SQL con funciones agregadas, CASE, GROUP BY, HAVING, etc.

Comparar métricas clínicas entre pacientes diabéticos y no diabéticos.

Analizar relaciones entre variables.

#🛠️ Tecnologías utilizadas
SQL para consultas y análisis de datos

DBeaver como entorno para gestión de base de datos

CSV importado a base relacional desde DBeaver

# 📁 Estructura del repositorio

├── queries/

│   ├── Consultas Datos demográficos.sql

│   ├── Consultas_atencion_sanitaria.sql

│   ├── Consultas_habitos.sql

│   ├── Consultas_indicadores de vida.sql

│   └── Creacion de tablas e importar datos

│   ├── Cruces y agrupaciones.sql

├── data/

│   └── diabetes.csv

└── README.md
