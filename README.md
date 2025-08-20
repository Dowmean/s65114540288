# Clone

```bash
gh repo clone Dowmean/65114540288-ST
```
## 🔧 Backend Setup

**1. ดาวน์โหลด AccountKey JSON**  
🔗 [Download Firebase AccountKey](https://drive.google.com/file/d/1_0OHrLCTuEjSL1zXgBeeCJrLJ0OFYdXY/view?usp=sharing)

- วางไฟล์ `serviceAccountKey.json` ไว้ที่  
\backend_api\` *(ที่เดียวกับ `server.js`)*

# Docker

```bash
docker-compose down --volumes --remove-orphans

docker-compose build --no-cache

docker-compose up -d
```

# Hiwmai Project Setup

> ⚠️ **หมายเหตุ: ทุกอย่างใน README นี้จำเป็นต้องลงให้ตรงเวอร์ชันที่ระบุไว้เท่านั้น**

## 🧰 Install Dependencies

### Tools
- **Dart**: `3.5.4`  
- **Flutter**: `3.27.3` ([Download archive](https://docs.flutter.dev/install/archive))
- **DevTools**: `2.37.3`
- **Java JDK**: `jdk-17.0.12` ([Download](https://www.techspot.com/downloads/7440-java-se-17.html))
- **Android Studio**: [https://developer.android.com/studio](https://developer.android.com/studio)
- **Visual Studio Code**: [https://code.visualstudio.com/download](https://code.visualstudio.com/download)
- **MySQL**: [https://www.mysql.com/downloads/](https://www.mysql.com/downloads/)

## 🖥️ Environment
แบบละเอียด [https://docs.google.com/document/d/1jPUan9GOPwN2sT-UiuWq600-I_xM3JJg/edit?usp=sharing&ouid=101967806734429222371&rtpof=true&sd=true)
![Environment Image](https://github.com/user-attachments/assets/e17518ef-42a3-4c30-b7e3-880d93360206)

## 📱 Android Studio

- Android Emulator  
- Android SDK Build-Tools `36-rc1`  
- Android SDK Commandline Tools  
- Android SDK Platform Tools  
- Android Emulator Hypervisor Driver (installed)

![Android Studio Image 1](https://github.com/user-attachments/assets/ee55247c-deb7-434e-9e8e-b1c9ea6c0188)  
![Android Studio Image 2](https://github.com/user-attachments/assets/065ea24b-75f0-4e34-b2e7-6f83aa12e931)

## 🔌 Visual Studio Code Extensions

- Dart  
- Flutter  
- Gradle for Java  
- Flutter Widget Snippets

# 🚀 How to Run

---



## 💻 Frontend (Flutter)

### 🔓 เปิด Developer Mode (Windows)

**วิธีที่ 1: ใช้คำสั่งลัด**
- กด `Windows + R`
- พิมพ์: `ms-settings:developers` → กด Enter
- เปิด **Developer Mode** → กด **Yes** ถ้ามี popup

**วิธีที่ 2: ผ่าน Settings**
- ไปที่ Settings →  
  `Privacy & Security > For Developers`  
- เปิด **Developer Mode** → กดยืนยันถ้ามี popup

📌 **หมายเหตุ:** ต้องใช้สิทธิ์ Admin  
📌 Developer Mode จำเป็นสำหรับใช้งาน symlink ใน Flutter plugins

---

### 🔁 Flutter Setup

1. กด `Ctrl + Shift + P` → พิมพ์ `Flutter: Select Device`  
2. เลือก Device ตามภาพ  
   ![Flutter Device](https://github.com/user-attachments/assets/3b2a90ad-7aed-4df0-a09b-5c094004c6f7)
  หรือ emulator API35ขึ้นไป
3. รันคำสั่ง:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🛠️ หากพบปัญหา

### 🚫 Gradle Plugin Not Found

**ข้อความ Error:**
```
Plugin [id: 'com.android.application', version: '8.1.0'] was not found
```

**วิธีแก้ (เน็ตองค์กรอาจโดนบล็อก):**  
เพิ่มใน `android/settings.gradle` ใน `pluginManagement`:
```gradle
maven { url 'https://maven.aliyun.com/repository/google' }
maven { url 'https://maven.aliyun.com/repository/central' }
maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
google()
mavenCentral()
gradlePluginPortal()
```

---

### 🔐 Firebase API Key

อย่าลืมวางไฟล์ serviceAccountKey.json ที่:  
\backend_api\` *(ที่เดียวกับ `server.js`)*

---

### ⚠️ CERTIFICATE_VERIFY_FAILED (SSL)

**ข้อความ Error:**
```
CERTIFICATE_VERIFY_FAILED: unable to get local issuer certificate
```
**วิธีแก้ชั่วคราว (เฉพาะ dev เท่านั้น):**
📌 สาเหตุ: รันบนเครื่อง local (ไม่มีใบรับรอง SSL จริง)

หากต้องการจะรันจริงๆ  ต้องปิดการตรวจสอบ SSL ด้วย NODE_TLS_REJECT_UNAUTHORIZED=0 

** ให้รันคำสั่งนี้ใน Terminal ก่อนรันโปรเจกต์

**Windows:**
```cmd
set NODE_TLS_REJECT_UNAUTHORIZED=0
```
# เสร็จแล้วรันใหม่
