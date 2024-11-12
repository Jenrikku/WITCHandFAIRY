using ImGuiNET;
using Silk.NET.OpenGL;
using TilemapTool.Context;
using TinyFileDialogsSharp;

namespace TilemapTool.GUI;

internal class MainWindowContext : WindowContext
{
    private bool _isFirstFrame = true;

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

            GL!.BindFramebuffer(FramebufferTarget.Framebuffer, 0);
            GL!.Clear(ClearBufferMask.ColorBufferBit);
            GL!.Viewport(Window.FramebufferSize);
            ImGuiController.Render();
        };
    }

    public override bool Close()
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
                return false;
            }

            if (result == MessageBoxButton.OkYes)
            {
                // TODO: Save
            }
        }

        return true;
    }

    private void RenderMainMenuBar()
    {
        if (!ImGui.BeginMainMenuBar())
            return;

        if (ImGui.BeginMenu("Map"))
        {
            if (ImGui.MenuItem("New"))
                New();

            if (ImGui.MenuItem("Open"))
                OpenFile();

            if (ImGui.MenuItem("Save"))
                SaveFile(ContextHandler.SavePath);

            if (ImGui.MenuItem("Save As"))
                SaveFile(); // No path so always ask the user.

            if (ImGui.MenuItem("Properties"))
                ImGui.OpenPopupOnItemClick("Properties");

            ImGui.Separator();

            if (ImGui.MenuItem("Exit"))
                WindowManager.Stop();

            ImGui.EndMenu();
        }

        ImGui.EndMainMenuBar();
    }

    private void New() {
        ContextHandler.BTM
    }

    private bool OpenFile()
    {
        bool success = TinyFileDialogs.OpenFileDialog(
            out string[]? output,
            title: "Choose the map file to open",
            filterPatterns: ["*.btm"],
            filterDescription: "Binary Tile Map (*.btm)"
        );

        if (!success || output is null || output.Length <= 0)
            return false;

        ContextHandler.ReadBTM(output[0]);
        return true;
    }

    private bool SaveFile(string? path = null)
    {
        if (path is null)
        {
            bool success = TinyFileDialogs.SaveFileDialog(
                out path,
                title: "Choose where to save the map file",
                filterPatterns: ["*.btm"],
                filterDescription: "Binary Tile Map (*.btm)"
            );

            if (!success || path is null)
                return false;
        }

        ContextHandler.WriteBTM(path);
        return true;
    }

    private void RenderEditors()
    {
        RenderTileSetSelector();
        RenderMapEditor();
    }

    private void RenderTileSetSelector() { }

    private void RenderMapEditor() { }
}
