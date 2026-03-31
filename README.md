# AI Book Scanner (Swift) — wyszukiwanie opisów książek po zdjęciu okładki

Aplikacja iOS napisana w **Swift**, która umożliwia **wgranie zdjęcia okładki książki**, a następnie wykorzystuje **Google Gemini** do **rozpoznania książki i wyszukania / wygenerowania jej opisu** na podstawie okładki.

> Aplikacja wymaga podania **Gemini API Key** w **ustawieniach aplikacji** (w środku aplikacji). Klucz **nie jest przechowywany w repozytorium**.

---

## Co robi aplikacja?

1. **Wgrywanie zdjęcia okładki**
   - Użytkownik wybiera zdjęcie okładki książki (np. z galerii).

2. **Analiza okładki przez AI (Google Gemini)**
   - Aplikacja wysyła obraz do Gemini, aby:
     - rozpoznać książkę (tytuł/autor – jeśli możliwe),
     - dopasować najbardziej prawdopodobne wyniki,
     - zwrócić opis książki (np. streszczenie, gatunek, tematyka).

3. **Prezentacja wyników**
   - Wyniki są wyświetlane w aplikacji w czytelnej formie.

---

## Czego aplikacja NIE robi

- Aplikacja **nie skanuje stron** książki.
- Aplikacja **nie wykonuje OCR treści** z wnętrza książki.
- Punktem wejścia jest **zdjęcie okładki**, a nie tekst.

---

## Zastosowane technologie / podejście

- **Swift / iOS** – aplikacja natywna
- **Import obrazu** – wybór zdjęcia okładki z urządzenia
- **Integracja z Google Gemini** – wywołania API i przetwarzanie odpowiedzi
- **Architektura warstwowa (wg struktury projektu)**
  - `App` – uruchomienie, konfiguracja
  - `Presentation` – UI
  - `Domain` – logika i modele
  - `Data` – komunikacja z API / repozytoria

---

## Wymagania

- macOS + **Xcode**
- urządzenie iOS lub Simulator
- aktywny klucz API do **Google Gemini**

---

## Konfiguracja: Gemini API Key (wymagane)

Aplikacja **nie zadziała bez** klucza API do Gemini.

### Skąd wziąć klucz?
Wygeneruj klucz w Google AI Studio / konsoli Google (Gemini API).

### Gdzie wpisać klucz?
Klucz wpisuje się **w ustawieniach aplikacji** (w samym UI aplikacji), a nie w repozytorium.

**Przykładowy flow:**
1. Otwórz aplikację
2. Wejdź w **Ustawienia / Settings**
3. Wklej **Gemini API Key**
4. Zapisz
5. Wróć do ekranu głównego i wgraj okładkę

> Uwaga: jeśli zmienisz klucz lub jest nieprawidłowy, aplikacja może zwracać błąd autoryzacji / brak wyników.

---

## Uruchomienie

1. Otwórz projekt w Xcode (`.xcodeproj` lub `.xcworkspace`)
2. Uruchom aplikację (**Run**, ⌘R)
3. W aplikacji przejdź do **Ustawienia / Settings** i wprowadź **Gemini API Key**
4. Wgraj zdjęcie okładki i sprawdź otrzymany opis

---

## Ograniczenia

- Jakość dopasowania zależy od jakości zdjęcia (światło, ostrość, kąt, zasłonięcia).
- Model może zwrócić kilka możliwych dopasowań lub odpowiedź przybliżoną.

---

## Bezpieczeństwo

- Klucz API to sekret — nie udostępniaj go publicznie.
- Warto używać klucza z ograniczeniami i monitorować wykorzystanie w Google.

---

## Licencja

Uzupełnij zgodnie z repozytorium (MIT / Apache-2.0 / prywat
