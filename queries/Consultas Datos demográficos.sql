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
