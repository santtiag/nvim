vim.keymap.set(
	{ "n", "x" },
	"<leader>ms",
	function() require("rip-substitute").sub() end,
	{ desc = " Rip substitute" }
)

