{
  config,
  jq,
  writeShellApplication,
}:

writeShellApplication {
  name = "swap-workspace-windows";
  runtimeInputs = [
    jq
    config.wayland.windowManager.hyprland.finalPackage
  ];
  text = /* sh */ ''
    SOURCE_WORKSPACE_START=$1
    TARGET_WORKSPACE_START=$2
    COUNT=$3

    for i in $(seq 0 $((COUNT - 1))); do
      SOURCE_WORKSPACE=$((SOURCE_WORKSPACE_START + i))
      TARGET_WORKSPACE=$((TARGET_WORKSPACE_START + i))

      WINDOW_IDS_SRC=$(hyprctl clients -j | jq -r --arg workspace "$SOURCE_WORKSPACE" '.[] | select(.workspace.name == $workspace) | select((.grouped | length) == 0 or .address == (.grouped[0])) | .address')
      WINDOW_IDS_DEST=$(hyprctl clients -j | jq -r --arg workspace "$TARGET_WORKSPACE" '.[] | select(.workspace.name == $workspace) | select((.grouped | length) == 0 or .address == (.grouped[0])) | .address')

      for WINDOW_ID in $WINDOW_IDS_SRC; do
        hyprctl dispatch movetoworkspacesilent "$TARGET_WORKSPACE,address:$WINDOW_ID"
      done

      for WINDOW_ID in $WINDOW_IDS_DEST; do
        hyprctl dispatch movetoworkspacesilent "$SOURCE_WORKSPACE,address:$WINDOW_ID"
      done
    done
  '';
}
