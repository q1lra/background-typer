# Background Typer

<img width="504" height="350" alt="image" src="https://github.com/user-attachments/assets/63ef76fb-2618-46f9-bd3c-673beefe3f9c" />


A professional Windows utility developed in AutoHotkey v2 for simulating human-like keyboard input to background processes.

## Technical Overview

**Background Typer** utilizes the `ControlSend` API to inject keystrokes directly into a target application's message queue. This allows the utility to operate while the target window is in the background, bypassing standard copy-paste restrictions and simulating physical hardware events.

### Core Architecture

* **Background Injection:** Targets specific UI controls (e.g., `Edit1`) or top-level window handles (`HWND`) via `ahk_id`.
* **Anti-Detection Algorithm:** Implements a dynamic jitter engine. It applies a random variance to base delays and adds specific micro-pauses (30ms–70ms) following whitespace characters to replicate human typing rhythms and bypass behavioral analysis.
* **Conditional Persistence:** Managed via a `background-typer.ini` handler. To maintain a clean file system, the configuration file is only generated if the user provides text input.
* **Process Control:** Features a state-aware execution loop with real-time `Pause` and `Reload` (Emergency Stop) capabilities.

## Installation

1.  **Install AutoHotkey:** Download and install [AutoHotkey v2.0+](https://www.autohotkey.com/).
2.  **Download Script:** Save the `background-typer.ahk` source code to a folder of your choice.
3.  **Run:** Double-click the `.ahk` file to launch the utility.
4.  *(Optional)* **Compile:** Right-click the `.ahk` file and select **Compile Script** to create a standalone `.exe` executable.

## Operation Guide

1.  **Selection:** Focus the target application and press **F1** to lock the process. The status indicator will turn green upon a successful hook.
2.  **Configuration:** Enter the source text and define the base speed (default 60ms).
3.  **Execution:** Click **Start Typing**. The utility will minimize to prevent UI interference during simulation.
4.  **Control:** Use **Pause / Resume** for temporary halts or **Reset / Stop** to terminate the current execution thread.

## License

This project is open-source and intended for professional and educational use.
