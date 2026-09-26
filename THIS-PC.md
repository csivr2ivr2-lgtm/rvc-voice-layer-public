# מסלול מקומי למחשב i5-7500 / 12GB / Intel HD 630

בחומרה הזו ברירת המחדל היא CPU לצורך יציבות. RVC הרשמי תומך ב-Windows עם Python 3.12 ובסט התלויות CPU/AMD/Intel.

## התקנה ללא Git

נדרש Python 3.12 x64.

מתוך עותק המאגר הזה:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install_this_pc.ps1
```

הסקריפט מוריד את RVC הרשמי כ-ZIP, יוצר venv, מתקין את סט ה-CPU, ומוריד HuBERT/RMVPE/pretrained.

## הפעלה

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start_this_pc.ps1
```

ה-WebUI אמור להיפתח מקומית בפורט 7865.

## פרופיל אימון מומלץ

- Single speaker
- Version v2
- Sample rate 40k
- F0 enabled
- RMVPE
- CPU
- Batch size 2 להתחלה
- Cache dataset in GPU: כבוי
- 200 epochs להתחלה
- Save every 20 epochs

אם יש שגיאת זיכרון, הורד batch size ל-1. אם הכול יציב, אפשר לבדוק batch size 3-4.

## Dataset

השתמש בכל 7 הדקות. RVC יחתוך את ההקלטה למקטעים כחלק מ-preprocess; אין צורך לחתוך ידנית ל-12 שניות.