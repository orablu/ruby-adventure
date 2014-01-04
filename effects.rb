require './abstracts'

class Burn < Effect
    def initialize(type, damage)
        super("#{type.proper }Burn",
              "A #{type} burn. The target takes #{damage} element damage every turn.", 
              :burn, :herb, damage){ |e|
            puts "#{e.name} has a #{type} burn!"
        }
    end
end

class Poison < Effect
    def initialize(type, damage)
        super("#{type.proper} Poison",
              "A #{type} poison. The target takes #{damage} element damage every turn.", 
              :poison, :antidote, damage){ |e|
            puts "#{e.name} is infected with a #{type} poison!"
        }
    end
end
