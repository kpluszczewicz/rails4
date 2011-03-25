# Monkey Presents

Aplikacja internetowa umożliwiająca użytkownikom tworzenie, gromadzenie oraz wyświetlanie prezentacji.
Projekt został stworzony na potrzeby zajęć na Uniwersytecie Gdańskim „Architektura serwisów internetowych”.

## Nazwa

Projekt zyskał nazwę taką jaką ma, dzięki burzy mózgów, jaka odbyła się na jednych zajęciach laboratoryjnych.
Ogólnie nazwa bardzo dobrze odzwierciedla istotę projektu. Chodzi o zwinne, spytne tworzenie prezentacji, bez zagłębiania się w
przyciężkawe edytory typu Powerpoint czy nawet Openoffice. A jakie zwierzę jest tak zwinne i sprytne jak nie poczciwa małpa?

## Opis projektu

Aplikacja umożliwia stworzenie konta oraz kreowanie prezentacji w oparciu o język znaczników markdown. Autor w chwili pisania ma przed oczami poglądowy pogląd (znaczy to tyle, że nie w pełni odzwierciedla on wynik końcowy, aczkolwiek jest bardzo do niego zbliżony).

Twórca prezentacji może ją odtworzyć w przeglądarce. Jeśli tylko przeglądarka umożliwia włączenie trybu pełnoekranowego (a każdy współcześnie liczący się program tego typu dostarcza taką funkcjonalność), to mamy dostęp do całkiem sprytengo narzędzia, dzięki któremu możemy tworzyć prezentacje. Szybko i bezboleśnie. Nie potrzeba do tego żadnych wtyczek (Flash, Java).

Alikacja posiada jedną funkcję, którą z angielska można określić jako sweetspot (jak dla mnie jest to bardziej wisienka na torcie). Otóż osoba, która uruchomi prezentację (najpewniej jej twórca, zwany dalej prelegentem), umożliwia innym użytkownikom podgląd na żywo na swoich komputerach. Oglądający jednak, nie mogą dowolnie nawigować po poszczególnych przeźroczach. To prelegent zmieniając bieżący slajd powoduje zmianę podglądu na komputerach obserwatorów.

## Użyte technologie

Projekt został zbudowany na fundamencie Rails 3. Wsparliśmy się dodatkowo następującymi gemami:

* devise
* simple_form
* will_paginate
* makers-mark
* open4
* albino
* nokogiri
* cancan
* eventmachine
* rack
* acts-as-tagable-on

(na pewno nie wszystkie są potrzebne, ale takie jest extreme programming ;)

Funkcjonalność RealTime jest osiągnięta dzięki gemowi [Faye](http://faye.jcoglan.com/).

## Status obecny

Projekt nie został ukończony w sensie produkcyjnym. Posiada błędy, które należałoby naprawić. Tym zajmuje się lider zespołu (Kamil Pluszczewicz), który po usprawnieniu aplikacji i refaktoryzacji kodu ma zamiar użyć go w swojej pracy magisterskej.

## Autorzy

* Krzysztof Dermont (erihel)
* Łukasz Draba (eaplokryo)
* Aleksander Wierucki (awieruck)
* Kamil Pluszczewicz (borch)
