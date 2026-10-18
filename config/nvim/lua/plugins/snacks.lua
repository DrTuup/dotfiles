return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        style = "float",
        width = 0.85,
        height = 0.8,
        border = "rounded",
      },
    },
    -- Add the picker configuration below
    picker = {
      sources = {
        explorer = {
          hidden = true, -- shows dotfiles by default
        },
      },
    },
  },
}
