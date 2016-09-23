#!/bin/bash

# Url para obtener nuevo token de facebook: https://developers.facebook.com/tools/explorer/145634995501895/
# Url para obtener nuevo token google: https://developers.google.com/+/web/api/rest/latest/activities/list#try-it
# (Para el caso de Google, haces una petición a la API con el explorer API, vas a networks, y coges el token que
# viene en el header Authorization: 'Bearer TOKEN')

# Antes de hacer una prueba nueva hay que hacer los siguientes pasos:
# - 	Hay que cambiar el token que está en FacebookWallLatency.html (carpeta Stable) y la variable FACEBOOK_TOKEN
# En GoogleplusLatency.html (Carpetas Accuracy, Latency, Stable) cambiar el valor de la variable access_token y la variable GOOGLE_TOKEN
FACEBOOK_TOKEN="EAANMUmJPs2UBAMihfYZAXEoOnaqxkigZCMQb9xewYQxhbUOmdjb7p25n6X8K301o1OzYxYDsHfGcqtBZBBcMuNEhZCpViFqV8ndvBgxZArsR9s78K4CKZCkE4cjCImJ6qjVSaqOG37TykZBEzqbKzfwmU8ZCYjv3b16NLss1QjV8iwZDZD"
GOOGLE_TOKEN="ya29.CjlZA16oU6ZNa3JEj5JTNG3I4_gj89sHFG0gjSD4O-7_XNTJ0z83CHV4-JCCh0HZBOyRR6ipFQ0Oi9Q"

# Comentar esta línea si los componentes están deplegados en remoto
python -m SimpleHTTPServer >> /dev/null &
PID=`echo $!`
echo $PID
# # Ejecutamos scripts para medir y recolectar los datos
#echo "##################################################################"
#echo "Realizando pruebas sobre el componente instagram-timeline..."
#python measureLatency.py instagram

# Esperamos un tiempo para asegurar que se recolectan los eventos de las distintas versiones
# y para intentar que las ejecuciones anteriores de componentes "no afecten" posteriores medidas
sleep 10
echo "##################################################################"
echo "Realizando pruebas sobre el componente github-events..."
python measureLatency.py github

sleep 10
echo "##################################################################"
echo "Realizando pruebas sobre el componente facebook-wall..."
python measureLatency.py facebook $FACEBOOK_TOKEN

#sleep 10
#echo "##################################################################"
#echo "Realizando pruebas sobre el componente googleplus-timeline..."
#python measureLatency.py googleplus $GOOGLE_TOKEN


sleep 10
echo "##################################################################"
echo "Recolectando y calculando métrica de latencia sobre los componentes probados..."
#python collectLatencyRecords.py instagram-timeline
python collectLatencyRecords.py github-events
python collectLatencyRecords.py facebook-wall
#python collectLatencyRecords.py googleplus-timeline
echo "Métricas calculadas"

# Matamos el proceso correspondiente al servidor local de componentes de python
kill -9 $PID