require 'abstracts'

# Events: dodged(attack)
class Player < Entity
    attr_reader :level
    def initialize(name, hp, attacks: [], events: {})
        super(name, hp, 0.2, attacks: attacks[1], events: events)
        @level = 1
    end

    def levelup(hp = 3, attacks = nil)
        @level = @level + 1
        @mhp = @hp = @mhp + hp
        attacks.each{ |attack| @attacks << attack } if attacks
    end

    def attack(entity, i, &fail)
        if @attacks[i].use
            entity.hit_with @attacks[i]
        else
            @no_pp.call(@attacks[i])
        end
    end
end
