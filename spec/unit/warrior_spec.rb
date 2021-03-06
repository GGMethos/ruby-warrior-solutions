require "spec_helper"

class Warrior
  include WarriorMethods
  include EntityMethods
end

class Enemy
  include EntityMethods
end

describe "RubyWarrior" do
  before do
    @warrior = double(Warrior)
    @warrior.extend WarriorMethods
    @warrior.extend EntityMethods
    @warrior.extend TestOnlyMethods
    @warrior.health = @warrior.max_health = 20
  end

  describe Warrior do
    subject { @warrior }
    it { should respond_to(:walk!) }
    it { should respond_to(:attack!) }
    it { should respond_to(:feel) }
    it { should respond_to(:health) }
    it { should respond_to(:rest!) }

    context "resting" do
      context "when at full health" do
        it "should stay at full health" do
          @warrior.should_not_receive(:nap!)
          @warrior.rest!
        end
      end
      context "when wounded" do
        before do
          @warrior.wound
        end
        it "energy should be restored" do
          @warrior.should_receive(:nap!)
          @warrior.rest!
        end
      end
    end

    context "when facing nothing" do
      before do
        @space = double(Object).extend EntityMethods
        @space.stub(:empty?) { true }
        @warrior.ahead = @space
      end

      it "should walk" do
        if @warrior.feel.empty?
          @warrior.walk!
        end
      end
    end

    context "when facing an enemy" do
      before do
        @enemy = double(Enemy).extend(EntityMethods).extend(TestOnlyMethods)
        @enemy.health = @enemy.max_health = 20
        @warrior.ahead = @enemy
      end
      
      it "should be attacked" do
        @enemy.should_not be_wounded
        @warrior.attack!
        @enemy.should be_wounded
      end
    end
  end

end
