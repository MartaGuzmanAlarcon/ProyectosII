% importar archivos de geometric vector: ERROR DE DIM VOLVER
%OJO: al importar coge 4 decimales y redondea el ultimo
data = readmatrix('/Users/martaguzman/3_Carrera/3S2/ProyectosII/ArchivosPrueba/ArchivostablasResultados/OpenSignalResultados_geometricMean_vector.csv');
resultados_geometricMean_vector = data(:, 1); 

% importar archivos de potencias:

data = readmatrix('/Users/martaguzman/3_Carrera/3S2/ProyectosII/ArchivosPrueba/ArchivostablasResultados/OpenSignalResultados_potencias.csv');
%%OJO: Remove the last element from each column
% Remove the last element from each column -> los reultados de las ventanas
% de power tenia una ventana mas que geometricMean_vector -> quitado el
% ultimo valor de resultados_potenciax,resultados_potenciay,resultados_potenciaz, resultados_potenciaxyz, para q tenga la misma dimension que  
resultados_potenciax = data(1:end-1, 1); 
resultados_potenciay = data(1:end-1, 2); 
resultados_potenciaz = data(1:end-1, 3); 
resultados_potenciaxyz = data(1:end-1,4);

% Calculate correlations
corr_mSQI_px = corr(resultados_geometricMean_vector, resultados_potenciax);
corr_mSQI_py = corr(resultados_geometricMean_vector, resultados_potenciay);
corr_mSQI_pz = corr(resultados_geometricMean_vector, resultados_potenciaz);
corr_mSQI_pxyz = corr(resultados_geometricMean_vector, resultados_potenciaxyz);

% Guardar las correlaciones
correlations = [corr_mSQI_px;corr_mSQI_py;corr_mSQI_pz; corr_mSQI_pxyz];

% Definir los nombres de las correlaciones
columnas = {'corr_mSQI_px', 'corr_mSQI_py', 'corr_mSQI_pz', 'corr_mSQI_pxyz'};

% Crear la tabla
tabla_resultados = table(corr_mSQI_px, corr_mSQI_py, corr_mSQI_pz, corr_mSQI_pxyz, 'VariableNames', columnas);

% Definir el nombre del archivo CSV de salida
nombre_archivo = 'OpenSignal_correlation_results.csv';

% Escribir la tabla en el archivo CSV
writetable(tabla_resultados, nombre_archivo);

