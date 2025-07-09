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