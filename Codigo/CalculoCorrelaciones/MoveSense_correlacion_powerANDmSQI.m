% correlacion entre geometricMean_vector y las potencias 
%hacer esto para x, y ,z y para las tres sumadas. Las cuatro señales que se calculan.

% importar archivos de geometric vector:
%OJO: al importar coge 4 decimales y redondea el ultimo
data = readmatrix('/Users/martaguzman/3_Carrera/3S2/ProyectosII/ArchivosPrueba/tablasResultados/MoveSenseResultados_geometricMean_vector.csv');
resultados_geometricMean_vector = data(:, 1); 

% importar archivos de potencias:

data = readmatrix('/Users/martaguzman/3_Carrera/3S2/ProyectosII/ArchivosPrueba/tablasResultados/MoveSenseResultados_potencias 10.20.51.csv');
m_resultados_potenciax = data(:, 1); 
m_resultados_potenciay = data(:, 2); 
m_resultados_potenciaz = data(:, 3); 
m_resultados_potenciaxyz = data(:, 7); 

% Calculate correlations
m_corr_mSQI_px = corr(resultados_geometricMean_vector, m_resultados_potenciax);
m_corr_mSQI_py = corr(resultados_geometricMean_vector, m_resultados_potenciay);
m_corr_mSQI_pz = corr(resultados_geometricMean_vector, m_resultados_potenciaz);
m_corr_mSQI_pxyz = corr(resultados_geometricMean_vector, m_resultados_potenciaxyz);% Guardar las correlaciones

% Guardar las correlaciones
correlations = [m_corr_mSQI_px; m_corr_mSQI_py; m_corr_mSQI_pz; m_corr_mSQI_pxyz];

% Definir los nombres de las correlaciones
columnas = {'corr_mSQI_px', 'corr_mSQI_py', 'corr_mSQI_pz', 'corr_mSQI_pxyz'};

% Crear la tabla
tabla_resultados = table(m_corr_mSQI_px, m_corr_mSQI_py, m_corr_mSQI_pz, m_corr_mSQI_pxyz, 'VariableNames', columnas);

% Definir el nombre del archivo CSV de salida
nombre_archivo = 'Movesense_correlation_results.csv';

% Escribir la tabla en el archivo CSV
writetable(tabla_resultados, nombre_archivo);

