#MAPAS DE GUATEMALA CON DISTINTAS HERRAMIENTAS Y DISE�OS
K. Samanta Orellana, 25 diciembre, 2021

#Referencia: https://slcladal.github.io/maps.html
#Schweinberger, Martin. 2021. Displaying Geo-Spatial Data with R. Brisbane: The University of Queensland. url: https://slcladal.github.io/maps.html (Version 2021.09.29).

#Instalar paquetes
install.packages("OpenStreetMap")
install.packages("DT")
install.packages("RColorBrewer")
install.packages("mapproj")
install.packages("sf")
install.packages("RgoogleMaps")
install.packages("scales")
install.packages("rworldmap")
install.packages("maps")
install.packages("tidyverse")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("rgeos")
install.packages("ggspatial")
install.packages("maptools")
install.packages("leaflet")
install.packages("sf")
install.packages("tmap")
install.packages("here")
install.packages("rgdal")
install.packages("scales")
install.packages("flextable")

library("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
remotes::install_github("rlesur/klippy")

#Especificar opciones
options(stringsAsFactors = F)         # no automatic data transformation
options("scipen" = 100, "digits" = 4) # suppress math annotation
op <- options(gvis.plot.tag='chart')  # set gViz options

# Cargar paquetes
library(OpenStreetMap)
library(DT)
library(RColorBrewer)
library(mapproj)
library(sf)
library(RgoogleMaps)
library(scales)
library(rworldmap)
library(maps)
library(tidyverse)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(ggspatial)
library(maptools)
library(leaflet)
library(sf)
library(tmap)
library(here)
library(rgdal)
library(scales)
library(flextable)
# activate klippy for copy-to-clipboard button
klippy::klippy()

#Hay diferentes tipos de mapas
#Generar mapa (relieve realista = nps)
GuatemalaMap <- openmap(c(18,-93),
    c(13,-88),
#   type = "osm",
#   type = "esri",
    type = "nps",
    minNumTiles=14)
# plot map
plot(GuatemalaMap)

##Generar mapa (como Open Street Map = osm)
GuatemalaMap2 <- openmap(c(18,-93),
    c(13,-88),
    type = "osm",
    minNumTiles=14)
#plot map
plot(GuatemalaMap2)

#Poner dos mapas a la par
par(mfrow = c(1, 2)) # display plots in 1 row/2 columns
plot(GuatemalaMap); plot(GuatemalaMap2); par(mfrow = c(1, 1)) # restore original settings

#MAPAS CON WORLD MAP

# load library
library(rworldmap)
#Generar mapa del mundo
worldmap <- getMap(resolution = "coarse")
# plot world map
plot(worldmap, col = "lightgrey", 
     fill = T, border = "darkgray",
     xlim = c(-180, 180), ylim = c(-90, 90),
     bg = "aliceblue",
     asp = 1, wrap=c(-180,180))

#Se puede personalizar
#Mapa de Guatemala fondo gris
worldmap <- getMap(resolution = "coarse")
# plot world map
plot(worldmap, col = "lightgrey", 
     fill = T, border = "darkgray",
     xlim = c(-94.15, -86.12), ylim = c(12.65, 18.97),
     bg = "aliceblue",
     asp = 1, wrap=c(-180,180))

#Mapa de Guatemala l�neas negras
library(maps)
# plot maps
# show map with Latitude 200 as center
maps::map('world', xlim = c(-94.15, -86.12), ylim = c(12.65, 18.97))
# add axes
maps::map.axes()