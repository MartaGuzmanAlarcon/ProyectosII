% Frecuencia de muestreo original
frecuencia_original = 52;  % Hz

% Número de muestras por ventana de 10 segundos
muestras_por_ventana = round(frecuencia_original * 10);  % 520 muestras para 10 segundos a 52 Hz

% Lista de archivos IMU de prueba: Escaleras, Sentada, Tumbada
files_pruebaCortas = {'20240301_Escaleras_imu_stream.csv','20240301_Sentada_imu_stream.csv','20240301_Tumbada_imu_stream.csv'};

% Loop sobre cada archivo
for file_index = 1:numel(files_pruebaCortas)
    file_name = files_pruebaCortas{file_index};
    % Leer los datos
    data = readmatrix([file_name ]);

    % Extraer las columnas correspondientes a las aceleraciones x, y, z
    a_x = data(:, 2);
    a_y = data(:, 3);
    a_z = data(:, 4);

    % Aplicar filtro paso bajo a las lecturas del acelerómetro
    g_x = 0; g_y = 0; g_z = 0;
    for i = 1:length(a_x)
        g_x = 0.9 * g_x + 0.1 * a_x(i);
        a_x(i) = a_x(i) - g_x;

        g_y = 0.9 * g_y + 0.1 * a_y(i);
        a_y(i) = a_y(i) - g_y;

        g_z = 0.9 * g_z + 0.1 * a_z(i);
        a_z(i) = a_z(i) - g_z;
    end

    % Extraer las columnas correspondientes al giroscopio x, y, z
    giroscopio_x = data(:, 5);
    giroscopio_y = data(:, 6);
    giroscopio_z = data(:, 7);

    % Inicializar matriz para almacenar los resultados
    resultados = zeros(floor(size(data, 1)/muestras_por_ventana), 8);

    % Calcular la potencia total para cada ventana de 10 segundos
    indice_resultados = 1;
    for i = 1 : muestras_por_ventana : (size(resultados, 1)*muestras_por_ventana)
        ventana_x = a_x(i : min(i + muestras_por_ventana - 1, size(data, 1)));
        ventana_y = a_y(i : min(i + muestras_por_ventana - 1, size(data, 1)));
        ventana_z = a_z(i : min(i + muestras_por_ventana - 1, size(data, 1)));

        ventana_gx = giroscopio_x(i : min(i + muestras_por_ventana - 1, size(data, 1)));
        ventana_gy = giroscopio_y(i : min(i + muestras_por_ventana - 1, size(data, 1)));
        ventana_gz = giroscopio_z(i : min(i + muestras_por_ventana - 1, size(data, 1)));

        potencia_x = mean(ventana_x.^2);
        potencia_y = mean(ventana_y.^2);
        potencia_z = mean(ventana_z.^2);

        potencia_gx = mean(ventana_gx.^2);
        potencia_gy = mean(ventana_gy.^2);
        potencia_gz = mean(ventana_gz.^2);

        potencia_total_xyz = potencia_x + potencia_y + potencia_z;
        potencia_total_gxgygz = potencia_gx + potencia_gy + potencia_gz;

        % Guardar resultados en la matriz
        resultados(indice_resultados, :) = [potencia_x, potencia_y, potencia_z, ...
            potencia_gx, potencia_gy, potencia_gz, potencia_total_xyz, potencia_total_gxgygz];

        indice_resultados = indice_resultados + 1;
    end

    % Nombre del archivo CSV de salida
    nombre_archivo = [file_name '_PotenciasMoveSense.csv'];

    % Crear una tabla con nombres de columnas
    columnas = {'potencia_x', 'potencia_y', 'potencia_z', ...
                'potencia_gx', 'potencia_gy', 'potencia_gz', ...
                'potencia_total_xyz', 'potencias_totales_gxgygz'};
    tabla_resultados = array2table(resultados, 'VariableNames', columnas);

    % Escribir en el archivo CSV
    writetable(tabla_resultados, nombre_archivo);
end
