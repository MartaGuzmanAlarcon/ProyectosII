% Frecuencia de muestreo original  
frecuencia_original = 52;  % Hz

% Número de muestras por ventana de 10 segundos
muestras_por_ventana = round(frecuencia_original * 10);  % 520 muestras para 10 segundos a 52 Hz

% Leer datos desde el archivo CSV 
data = readmatrix('imu_streamp1.csv');

% Extraer las columnas correspondientes a las aceleraciones x, y, y z
a_x = data(:, 2);
a_y = data(:, 3);
a_z = data(:, 4);

g_x = data(:, 5);
g_y = data(:, 6);
g_z = data(:, 7);

% Inicializar matrices para almacenar los resultados ->el 8 es xq son 9 var.
% variables (1,8)
resultados = zeros(floor(size(data, 1)/muestras_por_ventana), 8);

% Calcular la potencia total para cada ventana de 10 segundos
indice_resultados = 1;

% recorro todos los datos en incrementos de 520-> 520 muetsras por ventana de 10s
% a_x -> es un vector y representa la serie temporal de la componente x.
% min-> asegura que no se seleccionen más muestras de las que hay en los datos.

for i = 1 : muestras_por_ventana : size(data, 1)
    ventana_x = a_x(i : min(i + muestras_por_ventana - 1, size(data, 1)));
    ventana_y = a_y(i : min(i + muestras_por_ventana - 1, size(data, 1)));
    ventana_z = a_z(i : min(i + muestras_por_ventana - 1, size(data, 1)));

    ventana_gx = g_x(i : min(i + muestras_por_ventana - 1, size(data, 1)));
    ventana_gy = g_y(i : min(i + muestras_por_ventana - 1, size(data, 1)));
    ventana_gz = g_z(i : min(i + muestras_por_ventana - 1, size(data, 1)));

    potencia_x = mean(ventana_x.^2);
    potencia_y = mean(ventana_y.^2);
    potencia_z = mean(ventana_z.^2);

    potencia_gx = mean(ventana_gx.^2);
    potencia_gy = mean(ventana_gy.^2);
    potencia_gz = mean(ventana_gz.^2);

    potencia_total_xyz = potencia_x + potencia_y + potencia_z;
    potencias_totales_xyz = potencia_total_xyz;

    potencia_total_gxgygz = potencia_gx + potencia_gy + potencia_gz;
    potencias_totales_gxgygz = potencia_total_gxgygz;


    % Guardar resultados en la matriz 
    % Asigna los valores de las variables (potencia_x, potencia_y...) a la fila 1 de resultados 
    
    resultados(indice_resultados, :) = [potencia_x, potencia_y, potencia_z, potencia_gx, potencia_gy, potencia_gz, potencia_total_xyz, potencias_totales_gxgygz];

    % Incrementar el índice de resultados
    indice_resultados = indice_resultados + 1;
end

% Nombre del archivo CSV de salida
nombre_archivo = 'resultados_potencias.csv';

% Crear una tabla con nombres de columnas
columnas = {'potencia_x', 'potencia_y', 'potencia_z', 'potencia_gx', 'potencia_gy', 'potencia_gz', 'potencia_total_xyz', 'potencias_totales_gxgygz'};
tabla_resultados = array2table(resultados, 'VariableNames', columnas);

% Escribir en el archivo CSV
writetable(tabla_resultados, nombre_archivo);
