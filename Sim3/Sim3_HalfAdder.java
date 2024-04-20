public class Sim3_HalfAdder {
    public void execute()
	{
        // sum is the same as XOR.
        // (A & ~B) | (~A & B).
        xor.a.set(a.get());
        xor.b.set(b.get());
        xor.execute();
        sum.set(xor.out.get());

        //carry is the same as A & B.
        and.a.set(a.get());
        and.b.set(b.get());
        and.execute();
        carry.set(and.out.get());
	}

    // inputs
	public RussWire a,b;
	// outputs
	public RussWire sum;
    public RussWire carry;
    // extras
    private XOR xor;
    private AND and;

    public Sim3_HalfAdder()
	{
		a   = new RussWire();
		b   = new RussWire();

		sum = new RussWire();
        carry = new RussWire();

		xor = new XOR();

        and = new AND();
	}
}
