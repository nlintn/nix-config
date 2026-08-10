{
  ...
}:

{
  programs.swayimg = {
    enable = true;
    initLua = /* lua */ ''
      swayimg.mode = "viewer"

      local step = 20

      -- Viewer mode bindings

      swayimg.viewer.on_key("plus", function()
        swayimg.viewer.scale = swayimg.viewer.scale + swayimg.viewer.scale / 10
      end)
      swayimg.viewer.on_key("minus", function()
        swayimg.viewer.scale = swayimg.viewer.scale - swayimg.viewer.scale / 10
      end)
      swayimg.viewer.on_key("0", function()
        swayimg.viewer.reset()
      end)

      swayimg.viewer.on_key("h", function()
        local pos = swayimg.viewer.get_position()
        swayimg.viewer.set_abs_position(pos.x + step, pos.y)
      end)
      swayimg.viewer.on_key("l", function()
        local pos = swayimg.viewer.get_position()
        swayimg.viewer.set_abs_position(pos.x - step, pos.y)
      end)
      swayimg.viewer.on_key("k", function()
        local pos = swayimg.viewer.get_position()
        swayimg.viewer.set_abs_position(pos.x, pos.y + step)
      end)
      swayimg.viewer.on_key("j", function()
        local pos = swayimg.viewer.get_position()
        swayimg.viewer.set_abs_position(pos.x, pos.y - step)
      end)

      swayimg.viewer.on_key("q", function()
        swayimg.exit()
      end)

      -- Gallery mode bindings

      swayimg.gallery.on_key("plus", function()
        swayimg.gallery.thumb_size = swayimg.gallery.thumb_size + 10
      end)
      swayimg.gallery.on_key("minus", function()
        swayimg.gallery.thumb_size = math.max(20, swayimg.gallery.thumb_size - 10)
      end)
      swayimg.gallery.on_key("0", function()
        swayimg.gallery.thumb_size = 200
      end)

      swayimg.gallery.on_key("h", function()
        swayimg.gallery.select("left")
      end)
      swayimg.gallery.on_key("l", function()
        swayimg.gallery.select("right")
      end)
      swayimg.gallery.on_key("k", function()
        swayimg.gallery.select("up")
      end)
      swayimg.gallery.on_key("j", function()
        swayimg.gallery.select("down")
      end)

      swayimg.gallery.on_key("q", function()
        swayimg.exit()
      end)
    '';
  };
}
