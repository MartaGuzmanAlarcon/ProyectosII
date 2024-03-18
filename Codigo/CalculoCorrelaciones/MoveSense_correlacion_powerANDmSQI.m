% Importar archivos de geometric vector:
% Importar archivos de POTENCIAS y archivos de GEOMETRIC VECTOR:
files_power = {'20240301_Escaleras_imu_stream.csv_PotenciasMoveSense.csv', ...
               '20240301_Sentada_imu_stream.csv_PotenciasMoveSense.csv', ...
               '20240301_Tumbada_imu_stream.csv_PotenciasMoveSense.csv'};

files_geomVector = {'20240301_Escaleras_ecg_stream.csv_mSQI_MoveSense.csv', ...
                    '20240301 _Sentada_ecg_stream.csv_mSQI_MoveSense.csv', ...
                    '20240301_Tumbada_ecg_stream.csv_mSQI_MoveSense.csv'};

% Loop sobre cada par de archivos (potencias y vector geométrico)
for i = 1:numel(files_power)
    file_name_power = files_power{i};
    file_name_geomVector = files_geomVector{i};
    
    % Leer los datos del archivo de potencia actual
    data_potencias = readmatrix(file_name_power);  
    m_resultados_potenciax = data_potencias(:, 1); 
    m_resultados_potenciay = data_potencias(:, 2); 
    m_resultados_potenciaz = data_potencias(:, 3); 
    m_resultados_potenciaxyz = data_potencias(:, 7); 
    
    % Leer los datos del archivo geométrico actual
    data_geometricMean_vector = readmatrix(file_name_geomVector);  
    resultados_geometricMean_vector = data_geometricMean_vector(:, 1); 

    % Calcular correlaciones
    m_corr_mSQI_px = corr(resultados_geometricMean_vector, m_resultados_potenciax);
    m_corr_mSQI_py = corr(resultados_geometricMean_vector, m_resultados_potenciay);
    m_corr_mSQI_pz = corr(resultados_geometricMean_vector, m_resultados_potenciaz);
    m_corr_mSQI_pxyz = corr(resultados_geometricMean_vector, m_resultados_potenciaxyz);

    % Guardar las correlaciones en una tabla
    columnas = {'corr_mSQI_px', 'corr_mSQI_py', 'corr_mSQI_pz', 'corr_mSQI_pxyz'};
    tabla_resultados = table(m_corr_mSQI_px, m_corr_mSQI_py, m_corr_mSQI_pz, m_corr_mSQI_pxyz, 'VariableNames', columnas);

        % Definir el nombre del archivo CSV de salida
        nombre_archivo = [file_name_power '_' file_name_geomVector '_CorrelacionesMoveSense.csv'];  

        % Escribir la tabla en el archivo CSV
        writetable(tabla_resultados, nombre_archivo);
    end

