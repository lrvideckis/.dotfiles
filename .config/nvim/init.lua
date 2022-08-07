-- settings
vim.o.number = true -- show line numbers
tab_len = 4 -- tabs!
vim.o.tabstop = tab_len
vim.o.shiftwidth = tab_len
vim.o.wrap = false -- don't wrap
vim.o.ignorecase = true -- better search highlight settings
vim.o.smartcase = true
vim.o.cindent = true
vim.o.scrolloff = 2
vim.o.cursorline = true
vim.o.list = true -- show '>' for tabs and '-' for trailing spaces
vim.o.termguicolors = true -- looks cooler
vim.o.wildmode = "list:longest" -- bash-like tab completion
vim.o.colorcolumn = "100";
vim.o.matchpairs = "(:),{:},[:],<:>"
vim.o.splitbelow = true -- terminal opens at bottom on <F9>
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]

-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true}) -- the OG keymap!
vim.api.nvim_set_keymap('i', '<TAB>', '<C-N>', {noremap = true}) -- tab completion
vim.api.nvim_set_keymap('i', '<S-TAB>', '<C-P>', {noremap = true})
vim.api.nvim_set_keymap('c', 'W', 'w', {noremap = true}) -- :W now writes
vim.api.nvim_set_keymap("", '<C-J>', '6j', {noremap = true}) -- faster navigation
vim.api.nvim_set_keymap("", '<C-K>', '6k', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', '<CMD>nohlsearch<CR>', {noremap = true}) -- unhighlight search results
vim.api.nvim_set_keymap('n', '<F5>', -- save, remove old executable, and compile
	'<CMD>w!<CR>' ..
	'<CMD>!rm --force %:r.out<CR>' ..
	'<CMD>!g++ -Wall -Wextra -Wno-unused-result -Wshadow -g -std=c++20 %:r.cpp -o %:r.out<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F9>', '<CMD>8split | terminal ./%:r.out<CR>', {noremap = true}) -- run in interactive terminal
vim.api.nvim_set_keymap('n', '<C-T>', '<CMD>NvimTreeFocus<CR>', {noremap = true}) -- open nvim tree

-- enhancements
vim.api.nvim_create_autocmd("TermOpen", { command = "startinsert" }) -- you can now paste stuff when running with <F9>
vim.api.nvim_create_autocmd("BufNewFile", { pattern = "*.cpp", command = "-r ~/programming_team_code/template.cpp" }) -- new cpp files default to template
vim.api.nvim_create_autocmd("BufWrite", { pattern = "*.cpp,*.h,*.lua", command = "silent! execute \'%s/\\s\\+$//ge\'" }) -- remove trailing white space during writes
require('packer').startup(function() -- :PackerSync to reload (run after all changes)
	use 'wbthomason/packer.nvim' -- Packer can manage itself
	use 'karb94/neoscroll.nvim' -- smooth scroll
	use 'folke/tokyonight.nvim' -- color scheme
	use { -- better status bar
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use { -- better file tree than Netrw
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}
end)
vim.cmd([[colorscheme tokyonight]])
require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', 'zt', 'zz', 'zb'} }) -- importantly, not <C-E> and <C-Y>
require('lualine').setup()
require("nvim-tree").setup()
