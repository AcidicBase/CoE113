`timescale 1ns/1ps
`define CLK_PD 10
`define DEL_IN 3

module tb_mem;
    reg clk;
    reg nrst;

    wire[31:0] wire_dout, wire_din, wire_addr;
    wire w_wr_en;

    wire done;

    fsm UUT(.clk(clk),
    .nrst(nrst),
    .wr_en(w_wr_en),
    .addr(wire_addr),
    .data_in(wire_din),
    .data_out(wire_dout),
    .done(done)
    );

    mem in(.clk(clk),
    .addr(wire_addr),
    .wr_en(w_wr_en),
    .data_in(wire_dout),
    .data_out(wire_din)
    );

    always 
        #(`CLK_PD/2.0) clk = ~clk;

    integer i;

    initial begin
        $vcdplusfile("tb_mem.vpd");
        $vcdpluson;

        /* Initialization */
        clk = 0;
	nrst = 0;
        #(`CLK_PD/2.0);
	nrst = 1;
	#(`CLK_PD/2.0);
        #(`DEL_IN);

        /* Display initial contents of memory */
        for (i=0;i<5;i=i+1) begin
            $display("%X%X%X%X",
            in.memory[(i*4)],
            in.memory[(i*4)+1],
            in.memory[(i*4)+2],
            in.memory[(i*4)+3]
            );
        end

        /* Start */
	while(!done) begin
		#(`CLK_PD/2.0);
	end
	for (i=0;i<5;i=i+1) begin
            $display("%X%X%X%X",
            in.memory[(i*4)],
            in.memory[(i*4)+1],
            in.memory[(i*4)+2],
            in.memory[(i*4)+3]
            );
        end
        $finish;
    end
endmodule
