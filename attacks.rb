require './abstracts'

class Punch < Attack
    def initialize(type, damage)
        super("#{type.proper} Punch",
              "Throw a #{type} punch. Deals #{damage} physical damage.",
              :physical, 3){ |e|
                  puts "#{e.name} lets loose a #{type} punch."
              }
    end
end

class Sword < Attack
    def initialize(type, damage, durability)
        super("#{type.proper} Sword",
              "Strike with the #{type} sword. Deals #{damage} physical damage.",
              :physical, damage, durability, false){ |e|
                  puts "#{e.name} slashes forward with the #{type} sword."
              }
    end
end

class Fire < Attack
    def initialize(level, type, damage, pp)
        super("Fire #{level}",
              "A #{type.proper}. Deals #{damage} magic damage.",
              :magical, damage, pp){ |e|
                  puts "#{e.name} summons a #{type} from the abyss."
              }
    end
end
