# אימון RVC מקומי ב-Windows

המסלול הזה משתמש ב-RVC הרשמי בלבד. אין Colab ואין שירות ענן לעיבוד הקול.

## 1. בדיקת חומרה

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\detect_hardware.ps1
```

## 2. התקנה

נדרשים Git ו-Python 3.12 x64.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install_rvc_local.ps1
```

הסקריפט מזהה NVIDIA מול CPU/AMD/Intel ומתקין את סט התלויות המתאים.

## 3. הפעלה

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_rvc.ps1
```

ה-WebUI המקומי עולה כברירת מחדל על פורט 7865.

## 4. אימון 7 הדקות

ב-Model Training:

- Dataset: קובץ/תיקיית ההקלטה המקומית
- Sample rate: 40k
- Version: v2
- F0: enabled
- F0 method: RMVPE
- Single speaker
- Preprocess ואז Extract ואז Train ואז Index

במחשב ללא NVIDIA, RVC תומך ב-CPU; האימון יהיה איטי יותר אך נשאר מקומי.

## 5. איכות

7 דקות יכולות לעבוד, אך RVC הרשמי ממליץ על 10 דקות ומעלה של דיבור נקי. אם אפשר להוסיף עוד 3-5 דקות מאותו דובר ובאותו מיקרופון, זה עדיף.