
data = readmatrix('/Users/martaguzman/3_Carrera/3S2/ProyectosII/PruebasDistintosRegistros/opensignals_Escaleras_22-58-24.txt');

% Extraer las columnas correspondientes a las aceleraciones x, y, y z

ecg_opensignal = data(:, 3);% opensignal


n = length(ecg_opensignal);
indexes_escaleras = cell(1,n);

 [kSQI_01_vector,sSQI_01_vector, pSQI_01_vector,rel_powerLine01_vector, cSQI_01_vector, basSQI_01_vector,dSQI_01_vector,geometricMean_vector,averageGeometricMean] = mSQI(ecg_opensignal, 1000)

 
% Escribir el geometricMean_vector en un archivo de texto -> la usare luego para calcular la correlacion
% Convertir el vector en una tabla con el nombre de columna deseado
%aplico la traspuesta -> geometricMean_vector', para q el archivo tenga
%geometricMean_vector en formato columna
geometricMean_table = table(geometricMean_vector', 'VariableNames', {'geometricMean_vector'});

% Nombre del archivo CSV de salida
nombre_archivo = 'OpenSignalResultados_geometricMean_vector.csv';

% Escribir la tabla en el archivo CSV
writetable(geometricMean_table, nombre_archivo);


