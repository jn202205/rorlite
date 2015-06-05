require 'searchable'

describe 'Searchable' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Cat < SQLObject
      finalize!
    end

    class Human < SQLObject
      self.table_name = 'humans'

      finalize!
    end
  end

  describe '#where' do
    it 'searches with single criterion' do
      cats = Cat.where(name: 'Breakfast')
      cat = cats.first

      expect(cats.length).to eq(1)
      expect(cat.name).to eq('Breakfast')
    end

    it 'can return multiple objects' do
      humans = Human.where(house_id: 1)
      expect(humans.length).to eq(2)
    end

    it 'searches with multiple criteria' do
      humans = Human.where(fname: 'Matt', house_id: 1)
      expect(humans.length).to eq(1)

      human = humans[0]
      expect(human.fname).to eq('Matt')
      expect(human.house_id).to eq(1)
    end

    it 'returns [] if nothing matches the criteria' do
      expect(Human.where(fname: 'Nowhere', lname: 'Man')).to eq([])
    end
  end

  describe '#find_by' do
    it 'searches with single criterion' do
      cats = Cat.find_by(name: 'Breakfast')
      cat = cats.first

      expect(cats.length).to eq(1)
      expect(cat.name).to eq('Breakfast')
    end

    it 'can return multiple objects' do
      humans = Human.find_by(house_id: 1)
      expect(humans.length).to eq(2)
    end

    it 'searches with multiple criteria' do
      humans = Human.find_by(fname: 'Matt', house_id: 1)
      expect(humans.length).to eq(1)

      human = humans[0]
      expect(human.fname).to eq('Matt')
      expect(human.house_id).to eq(1)
    end

    it 'returns [] if nothing matches the criteria' do
      expect(Human.find_by(fname: 'Nowhere', lname: 'Man')).to eq([])
    end
  end
end
