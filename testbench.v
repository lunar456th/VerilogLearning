`timescale 1ns/10ps
module WaveGenerator_tb();
	reg Clk, I;
	wire R, W;
	
	WaveGenerator WaveGenerator_1(Clk, I, R, W);
	
	initial
	begin
		Clk = 1'b0; I = 1'b1; 
		// R = 0, 0, 0, 1, 0, 0, 0, 1, ...
		// W = 0, 0, 1, 1, 0, 0, 1, 1, ...
	end
	
	always
	begin
		Clk = ~Clk; #250;
	end
endmodule

`timescale 1ns/10ps
module StateDiagram_2_tb();
	reg clk;
	reg in;
	wire [1:0] out;
	
	StateDiagram_2 StateDiagram_2_1(clk, in, out);
	
	initial
	begin
		clk = 1'b0;
		in = 1'b0; #250; // out = 2'b00;
		in = 1'b1; #250; // out = 2'b01;
		in = 1'b1; #250; // out = 2'b11;
		in = 1'b1; #250; // out = 2'b00;
		in = 1'b1; #250; // out = 2'b01;
		in = 1'b0; #250; // out = 2'b10;
		in = 1'b0; #250; // out = 2'b10;
		in = 1'b1; #250; // out = 2'b11;
		in = 1'b0; #250; // out = 2'b01;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module StateDiagram_1_tb();
	reg clk;
	reg in;
	wire [1:0] out;
	
	StateDiagram_1 StateDiagram_1_1(clk, in, out);
	
	initial
	begin
		clk = 1'b0;
		in = 1'b0; #250; // out = 2'b00;
		in = 1'b1; #250; // out = 2'b01;
		in = 1'b1; #250; // out = 2'b11;
		in = 1'b1; #250; // out = 2'b00;
		in = 1'b1; #250; // out = 2'b01;
		in = 1'b0; #250; // out = 2'b10;
		in = 1'b0; #250; // out = 2'b10;
		in = 1'b1; #250; // out = 2'b11;
		in = 1'b0; #250; // out = 2'b01;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module SequenceDetector101_tb();
	reg clk, in;
	wire out;
	
	SequenceDetector101 SequenceDetector101_1(clk, in, out);
	
	initial
	begin
		clk = 1'b0;
		in = 1'b0; #250; // out = 0;
		in = 1'b1; #250; // out = 0;
		in = 1'b1; #250; // out = 0;
		in = 1'b0; #250; // out = 0;
		in = 1'b0; #250; // out = 0;
		in = 1'b1; #250; // out = 0;
		in = 1'b0; #250; // out = 0;
		in = 1'b1; #250; // out = 1;
		in = 1'b1; #250; // out = 0;
		in = 1'b0; #250; // out = 0;
		in = 1'b1; #250; // out = 1;
		in = 1'b0; #250; // out = 0;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module TrafficSignalControllerFND_tb();
	reg clk, is_standby, is_test;
	wire [2:0] out;
	wire [6:0] FND3, FND2, FND1;
	wire FND3Sel2, FND3Sel1;
	wire FND2Sel2, FND2Sel1;
	wire FND1Sel2, FND1Sel1;
	
	TrafficSignalControllerFND TrafficSignalControllerFND_1(clk, is_standby, is_test, FND3, FND2, FND1, FND3Sel2, FND3Sel1, FND2Sel2, FND2Sel1, FND1Sel2, FND1Sel1);
	
	initial
	begin
		clk = 1'b0;
		is_standby = 1'b1; #250; // out = 3'b000
		is_standby = 1'b0; // count를 어떻게 처리해야 할지 모르겠는데, 000, 001, 010, 011, 100, 001, 010, ... 순으로 바뀜.	
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module TrafficSignalController_tb();
	reg clk, is_standby, is_test;
	wire [2:0] out;
	
	TrafficSignalController TrafficSignalController_1(clk, is_standby, is_test, out);
	
	initial
	begin
		clk = 1'b0;
		is_standby = 1'b1; #250; // out = 3'b000
		is_standby = 1'b0; // count를 어떻게 처리해야 할지 모르겠는데, 000, 001, 010, 011, 100, 001, 010, ... 순으로 바뀜.
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module SequenceDetector_tb();
	reg clk, reset, in;
	wire out;
	
	SequenceDetector SequenceDetector_1(clk, reset, in, out);
	
	initial
	begin
		clk = 1'b0; reset = 1'b1; reset = 1'b0;
		in = 1'b1; // state = 1, 2, 3, 3, 3, ...
		in = 1'b0; // state = 0
	end
	
	always
	begin
		clk = ~clk; #250;
	end
endmodule

`timescale 1ns/10ps
module BCDCounter2digit_tb();
	reg clk, reset;
	wire [6:0] FND;
	wire FNDSel2, FNDSel1;
	
	BCDCounter2digit BCDCounter2digit_1(clk, reset, FND, FNDSel2, FNDSel1);
	
	initial
	begin
		clk = 1'b0; reset = 1'b1; reset = 1'b0; // 두자리 FND에 대해서 값이 변화하는 것을 확인하면 됨.
	end
	
	always
	begin
		clk = ~clk;	#250;
	end
endmodule

`timescale 1ns/10ps
module AsymUpDownCounter_tb();
	reg clk, x, reset;
	wire [1:0] state;
	
	AsymUpDownCounter AsymUpDownCounter_1(clk, x, state, reset);
	
	initial
	begin
		clk = 1'b0;
		x = 1'b0; // state = 1, 3, 0, 1, 3, 0, ...
		reset = 1'b1; reset = 1'b0;
		x = 1'b1; // state = 3, 2, 0, 3, 2, 0, ...
	end
	
	always
	begin
		clk = ~clk; #250;
	end
endmodule

`timescale 1ns/10ps
module Mod3Counter_tb();
	reg clk;
	wire [1:0] state;
	
	Mod3Counter Mod3Counter_1(clk, state);
	
	initial
	begin
		clk = 1'b0;
		// state = 매 클럭마다 0, 1, 2, 3 순으로 바뀜;
	end
	
	always
	begin
		clk = ~clk; #250;
	end
endmodule

`timescale 1ns/10ps
module SyncBCDUpDownCounter_tb();
	reg clk, reset, updown;
	wire [3:0] count_out;
	wire [6:0] FND;
	wire FNDSel2, FNDSel1;
	
	SyncBCDUpDownCounter SyncBCDUpDownCounter_1(clk, reset, updown, count_out, FND, FNDSel2, FNDSel1);
	
	initial
	begin
		clk = 1'b0; reset = 1'b1; reset = 1'b0;
		updown = 1'b0; // FND가 	250ns마다 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 순으로 바뀜
		updown = 1'b1; // FND가 	250ns마다 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 순으로 바뀜
	end
	
	always
	begin
		clk = ~clk; #250;
	end
endmodule

`timescale 1ns/10ps
module UpDownCounter_tb();
	reg clk, reset, updown;
	reg [1:0] count_out;
	reg [6:0] FND;
	reg FNDSel2, FNDSel1;
	
	UpDownCounter UpDownCounter_1(clk, reset, updown, count_out, FND, FNDSel2, FNDSel1);
	
	initial
	begin
		clk = 1'b0; reset = 1'b1; reset = 1'b0;
		updown = 1'b0; // FND가 	250ns마다 1, 2, 3, 0 순으로 바뀜
		updown = 1'b1; // FND가 	250ns마다 3, 2, 1, 0 순으로 바뀜
	end
	
	always
	begin
		clk = ~clk; #250;
	end
endmodule

`timescale 1ns/10ps
module DLatch_tb();
	reg a, en;
	wire y;
	
	DLatch DLatch_1(a, en, y);
	
	initial
	begin
		en = 1'b1; a = 1'b0; // y = 0
		en = 1'b1; a = 1'b1; // y = 1 
		en = 1'b0; a = 1'b0; // y = 1
		en = 1'b0; a = 1'b1; // y = 1
	end
endmodule

`timescale 1ns/10ps
module DFlipFlop_tb();
	reg clk, d;
	wire q;
	
	DFlipFlop DFlipFlop_1(clk, d, q);
	
	initial
	begin
		clk = 1'b0;
		d = 1'b0; #250; // q = 0;
		d = 1'b1; #250; // q = 1;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module SerialParallelConverter_tb();
	parameter n = 8;
	reg clk, load;
	reg [n-1:0] p_in;
	wire s_out;
	
	SerialParallelConverter SerialParallelConverter_1(clk, load, p_in, s_out);
	
	initial
	begin
		clk = 1'b0;
		p_in = n'b10101010; load = 1'b0; load = 1'b1; load = 1'b0; // 매 클럭마다 1 0 1 0 1 0 1 0 출력
	end
	
	always
	begin
		clk = ~clk; #250;
	end
endmodule

`timescale 1ns/10ps
module RegisterInference_tb();
	reg clk, clr, pre, load, data, d;
	wire q1, q2;
	
	RegisterInference RegisterInference_1(clk, clr, pre, data, d, q1, q2);
	
	initial
	begin
		clk = 1'b0;
		clr = 1'b1; clr = 1'b0; #250; // q2 = 0
		pre = 1'b1; pre = 1'b0; #250; // q2 = 1
		data = 1'b0; load = 1'b0; load = 1'b1; #250; // q1 = 0
		data = 1'b1; load = 1'b0; load = 1'b1; #250; // q1 = 1
		d = 1'b0; load = 1'b0; #250; // q1 = 0;
		d = 1'b1; load = 1'b0; #250; // q1 = 1;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module StateMachine2state_tb();
	reg clk, x;
	wire y;

	StateMachine2state StateMachine2state_1(clk, x, y);
	
	initial
	begin
		x = 1'b0; #250; // 0
		x = 1'b1; #250; // 0
		x = 1'b0; #250; // 1
		x = 1'b1; #250; // 0
		x = 1'b1; #250; // 1
		x = 1'b1; #250; // 0
	end
	
	always
	begin
		clk = ~clk;
	end
endmdule

`timescale 1ns/10ps
module StateMachineMilli_tb();
	reg clk, reset, i0, i1, x;
	wire y;

	StateMachineMilli StateMachineMilli_1(clk, reset, i0, i1, x, y);
	
	initial
	begin
		clk = 1'b0;
		reset = 1'b0;
		i0 = 1'b0; i1 = 1'b0; x = 1'b0; #250; // 0000
		i0 = 1'b0; i1 = 1'b0; x = 1'b1; #250; // 0000
		i0 = 1'b0; i1 = 1'b1; x = 1'b0; #250; // 0000
		i0 = 1'b0; i1 = 1'b1; x = 1'b1; #250; // 0101
		i0 = 1'b1; i1 = 1'b0; x = 1'b0; #250; // 1111
		i0 = 1'b1; i1 = 1'b0; x = 1'b1; #250; // 1010
		i0 = 1'b1; i1 = 1'b1; x = 1'b0; #250; // 1111
		i0 = 1'b1; i1 = 1'b1; x = 1'b1; #250; // 1111
		reset = 1'b1;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module StateMachineMoore_tb();
	reg clk, reset, i0, i1, x;
	wire y;
	
	StateMachineMoore StateMachineMoore_1(clk, reset, i0, i1, x, y);
	
	initial
	begin
		clk = 1'b0;
		reset = 1'b0;
		i0 = 1'b0; i1 = 1'b0; x = 1'b0; #250; //지연을 이렇게 주는게 맞나? // 0000
		i0 = 1'b0; i1 = 1'b0; x = 1'b1; #250; // 0000
		i0 = 1'b0; i1 = 1'b1; x = 1'b0; #250; // 0000
		i0 = 1'b0; i1 = 1'b1; x = 1'b1; #250; // 0101
		i0 = 1'b1; i1 = 1'b0; x = 1'b0; #250; // 1111
		i0 = 1'b1; i1 = 1'b0; x = 1'b1; #250; // 1010
		i0 = 1'b1; i1 = 1'b1; x = 1'b0; #250; // 1111
		i0 = 1'b1; i1 = 1'b1; x = 1'b1; #250; // 1111
		reset = 1'b1;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module ClockDividingCircuit_tb();
	reg clk;
	wire outClk;
	
	ClockDividingCircuit ClockDividingCircuit_1(clk, outClk);
	
	initial
	begin
		clk = 1'b0;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module SimpleStateMachine_tb();
	reg clk, reset, i, m, n;
	wire y;
	
	SimpleStateMachine SimpleStateMachine_1(clk, reset, i, m, n, y);
	
	initial
	begin
		clk = 1'b0;
		i = 1'b0; #250;
		i = 1'b1; #250;
		i = 1'b0; #250;
		i = 1'b1; #250;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module CarryLookAheadBCDAdder_tb();
	reg [15:0] a, b;
	reg c_in;
	wire [15:0] s;
	wire c_out;
	
	CarryLookAheadBCDAdder CarryLookAheadBCDAdder_1(a, b, c_in, s, c_out);
	
	initial
	begin
		a = 16'b0000000000000001; b = 16'b0000000000000001; c = 1'b0; #250;
		a = 16'b0000000000000001; b = 16'b0000000000000001; c = 1'b1; #250;
		a = 16'b1000000000000000; b = 16'b1000000000000000; c = 1'b0; #250;
	end
endmodule

`timescale 1ns/10ps
module CarryLookAheadAdder_tb();
	reg [3:0] A, B;
	reg C_in;
	wire [3:0] S;
	wire C_out;
	
	CarryLookAheadAdder CarryLookAheadAdder_1(A, B, C_in, S, C_out);
	
	initial
	begin
		A = 4'b0001; B = 4'b0001; C_in = 1'b0; #250;
		A = 4'b0001; B = 4'b0001; C_in = 1'b1; #250;
		A = 4'b1000; B = 4'b1000; C_in = 1'b0; #250;
	end
endmodule

`timescale 1ns/10ps
module ParityGenerator_3_tb();
	parameter width = 8;
	reg [width-1:0] data_in;
	wire [width:0] parity_out;
	
	ParityGenerator_3 ParityGenerator_3_1(data_in, parity_out);
	
	initial
	begin
		data_in = width'b00000000; #250;
		data_in = width'b00000001; #250;
	end
endmodule

`timescale 1ns/10ps
module ParityGenerator_2_tb();
	parameter width = 8;
	reg [width-1:0] data_in;
	wire [width:0] parity_out;
	
	ParityGenerator_2 ParityGenerator_2_1(data_in, parity_out);
	
	initial
	begin
		data_in = width'b00000000; #250;
		data_in = width'b00000001; #250;
	end
endmodule

`timescale 1ns/10ps
module ParityGenerator_tb();
	parameter width = 8;
	reg [width-1:0] data_in;
	wire [width:0] parity_out;
	
	ParityGenerator ParityGenerator_1(data_in, parity_out);
	
	initial
	begin
		data_in = width'b00000000; #250;
		data_in = width'b00000001; #250;
	end
endmodule

`timescale 1ns/10ps
module LeadingCounter_tb();
	reg [7:0] d;
	wire [6:0] FND;
	wire FNDSel2, FNDSel1;
	
	LeadingCounter LeadingCounter_1(d, FND, FNDSel1, FNDSel2);
	
	initial
	begin
		d = 8'b00000000; #250;
		d = 8'b00000001; #250;
		d = 8'b00000010; #250;
		d = 8'b00000100; #250;
		d = 8'b00001000; #250;
		d = 8'b00010000; #250;
		d = 8'b00100000; #250;
		d = 8'b01000000; #250;
		d = 8'b10000000; #250;
	end
endmodule

`timescale 1ns/10ps
module OneCounter_tb();
	reg [7:0] d;
	wire [6:0] FND;
	wire FNDSel2, FNDSel1;
	
	OneCounter OneCounter_1(d, FND, FNDSel2, FNDSel1);
	
	initial
	begin
		d = 8'b00000000; #250;
		d = 8'b00000001; #250;
		d = 8'b00000011; #250;
		d = 8'b00000111; #250;
		d = 8'b00001111; #250;
		d = 8'b00011111; #250;
		d = 8'b00111111; #250;
		d = 8'b01111111; #250;
		d = 8'b11111111; #250;
	end
endmodule

`timescale 1ns/10ps
module BCDAdder_tb();
	parameter width = 4;
	reg [width-1:0] a, b;
	reg clk;
	wire FND;
	wire [1:0] FNDSel;
	
	BCDAdder BCDAdder_1(clk, a, b, FND, FNDSel);
	
	initial
	begin
		clk = 1;b0;
		a = width'b1;
		b = width'b1;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module nBitAddSub_2_tb();
	parameter width = 4;
	reg [width-1:0] a, b;
	reg clk, m;
	
	nBitAddSub_2 nBitAddSub_2_1(clk, a, b, m, FND2, FND1, FND2Sel, FND1Sel);
	
	initial
	begin
		clk = 1'b0;
		a = width'b1; b = width'b1; m = 1'b0; #250;
		a = width'b1; b = width'b1; m = 1'b1; #250;
	end
	
	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module nBitAddSub_1_tb();
	reg [width-1:0] a, b;
	reg m;
	wire [width+1:0] sum;
	
	nBitAddSub_1 nBitAddSub_1_1(a, b, m, sum);
	
	initial
	begin
		a = width'1; b = width'1; m = 1'b0; #250;
		a = width'1; b = width'1; m = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module Sorting_tb();
	parameter width = 4;
	reg [width-1:0] a, b;
	reg clk;
	wire FNDSel2, FNDSel1;
	wire [6:0] FND;

	Sorting Sorting_1(clk, a, b, FND, FNDSel2, FNDSel1);

	initial
	begin
		clk = 1'b0;
		a = width'b0; b = width'b0; #250;
		a = width'b0; b = width'b1; #250;
		a = width'b1; b = width'b0; #250;
	end

	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module Comparator_tb();
	parameter width = 4;
	reg [width-1:0] a, b;
	wire aLessb, aGreaterb, aEqualb;

	Comparator Comparator_1(a, b, aLessb, aGreaterb, aEqualb);

	initial
	begin
		a = width'b0; b = width'b0; #250;
		a = width'b0; b = width'b1; #250;
		a = width'b1; b = width'b0; #250;
	end
endmodule

`timescale 1ns/10ps
module Demultiplexer1x8_tb();
	reg i;
	reg [2:0] s;
	wire [7:0] y;

	Demultiplexer1x8 Demultiplexer1x8_1(s, i, y);

	initial
	begin
		i = 1'b1;
		s = 3'b000; #250;
		s = 3'b001; #250;
		s = 3'b010; #250;
		s = 3'b011; #250;
		s = 3'b100; #250;
		s = 3'b101; #250;
		s = 3'b110; #250;
		s = 3'b111; #250;
	end
endmodule

`timescale 1ns/10ps
module Multiplexer8x1_tb();
	reg [7:0] i;
	reg [2:0] s;
	wire y;

	Multiplexer8x1 Multiplexer8x1_1(s, i, y);

	initial
	begin
		i = 8'b10101010;
		s = 3'b000; #250;
		s = 3'b001; #250;
		s = 3'b010; #250;
		s = 3'b011; #250;
		s = 3'b100; #250;
		s = 3'b101; #250;
		s = 3'b110; #250;
		s = 3'b111; #250;
	end
endmodule

`timescale 1ns/10ps
module Demultiplexer_tb();
	reg [1:0] s;
	reg i;
	wire [3:0] y;

	Demultiplexer Demultiplexer1(s, i, y);

	initial
	begin
		i = 1'b1;
		s = 2'b00; #250;
		s = 2'b01; #250;
		s = 2'b10; #250;
		s = 2'b11; #250;
	end
endmodule

`timescale 1ns/10ps
module Multiplexer_tb();
	reg [1:0] s;
	reg [3:0] i;
	wire y;

	Multiplexer Multiplexer_1(s, i, y);

	initial
	begin
		i = 4'b1010;
		s = 2'b00; #250;
		s = 2'b01; #250;
		s = 2'b10; #250;
		s = 2'b11; #250;
	end
endmodule

`timescale 1ns/10ps
module SwitchEncoder_3_tb();
	reg clk;
	reg [3:0] a, b;
	wire [6:0] FND;

	SwitchEncoder_3 SwitchEncoder_3_1(clk, reset, a, b, FND);

	initial
	begin
		clk = 1'b0;
		a = 4'b0000; b = 4'b0000; #250;
		a = 4'b0001; b = 4'b0001; #250;
		a = 4'b0010; b = 4'b0010; #250;
		a = 4'b0011; b = 4'b0011; #250;
		a = 4'b0100; b = 4'b0100; #250;
		a = 4'b0101; b = 4'b0101; #250;
		a = 4'b0110; b = 4'b0110; #250;
		a = 4'b0111; b = 4'b0111; #250;
		a = 4'b1000; b = 4'b1000; #250;
		a = 4'b1001; b = 4'b1001; #250;
		a = 4'b1010; b = 4'b1010; #250;
		a = 4'b1011; b = 4'b1011; #250;
		a = 4'b1100; b = 4'b1100; #250;
		a = 4'b1101; b = 4'b1101; #250;
		a = 4'b1110; b = 4'b1110; #250;
		a = 4'b1111; b = 4'b1111; #250;
	end

	always
	begin
		clk = ~clk;
	end
endmodule


`timescale 1ns/10ps
module SwitchEncoder_2_tb();
	reg clk, reset;
	reg [15:0] key;
	wire [6:0] FND;
	wire [3:0] keyVal;

	SwitchEncoder_2 SwitchEncoder_2_1(clk, reset, key, keyVal, FND);

	initial
	begin
		clk = 1'b0;
		key = 16'0000000000000001; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000000010; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000000100; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000001000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000010000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000100000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000001000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000010000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000100000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000001000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000010000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000100000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0001000000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0010000000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0100000000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'1000000000000000; reset = 1'b0;  reset = 1'b1; #250;
	end

	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module SwitchEncoder_tb();
	reg clk, reset;
	reg [15:0] key;
	wire [3:0] keyVal;

	SwitchEncoder SwitchEncoder_1(clk, reset, key, keyVal);

	initial
	begin
		clk = 1'b0;
		key = 16'0000000000000001; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000000010; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000000100; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000001000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000010000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000000100000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000001000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000010000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000000100000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000001000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000010000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0000100000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0001000000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0010000000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'0100000000000000; reset = 1'b0;  reset = 1'b1; #250;
		key = 16'1000000000000000; reset = 1'b0;  reset = 1'b1; #250;
	end

	always
	begin
		clk = ~clk;
	end
endmodule

`timescale 1ns/10ps
module DecimalToBCDEncoder_tb();
	reg en;
	reg [9:0] d;
	wire a, v;

	DecimalToBCDEncoder DecimalToBCDEncoder_1(d, en, a, v);

	initial
	begin
		en = 1'b0; d = 10'b1111111111; #250;
		en = 1'b1; d = 10'b0000000001; #250;
		en = 1'b1; d = 10'b0000000010; #250;
		en = 1'b1; d = 10'b0000000100; #250;
		en = 1'b1; d = 10'b0000001000; #250;
		en = 1'b1; d = 10'b0000010000; #250;
		en = 1'b1; d = 10'b0000100000; #250;
		en = 1'b1; d = 10'b0001000000; #250;
		en = 1'b1; d = 10'b0010000000; #250;
		en = 1'b1; d = 10'b0100000000; #250;
		en = 1'b1; d = 10'b1000000000; #250;
		en = 1'b1; d = 10'b0000000000; #250;
	end
endmodule

`timescale 1ns/10ps
module PriorityEncoder8x3_tb();
	reg en;
	reg [7:0] d;
	wire a, v;

	PriorityEncoder8x3 PriorityEncoder8x3_1(d, en, a, v);

	initial
	begin
		en = 1'b0; d = 8'b11111111; #250;
		en = 1'b1; d = 8'b00000000; #250;
		en = 1'b1; d = 8'b00000001; #250;
		en = 1'b1; d = 8'b00000011; #250;
		en = 1'b1; d = 8'b00000111; #250;
		en = 1'b1; d = 8'b00001111; #250;
		en = 1'b1; d = 8'b00011111; #250;
		en = 1'b1; d = 8'b00111111; #250;
		en = 1'b1; d = 8'b01111111; #250;
		en = 1'b1; d = 8'b11111111; #250;
	end
endmodule

`timescale 1ns/10ps
module Decoder3x8_2_tb();
	reg en, x;
	wire D;

	Decoder3x8_2 Decoder3x8_2_1(x, D, en);

	initial
	begin
		en = 1'b0; x = 1'b1; #250;
		en = 1'b1; x = 1'b0; #250;
		en = 1'b1; x = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module Decoder3x8_tb();
	reg en, x;
	wire D;

	Decoder3x8 Decoder3x8_1(x, D, en);

	initial
	begin
		en = 1'b0; x = 1'b1; #250;
		en = 1'b1; x = 1'b0; #250;
		en = 1'b1; x = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module FullAdder3bit_2_tb();
	reg x, y, z;
	wire S, C;

	FullAdder3bit_2 FullAdder3bit_2_1(x, y, z, S, C);

	initial
	begin
		x = 1'b0; y = 1'b0; z = 1'b0; #250;
		x = 1'b0; y = 1'b0; z = 1'b1; #250;
		x = 1'b0; y = 1'b1; z = 1'b0; #250;
		x = 1'b0; y = 1'b1; z = 1'b1; #250;
		x = 1'b1; y = 1'b0; z = 1'b0; #250;
		x = 1'b1; y = 1'b0; z = 1'b1; #250;
		x = 1'b1; y = 1'b1; z = 1'b0; #250;
		x = 1'b1; y = 1'b1; z = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module FullAdder3bit_tb();
	reg x, y, z;
	wire S, C;

	FullAdder3bit FullAdder3bit_1(x, y, z, S, C);

	initial
	begin
		x = 1'b0; y = 1'b0; z = 1'b0; #250;
		x = 1'b0; y = 1'b0; z = 1'b1; #250;
		x = 1'b0; y = 1'b1; z = 1'b0; #250;
		x = 1'b0; y = 1'b1; z = 1'b1; #250;
		x = 1'b1; y = 1'b0; z = 1'b0; #250;
		x = 1'b1; y = 1'b0; z = 1'b1; #250;
		x = 1'b1; y = 1'b1; z = 1'b0; #250;
		x = 1'b1; y = 1'b1; z = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module main_4_tb();
	reg A, B, C, X, Y;
	wire Z;

	main_4 main_4_1(A, B, C, X, Y, Z);

	initial
	begin
		A = 1'b0; B = 1'b0; C = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; X = 1'b1; Y = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module main_3_tb();
	reg A, B, C;
	wire F1, F2;

	main_3 main_3_1(A, B, C, F1, F2);

	initial
	begin
		A = 1'b0; B = 1'b0; C = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module main_2_tb();
	reg A, B, C, W, X, Y;
	wire Z;

	main_2 main_2_1(A, B, C, W, X, Y, Z);

	initial
	begin
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b0; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b0; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b0; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b0; X = 1'b1; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b0; Y = 1'b1; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b0; #250;
		A = 1'b1; B = 1'b1; C = 1'b1; W = 1'b1; X = 1'b1; Y = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module main_tb();
	reg a, b;
	wire and_out, or_out, not_out;

	main main_1(a, b, and_out, or_out, not_out);

	initial
	begin
		a = 1'b0; b = 1'b0; #250;
		a = 1'b0; b = 1'b1; #250;
		a = 1'b1; b = 1'b0; #250;
		a = 1'b1; b = 1'b1; #250;
	end
endmodule

`timescale 1ns/10ps
module sub_tb();
	reg a, b, c, d;
	wire y;

	sub sub_1(a, b, c, d, y);

	initial
	begin
		a = 1'b0; b = 1'b0; c = 1'b0; d = 1'b0; #250;
		a = 1'b0; b = 1'b0; c = 1'b0; d = 1'b1; #250;
		a = 1'b0; b = 1'b0; c = 1'b1; d = 1'b0; #250;
		a = 1'b0; b = 1'b0; c = 1'b1; d = 1'b1; #250;
		a = 1'b0; b = 1'b1; c = 1'b0; d = 1'b0; #250;
		a = 1'b0; b = 1'b1; c = 1'b0; d = 1'b1; #250;
		a = 1'b0; b = 1'b1; c = 1'b1; d = 1'b0; #250;
		a = 1'b0; b = 1'b1; c = 1'b1; d = 1'b1; #250;
		a = 1'b1; b = 1'b0; c = 1'b0; d = 1'b0; #250;
		a = 1'b1; b = 1'b0; c = 1'b0; d = 1'b1; #250;
		a = 1'b1; b = 1'b0; c = 1'b1; d = 1'b0; #250;
		a = 1'b1; b = 1'b0; c = 1'b1; d = 1'b1; #250;
		a = 1'b1; b = 1'b1; c = 1'b0; d = 1'b0; #250;
		a = 1'b1; b = 1'b1; c = 1'b0; d = 1'b1; #250;
		a = 1'b1; b = 1'b1; c = 1'b1; d = 1'b0; #250;
		a = 1'b1; b = 1'b1; c = 1'b1; d = 1'b1; #250;
	end
endmodule