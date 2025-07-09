CREATE DATABASE diabetes_health;

-- Tabla Paciente (clave primaria id_paciente)
CREATE TABLE paciente (
    id_paciente SERIAL PRIMARY KEY,
    sexo INTEGER,
    edad INTEGER,
    educacion INTEGER,
    ingreso INTEGER
);

-- Tabla Indicadores de Salud
CREATE TABLE indicadores_salud (
    id_indicador SERIAL PRIMARY KEY,
    id_paciente INTEGER REFERENCES paciente(id_paciente),
    diabetes_binary INTEGER,
    high_bp INTEGER,
    high_chol INTEGER,
    stroke INTEGER,
    heart_disease_attack INTEGER
);

-- Tabla Habitos
CREATE TABLE habitos (
    id_habito SERIAL PRIMARY KEY,
    id_paciente INTEGER REFERENCES paciente(id_paciente),
    smoker INTEGER,
    phys_activity INTEGER,
    fruits INTEGER,
    veggies INTEGER,
    heavy_alcohol_consump INTEGER
);

-- Tabla Salud Mental y Física
CREATE TABLE salud_mental_fisica (
    id_salud SERIAL PRIMARY KEY,
    id_paciente INTEGER REFERENCES paciente(id_paciente),
    gen_hlth INTEGER,
    ment_hlth INTEGER,
    phys_hlth INTEGER,
    diff_walk INTEGER
);

-- Tabla Atencion Sanitaria
CREATE TABLE atencion_sanitaria (
    id_atencion SERIAL PRIMARY KEY,
    id_paciente INTEGER REFERENCES paciente(id_paciente),
    chol_check INTEGER,
    any_healthcare INTEGER,
    no_docbc_cost INTEGER
);

CREATE TABLE temp_diabetes (
    Diabetes_binary INTEGER,
    HighBP INTEGER,
    HighChol INTEGER,
    CholCheck INTEGER,
    BMI NUMERIC,
    Smoker INTEGER,
    Stroke INTEGER,
    HeartDiseaseorAttack INTEGER,
    PhysActivity INTEGER,
    Fruits INTEGER,
    Veggies INTEGER,
    HvyAlcoholConsump INTEGER,
    AnyHealthcare INTEGER,
    NoDocbcCost INTEGER,
    GenHlth INTEGER,
    MentHlth INTEGER,
    PhysHlth INTEGER,
    DiffWalk INTEGER,
    Sex INTEGER,
    Age INTEGER,
    Education INTEGER,
    Income INTEGER
);


TRUNCATE TABLE atencion_sanitaria RESTART IDENTITY CASCADE;
TRUNCATE TABLE habitos RESTART IDENTITY CASCADE;
TRUNCATE TABLE salud_mental_fisica  RESTART IDENTITY CASCADE;
TRUNCATE TABLE paciente RESTART IDENTITY CASCADE;
TRUNCATE TABLE indicadores_salud RESTART IDENTITY CASCADE;


-- Iniciar transacción
BEGIN;

-- Paso 1: Insertar en paciente
INSERT INTO paciente (sexo, edad, educacion, ingreso)
SELECT sex, age, education, income
FROM temp_diabetes;

-- Paso 2: Insertar en indicadores_salud
WITH temp_with_rownum AS (
  SELECT *, ROW_NUMBER() OVER () AS rn
  FROM temp_diabetes
),
paciente_with_rownum AS (
  SELECT id_paciente, ROW_NUMBER() OVER () AS rn
  FROM paciente
)
INSERT INTO indicadores_salud (id_paciente, diabetes_binary, high_bp, high_chol, stroke, heart_disease_attack)
SELECT p.id_paciente, t.Diabetes_binary, t.HighBP, t.HighChol, t.Stroke, t.HeartDiseaseorAttack
FROM temp_with_rownum t
JOIN paciente_with_rownum p ON t.rn = p.rn;

-- Paso 3: Insertar en habitos
WITH temp_with_rownum AS (
  SELECT *, ROW_NUMBER() OVER () AS rn
  FROM temp_diabetes
),
paciente_with_rownum AS (
  SELECT id_paciente, ROW_NUMBER() OVER () AS rn
  FROM paciente
)
INSERT INTO habitos (id_paciente, smoker, phys_activity, fruits, veggies, heavy_alcohol_consump)
SELECT p.id_paciente, t.Smoker, t.PhysActivity, t.Fruits, t.Veggies, t.HvyAlcoholConsump
FROM temp_with_rownum t
JOIN paciente_with_rownum p ON t.rn = p.rn;

-- Paso 4: Insertar en salud_mental_fisica
WITH temp_with_rownum AS (
  SELECT *, ROW_NUMBER() OVER () AS rn
  FROM temp_diabetes
),
paciente_with_rownum AS (
  SELECT id_paciente, ROW_NUMBER() OVER () AS rn
  FROM paciente
)
INSERT INTO salud_mental_fisica (id_paciente, gen_hlth, ment_hlth, phys_hlth, diff_walk)
SELECT p.id_paciente, t.GenHlth, t.MentHlth, t.PhysHlth, t.DiffWalk
FROM temp_with_rownum t
JOIN paciente_with_rownum p ON t.rn = p.rn;

-- Paso 5: Insertar en atencion_sanitaria
WITH temp_with_rownum AS (
  SELECT *, ROW_NUMBER() OVER () AS rn
  FROM temp_diabetes
),
paciente_with_rownum AS (
  SELECT id_paciente, ROW_NUMBER() OVER () AS rn
  FROM paciente
)
INSERT INTO atencion_sanitaria (id_paciente, chol_check, any_healthcare, no_docbc_cost)
SELECT p.id_paciente, t.CholCheck, t.AnyHealthcare, t.NoDocbcCost
FROM temp_with_rownum t
JOIN paciente_with_rownum p ON t.rn = p.rn;

-- Finalizar transacción
COMMIT;


SELECT COUNT(*) FROM temp_diabetes;
SELECT COUNT(*) FROM paciente;
SELECT COUNT(*) FROM indicadores_salud;
SELECT COUNT(*) FROM habitos;
SELECT COUNT(*) FROM salud_mental_fisica;
SELECT COUNT(*) FROM atencion_sanitaria;

--📊 Datos Demográficos
--¿Cuál es la distribución por sexo?
SELECT sexo, COUNT(*) AS cantidad
FROM paciente
GROUP BY sexo;

--¿Cuál es el rango y promedio de edad?
select MIN(edad) as edad_minima, max(edad) as edad_maxima, avg(edad) as media_edad from paciente

--¿Cómo varía el nivel educativo entre los pacientes?
SELECT educacion, COUNT(*) AS numero_pacientes
FROM paciente
GROUP BY educacion
ORDER BY numero_pacientes DESC;

--¿Qué distribución de ingresos existe?
SELECT ingreso, COUNT(*) AS numero_ingresos
FROM paciente
GROUP BY ingreso
ORDER BY numero_ingresos DESC;


--💉 Indicadores de Salud
--¿Cuántos pacientes tienen diabetes?
select diabetes_binary, count(*) as gente_diabetes 
from paciente p join indicadores_salud i on p.id_paciente = i.id_paciente
group by diabetes_binary

--¿Cuántos tienen hipertensión (HighBP)?
SELECT high_bp, COUNT(*) AS con_sin_hipertension
FROM indicadores_salud
GROUP BY high_bp 
ORDER BY con_sin_hipertension  DESC;

--¿Cuántos tienen colesterol alto?
SELECT high_chol, COUNT(*) AS con_sin_colesterol
FROM indicadores_salud
GROUP BY high_chol
ORDER BY con_sin_colesterol  DESC;

--¿Cuántos han sufrido un ataque cardíaco o enfermedad del corazón?
SELECT heart_disease_attack, COUNT(*) AS con_sin_ataque_cardiaco
FROM indicadores_salud
GROUP BY heart_disease_attack
ORDER BY con_sin_ataque_cardiaco  DESC;

--¿Cuántos han sufrido un ictus (stroke)?
SELECT stroke, COUNT(*) AS con_sin_ictus
FROM indicadores_salud
GROUP BY stroke
ORDER BY con_sin_ictus  DESC;

--¿Cuántos tienen múltiples condiciones a la vez?
SELECT COUNT(*) AS pacientes_con_mas_de_una_condicion
FROM (
SELECT id_paciente, (high_bp + high_chol + heart_disease_attack + stroke) AS total_condiciones
  FROM indicadores_salud
) AS subconsulta
WHERE total_condiciones > 10;

--🚬 Hábitos de Vida
--¿Cuántos son fumadores?
select count(smoker) from habitos
where smoker = 10

--¿Cuántos hacen actividad física?
select count(phys_activity) from habitos
where phys_activity = 10

--¿Cuántos consumen frutas y verduras?
select count(fruits + veggies) as frutas_y_verduras from habitos
 WHERE fruits = 10 AND veggies = 10;


--¿Cuántos son consumidores de alcohol en exceso?
select count(heavy_alcohol_consump) from habitos
where heavy_alcohol_consump = 10

--¿Existe relación entre ser fumador y tener diabetes?
SELECT 
  h.smoker,
  i.diabetes_binary,
  COUNT(*) AS total_pacientes
FROM habitos h
JOIN indicadores_salud i ON h.id_paciente = i.id_paciente
GROUP BY h.smoker, i.diabetes_binary
ORDER BY h.smoker DESC, i.diabetes_binary DESC;


--¿La actividad física reduce el riesgo de ataque al corazón?
SELECT 
  h.phys_activity,
  i.heart_disease_attack,
  COUNT(*) AS total_pacientes
FROM habitos h
JOIN indicadores_salud i ON h.id_paciente = i.id_paciente
GROUP BY h.phys_activity, i.heart_disease_attack
ORDER BY h.phys_activity DESC, i.heart_disease_attack DESC;




--🧠 Salud Mental y Física
--¿Cuál es el promedio de días con mala salud mental?
select round(avg(ment_hlth), 2) as media_dias_salud_mental from salud_mental_fisica

--¿Cuál es el promedio de días con mala salud física?
select round(avg(phys_hlth), 2) as media_dias_salud_fisica from salud_mental_fisica


--¿Cuántos tienen dificultades para caminar?
select count(diff_walk) from salud_mental_fisica
where diff_walk = 10

--¿Los pacientes con diabetes tienen peor salud mental?
select diabetes_binary, ment_hlth, count(*) as pacientes from indicadores_salud p join salud_mental_fisica i  on p.id_paciente = i.id_paciente
group by diabetes_binary, i.ment_hlth

--¿Existe correlación entre salud general y número de días enfermos?

SELECT 
  gen_hlth,
  (phys_hlth + ment_hlth) AS total_dias_enfermo
FROM indicadores_salud p
JOIN salud_mental_fisica s ON p.id_paciente = s.id_paciente
WHERE gen_hlth IS NOT NULL
  AND phys_hlth IS NOT NULL
  AND ment_hlth IS NOT NULL;


--🏥 Atención Sanitaria
--¿Cuántos han revisado su colesterol recientemente?
select count(chol_check) from atencion_sanitaria 
where chol_check = 10

--¿Cuántos tienen acceso a atención médica?
select count(any_healthcare) from atencion_sanitaria 
where any_healthcare = 10

--¿Cuántos no han ido al médico por razones económicas?
select count(no_docbc_cost) from atencion_sanitaria 
where no_docbc_cost = 0

--¿Tener seguro sanitario está relacionado con menor incidencia de enfermedades?
SELECT 
  any_healthcare,
  AVG(high_bp) AS media_hipertension,
  AVG(high_chol) AS media_colesterol_alto,
  AVG(heart_disease_attack) AS media_ataques_corazon,
  AVG(stroke) AS media_ictus
FROM atencion_sanitaria a
JOIN indicadores_salud i ON a.id_paciente = i.id_paciente
WHERE any_healthcare IS NOT NULL
GROUP BY any_healthcare;




--📉 Cruces Interesantes
--¿Hay diferencias entre la educacion y tener diabetes?
select educacion, diabetes_binary from paciente p join indicadores_salud i on p.id_paciente = i.id_paciente
group by educacion, diabetes_binary


--¿Cómo se distribuye la diabetes según los ingresos?
select ingreso, diabetes_binary from paciente p join indicadores_salud i on p.id_paciente = i.id_paciente
group by ingreso, diabetes_binary 

--¿Qué combinación de factores es más frecuente en pacientes con diabetes?
SELECT 
  high_bp,
  high_chol,
  heart_disease_attack,
  stroke,
  phys_activity,
  smoker,
  heavy_alcohol_consump,
  COUNT(*) AS frecuencia
FROM indicadores_salud i
JOIN habitos h ON i.id_paciente = h.id_paciente
WHERE diabetes_binary = 10
GROUP BY 
  high_bp,
  high_chol,
  heart_disease_attack,
  stroke,
  phys_activity,
  smoker,
  heavy_alcohol_consump
ORDER BY frecuencia DESC
LIMIT 5;


--¿Los pacientes con buena salud general tienen menos enfermedades crónicas?
SELECT 
  gen_hlth,
  AVG(high_bp) AS prom_hipertension,
  AVG(high_chol) AS prom_colesterol_alto,
  AVG(heart_disease_attack) AS prom_enfermedad_cardiaca,
  AVG(stroke) AS prom_ictus
FROM salud_mental_fisica s
JOIN indicadores_salud i ON s.id_paciente = i.id_paciente
GROUP BY gen_hlth
ORDER BY gen_hlth DESC;


--¿Existe una edad umbral donde se dispara la prevalencia de enfermedades?
SELECT 
  CASE 
    WHEN edad < 30 THEN '1-30'
    WHEN edad BETWEEN 30 AND 39 THEN '30-39'
    WHEN edad BETWEEN 40 AND 49 THEN '40-49'
    WHEN edad BETWEEN 50 AND 59 THEN '50-59'
    WHEN edad BETWEEN 60 AND 69 THEN '60-69'
    ELSE '70 o más'
  END AS grupo_edad,
  AVG(high_bp) AS prom_hipertension,
  AVG(high_chol) AS prom_colesterol,
  AVG(heart_disease_attack) AS prom_cardio,
  AVG(stroke) AS prom_ictus,
  AVG(diabetes_binary) AS prom_diabetes
FROM paciente p
JOIN indicadores_salud i ON p.id_paciente = i.id_paciente
GROUP BY grupo_edad
ORDER BY grupo_edad;


--🔍 Agrupaciones y Tendencias
--¿Cuáles son los 5 perfiles más comunes de pacientes?
SELECT 
  sexo, 
  educacion, 
  edad, 
  ingreso, 
  COUNT(*) AS frecuencia
FROM paciente
GROUP BY sexo, educacion, edad, ingreso
ORDER BY frecuencia DESC
LIMIT 5;


--¿Cuáles son los grupos de edad con mayor incidencia de enfermedades?
SELECT 
  CASE 
    WHEN edad < 30 THEN '1-30'
    WHEN edad BETWEEN 30 AND 39 THEN '30-39'
    WHEN edad BETWEEN 40 AND 49 THEN '40-49'
    WHEN edad BETWEEN 50 AND 59 THEN '50-59'
    WHEN edad BETWEEN 60 AND 69 THEN '60-69'
    ELSE '70 o más'
  END AS grupo_edad,
  AVG(high_bp + high_chol + heart_disease_attack + stroke) AS media_condiciones
FROM paciente p
JOIN indicadores_salud i ON p.id_paciente = i.id_paciente
GROUP BY grupo_edad
ORDER BY media_condiciones DESC;


--¿Cómo varía el número de condiciones según la edad?
SELECT 
  edad,
  AVG((high_bp + high_chol + heart_disease_attack + stroke)/10.0) AS promedio_condiciones
FROM paciente p
JOIN indicadores_salud i ON p.id_paciente = i.id_paciente
GROUP BY edad
ORDER BY edad;


--¿Qué hábitos tienen en común los pacientes sin enfermedades?
SELECT 
  AVG(fruits) AS media_frutas,
  AVG(veggies) AS media_verduras,
  AVG(phys_activity) AS media_ejercicio,
  AVG(smoker) AS media_tabaquismo
FROM paciente p
JOIN indicadores_salud i ON p.id_paciente = i.id_paciente
JOIN habitos h ON p.id_paciente = h.id_paciente
WHERE 
  high_bp = 0 AND 
  high_chol = 0 AND 
  heart_disease_attack = 0 AND 
  stroke = 0 

