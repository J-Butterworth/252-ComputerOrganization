public class Sim2_FullAdder {
    public void execute()
	{
		// Step 1: get halfAdder1 sum and carry of a,b.
        halfAdder1.a.set(a.get());
        halfAdder1.b.set(b.get());
        halfAdder1.execute();
        boolean halfSum1 = halfAdder1.sum.get();
        boolean halfCarry1 = halfAdder1.carry.get();

        // Step 2: get halfAdder2 sum and carry of carryIn and halfAdder1 sum.
        halfAdder2.a.set(carryIn.get());
        halfAdder2.b.set(halfSum1);
        halfAdder2.execute();
        boolean halfSum2 = halfAdder2.sum.get();
        boolean halfCarry2 = halfAdder2.carry.get();

        // Final sum of FullAdder will be the sum of halfAdder2.
        sum.set(halfSum2);
        
        // CarryOut of FullAdder will be the (halfAdder1 carry) | (halfAdder2 carry).
        or.a.set(halfCarry1);
        or.b.set(halfCarry2);
        or.execute();
        carryOut.set(or.out.get());
	}

    // inputs
	public RussWire a,b;
    public RussWire carryIn;
	// outputs
	public RussWire sum;
    public RussWire carryOut;
    // extras
    private Sim2_HalfAdder halfAdder1;
    private Sim2_HalfAdder halfAdder2;
    private OR or;

    public Sim2_FullAdder()
	{
		a   = new RussWire();
		b   = new RussWire();

		carryIn = new RussWire();
        sum = new RussWire();
        carryOut = new RussWire();

        halfAdder1 = new Sim2_HalfAdder();
        halfAdder2 = new Sim2_HalfAdder();

        or = new OR();
	}
}
