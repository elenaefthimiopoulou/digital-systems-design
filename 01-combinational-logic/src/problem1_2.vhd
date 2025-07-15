library ieee;
use ieee.std_logic_1164.all;

entity and_2 is 
	port(x, y	:in std_logic;
		   p2		:out std_logic);
end and_2;

architecture behavior_and_2 of and_2 is 
begin 
	p2 <= x and y;
end behavior_and_2;

library ieee;
use ieee.std_logic_1164.all;

entity and_3 is
	port(x, y, z	:in std_logic;
			  p3		:out std_logic);
end and_3;

architecture behavior_and_3 of and_3 is 
begin 
	p3 <= x and y and z;
end behavior_and_3;

library ieee;
use ieee.std_logic_1164.all;

entity SOP is
	port(o1, o2, o3	:in std_logic;
				p			:out std_logic);
end SOP;

architecture behavior_SOP of SOP is
begin 
	p<= o1 or o2 or o3;
end behavior_SOP;

library ieee;
use ieee.std_logic_1164.all;

entity problem1_2 is
	port(x1, x2, x3, x4, x5	:in std_logic;
				f					:out std_logic);
end problem1_2;

architecture structure of problem1_2 is
	signal u1, u2, u3 : std_logic;
	component and_2 is
		port(x, y	:in std_logic;
		   p2		:out std_logic);
	end component;
	component and_3 is 
		port(x, y, z	:in std_logic;
				  p3		:out std_logic);
	end component;
	component SOP is
		port(o1, o2, o3	:in std_logic;
					p			:out std_logic);
	end component;
begin 
	stage0: and_2 port map(not x3, not x5, u1);
	stage1: and_2 port map(not x4, not x5, u2);
	stage2: and_3 port map(x1, x2, not x3, u3);
	stage4: SOP port map(u1, u2, u3, f);
end structure;