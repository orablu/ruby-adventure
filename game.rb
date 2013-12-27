require 'abstracts'
require 'player'

class Herb < Item
    def initialize
        super('Herb', 'A soothing herb. Cures burns.', 50){ |e|
            puts e.cure(:herb) ? "The burn is soothed from #{e.name}." : "It had no effect on #{e.name}."
        }
    end
end

class Potion < Item
    def initialize
        super('Concoction', 'A healing concoction. Heals 5hp.', 25){ |e|
            e.heal(5)
            puts "A restful feeling washes over #{e.name}."
        }
    end
end

class Crystal < Item
    def initialize
        super('Crystal', 'A focusing crystal. Heals an attack for 5pp', 35){ |e, a|
            e.recover(5, a)
            puts "#{e.name} focuses, regaining energy."
        }
        @for = :None
    end

    def use_on(attack)
        @for = attack
    end
end

class FireBall < Item
    ATTACK = Attack.new('Explosion', 'Create an explosion', :magical, 6){|e| puts "A #{e.name} launches!"}
    def initialize
        super('Fire Ball', 'Creates a fiery explosion for 6 damage.', 60){ |e|
            entity = Entity.new(@name, @description, attacks: [ATTACK]){ exit(-1) } # Cannot target this entity to dodge
            entity.attack(e)
        }
    end
end

class Burn < Effect
    def initialize(name, description, damage)
        super(name, description + '\nThe target takes damage every turn.', :burn, :herb, 1){ |e|
            puts "#{e.name} is burned!"
        }
    end
end

# name, description, type, power, pp, effects
Attacks = {
    :punch => Attack.new('Punch', 'Throw a punch', :physical, 3){|e| puts "#{e.name} lets loose a weak punch."},
    :sword => Attack.new('Sword', 'Strike with a sword', :physical, 4){|e| puts "#{e.name} slashes forward with a sword."},
    :fire1 => Attack.new('Fire I', 'A small flame', :magical, 5, 4){|e| puts "#{e.name} summons flames from the abyss."},
}

Events = {
    :dodged => proc{|a| puts "The #{a.name} missed!"},
}
