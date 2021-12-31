# MapasDeGuatemalaEnR
K. Samanta Orellana, 28 de diciembre de 2021

Ejemplos para generar mapas de Guatemala en varios formatos, y cómo agregar puntos de ocurrencia de especies. El fin de este documento es facilitar el acceso a los códigos y las capas específicas para Guatemala. Pueden encontrar información mucho más detallada en las referencias a continuación.

### Construcción de mapas con ggplot2, sf y tidiverse
Algunas referencias: 
- https://reposhub.com/python/deep-learning/wtesto-SpeciesOccurrenceMapping.html
- https://r-spatial.org/r/2018/10/25/ggplot2-sf.html
- https://slcladal.github.io/maps.html

Capas descargadas de:
-DivaGis: https://www.diva-gis.org/gdata (divisiones administrativas: GTM_adm0.shp (país), GTM_adm1.shp (departamentos), GTM_adm2.shp (municipios))
-URL-IARNA: https://sie.url.edu.gt/capas-geograficas/ (SIGAP)

### Paquetes necesarios
Instalar paquetes

```
install.packages("tidyverse")
install.packages("sf")
install.packages("ggplot2)
install.packages("raster")
install.packages("rnaturalearth")
install.packages("sf")
install.packages("elevatr")
install.packages("dplyr")
install.packages("magrittr")
install.packages("ggspatial")
install.packages("ggplot2")
install.packages("ggpubr")
```

Instalar "rnaturalearthhires" desde github para que no de problemas

```
install.packages("githubinstall")
library(githubinstall)
githubinstall("rnaturalearthhires")
```

Cargar paquetes

```
library(tidyverse)
library(sf)
library(ggplot2)
library(raster) #for processing some spatial data
library(rnaturalearth) #for downloading shapefiles
library(sf) #for processing shapefiles
library(elevatr) #for downloading elevation data
library(dplyr) #to keep things tidy
library(magrittr) #to keep things very tidy
library(ggspatial) #for scale bars and arrows
library(ggplot2) #for tidy plotting
library(ggpubr) #for easy selection of symbols
library(rnaturalearthhires)
```

Cargar capas que van a construir el mapa de fondo con ggplot

```
world <- ne_countries(scale = "medium", returnclass = "sf") #Mundo, para construir los mapas
```

Cargar las capas del mapa que quieran ser utilizadas

```
map <- ne_countries(scale = 10, returnclass = "sf") #Mundo, para definir el área que se va a cortar
states <- ne_states(returnclass = "sf") 
ocean <- ne_download(scale = 10, type = 'ocean', 
  category = 'physical', returnclass = 'sf')
rivers <- ne_download(scale = 10, type = 'rivers_lake_centerlines', 
                    category = 'physical', returnclass = 'sf')
```

Para definir el área del mapa, en este caso, Guatemala

```
focalArea <- map %>% filter(admin == "Guatemala")
limit <- st_buffer(focalArea, dist = 1) %>% st_bbox()
clipLimit <- st_buffer(focalArea, dist = 2) %>% st_bbox()
limitExtent <- s(extent(clipLimit), 'SpatialPolygons')
crs(limitExtent) <- "+proj=longlat +datum=WGS84 +no_defs"
```

### Capas de Guatemala

-Descargar capa de departamentos en DivaGis (https://www.diva-gis.org/gdata) si no quiere usarse la capa de "states" que incluye todas las divisiones de los otros países.
-DivaGis: https://www.diva-gis.org/gdata
-URL-IARNA:https://sie.url.edu.gt/capas-geograficas/
-Guardar todos los archivos en el directorio que estemos usando

Abrir directorio donde guardamos y extrajimos las capas

```
setwd("C://Coding")
```

Cargar capas de Guatemala

```
gua_pais <- st_read("GTM_adm0.shp")
gua_dep <- st_read("GTM_adm1.shp")
gua_mun <- st_read("GTM_adm2.shp")
gua_rios <- st_read("GTM_water_lines_dcw.shp")
gua_lagos <- st_read("GTM_water_areas_dcw.shp")
gua_sigap <- st_read("sigap_2019-gtm_corr-iarna.shp")
```

### Puntos de ocurrencia
Cargar el (los) archivo(s) con los puntos (especie -u otra variable-, lat, long)

Abrir directorio

```
setwd("C://Coding")
```

Añadir puntos con archivos .csv, con tres columnas: especie (o alguna otra variable), latitud y longitud

```
puntos <- read.csv("puntos.csv")
```

Revisar los nombres de las columnas

```
names(puntos)
```

## Mapa de Guatemala con las Áreas Protegidas delimitadas y puntos de ocurrencia 

Para este mapa uso:

```
gua_dep <- st_read("GTM_adm1.shp")
gua_sigap <- st_read("sigap_2019-gtm_corr-iarna.shp")
head(gua_sigap)
```

Para ver preliminarmente alguna de las capas cargadas
```
plot(gua_sigap)
```

Construir mapa

```
ggplot(data = world) +
  geom_sf(fill="white")+
geom_sf(data = ocean, color = "blue", size = 0.05, fill = "#add8e6") +
	geom_sf(data = focalArea, color = "black", size = 0.15,
          linetype = "solid", fill = "white", alpha = 0.5) +
	geom_sf(data=gua_dep, fill="white") +
	geom_sf(data=gua_sigap, aes(fill=PERIMETER), linetype="solid", colour="#067010", size=0.3, alpha=0.5) +
	scale_fill_gradient("Áreas Protegidas", low="green", high= "white", 
  na.value="transparent")+ 	
   	labs( x = "Longitud", y = "Latitud") +
  coord_sf(xlim = c(-92.5, -88.1), ylim = c(13.8, 18.1), expand = T) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()
```

## Mapa Áreas Protegidas con puntos incorporados

```
ggplot(data = world) +
  geom_sf(fill="white")+
geom_sf(data = ocean, color = "blue", size = 0.05, fill = "#add8e6") +
	geom_sf(data = focalArea, color = "black", size = 0.15,
          linetype = "solid", fill = "white", alpha = 0.5) +
	geom_sf(data=gua_dep, fill="white") +
	geom_sf(data=gua_sigap, aes(fill=PERIMETER), linetype="solid", colour="#067010", size=0.3, alpha=0.5) +
	scale_fill_gradient("Áreas Protegidas", low="green", high= "white", 
  na.value="transparent")+ 	
geom_point(data = puntos, aes(x=decimalLongitude, y = decimalLatitude, color=scientificName, pch=scientificName), cex = 3) + #esta es la línea donde van los puntos, nombrar adecuadamente las columnas de lon y lat
	 scale_color_manual(values=c("blue", "red", "orange"))+
 	labs( x = "Longitud", y = "Latitud") +
  coord_sf(xlim = c(-92.5, -88.1), ylim = c(13.8, 18.1), expand = T) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()

ggsave("AreasProtegidasPuntos.png")
ggsave("AreasProtegidasPuntos.pdf")
```


| <img src="https://github.com/ksorellana/MapasDeGuatemalaEnR/blob/main/mapas/AreasProtegidasGuatemala.jpg?raw=true" alt="Mapa AP" width="440" height="470"> <img src="https://github.com/ksorellana/MapasDeGuatemalaEnR/blob/main/mapas/AreasProtegidasPuntos.jpg?raw=true" alt="Mapa AP con puntos" width="440" height="470">| 
|:--:| 
|1. Mapa delimitando las Áreas Protegidas de Guatemala. 2. Puntos de ocurrencia agregados. Fuente de shape: IARNA.|


## Mapa de Guatemala con capa de altitud

Cargar capas de elevación

```
library(elevatr) #for downloading elevation data
elev<-get_elev_raster(locations = limitExtent, z = 6, override_size_check = T)
elevDF<-as.data.frame(elev, xy=TRUE)
colnames(elevDF)<-c("x", "y", "elevation")
elevDF[, 3][elevDF[, 3] < 1500] <- NA
```

Construir mapa

```
ggplot(data = world) +
  geom_sf(fill="white")+
geom_sf(data = ocean, color = "blue", size = 0.05, fill = "#add8e6") +
	geom_sf(data = focalArea, color = "black", size = 0.15,
          linetype = "solid", fill = "white", alpha = 0.5) +
	geom_sf(data=gua_dep, fill="white") +
	geom_tile(data = elevDF, aes(x=x, y=y, fill=elevation), alpha =0.5)+
  scale_fill_gradient("Altitud (m)", low="#a3a0a0", high= "#000000", 
                      na.value="transparent")+ 	
   	labs( x = "Longitud", y = "Latitud") +
  coord_sf(xlim = c(-92.5, -88.1), ylim = c(13.8, 18.1), expand = T) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()
```

```
ggsave("GuatemalaAltitud.png")
ggsave("GuatemalaAltitud.pdf")
```

## Mapa de Guatemala con capa de altitud y puntos incorporados

```
ggplot(data = world) +
  geom_sf(fill="white")+
	geom_sf(data = ocean, color = "blue", size = 0.05, fill = "#add8e6") +
	geom_sf(data = focalArea, color = "black", size = 0.15,
          linetype = "solid", fill = "white", alpha = 0.5) +
	geom_sf(data=gua_dep, fill="white") +
	geom_tile(data = elevDF, aes(x=x, y=y, fill=elevation), alpha =0.5)+
  scale_fill_gradient("Altitud (m)", low="#a3a0a0", high= "#000000", 
                      na.value="transparent")+ 	
		geom_point(data = puntos, aes(x=decimalLongitude, y = decimalLatitude, color=scientificName, pch=scientificName), cex = 3) + #esta es la línea donde van los puntos, nombrar adecuadamente las columnas de lon y lat
	 scale_color_manual(values=c("blue", "red", "orange"))+
 	labs( x = "Longitud", y = "Latitud") +
  coord_sf(xlim = c(-92.5, -88.1), ylim = c(13.8, 18.1), expand = T) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()
```

Para guardar

```  
ggsave("GuatemalaAltitudPuntos.png")
ggsave("GuatemalaAltitudPuntos.pdf")
```

| <img src="https://github.com/ksorellana/MapasDeGuatemalaEnR/blob/main/mapas/Mapa_Puntos_Elev_Verde.jpg?raw=true" alt="Mapa AP" width="490" height="400"> | 
|:--:| 
|Mapa de Guatemala con capa de altitud.|


## Mapa de Guatemala con departamentos y coloreado por número de especies

Cargar la capa que se va a usar para colorear, en este caso departamentos

```
setwd("C://Coding")
gua_dep <- st_read("GTM_adm1.shp")
```

Cargar el archivo .csv con las columnas de departamentos (NAME_1) y número de especies
Que la columna de depatamentos se llame igual y que todos los nombres coincidan

```
especies <- read_csv("puntos2.csv")
especies
names(especies)
```

Unir esta tabla al archivo del mapa (asegurarse que el nombre de las columnas a unir sean iguales (NAME_1 = NAME_1)
  
```
  gua_dep_esp <- gua_dep %>%
	left_join(especies)

```  
  	###Si las columnas tienen nombres distintos, se puede hacer esto, por ejemplo:
	#left_join(especies,
            #by = c("NAME_1" = "departamento"))
	
  
Para revisar la tabla obtenida

```
gua_dep_esp
names(gua_dep_esp)
```

Para generar el mapa

```
ggplot(data = world) +
  geom_sf(fill="white")+
	geom_sf(data = ocean, color = "blue", size = 0.05, fill = "#add8e6") +
	geom_sf(data = focalArea, color = "black", size = 0.15,
          linetype = "solid", fill = "white", alpha = 0.5) +
	geom_sf(data=gua_dep, fill="white") +
	geom_sf(data=gua_dep_esp, aes(fill=especies), linetype="solid", size=0.3) +
	scale_fill_gradient ("Total de especies", high = "green", low = "white") +
	 	labs( x = "Longitud", y = "Latitud") +
  coord_sf(xlim = c(-92.5, -88.1), ylim = c(13.8, 18.1), expand = T) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()
```

Para guardar

```
ggsave("GuatemalaDepartamentoEspecies.png")
ggsave("GuatemalaDepartamentoEspecies.pdf")
```

| <img src="https://github.com/ksorellana/MapasDeGuatemalaEnR/blob/main/mapas/Mapa_Gt.jpg?raw=true" alt="Mapa AP" width="460" height="410"> | 
|:--:| 
|Mapa de Guatemala con departamentos coloreados por número de especies.|

## Mapa de Guatemala con departamentos y coloreado por número de especies y con puntos

```
ggplot(data = world) +
  geom_sf(fill="white")+
	geom_sf(data = ocean, color = "blue", size = 0.05, fill = "aliceblue") +
	geom_sf(data = focalArea, color = "black", size = 0.15,
          linetype = "solid", fill = "white", alpha = 0.5) +
	geom_sf(data=gua_dep, fill="white") +
	geom_sf(data=gua_dep_ant, aes(fill=especies), linetype="solid", size=0.3) +
	scale_fill_gradient ("Total de especies", high = "green", low = "white") +
geom_point(data = puntos, aes(x=decimalLongitude, y = decimalLatitude, color=scientificName, pch=scientificName), cex = 3) + #esta es la línea donde van los puntos, nombrar adecuadamente las columnas de lon y lat
	 scale_color_manual(values=c("black", "red", "blue"))+
	 	labs( x = "Longitud", y = "Latitud") +
  coord_sf(xlim = c(-92.5, -88.1), ylim = c(13.8, 18.1), expand = T) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()
```

Para guardar

```
ggsave("GuatemalaDepartamentoEspecies.png")
ggsave("GuatemalaDepartamentoEspecies.pdf")
```








