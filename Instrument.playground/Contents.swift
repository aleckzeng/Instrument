// 1
class Piano: Instrument { //piano class inherits from instrument class (piano is the child class)
  let hasPedals: Bool
  // 2
  static let whiteKeys = 52
  static let blackKeys = 36
  
  // 3
  init(brand: String, hasPedals: Bool = false) {
    self.hasPedals = hasPedals
    // 4
    super.init(brand: brand) //super keyword to call parent class initializer
      //The super class initializer takes care of initializing inherited properties — in this case, brand. Can now access super class elements through this initilization.
  }
  
  // 5
  override func tune() -> String {
    return "Piano standard tuning for \(brand)."
  }
  
  /*
   override func play(_ music: Music) -> String {
    // 6
    let preparedNotes = super.play(music)
    return "Piano playing \(preparedNotes)"
  }
   */
    override func play(_ music: Music) -> String {
      return play(music, usingPedals: hasPedals)
    }
    func play(_ music: Music, usingPedals: Bool) -> String {
      let preparedNotes = super.play(music)
      if hasPedals && usingPedals {
        return "Play piano notes \(preparedNotes) with pedals."
      }
      else {
        return "Play piano notes \(preparedNotes) without pedals."
      }
    }
}

// 1
let piano = Piano(brand: "Yamaha", hasPedals: true)
piano.tune()
// 2
let music = Music(notes: ["C", "G", "F"])
piano.play(music, usingPedals: false)
// 3
piano.play(music)
// 4
Piano.whiteKeys
Piano.blackKeys

class Guitar: Instrument { //similar to Instrument Abstract class - methods need to be overriden in a subclass
  let stringGauge: String
  
  init(brand: String, stringGauge: String = "medium") {
    self.stringGauge = stringGauge
    super.init(brand: brand)
  }
}

class AcousticGuitar: Guitar {
  static let numberOfStrings = 6
  static let fretCount = 20
  
  override func tune() -> String {
    return "Tune \(brand) acoustic with E A D G B E"
  }
  
  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play folk tune on frets \(preparedNotes)."
  }
}

//My solution for challenge
/*let acousticguitar = AcousticGuitar(brand: "Roland")
acousticguitar.tune()
acousticguitar.play(music)
 */

let acousticGuitar = AcousticGuitar(brand: "Roland", stringGauge: "light")
acousticGuitar.tune()
acousticGuitar.play(music)

// 1
class Amplifier { //root class similar to instrument class
// private is extremely useful for hiding away complexity and protecting your class from invalid modifications
  // 2
  private var _volume: Int
    //can only be acccessed in the Ampliflier class, underscore in front of variable name is for convention
  // 3
  private(set) var isOn: Bool //private(set) can be read by outside users but not written to

  init() {
    isOn = false
    _volume = 0
  }

  // 4
  func plugIn() {
    isOn = true
  }

  func unplug() {
    isOn = false
  }

  // 5
  var volume: Int { //computed property to retreive and set other values indirectly
    // 6
    get { //has a getter
      return isOn ? _volume : 0 //conditional operator, inline if (iif), or ternary if
    }
    // 7
    set { //and an optional setter
      _volume = min(max(newValue, 0), 10)
    }
  }
}

// 1
class ElectricGuitar: Guitar { //derived from Guitar
  // 2
  let amplifier: Amplifier //composition, has-a relationship with an Amplifier
  
  // 3
  init(brand: String, stringGauge: String = "light", amplifier: Amplifier) { //custom initializer that initializes all of the stored properties and then calls the super class
    self.amplifier = amplifier
    super.init(brand: brand, stringGauge: stringGauge)
  }
  
  // 4
  override func tune() -> String {
    amplifier.plugIn()
    amplifier.volume = 5
    return "Tune \(brand) electric with E A D G B E"
  }
  
  // 5
  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play solo \(preparedNotes) at volume \(amplifier.volume)."
  }
}

class BassGuitar: Guitar {
  let amplifier: Amplifier //has-a relationship, composition

  init(brand: String, stringGauge: String = "heavy", amplifier: Amplifier) {
    self.amplifier = amplifier
    super.init(brand: brand, stringGauge: stringGauge)
  }

  override func tune() -> String {
    amplifier.plugIn()
    return "Tune \(brand) bass with E A D G"
  }

  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play bass line \(preparedNotes) at volume \(amplifier.volume)."
  }
}

//my solution
/*
var amplifier = Amplifier()
var gibson = ElectricGuitar(brand: "Gibson", amplifier: amplifier)
var fender = BassGuitar(brand: "Fender", amplifier: amplifier)
*/

let amplifier = Amplifier()
let electricGuitar = ElectricGuitar(brand: "Gibson", stringGauge: "medium", amplifier: amplifier)
electricGuitar.tune()

let bassGuitar = BassGuitar(brand: "Fender", stringGauge: "heavy", amplifier: amplifier)
bassGuitar.tune()

// Notice that because of class reference semantics, the amplifier is a shared
// resource between these two guitars.

bassGuitar.amplifier.volume
electricGuitar.amplifier.volume

bassGuitar.amplifier.unplug()
bassGuitar.amplifier.volume
electricGuitar.amplifier.volume

bassGuitar.amplifier.plugIn()
bassGuitar.amplifier.volume
electricGuitar.amplifier.volume
 
class Band { //polymorphism - something occurs in various different forms, objects of different types can access one another through same interface, passes through multiple is-a relationships
  let instruments: [Instrument]
  
  init(instruments: [Instrument]) {
    self.instruments = instruments
  }
  
  func perform(_ music: Music) {
    for instrument in instruments {
      instrument.perform(music)
    }
  }
}

/*You first define an instruments array from the Instrument class instances you’ve previously created. Then you declare the band object and configure its instruments property with the Band initializer. Finally you use the band instance’s perform(_:) method to make the band perform live music (print results of tuning and playing).
 Notice that although the instruments array’s type is [Instrument], each instrument performs accordingly depending on its class type.*/

let instruments = [piano, acousticGuitar, electricGuitar, bassGuitar]
let band = Band(instruments: instruments)
band.perform(music)




