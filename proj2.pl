%% Project 2 for Declarative Programming COMP90048
%% Date: 07/10/17
%% Samuel Xu, samuelx@student.unimelb.edu.au
%% Student Number: 835273
%%
%% Solution inspired by the Sudoku solution as described in Prolog's 
%% "transpose" documentation:
%%	http://www.swi-prolog.org/pldoc/doc_for?object=clpfd%3Atranspose/2
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This program is a program written in Prolog which attempts to solve 
%% maths puzzles. It takes this maths puzzle as a list of lists, each list
%% representing a row of the puzzle.
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% As always, Here's Sam's Style Guide!:
%% - 78 Character ruler! If the line goes beyond 78 characters (including 
%%		commends)
%% - Functions in Prolog should be all <lower_case> with underscores, 
%%		following the way built-in functions are written.
%% - Atoms should be spelt with <Capital_Letters> and underscores, for the
%% 		sake of consistency, as single letter atoms should be spelt with 
%%		capitals.
%% - One tab (four spaces) for indentation.
%%
%% Changelog:
%%	1.1 9th Oct - [SUBMISSION 2]
%%					Renamed some functions. Cleared up some comments and made
%%					things neater.
%%
%%	1.0 8th Oct - [SUBMISSION]
%%					Turns out program already worked, just needed to label 
%%					the values. Also, must define for valid domain and 
%%					distinct values BEFORE defining sum and product
%%					constraints (not while doing it).
%%
%%  0.33 8th Oct - Program finally works. Correctly guesses 2x2 squares.
%%					Yay! (Named version 0.33 because it has 33% correct).
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

%% Load in CLPFD library
:- ensure_loaded(library(clpfd)).

%% This function starts the puzzle!
puzzle_solution(Rows) :-
	%% Make sure the entry is square, and of size 2x2, 3x3 or 4x4.
	length(Rows, Len), Len in 3..5, maplist(same_length(Rows), Rows),
	%% Check if the supplied puzzle fulfills the diagonal constraint.
	check_diagonal(Rows),

	%% Transpose rows to columns for later checking.
	transpose(Rows, Columns),

	%% Strip the headers of the rows and the columns (the row which contains
	%% the zero.)
	Rows = [_|Row_Tail], Columns = [_|Columns_Tail],

	%% Check for valid digits in the puzzle.
	maplist(valid_digits, Row_Tail),
	maplist(valid_digits, Columns_Tail),

	%% Check the row for product and sum.
	maplist(check_row, Row_Tail),
	maplist(check_row, Columns_Tail),

	%% Append all of the puzzle to label - flatten the list.
	append(Row_Tail, Non_Header),

	%% Label the list.
	label(Non_Header).

/*---------------------- Checking For Valid Digits -------------------------*/

%% This function checks the row for valid values. A valid value is a value 
%% is 
%% a) A digit between 1 to 9.
%% b) Not a repeating value for that row/column.
valid_digits([_|Solution]) :-
	Solution ins 1..9,
	all_distinct(Solution).

/*--------------- Checking For Product and Sum Constraints -----------------*/

%% This function checks if a supplied row (or transposed column) fulfills the
%% specified constraint where the list must sum or product to the heading of
%% the row or column (in this case, the head of the supplied list).
check_row([Head|Tail]) :-
	check_sum(Tail, Head);
	check_product(Tail, Head).

%% This function checks if the supplied row sufficiently fulfills the product
%% constraint, that is, the product of the row correctly multiples to the 
%% "Product".
check_product([],1).
check_product([H|T], Product) :-
	check_product(T, N_Product),
	Product #= N_Product * H.

%% This function checks if the supplied row sufficiently fulfills the sum
%% constraint, that is, the sum of the row correctly sums to "Sum".
check_sum([],0).
check_sum([H|T], Sum) :-
	check_sum(T, N_Sum),
	Sum #= N_Sum + H.

/*--------------- Checking the Diagonal Constraint -------------------------*/
%% This function checks for the diagonal constraint.
%% It initially checks for the zero in the top left, and then makes sure that
%% all the diagonals are the same. This is done by appending all the diagonals
%% into an array and checking the array if all elements are the same in
%% check_same().
check_diagonal([Head|Rows]) :- 
	zero_check(Head),
	diagonal(Rows, 1, []).

%% This is the function which is used for the non-heading squares. Checks an
%% element at the incremented index (the diagonal), and appends this to an 
%% array for checking later.
diagonal([Row|Tail], Index, Append_To) :-
	nth0(Index, Row, Diagonal),
	New_Index #= Index + 1,
	diagonal(Tail, New_Index, [Diagonal|Append_To]).

%% Once the diagonal has been extracted from the puzzle, check the array of 
%% diagonal values so that they are all the same.
%% NOTE: This is done at the end of diagonal() and not check_diagonal() to
%% 		 prevent an infinite loop.
diagonal([], _, Appended) :-
	check_same(Appended).

%% This function checks if everything in an array is the same value.
check_same([]).
check_same([_]).
check_same([H, X|T]) :-
	H #= X,
	check_same([X|T]).

%% Checks if the top left corner of the puzzle is Zero.
zero_check([0|_]).
