class Age {
    constructor() {}

    generator(max, min, media) {
        const taquicardiaca = Math.random() <= 0.2
        if (taquicardiaca) {
            return max + parseInt(Math.random() * 10)
        }
    
        const bradicardia = Math.random() <= 0.15
        if (bradicardia) {
            return min - parseInt(Math.random() * 8)
        }
    
        return media + parseInt(Math.random() * 40)
    }

    idadeMenor2Anos() {
        return this.generator(130, 80, 110)
    }
    
    idadeEntre2AnosE4Anos() {
        return this.generator(120, 80, 100)
    }
    
    idadeEntre4AnosE6Anos() {
        return this.generator(115, 75, 95)
    }
    
    idadeEntre6AnosE12Anos() {
        return this.generator(110, 70, 90)
    }
    
    idadeEntre12AnosE17Anos() {
        return this.generator(110, 60, 80)
    }
}

module.exports = Age