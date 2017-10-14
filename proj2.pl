%% Project 2 for Declarative Programming COMP90048
%% Date: 07/10/17
%% Samuel Xu, samuelx@student.unimelb.edu.au
%% Solution inspired by the Sudoku solution as described in Prolog's 
%% "transpose" documentation:
%%	http://www.swi-prolog.org/pldoc/doc_for?object=clpfd%3Atranspose/2
%%
%% This program is a program written in Prolog which attempts to solve 
%% maths puzzles.
%%
%% A maths puzzle is defined as the following:
%% - Square grid of squares, each to be filled with a single digit 1-9
%% - Satisfies the following constraints:
%% 	- each row and column contains no repeated digits
%% 	- all squares on the diagonal line from upper left to lower right contains
%% 		the same value
%% 	- the heading of each row and column holds the sum or the product of all
%% 		the digits in that row or column
%%
%%		|	0	|	6	|	6	|
%%		|	6	|	3	|	2	|		<- A valid 2x2 maths puzzle
%%		|	6	|	2	|	3	|
%%
%% As always, Here's Sam's Style Guide!:
%% - 78 Character ruler! If the line goes beyond 78 characters (including 
%%		commends)
%%
%% Changelog:
%%  0.06 8th Oct - Program finally works. Correctly guesses 2x2 squares.
%%					Yay!
%%
%%  0.05 8th Oct - Diagonal works properly now! Can successfully derive the 
%%					correct value. Alcoholic Beverage Counter: 2.
%%
%%  0.04 7th Oct - Changed the product_list and sum_list functions to 
%%					incorporate the #= operator, to avoid instantiation errors
%%					Turns out diagonal in it's current state cannot calculate
%%					empty spaces. :(
%%
%%	0.03 7th Oct - Program now can correctly check if a row fulfills the 
%%					sum or product constraint. (As in the elements of the
%%					row or column will sum or product to the heading). Yay!
%%
%% 	0.02 7th Oct - Program successfully checks for diagonal constraints
%%
%% 	0.01 7th Oct - Program correctly checks for square and same length 
%%				    constraints. This language is interesting.
%%

:- ensure_loaded(library(clpfd)).

%% This function starts the puzzle!
puzzle_solution(Rows) :-
	%% Make sure the entry is square, and of size 2x2, 3x3 or 4x4.
	count(Rows, Len), Len in 3..5, maplist(same_length(Rows), Rows),
	%% Check if the supplied puzzle fulfills the diagonal constraint.
	check_diagonal(Rows),
	transpose(Rows, Columns),
	Rows = [_|Row_Tail], Columns = [_|Columns_Tail],
	maplist(check_row, Row_Tail),
	maplist(check_row, Columns_Tail),
	ground(Rows).

%% This function checks if a supplied row (or transposed column) fulfills the
%% specified constraint where the list must sum or product to the heading of
%% the row or column (in this case, the head of the supplied list).
check_row([Head|Tail]) :-
	valid_digits(Tail),
	sum_list_but_better(Tail, Head);
	product_list(Tail, Head).

%% check_domain([]).
%% check_domain(Solution) :-
%% 	%%write(No_Header),
%% 	valid_digits(Solution).

valid_digits(Solution) :-
	Solution ins 1..9,
	all_distinct(Solution).

product_list([],1).
product_list([H|T], Product) :-
	product_list(T, N_Product),
	Product #= N_Product * H.

sum_list_but_better([],0).
sum_list_but_better([H|T], Sum) :-
	sum_list_but_better(T, N_Sum),
	Sum #= N_Sum + H.


%% Counts the number of elements in a list
count([], 0).
count([_|Tail], N) :-
	count(Tail, M),
	N #= M+1.

zero_check([0|_]).

check_diagonal([Head|Rows]) :- 
	zero_check(Head),
	diagonal(Rows, 1, []).

diagonal([Row|Tail], Index, Append_To) :-
	nth0(Index, Row, Diagonal),
	New_Index #= Index + 1,
	diagonal(Tail, New_Index, [Diagonal|Append_To]).

diagonal([], _, Appended) :-
	check_same(Appended).

check_same([]).
check_same([_]).
check_same([H, X|T]) :-
	H #= X,
	check_same([X|T]).


%% diagonal([],_,_).

%% %% If the length and the nth of the row (the diagonal) has reached the final
%% %% row, then terminate.
%% diagonal([[0|_],[_,Prev_Match|_]|Tail], 0, 0) :-
%% 	diagonal(Tail, 1, Match), Match #= Prev_Match.
%% diagonal([Row|Tail], Pos, Prev_Match) :-
%% 	nth0(New_Pos, Row, Match), Match #= Prev_Match,
%% 	diagonal(Tail, New_Pos, Match), New_Pos is Pos + 1.
