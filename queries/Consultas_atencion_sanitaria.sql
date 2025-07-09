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