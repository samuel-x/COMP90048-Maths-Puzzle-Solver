%% Project 2 for Declarative Programming COMP90048
%% Date: 07/10/17
%% Samuel Xu, samuelx@student.unimelb.edu.au
%% Solution inspired by the Sudoku solution as described in Prolog's 
%% "transpose" documentation:
%%	http://www.swi-prolog.org/pldoc/doc_for?object=clpfd%3Atranspose/2
%%
%% This program is a program written in Prolog which solves maths puzzles.
%% A maths puzzle is defined as the following:
%% - Square grid of squares, each to be filled with a single digit 1-9
%% - Satisfies the following constraints:
%% 	- each row and column contains no repeated digits
%% 	- all squares on the diagonal line from upper left to lower right contains
%% 		the same value
%% 	- the heading of each row and column holds the sum or the product of all
%% 		the digits in that row or column
%%

%% Changelog
%% 	0.02 - Program successfully checks for diagonal constraints
%% 	0.01 - Program correctly checks for square and same length constraints



:- ensure_loaded(library(clpfd)).

%% Sudoku solution for reference
%% sudoku(Rows) :-
%% 		length(Rows, 9), maplist(same_length(Rows), Rows),
%% 		append(Rows, Vs), Vs ins 1..9,
%% 		maplist(all_distinct, Rows),
%% 		transpose(Rows, Columns),
%% 		Rows = [A, B, C, D, E, F, G, H, I],
%% 		blocks(A, B, C), blocks(D, E, F), blocks(G, H, I).

%% blocks([], [], []).
%% blocks([A, B, C | Bs1], [D, E, F|Bs2], [G, H, I|Bs3]) :-
%% 		all_distinct([A, B, C D, E, F, G, H, I]),
%% 		blocks(Bs1, Bs2, Bs3).

puzzle_solver(Rows) :-
		%% Make sure the entry is square, and of size 2x2, 3x3 or 4x4.
		count(Rows, Len), Len in 2..4, maplist(same_length(Rows), Rows),
		diagonal(Rows, Len, _, 0).

%% Counts the number of elements in a list
count([], 0).
count([_|Tail], N) :-
	count(Tail, M),
	N is M+1.

%% Base case
diagonal([], 0, 0, 0).
%% If the length and the nth of the row (the diagonal) has reached the final
%% row, then terminate.
diagonal([], Len, _, Pos) :-
	Pos == Len+1,
	diagonal([], 0, 0, 0).
%% Check the top left corner (which should be 0), and begin checking the
%% diagonals.
diagonal([[0|_],[_,ToMatch|_]|Tail], Len, _, 0) :-
	diagonal(Tail, Len, ToMatch, 3).
%% Check the nth diagonal.
diagonal([Row|Tail], Len, Match, Pos) :-
	get_elem(Match, Row, Pos),
	diagonal(Tail, Len, Match, Pos+1).

%% Gets the nth element of the list.
get_elem(X, [X|_], 1).
get_elem(X,[_|T], I) :-
	get_elem(X, T, N_I), I is N_I + 1.