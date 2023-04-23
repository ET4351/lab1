/*##########################################################################
###
### Toplevel SoC Testbench
###
###     TU Delft ET4351
###     April 2023, C. Gao
###
##########################################################################*/
`include "macros.svh"
`timescale 1 ns / 1 ps

module testbench;
	// Local Parameters
	localparam clk_period = 5; // Clock cycle in ns
	localparam ser_half_period = 53;
	localparam freq_show_cycles = 50000;  // Number of clock cycles between each cycle count display

	// Generate clock
	reg clk;
	always #clk_period clk = (clk === 1'b0);

	// Generate resetn
	reg [1:0] reset_cnt = 0;
	wire resetn = &reset_cnt;
	always @(posedge clk) begin
		reset_cnt <= reset_cnt + !resetn;
	end

	// Clock Cycle Counter
	integer cnt_cycles = 0;
	always @(posedge clk) begin
		cnt_cycles <= cnt_cycles + 1;
	end

	// Start simulation
	integer file;  // File handle
	initial begin
		$display("##################################################");
		$display("# Start of Testbench 						        ");
		$display("##################################################");
		
		// $dumpfile("testbench.vcd");	// Create VCD file
		// $dumpvars(0, testbench);	// Dump all variables

		// Create a file store simulation outputs
		file = $fopen("outputs.txt", "w");

		// Run
		while (1) begin
			@(posedge clk);
			if (cnt_cycles % freq_show_cycles == 0) begin
				`ifdef DISPLAY_CYCLES
				$display("+%d cycles", cnt_cycles);
				`endif
			end
		end
	end

	wire ser_rx;
	wire ser_tx;

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire flash_io2;
	wire flash_io3;

	et4351 dut (
		.clk      (clk      ),
		.resetn   (resetn   ),
		.ser_rx   (ser_rx   ),
		.ser_tx   (ser_tx   ),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.flash_io2(flash_io2),
		.flash_io3(flash_io3)
	);
	
	spiflash spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(flash_io2),
		.io3(flash_io3)
	);

	reg [7:0] buffer_tx;

	always begin
		@(negedge ser_tx);

		// start bit
		repeat (ser_half_period) @(posedge clk);

		// data bit
		repeat (8) begin
			repeat (ser_half_period) @(posedge clk);
			repeat (ser_half_period) @(posedge clk);
			buffer_tx = {ser_tx, buffer_tx[7:1]};
		end

		// stop bit
		repeat (ser_half_period) @(posedge clk);
		repeat (ser_half_period) @(posedge clk);

		if (buffer_tx > 127) begin	// use any illegal ASCII code to stop simulation
			$display("Latency in Clock Cycles: %d", cnt_cycles);
			$fclose(file);
			$display("##################################################");
			$display("# End of Testbench 						        ");
			$display("##################################################");
			$finish;
		end else if (buffer_tx == 13 || buffer_tx == 10) begin	// CR or LF
			$write("\n");
			$fwrite(file, "\n");
		end else begin
			$write("%c", buffer_tx);
			$fwrite(file, "%c", buffer_tx);
		end
	end
	
endmodule
