library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Vending_machine is
    port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        dollar  : in  STD_LOGIC;    --+1.0
        quarter : in  STD_LOGIC;    --+0.5
        change  : out STD_LOGIC;
        drink   : out STD_LOGIC
    );
end entity Vending_machine;

architecture Behavioral of Vending_machine is
    
    constant s0 : std_logic_vector(2 downto 0) := "000";    --idle
    constant s1 : std_logic_vector(2 downto 0) := "001";    --0.5
    constant s2 : std_logic_vector(2 downto 0) := "010";    --1.0
    constant s3 : std_logic_vector(2 downto 0) := "011";    --1.5
    constant s4 : std_logic_vector(2 downto 0) := "100";    --2.0
    constant s5 : std_logic_vector(2 downto 0) := "101";    --empty
    constant s6 : std_logic_vector(2 downto 0) := "110";    --empty
    constant s7 : std_logic_vector(2 downto 0) := "111";    --empty

    signal state, nextstate : std_logic_vector(2 downto 0);


begin

    Resetter : process(clk, reset)
    begin                           --reset
        if reset = '0' then
            state <= s0;
        elsif (clk'event and clk ='1') then
            state <= nextstate;
        else 
            state <= state;
        end if;
    end process Resetter;

    state_transition : process (dollar, quarter, state)
    begin
        case state is
            when s1 =>
                if dollar = '1' then
                    nextstate <= s3;
                elsif quarter = '1' then
                    nextstate <= s2;
                else
                    nextstate <= s1;
                end if;

            when s2 =>
                if dollar = '1' then
                    nextstate <= s4;
                elsif quarter = '1' then
                    nextstate <= s3;
                else
                    nextstate <= s2;
                end if;

            when others =>          --the nextstate of other states is the same as s0
                if dollar = '1' then
                    nextstate <= s2;
                elsif quarter = '1' then
                    nextstate <= s1;
                else
                    nextstate <= s0;
                end if;
        end case;
    end process state_transition;

    output_logic : process (state)
    begin
        case state is
            when s3 =>
                change <= '0' ;
                drink  <= '1' ;
            when s4 =>
                change <= '1' ;
                drink  <= '1' ;
            when others =>          --no output other than s3,s4
                change <= '0' ;
                drink  <= '0' ;
        end case;
    end process;

end architecture Behavioral;