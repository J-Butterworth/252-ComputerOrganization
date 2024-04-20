public class Sim3_ALU {
    
    public void execute()
	{   
        for (int i=0; i<3; i++){
            elementArray[0].aluOp[i].set(aluOp[i].get());
        }
        elementArray[0].carryIn.set(bNegate.get());
        elementArray[0].a.set(a[0].get());
        elementArray[0].b.set(b[0].get());
        elementArray[0].bInvert.set(bNegate.get());
        elementArray[0].execute_pass1();
		for (int i=1; i<size; i++){
            for (int j=0; j<3; j++){
                elementArray[i].aluOp[j].set(aluOp[j].get());
            }
            elementArray[i].a.set(a[i].get());
            elementArray[i].b.set(b[i].get());
            elementArray[i].bInvert.set(bNegate.get());
            elementArray[i].carryIn.set(elementArray[i-1].carryOut.get());
            // Run Execute_Part1 on each individual ALUElement before iterating.
            elementArray[i].execute_pass1();
        }
        //Set the less value for the initial ALU element.
        elementArray[0].less.set(elementArray[size-1].addResult.get());
        // Assign the less values for every other ALU element.
        for (int i=1; i<size; i++){
            //elementArray[i].less.set(elementArray[i].addResult.get());
            elementArray[i].less.set(false);
        }
        // Run Execute_Part2 on every individual element, and assign its final result.
        for (int i=0; i<size; i++){
            elementArray[i].execute_pass2();
            result[i].set(elementArray[i].result.get());
        }

	}

    // inputs
	public RussWire[] a,b;
    public RussWire[] aluOp;
    public RussWire bNegate;
    public int size;
	// outputs
	public RussWire[] result;
    // extras
    public Sim3_ALUElement[] elementArray;

    public Sim3_ALU(int X)
	{   
        size = X;
        a = new RussWire[size];
        b = new RussWire[size];
        aluOp = new RussWire[3];
        bNegate = new RussWire();
        result = new RussWire[size];
        elementArray = new Sim3_ALUElement[size];

        for (int i=0; i<3; i++){
            aluOp[i] = new RussWire();
        }
		for (int i=0; i<size; i++){
            a[i] = new RussWire();
            b[i] = new RussWire();
            elementArray[i] = new Sim3_ALUElement();
            result[i] = new RussWire();
        }
	}
}
