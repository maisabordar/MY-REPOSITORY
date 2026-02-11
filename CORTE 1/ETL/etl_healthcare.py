
import sqlite3
import pandas as pd

# CARGAR CSV
df = pd.read_csv('healthcare_dataset.csv')

# Crear/conectar DB SQLite y guardar tabla
conn = sqlite3.connect('healthcare.db')
df.to_sql('healthcare', conn, if_exists='replace', index=False)
conn.close()

print("✓ Base de datos SQLite 'healthcare.db' creada con la tabla 'healthcare'")
# ...existing code...



# TRANSFORMACIÓN DE DATOS
# Normalizar nombres de columnas
df.columns = (
    df.columns
    .astype(str)
    .str.strip()
    .str.lower()
    .str.replace(r'[^\w]+', '_', regex=True)
    .str.replace(r'__+', '_', regex=True)
    .str.strip('_')
)

# Mapeo de las columnas deseadas (busca coincidencias por palabra clave)
desired_keys = {
    'age': ['age', 'edad'],
    'gender': ['gender', 'sexo', 'genero', 'sex'],
    'blood_type': ['blood_type', 'bloodtype', 'tipo_de_sangre', 'blood'],
    'admission_date': ['admission_date', 'admit_date', 'fecha_de_admision', 'fecha_admision', 'admission'],
    'discharge_date': ['discharge_date', 'discharge', 'fecha_de_salida', 'fecha_salida', 'discharge_date'],
    'medication': ['medication', 'medicacion', 'medications', 'meds', 'medicamento'],
    'admission_type': ['admission_type', 'tipo_de_admision', 'admission_type', 'admission_mode'],
    'billing_amount': ['billing_amount', 'billing', 'amount', 'cost', 'bill_amount'],
    'insurance_provider': ['insurance_provider', 'insurance', 'aseguradora', 'insurance_company'],
    'medical_condition': ['medical_condition', 'condition', 'diagnosis', 'condicion_medica', 'disease']
}

col_map = {}
available = set(df.columns)

for std_name, keywords in desired_keys.items():
    found = None
    for kw in keywords:
        # buscar columnas que contengan la palabra clave
        matches = [c for c in available if kw in c]
        if matches:
            found = matches[0]
            break
    if found:
        col_map[found] = std_name

if not col_map:
    print("⚠️ No se encontraron columnas coincidentes para la transformación. Revisa los nombres del CSV.")
else:
    # Seleccionar solo las columnas encontradas
    selected_cols = list(col_map.keys())
    df_clean = df[selected_cols].rename(columns=col_map)

    # Convertir fechas
    for dcol in ['admission_date', 'discharge_date']:
        if dcol in df_clean.columns:
            df_clean[dcol] = pd.to_datetime(df_clean[dcol], errors='coerce')

    # Normalizar billing_amount a numérico
    if 'billing_amount' in df_clean.columns:
        df_clean['billing_amount'] = (
            df_clean['billing_amount']
            .astype(str)
            .str.replace(r'[^\d\.\-]', '', regex=True)
        )
        df_clean['billing_amount'] = pd.to_numeric(df_clean['billing_amount'], errors='coerce')

    # Rellenar valores faltantes simples (opcional, puedes ajustar)
    # Ejemplo: gender -> 'unknown', age -> median
    if 'gender' in df_clean.columns:
        df_clean['gender'] = df_clean['gender'].fillna('unknown').astype(str)
    if 'age' in df_clean.columns:
        if pd.api.types.is_numeric_dtype(df_clean['age']):
            median_age = df_clean['age'].median(skipna=True)
            df_clean['age'] = df_clean['age'].fillna(median_age)
        else:
            df_clean['age'] = pd.to_numeric(df_clean['age'], errors='coerce')
            median_age = df_clean['age'].median(skipna=True)
            df_clean['age'] = df_clean['age'].fillna(median_age)

    # Eliminar duplicados
    df_clean = df_clean.drop_duplicates().reset_index(drop=True)

    # Guardar CSV limpio y actualizar SQLite con la tabla limpia
    clean_csv = 'healthcare_cleaned.csv'
    df_clean.to_csv(clean_csv, index=False)

    conn = sqlite3.connect('healthcare.db')
    df_clean.to_sql('healthcare_cleaned', conn, if_exists='replace', index=False)
    conn.close()

    print(f"✓ Transformación completa. CSV limpio guardado como '{clean_csv}' y tabla 'healthcare_cleaned' en healthcare.db")

print(df.head(10))


