import Foundation

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String
    let significado: String
    let periodo: String
    let detalleRegion: String
}

let culturas: [Cultura] = [
    Cultura(nombre: "Caral",
            region: "Lima (Valle de Supe)",
            descripcion: "Caral es la ciudad más antigua de América. Tiene más de 5000 años y se construyó en el valle de Supe, en Lima, casi al mismo tiempo que las pirámides de Egipto. Sus habitantes vivían de la agricultura y la pesca, y construyeron grandes pirámides de piedra, plazas circulares y templos. En 2009 fue declarada Patrimonio Mundial por la UNESCO.",
            imagen: "caral",
            significado: "Su nombre viene del lugar donde se encuentra, el caserío de Caral, en el valle de Supe. También se le conoce como la civilización Caral-Supe.",
            periodo: "Entre los años 3000 y 1800 a. C. aproximadamente",
            detalleRegion: "Caral está en el valle de Supe, en la provincia de Barranca, al norte de Lima, a unos 180 kilómetros de la capital y cerca del mar. Es una zona desértica de la costa, pero el río Supe forma un valle verde donde se podía sembrar. Por eso vivía allí mucha gente que cultivaba algodón, frijoles, zapallo y otros productos."),
    Cultura(nombre: "Chavín",
            region: "Áncash",
            descripcion: "La cultura Chavín se desarrolló hace más de 3000 años en Áncash, en la sierra norte del Perú. Su centro principal fue Chavín de Huántar, un gran templo donde la gente llegaba de lugares lejanos a hacer ofrendas. Es famosa por su arte en piedra, con figuras de felinos, serpientes y aves. Chavín de Huántar fue declarado Patrimonio Mundial por la UNESCO en 1985.",
            imagen: "chavin",
            significado: "Se cree que el nombre Chavín viene del quechua 'chawpin', que significa 'centro' o 'lugar del medio', porque fue un centro religioso al que llegaban personas de muchas regiones.",
            periodo: "Entre los años 1200 y 200 a. C. aproximadamente",
            detalleRegion: "Chavín de Huántar está en la provincia de Huari, en la sierra de Áncash, a unos 3150 metros sobre el nivel del mar. Queda en la unión de los ríos Mosna y Huachecsa, en un valle entre la Cordillera Blanca y la Cordillera Negra. Su ubicación servía de punto de encuentro entre la costa, la sierra y la selva."),
    Cultura(nombre: "Paracas",
            region: "Ica",
            descripcion: "La cultura Paracas vivió hace más de 2000 años en la costa de Ica. Es conocida por sus mantos bordados de colores muy finos, usados para envolver a sus muertos. También hacían cerámica y practicaban operaciones en el cráneo. Gran parte de lo que sabemos viene de la necrópolis de Wari Kayan, descubierta por Julio C. Tello.",
            imagen: "paracas",
            significado: "Se dice que Paracas viene del quechua 'para-ako', que significa 'lluvia de arena', por los fuertes vientos que levantan arena en la zona.",
            periodo: "Entre los años 800 a. C. y 100 d. C. aproximadamente",
            detalleRegion: "Paracas está en la costa de Ica, al sur de Lima, entre el mar y el desierto. Allí se encuentra la península de Paracas y el cementerio de Wari Kayan, donde se hallaron los mantos. Hoy en esa zona está la Reserva Nacional de Paracas, un área protegida con lobos marinos, aves y pingüinos."),
    Cultura(nombre: "Nazca",
            region: "Ica",
            descripcion: "La cultura Nazca se desarrolló entre los años 100 a. C. y 800 d. C. en la costa sur de Ica. Dibujaron enormes figuras en el desierto, como el colibrí, el mono y la araña, que se ven mejor desde el aire. También hacían cerámica de muchos colores y construyeron acueductos subterráneos llamados puquios para llevar agua. Las Líneas y Geoglifos de Nasca son Patrimonio Mundial desde 1994.",
            imagen: "nazca",
            significado: "Su nombre viene del valle de Nasca, donde vivieron. Se cree que podría venir de una palabra quechua relacionada con 'dolor' o 'pena', pero no se sabe con seguridad.",
            periodo: "Entre los años 100 a. C. y 800 d. C. aproximadamente",
            detalleRegion: "Nazca está en la costa sur del Perú, en la región Ica, en un desierto muy seco que casi no recibe lluvia. Las Líneas están en la Pampa de Nazca, una llanura plana de unos 500 kilómetros cuadrados. El suelo seco y la poca cantidad de viento ayudaron a que los dibujos se conservaran por muchos siglos."),
    Cultura(nombre: "Moche",
            region: "La Libertad y Lambayeque",
            descripcion: "La cultura Moche se desarrolló entre los años 100 y 800 d. C. en la costa norte del Perú, en La Libertad y Lambayeque. Construyeron grandes templos de adobe, como la Huaca del Sol y la Huaca de la Luna, y fueron expertos en metalurgia y cerámica. Sus vasijas muestran con mucho detalle rostros, animales y escenas de su vida. En 1987 se descubrió la tumba del Señor de Sipán, una de las más importantes de América.",
            imagen: "moche",
            significado: "Su nombre viene del valle y del río Moche, en La Libertad, donde se encuentran sus principales centros. También se le llama cultura Mochica.",
            periodo: "Entre los años 100 y 800 d. C. aproximadamente",
            detalleRegion: "Los moches vivieron en los valles de la costa norte del Perú, en las actuales regiones de La Libertad y Lambayeque. Sus principales centros estaban cerca de la ciudad de Trujillo, donde están las Huacas del Sol y de la Luna, y en Sipán, en Lambayeque. Eran valles regados por ríos que bajan de los Andes, lo que les permitió tener una agricultura muy productiva."),
    Cultura(nombre: "Inca",
            region: "Cusco",
            descripcion: "Los incas formaron el imperio más grande de América, llamado Tahuantinsuyo, durante los siglos XV y XVI. Su capital fue Cusco y llegaron a gobernar desde Ecuador hasta Chile. Construyeron caminos, puentes, andenes de cultivo y ciudades como Machu Picchu. El imperio terminó con la llegada de los españoles, en 1532.",
            imagen: "inca",
            significado: "Inca era el título del gobernante, que significa 'rey' o 'señor' en quechua. Después se usó para nombrar a todo el pueblo. Tahuantinsuyo significa 'las cuatro regiones'.",
            periodo: "Siglos XV y XVI (hasta 1532)",
            detalleRegion: "El centro del imperio inca estaba en Cusco, en la sierra sur del Perú, a unos 3400 metros sobre el nivel del mar. Desde allí gobernaron un territorio enorme que llegaba hasta Ecuador, Bolivia, Chile y Argentina. Cusco significa 'ombligo' en quechua, porque se le consideraba el centro del mundo.")
]
