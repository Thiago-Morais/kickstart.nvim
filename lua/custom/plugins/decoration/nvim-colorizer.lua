vim.pack.add { 'https://github.com/catgoose/nvim-colorizer.lua' }

require('colorizer').setup {
  lazy_load = true,
  options = {
    parsers = {
      css = true, -- preset: enables names, hex, rgb, hsl, oklch, css_var
      css_fn = true, -- preset: enables rgb, hsl, oklch
      hwb = { enable = true },
      lab = { enable = true },
      lch = { enable = true },
      css_color = { enable = true },
      tailwind = { enable = true },
      sass = { enable = true },
      xterm = { enable = true },
      ls_colors = { enable = true },
    },
  },
}
