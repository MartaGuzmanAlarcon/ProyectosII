% Frecuencia de muestreo original
frecuencia_original = 1000;  % Hz

% Número de muestras por ventana de 10 segundos
muestras_por_ventana = round(frecuencia_original * 10); % 10000 Hz

% Nombres de los archivos de prueba: Escaleras, Sentada, Tumbada
file1 = 'opensignals_Escaleras_22-58-24.txt';
file2 = 'opensignals_Sentada_22-53-55.txt';
file3 = 'opensignals_tumbada_22-50-01.txt';

files_pruebaCortas_OpenSignal = {file1, file2, file3};

% Loop sobre cada archivo
for file_index = 1:numel(files_pruebaCortas_OpenSignal)
    file_name = files_pruebaCortas_OpenSignal{file_index};
    
    % Leer los datos del archivo actual usando readmatrix
    data = readmatrix(file_name);  % Suponiendo que los datos están en formato adecuado para la carga
    
    % Extraer las columnas correspondientes a las posiciones x, y, z
    posicion_x = data(:, 6);
    posicion_y = data(:, 5);
    posicion_z = data(:, 4);

    % Calcular las velocidades a partir de las posiciones (primera derivada)
    velocidad_x = diff(posicion_x);
    velocidad_y = diff(posicion_y);
    velocidad_z = diff(posicion_z);

    % Asumir un intervalo de tiempo constante (s)
    intervalo_tiempo = mean(diff(data(:, 1)));  

    % Calcular las aceleraciones a partir de las velocidades (segunda derivada)
    aceleracion_x = diff(velocidad_x) / intervalo_tiempo;
    aceleracion_y = diff(velocidad_y) / intervalo_tiempo;
    aceleracion_z = diff(velocidad_z) / intervalo_tiempo;

    % Inicializar variables para el filtro paso bajo
    g_x = 0;
    g_y = 0;
    g_z = 0;

    % Aplicar el filtro paso bajo a las lecturas del acelerómetro
    for i = 1:length(aceleracion_x)
        % Aplicar filtro paso bajo a la componente x
        g_x = 0.9 * g_x + 0.1 * aceleracion_x(i);
        aceleracion_x(i) = aceleracion_x(i) - g_x;

        % Aplicar filtro paso bajo a la componente y
        g_y = 0.9 * g_y + 0.1 * aceleracion_y(i);
        aceleracion_y(i) = aceleracion_y(i) - g_y;

        % Aplicar filtro paso bajo a la componente z
        g_z = 0.9 * g_z + 0.1 * aceleracion_z(i);
        aceleracion_z(i) = aceleracion_z(i) - g_z;
    end

    % Inicializar matrices para almacenar los resultados
    resultados = zeros(floor(length(aceleracion_x)/muestras_por_ventana), 4);

    % Calcular la potencia total para cada ventana de 10 segundos
    indice_resultados = 1;
    for i = 1 : muestras_por_ventana : length(aceleracion_x)
        ventana_x = aceleracion_x(i : min(i + muestras_por_ventana - 1, length(aceleracion_x)));
        ventana_y = aceleracion_y(i : min(i + muestras_por_ventana - 1, length(aceleracion_y)));
        ventana_z = aceleracion_z(i : min(i + muestras_por_ventana - 1, length(aceleracion_z)));

        potencia_x = mean(ventana_x.^2);
        potencia_y = mean(ventana_y.^2);
        potencia_z = mean(ventana_z.^2);

        potencia_total_xyz= potencia_x + potencia_y + potencia_z;

        % Guardar resultados en la matriz 
        resultados(indice_resultados, :) = [potencia_x, potencia_y, potencia_z, potencia_total_xyz];

        % Incrementar el índice de resultados
        indice_resultados = indice_resultados + 1;
    end

    % Nombre del archivo CSV de salida
    nombre_archivo = [file_name '_PotenciasOpenSignal.csv'];

    % Crear una tabla con nombres de columnas
    columnas = {'potencia_x', 'potencia_y', 'potencia_z', 'potencia_total_xyz'};
    tabla_resultados = array2table(resultados, 'VariableNames', columnas);

    % Escribir en el archivo CSV
    writetable(tabla_resultados, nombre_archivo);
end
