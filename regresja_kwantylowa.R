install.packages("quantreg")

library(quantreg)

library(readxl)
data_a <- read_excel("nieruchomosci.xlsx")
View(data_a)
data_a <- na.omit(data_a)

hist(data_a$cena, breaks = 30, main = "Histogram ceny", xlab = "Cena", col = "lightblue")

data_a$cena_log <- log(data_a$cena)

#histogram po transformacji
hist(data_a$cena_log, breaks = 30, main = "Histogram ceny (log)", xlab = "Log(Cena)", col = "lightblue")


# Wybór zmiennych do analizy
selected_vars <- data_a[, c("cena", "metraz", "liczba_pokoi", "pietro", "wiek_zabudowy", "odl_centrum",
                            "parking", "winda", "balkon", "ochrona", "komorka_lokatorska",
                            "kamienica", "apartamentowiec", "typ_zabudowy")]

# Sprawdzenie typów zmiennych
str(selected_vars)
# Obliczenie macierzy korelacji
correlation_matrix <- cor(selected_vars, use = "complete.obs")

# Wyświetlenie macierzy korelacji
print(correlation_matrix)



#Zwykla regresja MNK
regresja_mnk <- lm(
  cena_log ~ metraz + liczba_pokoi + pietro + wiek_zabudowy + odl_centrum +
    parking + winda + balkon + ochrona + komorka_lokatorska +
    kamienica + apartamentowiec+male_miasto + srednie_miasto,
  data = data_a
)

summary(regresja_mnk)

# reszty z modelu regresji
reszty <- residuals(regresja_mnk)


# Test Jarque-Bera 
install.packages("tseries")
library(tseries)
jarque.bera.test(reszty)

# Histogram reszt
hist(reszty, breaks = 30, main = "Histogram reszt", xlab = "Reszty", col = "lightblue")


install.packages("lmtest")
library(lmtest)

# Test Breuscha-Pagana
bptest(regresja_mnk)


install.packages("car")
library(car)

# Test White'a
ncvTest(regresja_mnk)




