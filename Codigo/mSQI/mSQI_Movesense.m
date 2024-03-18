

% Lista de archivos de ECG: Escaleras, Sentada, Tumbada
files_pruebaCortasECG = {'20240301_Escaleras_ecg_stream.csv','20240301 _Sentada_ecg_stream.csv','20240301_Tumbada_ecg_stream.csv'};

for file_index = 1:numel(files_pruebaCortasECG)
    file_name = files_pruebaCortasECG{file_index};
    % Leer los datos
    ecg_data = readmatrix(file_name);
    ecg_movesense = ecg_data(:, 2); % Extraer las columnas correspondientes a las aceleraciones x, y, y z

n= length(ecg_movesense);
indexes_escaleras = cell(1,n);
[kSQI_01_vector,sSQI_01_vector, pSQI_01_vector,rel_powerLine01_vector, cSQI_01_vector, basSQI_01_vector,dSQI_01_vector,geometricMean_vector,averageGeometricMean] = mSQI(ecg_movesense, 125)

% Escribir el geometricMean_vector en un archivo de texto -> la usare luego para calcular la correlacion
% Convertir el vector en una tabla con el nombre de columna deseado
%aplico la traspuesta -> geometricMean_vector', para q el archivo tenga
%geometricMean_vector en formato columna
geometricMean_table = table(geometricMean_vector', 'VariableNames', {'geometricMean_vector'});

% Nombre del archivo CSV de salida
nombre_archivo = [file_name '_mSQI_MoveSense.csv'];

% Escribir la tabla en el archivo CSV
writetable(geometricMean_table, nombre_archivo);

end