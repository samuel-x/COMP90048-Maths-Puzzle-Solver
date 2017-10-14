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
	diagonal(Rows, 0, 0),
	transpose(Rows, Columns),
	Rows = [_|Row_Tail], Columns = [_|Columns_Tail],
	maplist(check_row, Row_Tail),
	maplist(check_row, Columns_Tail).

%% This function checks if a supplied row (or transposed column) fulfills the
%% specified constraint where the list must sum or product to the heading of
%% the row or column (in this case, the head of the supplied list).
check_row([Head|Tail]) :-
	valid_digits(Tail),
	sum_list_but_better(Tail, Head);
	product_list(Tail, Head).

valid_digits(Solution) :-
	Solution ins 1..9,
	all_distinct(Solution).

product_list([],1).
product_list([H|T], Product) :-
	product_list(T, N_Product),
	Product #= N_Product * H.

sum_list_but_better([],1).
sum_list_but_better([H|T], Sum) :-
	sum_list_but_better(T, N_Sum),
	Sum #= N_Sum + H.


%% Counts the number of elements in a list
count([], 0).
count([_|Tail], N) :-
	count(Tail, M),
	N #= M+1.

diagonal([],_,_).

%% If the length and the nth of the row (the diagonal) has reached the final
%% row, then terminate.
diagonal([[0|_],[_,Match|_]|Tail], 0, 0) :-
	diagonal(Tail, 1, Match).
diagonal([Row|Tail], Pos, Prev_Match) :-
	nth0(New_Pos, Row, Match), Prev_Match #= Match,
	diagonal(Tail, New_Pos, Match), New_Pos is Pos + 1.
