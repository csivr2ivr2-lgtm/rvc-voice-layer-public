# rvc-voice-layer-public

שכבת RVC/Applio ציבורית ונפרדת לפרויקט `tts`.

המאגר הזה לא משנה את `tts`. הרעיון הוא:

```text
Text -> existing Pocket TTS -> WAV -> RVC/Applio -> final WAV
```

## מטרה

לאמן מודל קול על כל חומר ההקלטה (למשל 7 דקות), ואז להעביר דרכו את פלט ה-TTS כדי לשפר את זהות הקול.

## מבנה

- `dataset/` - חומר האימון המקומי. מוחרג מ-Git.
- `models/` - קבצי `.pth` ו-`.index`. מוחרגים מ-Git.
- `output/` - קבצי שמע שנוצרו. מוחרגים מ-Git.
- `scripts/prepare_dataset.cmd` - ממיר הקלטה ארוכה ל-mono PCM 40 kHz.
- `scripts/train_applio.cmd` - מריץ preprocess, extract, train ו-index דרך `core.py` של Applio.
- `scripts/convert.cmd` - ממיר WAV דרך מודל RVC מאומן.

## הכנת 7 דקות ההקלטה

```cmd
scripts\prepare_dataset.cmd "C:\Aharon-TTS\voices\new-voice.wav"
```

התוצאה המקומית:

```text
dataset\newvoice\source.wav
```

## אימון עם Applio

לאחר התקנת Applio:

```cmd
set APPLIO_DIR=C:\Applio
scripts\train_applio.cmd newvoice
```

הגדרות הבסיס:

- 40 kHz
- RMVPE
- ContentVec
- 300 epochs
- batch size 4
- index algorithm: Auto

למחשב ללא NVIDIA מתאימה מומלץ לבצע את האימון על GPU בענן ולהוריד לאחר מכן את קבצי המודל.

## המרה

```cmd
scripts\convert.cmd "C:\Aharon-TTS\speech.wav" "C:\Aharon-TTS\speech-rvc.wav" "C:\Models\newvoice.pth" "C:\Models\newvoice.index"
```

המרה משתמשת כרגע ב-RMVPE, ContentVec ו-index rate של 0.75.

## פרטיות

המאגר ציבורי, ולכן קבצי קול ומודלים מוחרגים מ-Git כברירת מחדל. אל תעלה הקלטות אישיות או מודלים פרטיים למאגר.

## מצב

- [x] מאגר ציבורי נפרד
- [x] הכנת dataset
- [x] מעטפת לאימון Applio
- [x] מעטפת להמרת WAV
- [ ] Notebook לאימון GPU בענן
- [ ] API מקומי
- [ ] חיבור אופציונלי ל-tts