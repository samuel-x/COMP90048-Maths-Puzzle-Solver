% proj 2

:- ensure_loaded(library(clpfd)).

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

		%% maplist(same_length(Rows), Rows),
		%% Rows = [H|notSum],
		%% append(notSum, Vs), Vs ins 1..9.


count([], 0).
count([_|Tail], N) :-
	count(Tail, M),
	N is M+1.