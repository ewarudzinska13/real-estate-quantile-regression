list
describe

//histogram zmiennej cena
histogram cena, normal freq title("Histogram zmiennej cena")

//nakładam logarytm na zmienną cena
gen ln_cena = log(cena)

histogram ln_cena, normal freq title("Histogram zlogarytmowanej zmiennej cena")

/*Standardowa regresja + zapisanie wynikow*/
regress ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto
estimates store MNK

/*BSQREG - Regresja kwantylowa z bootstrapowana macierza wariancji-kowariancji */
bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.05) reps(200)
estimates store Q05

bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.1) reps(200)
estimates store Q10

bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.25) reps(200)
estimates store Q25

bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.50) reps(200)
estimates store Q50

bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.75) reps(200)
estimates store Q75

bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.90) reps(200)
estimates store Q90

bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.95) reps(200)
estimates store Q95


/*SQREG - Regresja kwantylowa z bootstrapowana macierza wariancji-kowariancji rownoczesnie dla wielu kwantyli - najwygodniejsza komenda w Stacie do regresji kwantylowej*/
sqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, quantile(0.05 0.1 0.25 0.5 0.75 0.9 0.95) reps(200)


estimates table MNK Q05 Q10 Q25 Q50 Q75 Q90 Q95, p



esttab MNK Q05 Q10 Q25 Q50 Q75 Q90 Q95 



/*GRQREG */
ssc install grqreg

/*a potem rysowanie wykresow z roznymi opcjami*/ 
bsqreg ln_cena metraz liczba_pokoi pietro wiek_zabudowy odl_centrum parking winda balkon ochrona komorka_lokatorska kamienica apartamentowiec male_miasto srednie_miasto, reps(200)
/*dodanie oszacowan MNK i przedzialow ufnosci*/
grqreg, cons ols ci olsci reps(20)

/*prezentacja tylko dla wybranych zmiennych*/
grqreg metraz, ols ci olsci reps(20)

grqreg liczba_pokoi, ols ci olsci reps(20)

grqreg pietro, ols ci olsci reps(20)

grqreg wiek_zabudowy, ols ci olsci reps(20)

grqreg odl_centrum, ols ci olsci reps(20)

grqreg parking winda balkon ochrona komorka_lokatorska, ols ci olsci reps(20)

grqreg apartamentowiec kamienica, ols ci olsci reps(20)

grqreg male_miasto srednie_miasto, ols ci olsci reps(20)


























