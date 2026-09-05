{ pkgs, ... }:

{
  home.packages = [
    pkgs.vulkan-tools
    pkgs.vulkan-tools-lunarg
    pkgs.vulkan-caps-viewer
    pkgs.vulkan-validation-layers

    pkgs.renderdoc
    pkgs.spirv-tools
    pkgs.shaderc
    pkgs.mesa-demos

    pkgs.glsl_analyzer
  ];

  home.sessionVariables.VK_ADD_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
}
