local M = {}

function M.toggle_group()
  local active = hl.get_active_window()
  if not active then
    return
  end

  if active.group then
    hl.dispatch(hl.dsp.group.toggle({ window = active }))
    return
  end

  local windows = hl.get_windows({ workspace = active.workspace })

  if #windows == 1 then
    hl.dispatch(hl.dsp.group.toggle({ window = active }))
    return
  end

  hl.dispatch(hl.dsp.group.toggle({ window = active }))

  local group = active.group
  if not group then
    return
  end

  for _, window in ipairs(windows) do
    if window ~= active and window.group ~= group then
      group:add(window, group.size + 1)
    end
  end

  hl.dispatch(hl.dsp.focus({
    window = "address:" .. active.address,
  }))
end

function M.visible_window_rectangles()
  local rectangles = {}

  for _, m in ipairs(hl.get_monitors()) do
    for _, w in ipairs(hl.get_workspace_windows(m.active_special_workspace or m.active_workspace or {})) do
      if w.visible and (w.pinned or (w.workspace and w.workspace.visible)) then
        table.insert(
          rectangles,
          string.format(
            "%d,%d %dx%d",
            w.at.x,
            w.at.y,
            w.size.x,
            w.size.y
          )
        )
      end
    end
  end

  return table.concat(rectangles, "\n")
end

function M.zoom(offset)
  local MAX_ZOOM = 5
  local MIN_ZOOM = 1

  if offset == nil then
    hl.config({ cursor = { zoom_factor = 1 } })
    return
  end

  hl.config({ cursor = { zoom_factor = math.max(MIN_ZOOM, math.min(MAX_ZOOM, hl.get_config("cursor.zoom_factor") + offset)) } })
end

return M
