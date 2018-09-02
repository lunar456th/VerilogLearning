module WaveGenerator(Clk, I, R, W);
	input Clk, I;
	output R, W;

	reg state;
	reg R, W;

	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter S3 = 2'b11;

	initial
	begin
		state = S0;
	end

	always @ (posedge Clk)
	begin
		case(state)
			S0 :
			begin
				if(I)
				begin
					state <= S1;
					R <= 1'b0;
					W <= 1'b0;
				end
			end
			S1 :
			begin
				if(I)
				begin
					state <= S2;
					R <= 1'b0;
					W <= 1'b0;
				end
			end
			S2 :
			begin
				if(I)
				begin
					state <= S3;
					R <= 1'b0;
					W <= 1'b1;
				end
			end
			S3 :
			begin
				if(I)
				begin
					state <= S0;
					R <= 1'b1;
					W <= 1'b1;
				end
			end
		endcase
	end
endmodule


module StateDiagram_2(clk, in, out);
	input clk;
	input in;
	output [1:0] out;

	reg [1:0] out;
	reg cur, next;

	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter S3 = 2'b11;

	always @ (posedge clk)
	begin
		cur <= next;
	end

	always @ (cur or in)
	begin
		case(cur)
			S0 :	if(in)  next <= S1;
					else	next <= S0;
			S1 :	if(in)  next <= S3;
					else	next <= S2;
			S2 :	if(in)  next <= S3;
					else	next <= S2;
			S3 :	if(in)  next <= S0;
					else	next <= S1;
		endcase
	end

	always @ (cur)
	begin
		case(cur)
			S0 : out <= 2'b00;
			S1 : out <= 2'b01;
			S2 : out <= 2'b10;
			S3 : out <= 2'b11;
		endcase
	end

endmodule


module StateDiagram_1(clk, in, out);
	input clk;
	input in;
	output [1:0] out;

	reg [1:0] out;
	reg [1:0] cur;
	reg [1:0] next;

	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter S3 = 2'b11;

	assign cur = next;
	
	assign out = cur;

	always @ (cur)
	begin
		case(cur)
			S0 :	if(in)  next <= S1;
					else	next <= S0;
			S1 :	if(in)  next <= S3;
					else	next <= S2;
			S2 :	if(in)  next <= S3;
					else	next <= S2;
			S3 :	if(in)  next <= S0;
					else	next <= S1;
		endcase
	end
endmodule


module SequenceDetector101(clk, in, out);
	input clk, in;
	output out;

	reg state, next_state;

	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter S3 = 2'b11;

	always @ (posedge clk)
	begin
		state <= next_state;
	end

	always @ (state)
	begin
		case(state)
			S0 :	if(in)  next_state <= S1;
			S1 :	if(~in) next_state <= S2;
			S2 :	if(in)  next_state <= S3;
		endcase
	end

	assign out = (state == S3);
endmodule


module TrafficSignalControllerFND(clk, is_standby, is_test, FND3, FND2, FND1, FND3Sel2, FND3Sel1, FND2Sel2, FND2Sel1, FND1Sel2, FND1Sel1);
	input clk, is_standby, is_test;
	output [2:0] out;
	output [6:0] FND3, FND2, FND1;
	output FND3Sel2, FND3Sel1;
	output FND2Sel2, FND2Sel1;
	output FND1Sel2, FND1Sel1;

	reg [5:0] state;
	reg sec;
	reg [6:0] FND3, FND2, FND1;
	reg FND3Sel2, FND3Sel1;
	reg FND2Sel2, FND2Sel1;
	reg FND1Sel2, FND1Sel1;
	reg [6:0] FNDVal3, FNDVal2, FNDVal1;
	reg [6:0] FNDVal6, FNDVal5, FNDVal4;

	integer index = 0;
	integer count = 0;
	integer time_normal [3:0];
	integer time_test   [3:0];

	// states
	parameter YY = 6'b010010;
	parameter RY = 6'b100010;
	parameter GR = 6'b001100;
	parameter YR = 6'b010100;
	parameter RG = 6'b100001;

	initial
	begin
		// time for normal
		time_normal[0] = 3;
		time_normal[1] = 15;
		time_normal[2] = 3;
		time_normal[3] = 10;

		// time for test
		time_normal[0] = 2;
		time_normal[1] = 2;
		time_normal[2] = 2;
		time_normal[3] = 2;
	end

	// standby mode on  -> YY
	// standby mode off -> RY
	always @ (is_standby)
	begin
		state <= (is_standby) ? YY : RY;
		count <= 0;
	end

	// set seconds to change state
	always @ (posedge clk)
	begin
		if(~is_test)
		begin
			if(count >= time_normal[index])
			begin
				sec <= ~sec;
				count <= 0;
				index <= (index + 1) % 4;
			end
			else
			begin
				count <= count + 1;
			end
		end
		else
		begin
			if(count >= time_normal[index])
			begin
				sec <= ~sec;
				count <= 0;
				index <= (index + 1) % 4;
			end
			else
			begin
				count <= count + 1;
			end
		end
	end

	// change state
	always @ (sec)
	begin
		case(state)
			YY :	if(is_standby)  state <= YY;
					else			state <= RY;
			RY :	if(is_standby)  state <= YY;
					else			state <= GR;
			GR :	if(is_standby)  state <= YY;
					else			state <= YR;
			YR :	if(is_standby)  state <= YY;
					else			state <= RG;
			RG :	if(is_standby)  state <= YY;
					else			state <= RY;
		endcase
	end

	// set 6 FNDVals
	always @ (state)
	begin
		case(state[2:0])
			3'b100 : begin
				FNDVal3 <= 7'b0110000;
				FNDVal2 <= 7'b0000000;
				FNDVal1 <= 7'b0000000;
			end
			3'b010 : begin
				FNDVal3 <= 7'b0000000;
				FNDVal2 <= 7'b0110000;
				FNDVal1 <= 7'b0000000;
			end
			3'b001 : begin
				FNDVal3 <= 7'b0000000;
				FNDVal2 <= 7'b0000000;
				FNDVal1 <= 7'b0110000;
			end
		endcase

		case(state[5:3])
			3'b100 : begin
				FNDVal6 <= 7'b0110000;
				FNDVal5 <= 7'b0000000;
				FNDVal4 <= 7'b0000000;
			end
			3'b010 : begin
				FNDVal6 <= 7'b0000000;
				FNDVal5 <= 7'b0110000;
				FNDVal4 <= 7'b0000000;
			end
			3'b001 : begin
				FNDVal6 <= 7'b0000000;
				FNDVal5 <= 7'b0000000;
				FNDVal4 <= 7'b0110000;
			end
		endcase
	end

	// display FND
	always @ (clk)
	begin
		if(~clk)
		begin
			FND3Sel2 <= 1'b1;
			FND3Sel1 <= 1'b0;
			FND2Sel2 <= 1'b1;
			FND2Sel1 <= 1'b0;
			FND1Sel2 <= 1'b1;
			FND1Sel1 <= 1'b0;
			FND3 <= FNDVal6;
			FND2 <= FNDVal4;
			FND1 <= FNDVal2;
		end
		else
		begin
			FND3Sel2 <= 1'b0;
			FND3Sel1 <= 1'b1;
			FND2Sel2 <= 1'b0;
			FND2Sel1 <= 1'b1;
			FND1Sel2 <= 1'b0;
			FND1Sel1 <= 1'b1;
			FND3 <= FNDVal5;
			FND2 <= FNDVal3;
			FND1 <= FNDVal1;
		end
	end
endmodule


module TrafficSignalController(clk, is_standby, is_test, out);
	input clk, is_standby, is_test;
	output [2:0] out;

	reg [2:0] state;
	reg sec;

	integer index = 0;
	integer count = 0;
	integer time_normal [3:0];
	integer time_test   [3:0];

	// states
	parameter YY = 3'b000;
	parameter RY = 3'b001;
	parameter GR = 3'b010;
	parameter YR = 3'b011;
	parameter RG = 3'b100;

	initial
	begin
		// time for normal
		time_normal[0] = 3;
		time_normal[1] = 15;
		time_normal[2] = 3;
		time_normal[3] = 10;

		// time for test
		time_normal[0] = 2;
		time_normal[1] = 2;
		time_normal[2] = 2;
		time_normal[3] = 2;
	end

	// standby mode on  -> YY
	// standby mode off -> RY
	always @ (is_standby)
	begin
		state <= (is_standby) ? YY : RY;
		count <= 0;
	end

	// get seconds to change state
	always @ (posedge clk)
	begin
		if(~is_test)
		begin
			if(count >= time_normal[index])
			begin
				sec <= ~sec;
				count <= 0;
				index <= (index + 1) % 4;
			end
			else
			begin
				count <= count + 1;
			end
		end
		else // ? ~is_test 와 is_test 가 동일하다?
		begin
			if(count >= time_normal[index])
			begin
				sec <= ~sec;
				count <= 0;
				index <= (index + 1) % 4;
			end
			else
			begin
				count <= count + 1;
			end
		end
	end

	// change state
	always @ (sec)
	begin
		case(state)
			YY :	if(is_standby)  state <= YY;
					else			state <= RY;
			RY :	if(is_standby)  state <= YY;
					else			state <= GR;
			GR :	if(is_standby)  state <= YY;
					else			state <= YR;
			YR :	if(is_standby)  state <= YY;
					else			state <= RG;
			RG :	if(is_standby)  state <= YY;
					else			state <= RY;
		endcase
	end

	// output
	assign out = state;

endmodule


module SequenceDetector(clk, reset, in, out);
	input clk, reset, in;
	output out;

	reg [1:0] state;

	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter S3 = 2'b11;

	always @ (posedge clk or negedge reset)
	begin
		if(~reset)
			state <= S0;
		else
			case(state)
				S0 :	if(in)  state <= S1;
						else	state <= S0;
				S1 :	if(in)  state <= S2;
						else	state <= S0;
				S2 :	if(in)  state <= S3;
						else	state <= S0;
				S3 :	if(in)  state <= S3;
						else	state <= S0;
			endcase
	end

	assign out = (state == S3);
endmodule


module BCDCounter2digit(clk, reset, FND, FNDSel2, FNDSel1);
	input clk, reset;
	output [6:0] FND;
	output FNDSel2, FNDSel1;

	reg [6:0] FND;
	reg FNDSel2, FNDSel1;
	reg FNDVal1, FNDVal0;

	wire clk_out[1:0];
	wire [3:0] count_out_0, count_out_1;

	SyncBCDUpDownCounter syncBCDUpDownCounter1(clk, reset, count_out_0, clk_out[0]);
	SyncBCDUpDownCounter syncBCDUpDownCounter2(clk_out[0], reset, count_out_1, clk_out[1]);

	always @ (count_out_0)
	begin
		case(count_out_0)
			4'b0000 : FNDVal0 <= 7'b1111110;
			4'b0001 : FNDVal0 <= 7'b0110000;
			4'b0010 : FNDVal0 <= 7'b1101101;
			4'b0011 : FNDVal0 <= 7'b1111001;
			4'b0100 : FNDVal0 <= 7'b0110011;
			4'b0101 : FNDVal0 <= 7'b1011011;
			4'b0110 : FNDVal0 <= 7'b1011111;
			4'b0111 : FNDVal0 <= 7'b1110010;
			4'b1000 : FNDVal0 <= 7'b1111111;
			4'b1001 : FNDVal0 <= 7'b1111011;
		endcase
	end

	always @ (count_out_1)
	begin
		case(count_out_1)
			4'b0000 : FNDVal1 <= 7'b1111110;
			4'b0001 : FNDVal1 <= 7'b0110000;
			4'b0010 : FNDVal1 <= 7'b1101101;
			4'b0011 : FNDVal1 <= 7'b1111001;
			4'b0100 : FNDVal1 <= 7'b0110011;
			4'b0101 : FNDVal1 <= 7'b1011011;
			4'b0110 : FNDVal1 <= 7'b1011111;
			4'b0111 : FNDVal1 <= 7'b1110010;
			4'b1000 : FNDVal1 <= 7'b1111111;
			4'b1001 : FNDVal1 <= 7'b1111011;
		endcase
	end

	always @ (posedge clk)
	begin
		if(clk)
		begin
			FNDSel2 <= 1'b0;
			FNDSel1 <= 1'b1;
			FND <= FNDVal0;
		end
		else
		begin
			FNDSel2 <= 1'b1;
			FNDSel1 <= 1'b0;
			FND <= FNDVal1;
		end
	end
endmodule

module SyncBCDUpDownCounter(clk, reset, count_out, clk_out);
	input clk, reset;
	output [3:0] count_out;
	output clk_out;

	reg state;
	reg [6:0] FND;

	parameter S0 = 4'b0000;
	parameter S1 = 4'b0001;
	parameter S2 = 4'b0010;
	parameter S3 = 4'b0011;
	parameter S4 = 4'b0100;
	parameter S5 = 4'b0101;
	parameter S6 = 4'b0110;
	parameter S7 = 4'b0111;
	parameter S8 = 4'b1000;
	parameter S9 = 4'b1001;

	always @ (posedge clk or negedge reset)
	begin
		if(~reset)
			state <= S0;
		else
		begin
			case(state)
				S0 : state <= S9;
				S1 : state <= S0;
				S2 : state <= S1;
				S3 : state <= S2;
				S4 : state <= S3;
				S5 : state <= S4;
				S6 : state <= S5;
				S7 : state <= S6;
				S8 : state <= S7;
				S9 : state <= S8;
			endcase
		end
	end

	always @ (state)
	begin
		case(state)
			S0 : FND <= 7'b1111110;
			S1 : FND <= 7'b0110000;
			S2 : FND <= 7'b1101101;
			S3 : FND <= 7'b1111001;
			S4 : FND <= 7'b0110011;
			S5 : FND <= 7'b1011011;
			S6 : FND <= 7'b1011111;
			S7 : FND <= 7'b1110010;
			S8 : FND <= 7'b1111111;
			S9 : FND <= 7'b1111011;
		endcase
	end

	assign count_out = state;
	assign clk_out = clk;
endmodule


module AsymUpDownCounter(clk, x, state, reset);
	input clk, x, reset;
	output [1:0] state;

	parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

	reg [1:0] state = S0;
	
	always @ (negedge reset)
	begin
		if(~reset)
			state = S0;
	end

	always @ (posedge clk)
	begin
		case(state)
			S0 :
				if(~x)  state <= S1;
				else	state <= S3;
			S1 :
				if(~x)  state <= S3;
				else	;
			S2 :
				if(~x)  ;
				else	state <= S0;
			S3 :
				if(~x)  state <= S0;
				else	state <= S2;
		endcase
	end
endmodule


module Mod3Counter(clk, state);
	input clk;
	output [1:0] state;

	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;

	reg state;
	
	initial
	begin
		state = 2'b00;
	end

	always @ (posedge clk)
	begin
		case(state)
			S0 : state <= S1;
			S1 : state <= S2;
			S2 : state <= S0;
		endcase
	end
endmodule


module SyncBCDUpDownCounter(clk, reset, updown, count_out, FND, FNDSel2, FNDSel1);
	input clk, reset, updown;
	output [3:0] count_out;
	output [6:0] FND;
	output FNDSel2, FNDSel1;

	reg state;
	reg [6:0] FND;

	wire FNDSel2 = 1'b1, FNDSel1 = 1'b0;

	parameter S0 = 4'b0000;
	parameter S1 = 4'b0001;
	parameter S2 = 4'b0010;
	parameter S3 = 4'b0011;
	parameter S4 = 4'b0100;
	parameter S5 = 4'b0101;
	parameter S6 = 4'b0110;
	parameter S7 = 4'b0111;
	parameter S8 = 4'b1000;
	parameter S9 = 4'b1001;

	always @ (posedge clk or negedge reset)
	begin
		if(~reset)
		begin
			state <= S0;
		end
		else
		begin
			case(state)
				S0:
					if(~updown) state <= S1;
					else		state <= S9;
				S1:
					if(~updown) state <= S2;
					else		state <= S0;
				S2:
					if(~updown) state <= S3;
					else		state <= S1;
				S3:
					if(~updown) state <= S4;
					else		state <= S2;
				S4:
					if(~updown) state <= S5;
					else		state <= S3;
				S5:
					if(~updown) state <= S6;
					else		state <= S4;
				S6:
					if(~updown) state <= S7;
					else		state <= S5;
				S7:
					if(~updown) state <= S8;
					else		state <= S6;
				S8:
					if(~updown) state <= S9;
					else		state <= S7;
				S9:
					if(~updown) state <= S0;
					else		state <= S8;
			endcase
		end
	end

	always @ (state)
	begin
		case(state)
			S0 : FND <= 7'b1111110;
			S1 : FND <= 7'b0110000;
			S2 : FND <= 7'b1101101;
			S3 : FND <= 7'b1111001;
			S4 : FND <= 7'b0110011;
			S5 : FND <= 7'b1011011;
			S6 : FND <= 7'b1011111;
			S7 : FND <= 7'b1110010;
			S8 : FND <= 7'b1111111;
			S9 : FND <= 7'b1111011;
		endcase
	end

	assign count_out = state;
endmodule


module UpDownCounter(clk, reset, updown, count_out, FND, FNDSel2, FNDSel1);
	input clk, reset, updown; // updown: 0 - up, 1 - down
	output [1:0] count_out;
	output [6:0] FND;
	output FNDSel2, FNDSel1;

	reg [6:0] FND;

	wire FNDSel2 = 1'b1, FNDSel1 = 1'b0;

	parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

	reg [1:0] state = S0;

	always @ (posedge clk or negedge reset)
	begin
		if(~reset)
			state <= S0;
		else
		begin
			case(state)
				S0 :
					if(~updown) state <= S1;
					else		state <= S3;
				S1 :
					if(~updown) state <= S2;
					else		state <= S0;
				S2 :
					if(~updown) state <= S3;
					else		state <= S1;
				S3 :
					if(~updown) state <= S0;
					else		state <= S2;
			endcase
		end
	end

	always @ (state)
	begin
		case(state)
			S0 : FND <= 7'b1111110;
			S1 : FND <= 7'b0110000;
			S2 : FND <= 7'b1101101;
			S3 : FND <= 7'b1111001;
		endcase
	end

	assign count_out = state;
endmodule


module DLatch(a, en, y);
	input a, en;
	output y;

	reg y;

	always @ (a)
	begin
		if(en)
		begin
			y <= a;
		end
	end
endmodule


module DFlipFlop(clk, d, q);
	input clk, d;
	output q;

	reg q;
	reg cur_state, next_state;

	always @ (posedge clk)
	begin
		cur_state <= next_state;
	end

	always @ (d)
	begin
		next_state <= d;
		q <= d;
	end
endmodule


module SerialParallelConverter(clk, load, p_in, s_out);
	parameter n = 8;
	input clk, load;
	input [n-1:0] p_in;
	output s_out;

	reg s_out;
	reg [n-1:0] reg1;

	always @ (posedge load)
	begin
		if(load)
		begin
			reg1 = p_in;
		end
	end

	always @ (posedge clk)
	begin
		if(~load)
		begin
			reg1 <= {reg1[n-2:0], 1'b0};
			s_out <= reg1[n-1];
		end
	end
endmodule


module RegisterInference(clk, clr, pre, data, d, q1, q2);
	input clk, clr, pre, load, data, d;
	output q1, q2;

	reg q1, q2;

	always @ (posedge clk or posedge load)
	begin
		if(load)
		begin
			q1 <= data;
		end
		else
		begin
			q1 <= d;
		end
	end

	always @ (posedge clk or negedge clr or negedge pre)
	begin
		if(~clr)
		begin
			q2 <= 1'b0;
		end
		else if(~pre)
		begin
			q2 <= 1'b1;
		end
		else
		begin
			q2 <= 2; // ? - 여기에 대한 테스트 케이스는 작성하지 않았음.
		end
	end
endmodule


module StateMachine2state(clk, x, y);
	input clk, x;
	output y;

	reg y, y_temp, cur_state, next_state;

	parameter S00 = 2'b00, S01 = 2'b01, S10 = 2'b10, S11 = 2'b11;

	always @ (clk)
	begin
		cur_state = next_state;
		y = y_temp;
	end
	
	initial
	begin
		cur_state = S00;
	end

	always @ (x or cur_state)
	begin
		case(cur_state)
			S00 :
				if(x == 1'b0)
				begin
					next_state = S00;
					y_temp = 0;
				end
				else
				begin
					next_state = S01;
					y_temp = 0;
				end
			S01 :
				if(x == 1'b0)
				begin
					next_state = S00;
					y_temp = 1;
				end
				else
				begin
					next_state = S11;
					y_temp = 0;
				end
			S10 :
				if(x == 1'b0)
				begin
					next_state = S00;
					y_temp = 1;
				end
				else
				begin
					next_state = S10;
					y_temp = 0;
				end
			S11 :
				if(x == 1'b0)
				begin
					next_state = S00;
					y_temp = 1;
				end
				else
				begin
					next_state = S10;
					y_temp = 0;
				end
		endcase
	end
endmodule


module StateMachineMilli(clk, reset, i0, i1, x, y);
	input clk, reset;
	input i0, i1, x;
	output y;

	reg cur_state, next_state;
	reg y;

	parameter S0 = 1'b0;
	parameter S1 = 1'b1;

	always @ (posedge clk or reset)
	begin
		if(reset)
		begin
			cur_state = S0;
		end
		else
		begin
			cur_state = next_state;
		end
	end

	always @ (x or cur_state or i0 or i1)
	begin
		case(cur_state)
			S0 :
			begin
				if(x == 1'b0)
				begin
					next_state = S0;
					y = i0;
				end
				else
				begin
					next_state = S1;
					y = i1;
				end
			end
			S1 :
			begin
				if(x == 1'b0)
				begin
					next_state = S1;
					y = i1;
				end
				else
				begin
					next_state = S0;
					y = i0;
				end
			end
		endcase
	end

endmodule


module StateMachineMoore(clk, reset, i0, i1, x, y);
	input clk, reset, i0, i1, x;
	output y;

	reg cur_state, next_state, y;

	parameter S0 = 1'b0, S1 = 1'b1;

	always @ (posedge clk or reset)
	begin
		if(reset)   cur_state = S0;
		else		cur_state = next_state;
	end

	always @ (x or cur_state)
		case(cur_state)
			S0 :
				if(x == 1'b0)   next_state <= S0;
				else			next_state <= S1;
			S1 :
				if(x == 1'b0)   next_state <= S1;
				else			next_state <= S0;
		endcase

	always @ (cur_state or i0 or i1)
		case(cur_state)
			S0 : y = i0;
			S1 : y = i1;
		endcase
endmodule


module ClockDividingCircuit(clk, outClk);
	input clk;

	output outClk;

	integer clkCount;

	parameter S0 = 1'b0;
	parameter S1 = 1'b1;

	reg outClk;
	reg state;
	reg next_state;

	always @ (posedge clk)
	begin
		state = next_state;
		clkCount = clkCount + 1;
	end

	always @ (clkCount or state)
	begin
		case(state)
			S0 :
			begin
				if(clkCount >= 500000)
				begin
					next_state <= S1;
					clkCount <= 0;
				end
				else
				begin
					outClk <= 0;
				end
			end
			S1 :
			begin
				if(clkCount >= 500000)
				begin
					next_state = S0;
					clkCount = 0;
				end
				else
				begin
					outClk = 1;
				end
			end
		endcase
	end

endmodule


module SimpleStateMachine(clk, reset, i, m, n, y);
	input clk;
	input reset;
	input i, m, n;

	output y;

	reg y;
	reg state;
	reg next_state;

	parameter S0 = 1'b0;
	parameter S1 = 1'b1;

	// rst -> state
	always @ (posedge clk)
		if(reset)
			state = S0;
		else
			state = next_state;

	// (i, state) -> next_state
	always @ (i or state)
		case(state)
			S0 :
				if(i)
					next_state = S1;
				else
					next_state = S0;
			S1 :
				if(i)
					next_state = S0;
				else
					next_state = S1;
		endcase

	// state, m, n -> y(output)
	always @ (state or m or n)
		case(state)
			S0 : y = m;
			S1 : y = n;
		endcase
endmodule


module CarryLookAheadBCDAdder(a, b, c_in, s, c_out);
	input [15:0] a;
	input [15:0] b;
	input c_in;

	output [15:0] s;
	output c_out;

	wire [15:0] w_p, w_g;
	wire [3:0] w_c;

	BCDFullAdder bcdFullAdder0(a[3:0], b[3:0], c_in, s[3:0], w_c[0], w_p[3:0], w_g[3:0]);
	BCDFullAdder bcdFullAdder1(a[7:4], b[7:4], w_c[0], s[7:4], w_c[1], w_p[7:4], w_g[7:4]);
	BCDFullAdder bcdFullAdder2(a[11:8], b[11:8], w_c[1], s[11:8], w_c[2], w_p[11:8], w_g[11:8]);
	BCDFullAdder bcdFullAdder3(a[15:12], b[15:12], w_c[2], s[15:12], c_out, w_p[15:12], w_g[15:12]);
endmodule

module BCDFullAdder(a, b, c_in, s, c_out, p, g);
	input [3:0] a;
	input [3:0] b;
	input c_in;

	output [3:0] s;
	output [3:0] p;
	output [3:0] g;
	output c_out;

	wire [3:0] c;

	assign p[3:0] = a[3:0] ^ b[3:0];
	assign g[3:0] = a[3:0] & b[3:0];

	assign c[0] = (a[0] & b[0]) | (b[0] & c_in) | (c_in & a[0]);
	assign c[3:1] = g[3:1] | p[3:1] & c[2:0];

	assign s[0] = a[0] ^ b[0] ^ c_in;
	assign s[3:1] = a[3:1] ^ b[3:1] ^ c[2:0];

	assign c_out = (s > 4'b1001 ? 1 : 0);
	assign s = (s > 4'b1001 ? s - 4'b0110 : s);

endmodule


module CarryLookAheadAdder(A, B, C_in, S, C_out);
	input [3:0] A;
	input [3:0] B;
	input C_in;

	output [3:0] S;
	output C_out;

	wire [3:0] w_p;
	wire [3:0] w_g;
	wire [3:0] w_c;

	GPFullAdder gpFullAdder0(A[0], B[0], C_in  , w_p[0], w_g[0], S[0], w_c[0]);
	GPFullAdder gpFullAdder1(A[1], B[1], w_c[0], w_p[1], w_g[1], S[1], w_c[1]);
	GPFullAdder gpFullAdder2(A[2], B[2], w_c[1], w_p[2], w_g[2], S[2], w_c[2]);
	GPFullAdder gpFullAdder3(A[3], B[3], w_c[2], w_p[3], w_g[3], S[3], C_out );
endmodule

module GPFullAdder(a, b, c_in, p, g, s, c_out);
	input a, b, c_in;
	output p, g, s, c_out;

	assign p = a ^ b;
	assign g = a & b;
	assign s = p ^ g;
	assign c_out = g | (p & c_in);
endmodule


module ParityGenerator_3(data_in, parity_out);
	parameter n = 8;
	input [n-1:0] data_in;
	output [n:0] parity_out;

	reg [n:0] parity_out;

	task parity;
		input [n-1:0] data;
		output [n:0] out;
		begin
			out = {^data, data};
		end
	endtask

	always @ (data_in)
	begin
		parity(data_in, parity_out);
	end
endmodule


module ParityGenerator_2(data_in, parity_out);
	parameter n = 8;
	input [n-1:0] data_in;
	output [n:0] parity_out;

	function [n:0] parity;
		input [n-1:0] data;
		begin
			parity = {^data, data};
		end
	endfunction

	assign parity_out = parity(data_in);
endmodule


module ParityGenerator(data_in, parity_out);
	input [7:0] data_in;
	output [8:0] parity_out;

	assign parity_out = {^data_in, data_in};
endmodule


module LeadingCounter(d, FND, FNDSel1, FNDSel2);
	input [7:0] d;
	output [6:0] FND;
	output FNDSel2, FNDSel1;

	reg [6:0] FND;
	reg FNDSel2, FNDSel1;

	integer oneCount = 0, i = 0;

	always @ (d)
	begin : block_name
		while(i < 8)
		begin
			if(d[i])
			begin
				oneCount <= oneCount + 1;
			end
			else
			begin
				disable block_name;
			end
			i <= i + 1;
		end
	end

	assign FNDSel2 = 1'b1;
	assign FNDSel1 = 1'b0;

	always @ (oneCount)
	begin
		case(oneCount)
			0 : FND = 7'b1111110;
			1 : FND = 7'b0110000;
			2 : FND = 7'b1101101;
			3 : FND = 7'b1111001;
			4 : FND = 7'b0110011;
			5 : FND = 7'b1011011;
			6 : FND = 7'b1011111;
			7 : FND = 7'b1110010;
			8 : FND = 7'b1111111;
			default : FND = 7'b0000000;
		endcase
	end
endmodule


module OneCounter(d, FND, FNDSel2, FNDSel1);
	input [7:0] d;
	output [6:0] FND;
	output FNDSel2, FNDSel1;

	reg [6:0] FND;
	wire FNDSel2, FNDSel1;

	integer oneCount = 0, i = 0;

	always @ (d)
	begin
		oneCount = 0;
		for(i = 0; i < 8; i++)
		begin
			if(d[i])
			begin
				oneCount = oneCount + 1;
			end
		end
	end

	assign FNDSel2 = 1'b1;
	assign FNDSel1 = 1'b0;

	always @ (oneCount)
	begin
		case(oneCount)
			0 : FND = 7'b1111110;
			1 : FND = 7'b0110000;
			2 : FND = 7'b1101101;
			3 : FND = 7'b1111001;
			4 : FND = 7'b0110011;
			5 : FND = 7'b1011011;
			6 : FND = 7'b1011111;
			7 : FND = 7'b1110010;
			8 : FND = 7'b1111111;
			default : FND = 7'b0000000;
		endcase
	end
endmodule


module BCDAdder(clk, a, b, FND, FNDSel);
	parameter width = 4;
	input [width-1:0] a, b;
	input clk;
	output FND;
	output [1:0] FNDSel;

	reg FND;
	reg [1:0] FNDSel;
	reg [6:0] FNDVal2, FNDVal1;
	reg clk100Hz;

	integer sum = 0;
	integer dec2, dec1;
	integer m = 0;

	// get clk100Hz
	always @ (posedge clk)
	begin
		if(m >= 4999)
		begin
			m <= 0;
			clk100Hz = ~clk100Hz;
		end
		else
		begin
			m <= m + 1;
		end
	end

	// sum -> dec2, dec1
	always @ (a or b)
	begin
		sum = a + b;
		if(sum > 9)
		begin
			sum = sum + 6;
		end
		dec2 = sum / 10;
		dec1 = sum % 10;
	end

	// dec2, dec1 -> FNDVal2, FNDVal1
	always @ (dec2 or dec1)
	begin
		case(dec2)
			0 : FNDVal2 = 7'b1111110;
			1 : FNDVal2 = 7'b0110000;
			2 : FNDVal2 = 7'b1101101;
			3 : FNDVal2 = 7'b1111001;
			4 : FNDVal2 = 7'b0110011;
			5 : FNDVal2 = 7'b1011011;
			6 : FNDVal2 = 7'b1011111;
			7 : FNDVal2 = 7'b1110010;
			8 : FNDVal2 = 7'b1111111;
			9 : FNDVal2 = 7'b1111011;
			10 : FNDVal2 = 7'b1110111;
			11 : FNDVal2 = 7'b0011111;
			12 : FNDVal2 = 7'b1001110;
			13 : FNDVal2 = 7'b0111101;
			14 : FNDVal2 = 7'b1001111;
			15 : FNDVal2 = 7'b1000111;
			default : FNDVal2 = 7'b0000000;
		endcase

		case(dec1)
			0 : FNDVal1 = 7'b1111110;
			1 : FNDVal1 = 7'b0110000;
			2 : FNDVal1 = 7'b1101101;
			3 : FNDVal1 = 7'b1111001;
			4 : FNDVal1 = 7'b0110011;
			5 : FNDVal1 = 7'b1011011;
			6 : FNDVal1 = 7'b1011111;
			7 : FNDVal1 = 7'b1110010;
			8 : FNDVal1 = 7'b1111111;
			9 : FNDVal1 = 7'b1111011;
			10 : FNDVal1 = 7'b1110111;
			11 : FNDVal1 = 7'b0011111;
			12 : FNDVal1 = 7'b1001110;
			13 : FNDVal1 = 7'b0111101;
			14 : FNDVal1 = 7'b1001111;
			15 : FNDVal1 = 7'b1000111;
			default : FNDVal1 = 7'b0000000;
		endcase
	end

	// FNDVal2, FNDVal1 -> FNDSel, FND
	always @ (clk100Hz or FNDVal2 or FNDVal1)
	begin
		if(clk100Hz)
		begin
			FNDSel[0] = 1'b0;
			FNDSel[1] = 1'b1;
			FND = FNDVal1;
		end
		else
		begin
			FNDSel[0] = 1'b1;
			FNDSel[1] = 1'b0;
			FND = FNDVal2;
		end
	end

endmodule


module nBitAddSub_2(clk, a, b, m, FND2, FND1, FND2Sel, FND1Sel);
	parameter width = 4
	input [width-1:0] a, b;
	input clk, m;
	output [6:0] FND2, FND1;
	output [1:0] FND2Sel, FND1Sel;

	reg [width+1:0] sum;
	reg [6:0] FND2, FND1;
	reg [1:0] FND2Sel, FND1Sel;
	reg [6:0] FND1Val2, FND1Val1;
	reg clk100Hz;

	integer ai = 0;, bi = 0;
	integer hex1 = 0, hex2 = 0;
	integer result;
	reg sign;

	integer m = 0;

	// get clk100Hz
	always @ (posedge clk)
	begin
		if(m >= 4999)
		begin
			m <= 0;
			clk100Hz = ~clk100Hz;
		end
		else
			m <= m + 1;
		end
	end

	// result -> sign, hex2, hex1
	always @ (a or b or m)
	begin
		ai = a;
		bi = b;
		if(m == 1'b0)
		begin
			result = ai + bil
		end
		else
		begin
			result = ai - bi;
		end

		if(result < 0)
		begin
			sign = 1'b1;
			hex2 = -result / 16;
			hex1 = -result % 16;
		end
		else
		begin
			sign = 1'b0;
			hex2 = result / 16;
			hex1 = result % 16;
		end
	end

	// hex2, hex1 -> FND1Val2, FND1Val1
	always @ (hex2 or hex1)
	begin
		case(hex2)
			0 : FND1Val2 = 7'b1111110;
			1 : FND1Val2 = 7'b0110000;
			2 : FND1Val2 = 7'b1101101;
			3 : FND1Val2 = 7'b1111001;
			4 : FND1Val2 = 7'b0110011;
			5 : FND1Val2 = 7'b1011011;
			6 : FND1Val2 = 7'b1011111;
			7 : FND1Val2 = 7'b1110010;
			8 : FND1Val2 = 7'b1111111;
			9 : FND1Val2 = 7'b1111011;
			10 : FND1Val2 = 7'b1110111;
			11 : FND1Val2 = 7'b0011111;
			12 : FND1Val2 = 7'b1001110;
			13 : FND1Val2 = 7'b0111101;
			14 : FND1Val2 = 7'b1001111;
			15 : FND1Val2 = 7'b1000111;
			default : FND1Val2 = 7'b0000000;
		endcase

		case(hex1)
			0 : FND1Val1 = 7'b1111110;
			1 : FND1Val1 = 7'b0110000;
			2 : FND1Val1 = 7'b1101101;
			3 : FND1Val1 = 7'b1111001;
			4 : FND1Val1 = 7'b0110011;
			5 : FND1Val1 = 7'b1011011;
			6 : FND1Val1 = 7'b1011111;
			7 : FND1Val1 = 7'b1110010;
			8 : FND1Val1 = 7'b1111111;
			9 : FND1Val1 = 7'b1111011;
			10 : FND1Val1 = 7'b1110111;
			11 : FND1Val1 = 7'b0011111;
			12 : FND1Val1 = 7'b1001110;
			13 : FND1Val1 = 7'b0111101;
			14 : FND1Val1 = 7'b1001111;
			15 : FND1Val1 = 7'b1000111;
			default : FND1Val1 = 7'b0000000;
		endcase
	end

	// print sign -> FND2
	assign FND2Sel[1] = 1'b1;
	assign FND2Sel[0] = 1'b0;

	always @ (sign)
	begin
		if(sign == 1'b1)
		begin
			FND2 = 7'b0000001;
		end
		else
		begin
			FND2 = 7'b0000000;
		end
	end

	// 
	always @ (clk100Hz or FND1Val2 or FND1Val1)
	begin
		if(clk100Hz)
		begin
			FND1Sel[0] = 1'b0;
			FND1Sel[1] = 1'b1;
			FND1 = FND1Val1;
		end
		else
		begin
			FND1Sel[0] = 1'b1;
			FND1Sel[1] = 1'b0;
			FND1 = FND1Val2;
		end
	end

endmodule


module nBitAddSub_1(a, b, m, sum);
	parameter width = 4
	input [width-1:0] a, b;
	input m;
	output [width+1:0] sum;

	reg [width+1:0] sum;

	always @ (a or b or m)
	begin
		if(m == 1'b0)
		begin
			sum = a + b;
		end
		else
		begin
			sum = a - b;
		end
	end
endmodule


module Sorting(clk, a, b, FND, FNDSel2, FNDSel1);
	parameter width = 4;
	input [width-1:0] a, b;
	input clk;
	output FNDSel2, FNDSel1;
	output [6:0] FND;

	reg [6:0] FND;
	reg [width-1:0] max, min;
	reg clk100Hz, FNDSel2, FNDSel1;
	reg [6:0] FNDmax, FNDmin;
	integer m = 0;

	// make 100Hz clock
	always @ (posedge clk)
	begin
		if(m >= 4999)
		begin
			m <= 0;
			clk100Hz <= ~clk100Hz;
		end
		else
		begin
			m <= m + 1;
		end
	end

	// sorting
	always @ (posedge clk)
	begin
		if(a > b)
		begin
			max = a;
			min = b;
		end
		else if(a < b)
		begin
			max = b;
			min = a;
		end
		else
		begin
		end
	end

	// renew FNDmax, FNDmin per clk
	always @ (posedge clk) begin
		case(max)
			4'b0000 : FNDmax = 7'b1111110;
			4'b0001 : FNDmax = 7'b0110000;
			4'b0010 : FNDmax = 7'b1101101;
			4'b0011 : FNDmax = 7'b1111001;
			4'b0100 : FNDmax = 7'b0110011;
			4'b0101 : FNDmax = 7'b1011011;
			4'b0110 : FNDmax = 7'b1011111;
			4'b0111 : FNDmax = 7'b1110010;
			4'b1000 : FNDmax = 7'b1111111;
			4'b1001 : FNDmax = 7'b1111011;
			4'b1010 : FNDmax = 7'b1110111;
			4'b1011 : FNDmax = 7'b0011111;
			4'b1100 : FNDmax = 7'b1001110;
			4'b1101 : FNDmax = 7'b0111101;
			4'b1110 : FNDmax = 7'b1001111;
			4'b1111 : FNDmax = 7'b1000111;
		endcase

		case(min)
			4'b0000 : FNDmin = 7'b1111110;
			4'b0001 : FNDmin = 7'b0110000;
			4'b0010 : FNDmin = 7'b1101101;
			4'b0011 : FNDmin = 7'b1111001;
			4'b0100 : FNDmin = 7'b0110011;
			4'b0101 : FNDmin = 7'b1011011;
			4'b0110 : FNDmin = 7'b1011111;
			4'b0111 : FNDmin = 7'b1110010;
			4'b1000 : FNDmin = 7'b1111111;
			4'b1001 : FNDmin = 7'b1111011;
			4'b1010 : FNDmin = 7'b1110111;
			4'b1011 : FNDmin = 7'b0011111;
			4'b1100 : FNDmin = 7'b1001110;
			4'b1101 : FNDmin = 7'b0111101;
			4'b1110 : FNDmin = 7'b1001111;
			4'b1111 : FNDmin = 7'b1000111;
		endcase
	end

	// convert digit per clk100Hz
	always @ (clk100Hz, FNDmax, FNDmin) begin
		if(clk100Hz)
		begin
			FNDSel1 = 1'b0;
			FNDSel2 = 1'b1; // tens digit
			FND = FNDmin;
		end
		else
		begin // if clock == 0
			FNDSel1 = 1'b1; // units digit
			FNDSel2 = 1'b0;
			FND = FNDmax;
		end
	end

endmodule


module Comparator(a, b, aLessb, aGreaterb, aEqualb);
	parameter width = 4;
	input [width-1:0] a, b;
	output aLessb, aGreaterb, aEqualb;

	reg aLessb, aGreaterb, aEqualb;

	always @ (a or b)
	begin
		if(a > b)
		begin
			aLessb <= 1'b0;
			aEqual <= 1'b0;
			aGreaterb <= 1'b1;
		end
		else if(a == b)
		begin
			aLessb <= 1'b0;
			aEqual <= 1'b1;
			aGreaterb <= 1'b0;
		end
		else
		begin
			aLessb <= 1'b1;
			aEqual <= 1'b0;
			aGreaterb <= 1'b0;
		end
	end
endmodule


module Demultiplexer1x8(s, i, y);
	input i;
	input [2:0] s;
	output [7:0] y;

	reg [7:0] y;

	always @ (s or i)
	begin
		case(s)
			3'b000 : y = {1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, i};
			3'b001 : y = {1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, i, 1'bz};
			3'b010 : y = {1'bz, 1'bz, 1'bz, 1'bz, 1'bz, i, 1'bz, 1'bz};
			3'b011 : y = {1'bz, 1'bz, 1'bz, 1'bz, i, 1'bz, 1'bz, 1'bz};
			3'b100 : y = {1'bz, 1'bz, 1'bz, i, 1'bz, 1'bz, 1'bz, 1'bz};
			3'b101 : y = {1'bz, 1'bz, i, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz};
			3'b110 : y = {1'bz, i, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz};
			3'b111 : y = {i, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz};
		endcase
	end
endmodule


module Multiplexer8x1(s, i, y);
	input [7:0] i;
	input [2:0] s;
	output y;

	reg y;

	always @ (s or i)
	begin
		case(s)
			3'b000 : y = i[0];
			3'b001 : y = i[1];
			3'b010 : y = i[2];
			3'b011 : y = i[3];
			3'b100 : y = i[4];
			3'b101 : y = i[5];
			3'b110 : y = i[6];
			3'b111 : y = i[7];
		endcase
	end
endmodule


module Demultiplexer(s, i, y);
	input [1:0] s;
	input i;
	output [3:0] y;

	reg [3:0] y;

	always @ (s or i)
	begin : DEMUX
		case(s)
			2'b00 : y = {1'bz, 1'bz, 1'bz, i};
			2'b01 : y = {1'bz, 1'bz, i, 1'bz};
			2'b10 : y = {1'bz, i, 1'bz, 1'bz};
			2'b11 : y = {i, 1'bz, 1'bz, 1'bz};
		endcase
	end
endmodule


module Multiplexer(s, i, y);
	input [1:0] s;
	input [3:0] i;
	output y;

	reg y;

	always @ (s or i)
	begin : MUX
		case(s)
			2'b00 : y = i[0];
			2'b01 : y = i[1];
			2'b10 : y = i[2];
			2'b11 : y = i[3];
		endcase
	end
endmodule


module SwitchEncoder_3(clk, reset, a, b, FND);
	input clk;
	input [3:0] a, b;
	output [6:0] FND;


	// FND value
	reg[6:0] FNDa, FNDb;
	reg FNDSel1, FNDSel2, FND;

	// clock
	reg clk100Hz;
	integer m = 0;

	// toggle clk100Hz per clk / (10000 / 2)
	always @ (posedge clk) begin
		if(m >= 4999) begin
			m <= 0;
			clk100Hz <= ~clk100Hz;
		end else
			m <= m + 1;
	end


	// renew FND of a, b per clk
	always @ (posedge clk) begin
		case(a)
			4'b0000 : FNDa = 7'b1111110;
			4'b0001 : FNDa = 7'b0110000;
			4'b0010 : FNDa = 7'b1101101;
			4'b0011 : FNDa = 7'b1111001;
			4'b0100 : FNDa = 7'b0110011;
			4'b0101 : FNDa = 7'b1011011;
			4'b0110 : FNDa = 7'b1011111;
			4'b0111 : FNDa = 7'b1110010;
			4'b1000 : FNDa = 7'b1111111;
			4'b1001 : FNDa = 7'b1111011;
			4'b1010 : FNDa = 7'b1110111;
			4'b1011 : FNDa = 7'b0011111;
			4'b1100 : FNDa = 7'b1001110;
			4'b1101 : FNDa = 7'b0111101;
			4'b1110 : FNDa = 7'b1001111;
			4'b1111 : FNDa = 7'b1000111;
		endcase

		case(b)
			4'b0000 : FNDb = 7'b1111110;
			4'b0001 : FNDb = 7'b0110000;
			4'b0010 : FNDb = 7'b1101101;
			4'b0011 : FNDb = 7'b1111001;
			4'b0100 : FNDb = 7'b0110011;
			4'b0101 : FNDb = 7'b1011011;
			4'b0110 : FNDb = 7'b1011111;
			4'b0111 : FNDb = 7'b1110010;
			4'b1000 : FNDb = 7'b1111111;
			4'b1001 : FNDb = 7'b1111011;
			4'b1010 : FNDb = 7'b1110111;
			4'b1011 : FNDb = 7'b0011111;
			4'b1100 : FNDb = 7'b1001110;
			4'b1101 : FNDb = 7'b0111101;
			4'b1110 : FNDb = 7'b1001111;
			4'b1111 : FNDb = 7'b1000111;
		endcase
	end

	// convert digit per clk100Hz
	always @ (clk100Hz, FNDa, FNDb) begin
		if(clk100Hz) begin // if clock == 1
			FNDSel1 = 1'b0; // tens digit
			FNDSel2 = 1'b1;
			FND = FNDb;
		end else begin // if clock == 0
			FNDSel1 = 1'b1; // units digit
			FNDSel2 = 1'b0;
			FND = FNDa;
		end
	end

endmodule


module SwitchEncoder_2(clk, reset, key, keyVal, FND);
	input clk, reset;
	input [15:0] key;
	output [6:0] FND;
	output [3:0] keyVal;

	reg[3:0] keyVal;

	always @ (posedge clk or reset) //
	begin
		case(clk)
			16'b0000000000000001 : keyVal = 4'b0000;
			16'b0000000000000010 : keyVal = 4'b0001;
			16'b0000000000000100 : keyVal = 4'b0010;
			16'b0000000000001000 : keyVal = 4'b0011;
			16'b0000000000010000 : keyVal = 4'b0100;
			16'b0000000000100000 : keyVal = 4'b0101;
			16'b0000000001000000 : keyVal = 4'b0110;
			16'b0000000010000000 : keyVal = 4'b0111;
			16'b0000000100000000 : keyVal = 4'b1000;
			16'b0000001000000000 : keyVal = 4'b1001;
			16'b0000010000000000 : keyVal = 4'b1010;
			16'b0000100000000000 : keyVal = 4'b1011;
			16'b0001000000000000 : keyVal = 4'b1100;
			16'b0010000000000000 : keyVal = 4'b1101;
			16'b0100000000000000 : keyVal = 4'b1110;
			16'b1000000000000000 : keyVal = 4'b1111;
			default :;
		endcase

		case(keyVal)				  /*ABCDEFG*/
			/* 0 */ 4'b0000 : FND = 7'b1111110;
			/* 1 */ 4'b0001 : FND = 7'b0110000;
			/* 2 */ 4'b0010 : FND = 7'b1101101;
			/* 3 */ 4'b0011 : FND = 7'b1111001;
			/* 4 */ 4'b0100 : FND = 7'b0110011;
			/* 5 */ 4'b0101 : FND = 7'b1011011;
			/* 6 */ 4'b0110 : FND = 7'b1011111;
			/* 7 */ 4'b0111 : FND = 7'b1110010;
			/* 8 */ 4'b1000 : FND = 7'b1111111;
			/* 9 */ 4'b1001 : FND = 7'b1111011;
			/* A */ 4'b1010 : FND = 7'b1110111;
			/* B */ 4'b1011 : FND = 7'b0011111;
			/* C */ 4'b1100 : FND = 7'b1001110;
			/* D */ 4'b1101 : FND = 7'b0111101;
			/* E */ 4'b1110 : FND = 7'b1001111;
			/* F */ 4'b1111 : FND = 7'b1000111;
		endcase
	end
endmodule


module SwitchEncoder(clk, reset, key, keyVal);
	input clk, reset;
	input [15:0] key;
	output [3:0] keyVal;

	reg[3:0] keyVal;

	always @ (posedge clk or reset)
	begin
		case(key)
			16'b0000000000000001 : keyVal = 4'b0000;
			16'b0000000000000010 : keyVal = 4'b0001;
			16'b0000000000000100 : keyVal = 4'b0010;
			16'b0000000000001000 : keyVal = 4'b0011;
			16'b0000000000010000 : keyVal = 4'b0100;
			16'b0000000000100000 : keyVal = 4'b0101;
			16'b0000000001000000 : keyVal = 4'b0110;
			16'b0000000010000000 : keyVal = 4'b0111;
			16'b0000000100000000 : keyVal = 4'b1000;
			16'b0000001000000000 : keyVal = 4'b1001;
			16'b0000010000000000 : keyVal = 4'b1010;
			16'b0000100000000000 : keyVal = 4'b1011;
			16'b0001000000000000 : keyVal = 4'b1100;
			16'b0010000000000000 : keyVal = 4'b1101;
			16'b0100000000000000 : keyVal = 4'b1110;
			16'b1000000000000000 : keyVal = 4'b1111;
			default :;
		endcase
	end
endmodule


module DecimalToBCDEncoder(d, en, a, v);
	input [9:0] d;
	input en;
	output a, v;

	reg a, v;

	always @ (d)
	begin
		if(en) begin
			if(d[9]) begin
				a = 4'b1001;
				v = 1'b1;
			end else if(d[8]) begin
				a = 4'b1000;
				v = 1'b1;
			end else if(d[7]) begin
				a = 4'b0111;
				v = 1'b1;
			end else if(d[6]) begin
				a = 4'b0110;
				v = 1'b1;
			end else if(d[5]) begin
				a = 4'b0101;
				v = 1'b1;
			end else if(d[4]) begin
				a = 4'b0100;
				v = 1'b1;
			end else if(d[3]) begin
				a = 4'b0011;
				v = 1'b1;
			end else if(d[2]) begin
				a = 4'b0010;
				v = 1'b1;
			end else if(d[1]) begin
				a = 4'b0001;
				v = 1'b1;
			end else if(d[0]) begin
				a = 4'b0000;
				v = 1'b1;
			end else begin
				a = 0;
				v = 1'b0;
			end
		end
	end
endmodule


module PriorityEncoder8x3(d, en, a, v);
	input [7:0] d;
	input en;
	output a, v;

	reg a, v;

	always @ (d)
	begin
		if(en) begin
			if(d[7]) begin
				a = 3'b111;
				v = 1'b1;
			end else if(d[6]) begin
				a = 3'b110;
				v = 1'b1;
			end else if(d[5]) begin
				a = 3'b101;
				v = 1'b1;
			end else if(d[4]) begin
				a = 3'b100;
				v = 1'b1;
			end else if(d[3]) begin
				a = 3'b011;
				v = 1'b1;
			end else if(d[2]) begin
				a = 3'b010;
				v = 1'b1;
			end else if(d[1]) begin
				a = 3'b001;
				v = 1'b1;
			end else if(d[0]) begin
				a = 3'b000;
				v = 1'b1;
			end else begin
				a = 0;
				v = 1'b0;
			end
		end
	end
endmodule


module Decoder3x8_2(x, D, en);
	input [2:0] x;
	input en; // enable signal
	output [7:0] D;

	assign D = (en) ? (1'b1 << x) : 8'h00;
endmodule


module Decoder3x8(x, D, en);
	input [2:0] x;
	input en; // enable signal
	output [7:0] D;
	
	reg [7:0] D;

	always @ (en or x)
	begin
		if(en) begin
			case(x)
				3'h0 : D <= 8'h01;
				3'h1 : D <= 8'h02;
				3'h2 : D <= 8'h04;
				3'h3 : D <= 8'h08;
				3'h4 : D <= 8'h10;
				3'h5 : D <= 8'h20;
				3'h6 : D <= 8'h40;
				3'h7 : D <= 8'h80;
			endcase
		end
	end
endmodule


module FullAdder3bit_2(x, y, z, S, C);
	input x, y, z;
	output S, C;

	assign S = (~X & ~Y & Z) | (~X & Y & ~Z) | (X & ~Y & ~Z) | (X & Y & Z);
	assign C = (X & Y) | (Y & Z) | (Z & X);
endmodule

module FullAdder3bit(x, y, z, S, C);
	input x, y, z;
	output S, C;

	reg S, C;
	wire[2:0] k;

	assign k = {x, y, z};

	always @ (k)
	begin
		case(k)
			3'b000 : begin
				S <= 1'b0;
				C <= 1'b0;
			end
			3'b001 : begin
				S <= 1'b0;
				C <= 1'b1;
			end
			3'b010 : begin
				S <= 1'b0;
				C <= 1'b1;
			end
			3'b011 : begin
				S <= 1'b1;
				C <= 1'b0;
			end
			3'b100 : begin
				S <= 1'b0;
				C <= 1'b1;
			end
			3'b101 : begin
				S <= 1'b1;
				C <= 1'b0;
			end
			3'b110 : begin
				S <= 1'b1;
				C <= 1'b0;
			end
			3'b111 : begin
				S <= 1'b1;
				C <= 1'b1;
			end
		endcase
	end
endmodule

module main_4(A, B, C, X, Y, Z);
	input A, B, C;
	inout X, Y;
	output Z;

	assign X = ~(A | B);
	assign Y = ~(B | ~C);
	assign Z = ~(X & Y);
endmodule

module main_3(A, B, C, F1, F2);
	input A, B, C;
	output F1, F2;

	assign F1 = A & B & C;
	assign F2 = A&B | B&C | C&A;
endmodule

module main_2(A, B, C, W, X, Y, Z);
	input A, B, C;
	inout W, X, Y;
	output Z;

	assign W = ~A & ~B & ~C;
	assign X = A & ~B & ~C;
	assign Y = ~A & ~B & C;
	assign Z = (~A & ~B) | (~B & ~C);
endmodule

module main(a, b, and_out, or_out, not_out);
	input a, b;
	output and_out, or_out, not_out;

	assign and_out = a & b; // 
	assign or_out = a | b;
	assign not_out = ~a;
endmodule

module sub(a, b, c, d, y);
	input a, b, c, d;
	output y;

	assign y = (~(a | b) & (c & d));
endmodule