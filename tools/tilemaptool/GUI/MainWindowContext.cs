using ImGuiNET;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

namespace TilemapTool.GUI;

internal class MainWindowContext : WindowContext
{
    private bool _isFirstFrame = true;

    private Image<Rgba32>? _currentTileset;

    public MainWindowContext()
        : base()
    {
        Window.Title = "TilemapTool";

        Window.Load += () =>
        {
            ImGuiIOPtr io = ImGui.GetIO();

            io.ConfigFlags |= ImGuiConfigFlags.DockingEnable;
            io.ConfigWindowsMoveFromTitleBarOnly = true;
        };

        Window.Render += (deltaSeconds) =>
        {
            if (ImGuiController is null)
                return;

            ImGuiController.MakeCurrent();

            // Fix docking settings not loading properly:
            if (_isFirstFrame)
            {
                ImGui.LoadIniSettingsFromDisk(ImguiSettingsFile);
                _isFirstFrame = false;
            }

            RenderMainMenuBar();
        };
    }

    private void RenderMainMenuBar()
    {
        if (!ImGui.BeginMainMenuBar())
            return;

        if (ImGui.BeginMenu("Map"))
        {
            if (ImGui.MenuItem("Open")) { }

            if (ImGui.MenuItem("Save")) { }

            if (ImGui.MenuItem("Export to 68k")) { }

            if (ImGui.MenuItem("Exit")) { }
        }

        if (ImGui.BeginMenu("Tiles"))
        {
            if (ImGui.MenuItem("Import image")) { }

            if (ImGui.MenuItem("Properties")) { }
        }
    }
}
