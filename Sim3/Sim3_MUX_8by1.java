public class Sim3_MUX_8by1{
    public void execute()
	{
        // We know from truth table in class that idx == binary of 
        // the control inputs combined.

        // control[2] = A, control[1] = B, control[0] == C.
        // Need (!A & B) || (A & C).

        boolean a = control[2].get();
        boolean b = control[1].get();
        boolean c = control[0].get();

        // Get all AND gates.
        boolean and1 = (!a && !b && !c && in[0].get());
        boolean and2 = (!a && !b && c && in[1].get());
        boolean and3 = (!a && b && !c && in[2].get());
        boolean and4 = (!a && b && c && in[3].get());
        boolean and5 = (a && !b && !c && in[4].get());
        boolean and6 = (a && !b && c && in[5].get());
        boolean and7 = (a && b && !c && in[6].get());
        boolean and8 = (a && b && c && in[7].get());

        // Our output is going to be an OR gate btwn all AND gates.
        out.set(and1 || and2 || and3 || and4 ||
                and5 || and6 || and7 || and8);

	}


    // inputs
    public RussWire[] control;
    public RussWire[] in;
	// outputs
    public RussWire out;
    // extras

    public Sim3_MUX_8by1()
	{
		control = new RussWire[3];
		in = new RussWire[8];

        out = new RussWire();

        for (int i=0; i<3; i++){
            control[i] = new RussWire();
        }
        for (int i=0; i<8; i++){
            in[i] = new RussWire();
        }

	}
}