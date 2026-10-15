import Foundation

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String
}

let culturas: [Cultura] = [
    Cultura(nombre: "Caral",
            region: "Lima (Valle de Supe)",
            descripcion: "Es la ciudad más antigua de América, con más de 5000 años. Tenía grandes pirámides y plazas.",
            imagen: "caral"),
    Cultura(nombre: "Chavín",
            region: "Áncash",
            descripcion: "Fue un centro religioso muy importante en los Andes. Su templo principal es Chavín de Huántar.",
            imagen: "chavin"),
    Cultura(nombre: "Paracas",
            region: "Ica",
            descripcion: "Es conocida por sus mantos bordados de colores y por sus momias.",
            imagen: "paracas"),
    Cultura(nombre: "Nazca",
            region: "Ica",
            descripcion: "Es famosa por las Líneas de Nazca, enormes dibujos en el desierto, y por su cerámica de colores.",
            imagen: "nazca"),
    Cultura(nombre: "Moche",
            region: "La Libertad y Lambayeque",
            descripcion: "Construyó grandes templos de adobe como la Huaca del Sol y la Luna. Hacía cerámica muy detallada.",
            imagen: "moche"),
    Cultura(nombre: "Inca",
            region: "Cusco",
            descripcion: "Fue el imperio más grande de América, el Tahuantinsuyo. Construyó Machu Picchu.",
            imagen: "inca")
]
