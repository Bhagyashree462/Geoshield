# 🏔️ GeoShield — AI-Based Landslide Early Warning & Real-Time Disaster System

**Full-Stack AI-Based Landslide Early Warning, Geolocation Tracking, and Multi-Sensor Risk Monitoring System**

> Real-time landslide risk assessment, environmental sensor telemetry fusion, OpenWeatherMap & Open-Meteo weather integration, OpenRouteService emergency evacuation routing, Groq LLM-powered conversational disaster guidance, and global browser GPS tracking.

---

## ✨ Key System Features

### 🤖 1. Groq LLM AI Assistant & Multilingual Bulletin Generator
- **Interactive AI Assistant (`AIChatbot.tsx`)**: Conversational real-time safety advisor powered by Groq API (`llama-3.1-8b-instant` / `qwen-2.5-32b`). Automatically injects live weather and district telemetry context.
- **Multilingual Emergency Alerts**: Generates urgent 2-sentence public warning bulletins in **Assamese, Bengali, Hindi, English, Mizo, and Khasi**.
- **Clean AI Output**: Automatic `<think>` tag filtering for professional output.

### 📍 2. Global & Nationwide Browser Geolocation Tracking
- **Real-Time GPS Location (`navigator.geolocation`)**: Instant location access button on the dashboard for users anywhere in India or worldwide.
- **Reverse Geocoding**: Automatically resolves user coordinates `(Latitude, Longitude)` into city, district, state, and country names.
- **Dynamic Live Risk Zone Creation (`createCustomUserRiskZone`)**: Generates an on-the-fly custom risk zone (`USER-GPS-LIVE`) for the user's location, computing live slope stability and risk scores based on real-time weather and soil saturation.

### 🌤️ 3. Multi-Source Atmospheric & Soil Moisture Telemetry
- **OpenWeatherMap Integration**: Live temperature, humidity, atmospheric pressure, wind speed, and 1-hour rainfall.
- **Open-Meteo API Service**: High-resolution 7-day hourly soil moisture (27–81 cm depth), soil temperature (54 cm depth), wind gusts, and precipitation forecasts.

### 🗺️ 4. OpenRouteService GIS Routing & Isochrones
- **Emergency Evacuation Routes**: Calculates real-time driving/walking routes from high-risk points to nearest elevated safe shelters.
- **Reachability Isochrones**: Generates 5-minute, 15-minute, and 30-minute emergency reachability polygons overlaying Leaflet GIS maps.

### 🗄️ 5. MongoDB Atlas Document Persistence & Offline Sync
- Persistent document storage for citizen hazard reports, telemetry snapshots, and active emergency alerts.
- Offline-first browser queueing with automatic re-sync when network connectivity recovers.

---

## 🌍 Operational Coverage & Risk Zones

Monitors 15 core districts across the 8 North-Eastern Region (NER) states as well as **any custom user coordinates globally**:

| State | Monitored Districts | Primary Geology | Risk Category |
|-------|---------------------|-----------------|---------------|
| **Arunachal Pradesh** | Tawang, Papum Pare | Pre-Cambrian Gneiss & Mica Schist | Critical (>80%) |
| **Assam** | Dima Hasao, Karbi Anglong | Disang Shale & Tertiary Sandstone | High (60–80%) |
| **Meghalaya** | East Khasi Hills, West Jaintia Hills | Shillong Group Quartzite | Critical (>80%) |
| **Mizoram** | Aizawl, Champhai | Surma Group Siltstone & Sandstone | High (60–80%) |
| **Sikkim** | Gangtok, Mangan (North Sikkim) | Daling Group Phyllite & Lingtse Gneiss | Critical (>80%) |
| **Nagaland** | Kohima, Tuensang | Disang Flysch & Jopi Siltstone | High (60–80%) |
| **Manipur** | Noney, Churachandpur | Disang Flysch & Barail Sandstone | Critical (>80%) |
| **Tripura** | North Tripura | Tipam Group Sandstone | Moderate (40–60%) |
| **Global GPS** | *Dynamic User Location* | *Local Soil & Bedrock Formation* | *Real-Time Calculated* |

---

## 🛠️ Architecture & Tech Stack

### **Frontend (Next.js 16)**
- **Framework**: Next.js 16 (App Router) + TypeScript
- **Styling**: Tailwind CSS v4 + Dark Glassmorphic Theme System
- **Geospatial GIS**: Leaflet & `react-leaflet` with custom vector markers, reachability isochrones, and evacuation route polylines
- **Icons**: Lucide React icon suite

### **Backend (FastAPI & Python)**
- **Framework**: FastAPI + Pydantic v2
- **AI Engine**: Groq Cloud API (`httpx` asynchronous client with multi-model fallback)
- **Database**: MongoDB Atlas (`motor` async driver)
- **Weather Services**: OpenWeatherMap API & Open-Meteo SDK (`openmeteo_requests`, `requests_cache`, `retry_requests`)
- **GIS Routing Engine**: OpenRouteService API

---

## 📡 Primary FastAPI Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/risk-zones` | `GET` | Returns 15 geolocated NER risk zones + live calculated metrics. |
| `/api/ai/chat` | `POST` | Groq AI chatbot assistant endpoint with context-aware telemetry injection. |
| `/api/ai/generate-bulletin` | `POST` | Multilingual emergency alert bulletin generator (6 languages). |
| `/api/weather/live` | `GET` | Real-time OpenWeatherMap atmospheric feed for target `(lat, lon)`. |
| `/api/weather/openmeteo` | `GET` | Open-Meteo 7-day soil moisture (27–81cm), soil temp, and hourly rain forecasts. |
| `/api/gis/evacuation-route` | `GET` | OpenRouteService evacuation path calculation to nearest safe shelter. |
| `/api/gis/isochrones` | `GET` | OpenRouteService reachability polygons (5, 15, 30 mins). |
| `/api/reports/submit` | `POST` | Receives community field incident reports with reverse-geocoded district assignment. |

---

## 🚀 Quick Start Guide

### 1. Configure Environment Variables

**Backend (`backend/.env`)**:
```env
GROQ_API_KEY=gsk_your_groq_api_key
OPENWEATHER_API_KEY=your_openweather_api_key
OPENROUTE_API_KEY=your_openroute_service_key
MONGODB_URI=mongodb+srv://your_mongodb_atlas_uri
```

**Frontend (`frontend/.env.local`)**:
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_GROQ_API_KEY=gsk_your_groq_api_key
```

### 2. Launch FastAPI Backend
```bash
cd backend
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS / Linux
pip install -r requirements.txt
python -m uvicorn app.main:app --reload --port 8000
```
- **Backend Base**: http://localhost:8000
- **Interactive Swagger Docs**: http://localhost:8000/docs

### 3. Launch Next.js Frontend
```bash
cd frontend
npm install
npm run dev
```
- **Frontend Dashboard**: http://localhost:3000

---

## 📁 Repository Structure

```
GeoShield/
├── frontend/                   # Next.js 16 App Router UI
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx        # GeoShield Landing Page (EN/HI/AS/BN)
│   │   │   ├── dashboard/      # Interactive Risk Dashboard & Telemetry Inspector
│   │   │   ├── reports/        # Offline-First Citizen Incident Reporter
│   │   │   └── alerts/         # Active Emergency Warnings Feed
│   │   ├── components/
│   │   │   ├── RiskMap.tsx     # Color-Coded Leaflet GIS Map with Isochrones & Routes
│   │   │   ├── TelemetryPanel.tsx # Weather & AI Bulletin Telemetry Inspector
│   │   │   ├── AIChatbot.tsx   # Floating Groq AI Chatbot Assistant Widget
│   │   │   └── FilterControls.tsx # Filters & Geolocation Access Control
│   │   └── lib/
│   │       └── api.ts          # Strongly-typed API client & Geolocation helpers
├── backend/                    # FastAPI Server
│   ├── app/
│   │   ├── main.py             # Entrypoint & Router Registrations
│   │   ├── routers/            # Routers (ai, weather, gis, risk_zones, alerts, reports)
│   │   └── services/           # Services (openmeteo_service, openroute_service, weather_service)
│   └── requirements.txt        # Python dependencies
└── README.md
```

---

Built for Global & Regional Landslide Disaster Risk Reduction 🇮🇳
