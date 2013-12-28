require './abstracts'

class Burn < Effect
    def initialize(level, type, damage)
        super("Burn #{level}",
              "A #{type} burn. The target takes #{damage} element damage every turn.", 
              burn, :herb, 1){ |e|
            puts "#{e.name} has a #{type} burn!"
        }
    end
end
