require("bigfile").setup {
  filesize = 0.1, -- size of the file in MiB, the plugin round file sizes to the closest MiB
  pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
  features = { -- features to disable
    "indent_blankline",
    "lsp",
    "treesitter",
    -- "illuminate",
    -- "syntax",
    -- "vimopts",
  },
}
