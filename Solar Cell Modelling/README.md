# 🌞 Solar PV Module Performance Analysis (MATLAB)

This project models and analyzes the performance of a solar photovoltaic (PV) module using MATLAB. It investigates how temperature and irradiance affect the current, voltage, power output, efficiency, and fill factor of the solar module.

---

## 📌 Overview

The simulation uses key parameters such as:

- Temperature coefficient
- Vmpp (Voltage at Maximum Power Point)
- Impp (Current at Maximum Power Point)
- Voc (Open-circuit voltage)
- Isc (Short-circuit current)

The relationship between **current**, **voltage**, and **power** is explored across different environmental conditions.

---

## 🔍 Project Focus

1. **Current and Power Behavior**  
   - How current and power change with temperature and irradiance.

2. **Temperature Dependence**  
   - Tested at 298 K, 318 K, and 343 K.

3. **Irradiance Dependence**  
   - Simulated at 1000 W/m², 650 W/m², and 300 W/m².

4. **Efficiency and Fill Factor**  
   - Calculated to evaluate the module’s performance quality.

---

## 📊 Key Observations

### 🔺 Temperature Effects

- Voc decreases with increasing temperature.
- Isc remains constant or increases slightly.
- Overall power output and efficiency drop as temperature rises.

### 🔆 Irradiance Effects

- Isc and power increase with irradiance.
- Voc increases slightly, but not significantly.
- Power output is highly sensitive to irradiance levels.

---

## 📈 Plots Generated

1. **I-V and P-V Characteristics** under:
   - Standard Test Conditions (1000 W/m², 298 K)
   - Higher Temperatures (318 K, 343 K)
   - Lower Irradiance (650 W/m², 300 W/m²)


---

## 🧠 Results Summary

- Efficiency and fill factor decline as temperature increases.
- Output power is significantly reduced at low irradiance.
- Optimal module performance occurs at STC (1000 W/m², 298 K).

---

## ⚙️ Functions Used in MATLAB

- `IrradianceCurrent()` – Calculates photonic current
- `ReverseCurrentSTC()` – Gets reverse saturation current at STC
- `ReverseCurrent()` – Adjusts reverse current for various temperatures
- `currentNewton()` – Uses Newton-Raphson method to solve for current
- `PVmod()` – Simulates current output for voltage, temp, and irradiance
- `modelDesigner()` – Designs values for Rs, Rsh, and ideality factor

---

## ▶️ How to Run

1. Open MATLAB.
2. Run the main script provided.
3. Choose the scenario (temperature & irradiance).
4. View generated plots and performance metrics.

---

## ✅ Conclusion

This project demonstrates how solar PV module performance is heavily influenced by temperature and irradiance. It highlights the importance of environmental optimization for efficient energy production.

