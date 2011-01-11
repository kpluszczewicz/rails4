class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new

        # pelny dostep dla admina
        if user.role? :admin
            can :manage, :all
        else
            # odczyc jezeli mamy publiczba prezentacje lub mamy jak w subskrypcji
            can :read, Presentation do |presentation|
                presentation.try(:visible) == true
            end
            # pelen dostep jezeli jestemy autorem
            can :manage, Presentation do |presentation|
                presentation.try(:owner) == user
            end
            # tworzenie
            if not user.email.empty?
                can :create, Presentation
            end
        end
    end
end
