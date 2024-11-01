using ImGuiNET;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using TilemapTool.Context;
using TinyFileDialogsSharp;

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
            RenderEditors();
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

            if (ImGui.MenuItem("Save As")) { }

            if (ImGui.MenuItem("Properties")) { }

            ImGui.Separator();

            if (ImGui.MenuItem("Exit"))
            {
                if (!ContextHandler.IsSaved)
                {
                    MessageBoxButton result = TinyFileDialogs.MessageBox(
                        title: "Warning",
                        message: "The map has not been saved, do you want to save it first?",
                        dialogType: DialogType.YesNoCancel,
                        iconType: MessageIconType.Warning,
                        defaultButton: MessageBoxButton.OkYes
                    );

                    if (result == MessageBoxButton.NoCancel)
                    {
                        ImGui.EndMenu();
                        ImGui.EndMainMenuBar();
                        return;
                    }

                    if (result == MessageBoxButton.OkYes)
                    {
                        // TODO: Save
                    }
                }

                WindowManager.Stop();
            }

            ImGui.EndMenu();
        }

        ImGui.EndMainMenuBar();
    }

    private void RenderEditors()
    {
        RenderTileSetSelector();
        RenderMapEditor();
    }

    private void RenderTileSetSelector() { }

    private void RenderMapEditor() { }
}
