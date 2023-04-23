 
/*##########################################################################
###
### Dummy accelerator module
###    
###     This is a dummy accelerator module that count from zero to
###     the value of the input data. It is used to demonstrate the use of
###     the accelerator interface.
###
###     TU Delft ET4351
###     April 2023, C.Gao, C. Frenkel
###
##########################################################################*/

/* Accelerator Memory Map
	iomem_accel[0] | 0x3000_0000: 32-bit General Purpose Input/Output (GPIO)
	iomem_accel[1] | 0x0300_0004: 32-bit Config & Status Register (CSR)
        --Bit [31:3] <xxxxxx>  : Undefined. You can use these bits for your own purposes.
        --Bit 2      <Status>  : Done Flag (Output Data Valid)      | 0 = No data, 1 = Data valid
        --Bit 1      <Config>  : Enable Accelerator (Active High)   | 0 = Disable, 1 = Enable
        --Bit 0      <Config>  : Reset Accelerator  (Active High)   | 0 = Assert,  1 = Release
	iomem_accel[2] | 0x0300_0008: 32-bit Input Data
	iomem_accel[3] | 0x0300_000C: 32-bit Output Data
*/

module accelerator (
	input  wire        clk,
	input  wire        resetn,
	input  wire        iomem_valid,
	output reg         iomem_ready,
	input  wire [ 3:0] iomem_wstrb,
	input  wire [31:0] iomem_addr,
	input  wire [31:0] iomem_wdata,
	output reg  [31:0] iomem_rdata
);  

    /*
     * Declare Local Parameters
     */
    localparam NUM_REGS = 4;  // Number of registers in the accelerator
	localparam NUM_REGS_WIDTH = $clog2(NUM_REGS);  // Number of bits required to address the registers

    /*
     * Declare internal signals
     */
	reg [31:0] iomem_accel [NUM_REGS-1:0];       // Accelerator Registers
    wire [NUM_REGS_WIDTH-1:0] iomem_accel_addr;  // Accelerator Register Address

	reg valid_out;
    wire resetn_accel;
    wire enable_accel;
    wire [31:0] count_dest;
    reg [31:0] counter;
    reg [31:0] result;
	integer i;

    /*
     * Memory Interface
     */
    assign iomem_accel_addr = iomem_addr >> 2;
	always @(posedge clk) begin
		if (!resetn) begin
			for (i = 0; i < 4; i = i + 1) iomem_accel[i] <= 0;
		end else begin
			iomem_ready <= 0;
			iomem_accel[1][2] <= valid_out; // Output Data Valid Flag
    		iomem_accel[3]    <= result; // Output Data (Change this for your own accelerator)
			if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 03) begin
				iomem_ready <= 1;
				iomem_rdata <= iomem_accel[iomem_accel_addr];
				if (iomem_wstrb[0]) iomem_accel[iomem_accel_addr][ 7: 0] <= iomem_wdata[ 7: 0];
				if (iomem_wstrb[1]) iomem_accel[iomem_accel_addr][15: 8] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) iomem_accel[iomem_accel_addr][23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) iomem_accel[iomem_accel_addr][31:24] <= iomem_wdata[31:24];
				// $display("iomem_addr = %h, iomem_accel_addr = %h, iomem_wdata = %h, iomem_wstrb = %h, iomem_rdata = %h, result = %h", 
				// 		 iomem_addr, iomem_accel_addr, iomem_wdata, iomem_wstrb, iomem_rdata, result);
			end
		end
	end

	/*
     * Space for your own accelerator code
     */
    assign reset_accel = iomem_accel[1][0];
    assign enable_accel = iomem_accel[1][1];
    assign count_dest = iomem_accel[2];
    always @(posedge clk) begin
        if (reset_accel) begin
            valid_out <= 0;
			result <= 0;
            counter <= 0;
        end else if (enable_accel) begin
            if (counter < count_dest) begin
                counter <= counter + 1;
            end
            if (counter == count_dest) begin
                result <= counter;
                valid_out <= 1;
            end
        end
    end

endmodule