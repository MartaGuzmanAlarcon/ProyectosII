
% Lista de archivos de ECG: Escaleras, Sentada, Tumbada
files_pruebaCortasECG = {'20240301_Escaleras_ecg_stream.csv','20240301 _Sentada_ecg_stream.csv','20240301_Tumbada_ecg_stream.csv'};


% Nombres de los archivos de prueba: Escaleras, Sentada, Tumbada
file1 = 'opensignals_Escaleras_22-58-24.txt';
file2 = 'opensignals_Sentada_22-53-55.txt';
file3 = 'opensignals_tumbada_22-50-01.txt';

files_pruebaCortas_OpenSignal = {file1, file2, file3};

% Loop sobre cada archivo
for file_index = 1:numel(files_pruebaCortas_OpenSignal)
    file_name = files_pruebaCortas_OpenSignal{file_index};
    
    % Leer los datos del archivo actual usando readmatrix
    data = readmatrix(file_name); 


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
nombre_archivo = [file_name '_mSQI_OpenSignal.csv'];

% Escribir la tabla en el archivo CSV
writetable(geometricMean_table, nombre_archivo);


end