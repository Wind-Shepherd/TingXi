"""Lightweight Windows EXE entry point: launches bundled HTML in Edge app mode.

Requires only Edge on the end-user PC. Python is needed for building, not running.
"""
from pathlib import Path
import os
import shutil
import subprocess
import sys
import tempfile

APP_NAME = "TingXi"
HTML_NAME = "listenloop.html"


def resource_path():
    bundle_root = Path(getattr(sys, "_MEIPASS", Path(__file__).resolve().parent))
    return bundle_root / HTML_NAME


def installed_browser():
    candidates = []
    for var in ("PROGRAMFILES(X86)", "PROGRAMFILES", "LOCALAPPDATA"):
        parent = os.environ.get(var)
        if parent:
            candidates.append(Path(parent) / "Microsoft" / "Edge" / "Application" / "msedge.exe")
    for exe in candidates:
        if exe.is_file():
            return exe
    # Rare case: Edge is installed on a nonstandard path.
    return shutil.which("msedge.exe") or shutil.which("msedge")


def show_error(message):
    try:
        from ctypes import windll
        windll.user32.MessageBoxW(None, message, "TingXi - Start error", 0x10)
    except Exception:
        print(message, file=sys.stderr)


def main():
    try:
        original = resource_path()
        if not original.is_file():
            raise FileNotFoundError("Missing bundled listenloop.html")

        # EXE --onefile extracts resources into a disposable folder, so copy HTML
        # to a persistent per-user folder before Edge opens it.
        appdata = Path(os.environ.get("LOCALAPPDATA") or tempfile.gettempdir())
        target_dir = appdata / APP_NAME
        target_dir.mkdir(parents=True, exist_ok=True)
        target = target_dir / HTML_NAME
        shutil.copyfile(original, target)
        page_uri = target.resolve().as_uri()

        browser = installed_browser()
        if browser:
            subprocess.Popen([str(browser), "--app=" + page_uri], close_fds=True)
        elif sys.platform == "win32":
            os.startfile(str(target))
        else:
            import webbrowser
            if not webbrowser.open(page_uri):
                raise RuntimeError("No browser could open the HTML file")
    except Exception as exc:
        show_error("Cannot launch TingXi.\n\n" + str(exc))
        raise SystemExit(1)


if __name__ == "__main__":
    main()
