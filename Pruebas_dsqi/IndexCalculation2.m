function [kSQI,sSQI, pSQI, cSQI, basSQI] = IndexCalculation2(data_s,qrs_vector,i)

      kSQI = kurtosis(data_s); %kurtosis
      sSQI = skewness(data_s); %skewness
      pSQI = relativePower(data_s); %relative power in QRS
      cSQI = variability_RR(qrs_vector,i,data_s); %variability in the R-R interval
      basSQI = baseline_drift(data_s); %relative power in the baseline
end 

function[rel_power] = relativePower(data)
     freqrange1 = [5,15];
     freqrange2 = [5,50];
     %%@TODO  necesitamos hacer el cálculo en milivoltios. Ver comentarios en
     %baseline_drift. aquí quizás no esté afectando tanto porque hay un
     %simple cociente que elimina el factor de escala.  Pero en otra
     %función  es esencial por el 1-p1
     data_v = (((data/2^16)-1/2)*3)/1019;
     data_mv = data_v*1000;
     p1 = bandpower(data_mv,330,freqrange1);
     p2 =  bandpower(data_mv,330,freqrange2);
     rel_power = p1/p2;

end

function[var_RR] = variability_RR(qrs_vector,i,data)
%@TODO nno es buena idea ejecutar Pamtomkins  para cada pequeño fragmento
%de señal.  Tiene un buffer  de inicialización. Ess decir, va a perder unos
%cuantos de los primeros latidos. Si lo hacemos así  y las ventanas son
%pocas vamos a tener  demasiados latidos perdidos. Habría que pasarle a
%IndexCalculation  el resultado de la detección de latidos de todo el
%registro, para que coja los latidos que le toca.
    window_len = 4*330;
    qrs_window = qrs_vector(i:i+30); %no se que índices poner aqui
    len = length(qrs_window);
    vector_RR= qrs_window(2:len)-qrs_window(1:(len-1));
    vector_RR_seconds = vector_RR/330;
    vector_RR_ms = vector_RR_seconds*1000;
    
    % %@TODO  los datos que obtenemos aquí sson muy diferentes a los rangos
    % indicados en el artículo porque nosotros estamos usando muestras de
    % la señal  como intervalos RR,, y no tiempo.  La verdad es que no me
    % queda claro si los intervalos deberían estar en milisegundos  o
    % segundos. Pero aquí ya es fácil cambiar  multiplicando por 1000.
    % Pero hay que pasar de muestras a segundos.
    %var_RR = std(vector_RR_seconds)/mean(vector_RR);
    var_RR = std(vector_RR_ms)/mean(vector_RR);
end


function[bas_power] = baseline_drift(data)
    freq1= [0,1];
    freq2 = [0,40];
    data_v1 = (((data/2^16)-1/2)*3)/1019;
    data_mv1 = data_v1*1000;
    p1 = bandpower(data_mv1,330,freq1);
    p2 = bandpower(data_mv1,330,freq2);
    %%@TODO  este índice sale negativo cuando debería ser positivo.  El problema es
    %que estamos usando  entteros comunidades arbitrarias para el cálculo
    %de la potencia en las bandas,  y no las   unidades reales
    %(milivoltios)  del electrocardiograma.
    bas_power = (1-p1)/p2;
end 
