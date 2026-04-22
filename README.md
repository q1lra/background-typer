# Typer

<img width="424" height="298" alt="image" src="https://github.com/user-attachments/assets/323c8cd8-4a09-4798-a5e5-7a4e76c18c42" />

-----

## Architecture

### Background Injection

The system targets specific UI controls or top-level window handles using the `ControlSend` API. This allows for direct message queue injection, meaning the target application receives keystrokes even while minimized or out of focus.

### Anti-Detection Engine

A dynamic jitter algorithm applies random variance to base delays. It specifically recognizes whitespace characters to insert secondary micro-pauses (30ms–70ms), accurately replicating human typing rhythms to bypass behavioral analysis.

### Conditional Persistence

Settings are managed via a localized `.ini` handler. To ensure a zero-footprint installation, the configuration file is only generated if the user enters valid text, keeping your project directory clean.

### Execution Control

The utility runs on a state-aware loop, allowing for real-time pausing, resuming, or an emergency reload to terminate the input thread instantly.

-----

## Installation

1.  **Install AutoHotkey:** Download [AutoHotkey v2.0+](https://www.autohotkey.com/).
2.  **Download Script:** Save the `background-typer.ahk` file.
3.  **Run:** Double-click the `.ahk` file to launch.
4.  **Lock Target:** Focus your target window and press **F1** to lock it.
5.  **Start:** Enter your text and hit **Start Typing**.

-----

## License

This project is open-source and intended for educational use.
