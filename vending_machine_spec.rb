require 'rspec/its'

require_relative 'vending_machine'


describe VendingMachine do

  it 'behavior' do
    machine = VendingMachine.new

    machine.store(Drink.cola, 5)
    expect(machine.stock_info).to eq({cola: {price: 120, stock: 5}})

    machine.store(Drink.redbull)
    machine.store(Drink.water)
    expect(machine.stock_info).to eq(
        {:cola=>{:price=>120, :stock=>5}, :redbull=>{:price=>200, :stock=>1}, :water=>{:price=>100, :stock=>1}})

    expect(machine.insert(1)).to eq 1
    expect(machine.insert(5)).to eq 5
    expect(machine.insert(10)).to be_nil
    expect(machine.insert(50)).to be_nil
    expect(machine.total).to eq 60
    expect(machine.refund).to eq 60
    expect(machine.total).to eq 0

    expect(machine.insert(100)).to be_nil
    expect(machine.total).to eq 100
    expect(machine.purchasable_drink_names).to eq [:water]
    expect(machine.purchasable?(:water)).to be true
    expect(machine.purchasable?(:cola)).to be false
    expect(machine.purchasable?(:redbull)).to be false
    expect(machine.purchase(:redbull)).to be_nil

    machine.insert 50
    expect(machine.purchasable_drink_names).to eq [:cola, :water]
    expect(machine.purchasable?(:cola)).to be true

    machine.insert 100
    expect(machine.purchasable_drink_names).to eq [:cola, :redbull, :water]
    expect(machine.purchasable?(:redbull)).to be true
    expect(machine.total).to eq 250
    expect(machine.purchase(:redbull)).to eq [Drink.redbull, 50]
    expect(machine.total).to eq 0
    expect(machine.refund).to eq 0
    expect(machine.sale_amount).to eq 200
    expect(machine.stock_info).to eq(
        {:cola=>{:price=>120, :stock=>5}, :redbull=>{:price=>200, :stock=>0}, :water=>{:price=>100, :stock=>1}})
  end
end
