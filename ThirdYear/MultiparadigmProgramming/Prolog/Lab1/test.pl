male(yaroslav).
male(oleksii).
male(volodymyr).
male(mykhailo).
male(svyatoslav).
male(borys).
male(glib).
male(serhii).

female(hanna).
female(natalya).
female(olha).
female(svitlana).
female(tetyana).
female(maryna).
female(josypyna).

roditel(hanna,volodymyr).
roditel(hanna,maryna).
roditel(yaroslav,volodymyr).
roditel(yaroslav,maryna).
roditel(natalya,svitlana).
roditel(natalya,tetyana).
roditel(oleksii,svitlana).
roditel(oleksii,tetyana).
roditel(olha,josypyna).
roditel(mykhailo,josypyna).
roditel(tetyana,svyatoslav).
roditel(tetyana,borys).
roditel(volodymyr,svyatoslav).
roditel(volodymyr,borys).
roditel(svyatoslav,glib).
roditel(svyatoslav,serhii).
roditel(josypyna,glib).
roditel(josypyna,serhii).

isParentAndHasParent(X):-roditel(X,_), roditel(_,X).
hasNoChild(X):-parent(_, X), \+ roditel(X,_).

father(X,Y):-roditel(X,Y), male(X).
mother(X,Y):-roditel(X,Y), female(X).
parent(X,Y):-father(X,Y); mother(X,Y).
son(X,Y):-roditel(Y,X), male(X).
daughter(X,Y):-roditel(Y,X), female(X).
child(X,Y):-son(X,Y); daughter(X,Y).
brother(X,Y):-roditel(Z,X), roditel(Z,Y), male(X), \+ X = Y.
sister(X,Y):-roditel(Z,X), roditel(Z,Y), female(X), \+ X = Y.
relative(X,Y):-brother(X,Y); sister(X,Y).
uncle(X,Y):-parent(Z,Y), brother(X,Z).
aunt(X,Y):-parent(Z,Y), sister(X,Z).
grandfather(X,Y):-parent(Z,Y), father(X,Z).
grandmother(X,Y):-parent(Z,Y), mother(X,Z).
grandson(X,Y):-child(Z,Y), son(X,Z).
granddaughter(X,Y):-child(Z,Y), daughter(X,Z).
nephev(X,Y):-relative(Y,Z), son(X,Z).
niece(X,Y):-relative(Y,Z), daughter(X,Z).
merried(X,Y):-child(Z,X), child(Z,Y), \+ X = Y.
husband(X,Y):-merried(X,Y), male(X).
wife(X,Y):-merried(X,Y), female(X).
tescha(X,Y):-wife(Z,Y), mother(X,Z).
test(X,Y):-wife(Z,Y), father(X,Z).
svekruha(X,Y):-husband(Z,Y), mother(X,Z).
svekr(X,Y):-husband(Z,Y), father(X,Z).
zyat(X,Y):-daughter(Z,Y), husband(X,Z).
nevistka(X,Y):-son(Z,Y), wife(X,Z).
diaver(X,Y):-husband(Z,Y), brother(X,Z).
svoyak(X,Y):-wife(Z,Y), sister(X,Z), husband(X,J).
svoyachka(X,Y):-wife(Z,Y), sister(X,Z).
grandnephew(X,Y):-child(Z,Y), grandson(X,Z).
grandniece(X,Y):-child(Z,Y), granddaughter(X,Z).
