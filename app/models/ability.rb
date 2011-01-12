class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new

        # pelny dostep dla admina
        if user.role? :admin
            can :manage, :all
        else
            # odczyc jezeli mamy publiczba prezentacje lub mamy jak w subskrypcji
            can :show, Presentation
            can :watch, Presentation
            can :run, Presentation do |presentation|
                if not presentation.nil?
                    presentation.visible == true || presentation.is_member?(user)
                else
                    false
                end
            end

            # pelen dostep jezeli jestemy autorem
            can :manage, Presentation do |presentation|
                presentation.try(:owner) == user
            end

            # tworzenie
            if not user.email.empty?
                can :create, Presentation
                can :subscribe, Presentation
                can :subscribe_create, Presentation
                can :subscribe_destroy, Presentation
            end
        end
    end
end
