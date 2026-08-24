{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vulkan-tools
    vulkan-tools-lunarg
    vulkan-caps-viewer
    vulkan-validation-layers

    renderdoc
    spirv-tools
    shaderc
    mesa-demos

    glsl_analyzer
  ];

  home.sessionVariables.VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
}
