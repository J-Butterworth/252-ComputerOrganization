public class Sim2_AdderX {
    public void execute()
	{   
        boolean carryIn = false;
        boolean tempCarryOut = false;
		for (int i=0; i<sum.length; i++){
            // Get the a,b,carryIn inputs for the fullAdder at index i.
            fullAdderArray[i].a.set(a[i].get());
            fullAdderArray[i].b.set(b[i].get());
            fullAdderArray[i].carryIn.set(carryIn);
            // Execute to get outputs.
            fullAdderArray[i].execute();
            // Update final sum array and output variables as necessary.
            // Be sure to update the current carryIn to the carryOut we got for next iteration.
            sum[i].set(fullAdderArray[i].sum.get());
            tempCarryOut = fullAdderArray[i].carryOut.get();
            carryIn = fullAdderArray[i].carryOut.get();
        }
        carryIn = fullAdderArray[sum.length-2].carryOut.get();
        // Set our official adderX carryOut to our last tempCarryOut iteration.
        carryOut.set(tempCarryOut);

        // Determining overflow. Use XOR between carryIn and carryOut.
        xor.a.set(carryIn);
        xor.b.set(carryOut.get());
        xor.execute();
        overflow.set(xor.out.get());
	}

    // inputs
	public RussWire[] a;
    public RussWire[] b;
	// outputs
    public RussWire[] sum;
	public RussWire carryOut;
    public RussWire overflow;
    // extras
    public Sim2_FullAdder[] fullAdderArray;
    private AND aSumAnd;
    private NOT aSumNot;
    private AND and;
    private NOT xorNot;
    private XOR xor;

    public Sim2_AdderX(int X)
	{
		a   = new RussWire[X];
		b   = new RussWire[X];
		
        sum = new RussWire[X];
        carryOut = new RussWire();
        overflow = new RussWire();

        fullAdderArray = new Sim2_FullAdder[X];
        xor = new XOR();
        xorNot = new NOT();
        aSumAnd = new AND();
        aSumNot = new NOT();
        and = new AND();

        for (int i=0; i<X; i++){
            a[i] = new RussWire();
            b[i] = new RussWire();
            sum[i] = new RussWire();
            fullAdderArray[i] = new Sim2_FullAdder();
        }

	}
}
