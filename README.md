# Java Version Switcher for Windows (`jsw`)

A lightweight, zero-dependency, symlink-based Java version manager designed specifically for Windows (`cmd` and `PowerShell`). Inspired by `jenv`, `jsw` allows you to switch between multiple JDK versions with a single command without corrupting or cluttering your Windows system `PATH` variables.

It features **zero-config auto-detection** of newly installed JDKs, making it seamless for human developers, DevOps pipelines, and AI coding agents.

---

## ✨ Features

*   **Fast Switching:** Changes take effect instantly across all terminal windows.
*   **Auto-Registration:** Automatically scans standard Windows paths (`C:\Program Files\Java`, `Adoptium`, `Corretto`) to find new JDK installations instantly.
*   **Safe Pathing:** Modifies your system `PATH` exactly *once* using a permanent symbolic link pointer (`C:\Program Files\Java\current`).
*   **Agent-Friendly:** Predictable CLI syntax that AI coding agents can easily parse and execute.

---

## 🚀 Quick Start & Installation

### 1. Clone the Repository
Clone this repository to a permanent location on your local drive (e.g., `C:\Tools\java-version-switch`):
```bash
git clone [https://github.com/aleem-raja/java-version-switcher-windows.git)
cd java-version-switch
```

### 2. Run the Installer
Right-click install.bat and select "Run as Administrator".

The installer will automatically:

Configure your local PowerShell Execution Policy (RemoteSigned).

Map your system PATH to use the jsw utility and the active Java symlink directory.

Launch an active test terminal immediately.

## 💻 Usage Examples
List Available Versions
Type jsw or jsw list to see what JDK distributions are installed on your machine:

```DOS
jsw
```
Output:

```Plaintext
Available Java Versions:
  [8]  -> C:\Program Files\Java\jdk1.8.0_291
  [17] -> C:\Program Files\Java\jdk-17
  [21] -> C:\Program Files\Java\jdk-21
  [25] -> C:\Program Files\Java\jdk-25

Current Active Version Target: C:\Program Files\Java\jdk-17
```

## Switch Java Versions
Switch your global and local environments to a target version instantly (requires standard Windows UAC confirmation to update the symlink safely):

```DOS
jsw 21```

## Verify your active Java version:

```DOS
java -version
```

## 🛠️ Auto-Detection Mechanics
Whenever you install a new JDK (e.g., Oracle, Eclipse Temurin, Amazon Corretto), you do not need to update your paths manually. jsw dynamically crawls your system roots on every invocation.

As long as the installation directory matches the standard naming conventions (e.g., containing jdk and a version number), it will instantly appear in your list next time you type jsw.

## 🤖 Notes for Coding Agents / LLMs
Idempotency: Calling jsw <version> multiple times is completely safe and won't result in duplicate path registrations.

Environment Variables: The tool permanently binds your user-level %JAVA_HOME% to C:\Program Files\Java\current. Build tools like Maven, Gradle, and IntelliJ IDEA should be pointed to this path to inherit version switches automatically.