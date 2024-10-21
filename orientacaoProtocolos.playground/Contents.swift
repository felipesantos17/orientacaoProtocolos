import UIKit

enum ZooFood: String {
    case beef
    case chicken
    case fruits
    case vegetables
}

protocol StockZooFoodProtocol {
    var stockZooFood: [ZooFood: Int]  { get set }
    func addFoodToStock(typeFood: ZooFood, quantity: Int) async -> Int
    func getFoodFromStock(typeFood: ZooFood) async -> Int
}

class StockZooFood: StockZooFoodProtocol {
    var stockZooFood: [ZooFood: Int] = [:]
    
    func addFoodToStock(typeFood: ZooFood, quantity: Int) async -> Int {
        stockZooFood.updateValue(quantity, forKey: typeFood)
        guard let newQuantity = stockZooFood[typeFood]?.hashValue else {
            return 0
        }
        return newQuantity
    }
    
    func getFoodFromStock(typeFood: ZooFood) async -> Int {
        guard let quantityInStock = stockZooFood.first(where: { $0.key == typeFood }) else {
            return 0
        }
        return quantityInStock.value
    }
}

protocol AnimalProtocol {
    var name: String { get set }
    var age: Int { get set }
    var weight: Double { get set }
    var carnivore: Bool? { get set }
    func animalIsCarnivore(carnivore: Bool)
    func hasAlreadyBeenFed() -> Bool
}

class AnimalZoo: AnimalProtocol {
    var name: String
    var age: Int
    var weight: Double
    var carnivore: Bool?
    var wasFed: Bool? = false
    
    init(name: String, age: Int, weight: Double) {
        self.name = name
        self.age = age
        self.weight = weight
    }
    
    func animalIsCarnivore(carnivore: Bool) {
        self.carnivore = carnivore
    }
    
    func hasAlreadyBeenFed() -> Bool {
        wasFed ?? false
    }
}

protocol ZooProtocol {
    var animals: [AnimalZoo] { get }
    var stockFood: StockZooFood { get set }

    func addAnimalToZoo(_ animal: AnimalZoo)
    func seeAnimals() async -> [AnimalZoo]
}

class Zoo: ZooProtocol {
    var animals: [AnimalZoo] = []
    var stockFood: StockZooFood
    
    init(stockFood: StockZooFood = StockZooFood()) {
        self.stockFood = stockFood
    }
    
    func addAnimalToZoo(_ animal: AnimalZoo) {
        animals.append(animal)
    }
    
    func seeAnimals() -> [AnimalZoo] {
        animals
    }
}

let lion: AnimalZoo = .init(name: "Lion", age: 3, weight: 50.2)
let crocodile: AnimalZoo = .init(name: "Crocodile", age: 10, weight: 150.9)
let zebra: AnimalZoo = .init(name: "Zebra", age: 7, weight: 97.6)
let ape: AnimalZoo = .init(name: "Ape", age: 19, weight: 39.7)

lion.animalIsCarnivore(carnivore: true)
crocodile.animalIsCarnivore(carnivore: true)

let zoo = Zoo()
zoo.addAnimalToZoo(lion)
zoo.addAnimalToZoo(crocodile)
zoo.addAnimalToZoo(zebra)
zoo.addAnimalToZoo(ape)

await zoo.stockFood.addFoodToStock(typeFood: .beef, quantity: 10)
await zoo.stockFood.addFoodToStock(typeFood: .fruits, quantity: 50)
await zoo.stockFood.addFoodToStock(typeFood: .chicken, quantity: 20)
await zoo.stockFood.addFoodToStock(typeFood: .vegetables, quantity: 30)

var beef = await zoo.stockFood.getFoodFromStock(typeFood: .beef)
var fruits = await zoo.stockFood.getFoodFromStock(typeFood: .fruits)
var chicken = await zoo.stockFood.getFoodFromStock(typeFood: .chicken)
var vegetables = await zoo.stockFood.getFoodFromStock(typeFood: .vegetables)

let animals = zoo.seeAnimals()
animals.forEach { print($0.wasFed ?? false) }

animals.forEach { animal in
    if !animal.hasAlreadyBeenFed() {
        if animal.carnivore ?? false {
            switch animal.name {
                case "Lion":
                    beef - 10
                case "Crocodile":
                    chicken - 10
                default:
                    break
            }
        } else {
            switch animal.name {
                case "Zebra":
                    vegetables - 10
                case "Ape":
                    fruits - 10
                default:
                    break
            }
        }
        animal.wasFed = true
    }
}

animals.forEach { print($0.wasFed ?? false) }
