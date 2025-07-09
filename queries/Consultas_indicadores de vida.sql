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
