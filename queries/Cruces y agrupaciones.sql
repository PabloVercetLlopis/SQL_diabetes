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
