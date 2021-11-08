/**
   Objeto, mensaje, parámetros
 1 - Calcular el poder de daño de una embarcación
     embarcacion.poderDeDanio() : número
 2 - Obtener al tripulante más corajudo de la embarcación
     embarcacion.tripulanteMasCorajudo() : tripulante
 3 - Saber si dos embarcaciones pueden entrar en conflicto
     embarcacion.puedeEntrarEnConflictoCon(otraEmbarcacion) : Bool
 4.a - Dadas dos embarcaciones y una forma de contienda, saber si la primera puede tomar a la segunda o no
	 embarcacion.puedeTomar(otraEmbarcacion, tipoDeContienda) : Bool
     tipoDeContienda.puedeTomar(unaEmbarcacion, otraEmbarcacion) : Bool
 4.b - Dadas dos embarcaciones y una forma de contienda, realizar la toma

 5 - Generar un motín.

 */
 
class Embarcacion {
 	var property capitan
 	var property contramaestre
 	const tripulacionGeneral = #{}
 	const caniones = #{}
 	var property ubicacion
 	var property botin
 	
 	/** 1 */
 	method poderDeDanio() = self.poderDeDanioTripulacion() + self.poderDeDanioCaniones()
 	
 	method poderDeDanioTripulacion() = self.tripulacion().sum { tripulante => tripulante.coraje() }
 	
 	method tripulacion() = tripulacionGeneral.union( #{capitan, contramaestre} )
 	
 	method poderDeDanioCaniones() = caniones.sum { canion => canion.poderDeDanio() }
 	
 	/** 2 */
 	method tripulanteMasCorajudo() = tripulacionGeneral.max { tripulante => tripulante.coraje() }
 	
 	/** 3 */
 	method puedeEntrarEnConflictoCon(otraEmbarcacion) = 
 		ubicacion.estaEnDistanciaDeConflicto(otraEmbarcacion.ubicacion())
 		
 	method tieneHabilNegociador() = self.tripulacion().any { tripulante => tripulante.esHabilNegociador() }	 
 		
 	method aumentarCoraje(cantidad) {
 		self.tripulacion().forEach { tripulante => tripulante.aumentarCoraje(cantidad) }
 	}
 		
 	method matarCobardes(cantidad) {
 		tripulacionGeneral.removeAll(self.tripulantesMasCobardes(cantidad))
 	}
 	
 	method tripulantesMasCobardes(cantidad) = 
 		self.tripulantesPorCoraje().reverse().take(cantidad)
 		
 	method tripulantesPorCoraje() = tripulacionGeneral.sortedBy {a, b => a.corajeTotal() >= b.corajeTotal() }
 	
 	method promoverAContramaestre() {
 		contramaestre = self.tripulanteMasCorajudo()
 		//contramaestre = self.tripulantesPorCoraje().first()
 		tripulacionGeneral.remove(contramaestre)
 	}
}

class Ubicacion {
	const property oceano = ""
	const property coordenadas
	
	method estaEnDistanciaDeConflicto(otraUbicacion) = 
		oceano == otraUbicacion.oceano() and 
		self.distancia(otraUbicacion.coordenadas()) <= ubicacion.distanciaMaxima()
		
	method distancia(unasCoordenadas) =
		((coordenadas.x() - unasCoordenadas.x()).square() + 
		(coordenadas.y() - unasCoordenadas.y()).square()).squareRoot()
}

object ubicacion {
	var property distanciaMaxima
}
 
class Tripulante {
	var property corajeBase
	const armas = #{}
	const inteligencia
	
 	method coraje() = corajeBase + self.poderDeDanioArmas()
 	
 	method poderDeDanioArmas() = armas.sum { arma => arma.poderDeDanio() }
 	
 	method esHabilNegociador() = inteligencia > 50
}
 
/** arma.poderDeDanio() */ 

class Cuchillo {
	method poderDeDanio(pirata) = cuchillo.poderDeDanio(pirata)
}

object cuchillo {
	var property poder = 5
	
	method poderDeDanio(pirata) = poder
}

class Espada {
	const poderDeDanio
	
	method poderDeDanio(pirata) = poderDeDanio
}

class Pistola {
	const calibre
	const nombreDeMaterial
	
	method poderDeDanio(pirata) = calibre * material.indice(nombreDeMaterial)
}

object material {
	method indice(nombre) = 10 
}

class Insulto {
	const frase = "Mira, un mono de tres cabezas"
	
	method poderDeDanio(pirata) = frase.words().size() * pirata.corajeBase()
}

class Canion {
	const danioBase
	var edad = 0
	
	method poderDeDanio() = danioBase * (1 - edad / 100)
}

object canion {
	var property danioBase = 350
	
	/** 6 */
	method canionNuevo() = new Canion(danioBase = danioBase)
}

object batalla {
	/** 4.a */
	method puedeTomar(unaEmbarcacion, otraEmbarcacion) = 
		unaEmbarcacion.poderDeDanio() > otraEmbarcacion.poderDeDanio()
		
	/** 4.b */		
	method tomar(unaEmbarcacion, otraEmbarcacion) {
		unaEmbarcacion.aumentarCoraje(5)
		otraEmbarcacion.matarCobardes(3)
		otraEmbarcacion.capitan(unaEmbarcacion.contramaestre())
		unaEmbarcacion.promoverAContramaestre()
		unaEmbarcacion.enviarCorajudos(3, otraEmbarcacion)
	}
}
 
object negociacion {
	/** 4.a */
	method puedeTomar(unaEmbarcacion, otraEmbarcacion) =
		unaEmbarcacion.tieneHabilNegociador()
	
	/** 4.b */
	method tomar(unaEmbarcacion, otraEmbarcacion) {
		const botin = otraEmbarcacion.botin() / 2
		unaEmbarcacion.modificarBotin(botin)
		otraEmbarcacion.modificarBotin(-botin)
	}
}



 
 
 
 
 
 