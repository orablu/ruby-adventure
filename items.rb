require "./abstracts"

class Herb < Item
    def initialize
        super("Herb",
              "A soothing herb. Cures minor burns.",
              50){ |e|
                  puts e.cure(:herb) ? "The burn is soothed from #{e.name}." : "It had no effect on #{e.name}."
              }
    end
end

class Antidote < Item
    def initialize
        super("Antidote",
              "A green vial. Cures minor poisons.",
              50){ |e|
                  puts e.cure(:antidote) ? "The poison leaves #{e.name}'s system." : "It had no effect on #{e.name}."
              }
    end
end

class Potion < Item
    def initialize(type = 'weak', strength = 5, cost = 20)
        super("#{type.proper} Potion",
              "A #{type} healing concoction. Heals #{strength} hp.",
              cost){ |e|
            e.heal(strength)
            puts "A restful feeling washes over #{e.name}."
        }
    end
end

class Crystal < Item
    def initialize(type = 'dull', strength = 5, cost = 35, onall: false)
        used = onall ?
            proc{|e| e.recover(strength); puts "#{e.name} focuses, regaining #{strength} energy."} :
            proc{|e, a| e.recover(strength, a); puts "#{e.name} focuses, #{a.name} regaining #{strength} energy."}
        super("#{type.proper} Crystal",
              "A #{type} focusing crystal. Heals #{onall ? 'all attacks' : 'one attack'} for #{strength} pp",
              cost, &used)
        @for = :None
    end

    def use_on(attack)
        @for = attack
    end
end

class FireBall < Item
    def initialize(type = 'small', damage = 6, cost = 60)
        @attack = Attack.new("#{type.proper} Explosion", "Creates an explosion.", :magical, damage){|e| puts "The #{e.name} launches!"}
        super("#{type.proper} Fire Ball",
              "A #{type} fire ball. Creates a #{type} explosion for #{damage} damage.",
              cost){ |e|
                  entity = Entity.new(@name, @description, attacks: [@attack]){
                      exit(-1) # Cannot target this entity
                  }
                  entity.attack e
              }
    end
end
class GrandFireBall < FireBall; def initialize; super 'grand', 12, 200; end; end

class LightningTome
    def initialize
        @attack = Attack.new('Lightning Strike', 'Strikes with lightning.', :magical, 10){|e| puts 'A bolt of lightning arcs down from the sky!'}
        used_up = proc{puts 'The tome fizzles away into nothingness.'}
        super('Lightning Tome',
              'A lightning tome. Deals 10 magic damage. May disappear after using.',
              350, 0.1, used_up: used_up){ |e|
                  entity = Entity.new(@name, @description, atacks: [@attack]){
                      exit(-1) # Cannot target this entity
                  }
                  entity.attack e
              }
    end
end
