Här är ditt skräddarsydda Git Cherry-Pick & PR Cheat Sheet.
Det är uppdelat i ditt dagliga flöde på Macen (marineringen) och själva PR-processen när koden har legat till sig och blivit redo för världen.
------------------------------

## 📑 Git Worktree & Cherry-Pick Cheat Sheet## 🧠 Gyllene regeln: Atomiska Commits

Blanda aldrig Mac-specifika ändringar och globala ändringar i samma commit. Gör separata, renodlade commits i ~/.config så att de är lätta att plocka ut senare.
------------------------------

## 💻 1. Det dagliga flödet (Marineringen)

Du jobbar, testar och säkrar dina filer live i ~/.config.

- Se vad du har ändrat just nu:

cd ~/.config && git status

- Spara en global ändring (som ska marineras):

git add .zshrc
git commit -m "feat: optimerat historik-inställningar för zsh"
git push

- Spara en Mac-specifik ändring (som stannar här för alltid):

git add skärmlayout.sh
git commit -m "mac: specifik upplösning för m4-skärmen"
git push

---

## 🚀 2. PR-flödet (När koden har marinerat klart)

När du känner att en global ändring är stabil och ska skickas till GitHub via en Pull Request.

## Steg A: Hitta rätt commit

Gå till din Mac-mapp och kopiera ID-hashen (t.ex. a1b2c3d) för den commit du vill lyfta upp.

cd ~/.config
git log --oneline -n 15

## Steg B: Skapa en temporär arbetsyta från main

Gå till din projektmapp, hämta det senaste från GitHub, och vik ut en tillfällig feature-branch i en ny mapp.

cd ~/projects/dotfiles
git fetch origin

# Skapa den tillfälliga mappen 'temp-pr' kopplad till en ny branch

git worktree add ~/projects/temp-pr -b feature/zsh-optimering origin/main

## Steg C: Körsbärsplocka och pusha

Gå in i den tillfälliga mappen, stjäl din gamla commit, och skicka upp den till GitHub.

cd ~/projects/temp-pr

# Plocka över ändringen (ersätt med din faktiska commit-hash)

git cherry-pick a1b2c3d

# Pusha din rena feature-branch till GitHub

git push origin feature/zsh-optimering

## Steg D: Skapa PR på GitHub

1.  Öppna webbläsaren och gå till ditt dotfiles-repo på GitHub.
2.  Skapa en ny Pull Request.
3.  Sätt base: main ➔ compare: feature/zsh-optimering.
4.  Granska din diff (den ska vara helt ren), klicka på Create PR och sedan Merge.

---

## 🧹 3. Städning och synkning (Efter din PR)

När din PR är godkänd och mergad på GitHub stänger du cirkeln på din dator.

- Ta bort den temporära arbetsytan:

# Git ser till att du inte förlorar något viktigt innan den raderar mappen

git worktree remove ~/projects/temp-pr

# Ta bort den lokala feature-branchen

git branch -d feature/zsh-optimering

- Hämta hem det nya till din levande Mac-miljö:

cd ~/.config
git fetch origin

# Detta slår ihop main med din Mac-branch helt ljudlöst och utan konflikter

git merge origin/main

# Pusha upp din Mac-branch igen så GitHub vet att den är i fas med main

git push

---

Spara detta i en markdown-fil eller skriv ut det. När du har gjort den här loopen 2–3 gånger kommer det att sitta helt i ryggmärgen på dig.
Vill du att vi kikar på hur du kan korta ner Steg B och Steg C till ett litet bash-skript/alias så du slipper skriva ut hela worktree-sökvägen varje gång, eller är du redo att köra skarpt?
