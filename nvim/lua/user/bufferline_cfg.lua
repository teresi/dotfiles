local status, bufferline = pcall(require, "bufferline")
if not status then
  print("ERROR bufferline")
  return
end

bufferline.setup({
    options = {
    indicator = {
        style = 'none',
    },
    color_icons = false,
    modified_icon = "●",
    buffer_close_icon = "",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    numbers = none,
    max_name_length = 15,
    max_prefix_length = 6,
    tab_size = 16,
    diagnostics = "nvim_lsp",
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    persist_buffer_sort = true,
    enforce_regular_tabs = true,
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and "" or ""
      return icon .. count
    end,
    },
    highlights = {
            buffer_visible = {
                fg = 'black',
                bg = 'green',
            },
    },
})
