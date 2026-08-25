function focusVertical(dir) {
    const active = workspace.activeWindow;
    if (active && !active.onAllDesktops) {
        const a = active.frameGeometry;
        const candidates = workspace.windowList().filter(w => {
            if (w === active || w.minimized || !w.normalWindow) return false;
            if (w.output !== active.output) return false;
            if (!w.onAllDesktops && w.desktops.indexOf(workspace.currentDesktop) === -1) return false;
            const g = w.frameGeometry;
            if (g.x >= a.x + a.width || g.x + g.width <= a.x) return false;
            return dir > 0 ? g.y >= a.y + a.height : g.y + g.height <= a.y;
        });
        if (candidates.length > 0) {
            candidates.sort((p, q) => dir > 0
                ? p.frameGeometry.y - q.frameGeometry.y
                : q.frameGeometry.y - p.frameGeometry.y);
            workspace.activeWindow = candidates[0];
            return;
        }
    }
    const i = workspace.desktops.indexOf(workspace.currentDesktop);
    const next = workspace.desktops[i + dir];
    if (next !== undefined) workspace.currentDesktop = next;
}

registerShortcut("focus-down-or-desktop", "Focus window down or next desktop", "Meta+J", () => focusVertical(1));
registerShortcut("focus-up-or-desktop", "Focus window up or previous desktop", "Meta+K", () => focusVertical(-1));
