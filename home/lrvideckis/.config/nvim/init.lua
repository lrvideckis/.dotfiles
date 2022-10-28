-- settings
vim.o.number = true -- show line numbers
tab_len = 4 -- tabs!
vim.o.tabstop = tab_len
vim.o.shiftwidth = tab_len
vim.o.ignorecase = true -- better search highlight settings
vim.o.smartcase = true
vim.o.cindent = true
vim.o.cursorline = true
vim.o.list = true -- show '>' for tabs and '-' for trailing spaces
vim.o.wildmode = 'list:longest' -- bash-like tab completion
vim.o.matchpairs = '(:),{:},[:],<:>'
vim.o.clipboard = 'unnamedplus' -- sync nvim and OS clipboard
vim.o.ls = 0 -- hide bottom panel
vim.o.ch = 0
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]

-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true}) -- the OG keymap!
vim.api.nvim_set_keymap('i', '<TAB>', '<C-n>', {noremap = true}) -- tab completion
vim.api.nvim_set_keymap('i', '<S-TAB>', '<C-p>', {noremap = true})
vim.api.nvim_set_keymap('c', 'W', 'w', {noremap = true}) -- :W now writes
vim.api.nvim_set_keymap('', '<C-j>', '6j', {noremap = true}) -- faster navigation
vim.api.nvim_set_keymap('', '<C-k>', '6k', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', '<CMD>nohlsearch<CR>', {noremap = true}) -- unhighlight search results
compile_flags = '-Wall -Wextra -Wunused -Wshadow -Wconversion -g -std=c++20'
vim.api.nvim_set_keymap('n', '<F5>', -- save, remove old executable, and compile
	'<CMD>w!<CR>' ..
	'<CMD>!rm --force %:r.out && g++ ' .. compile_flags .. ' %:r.cpp -o %:r.out<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F9>', '<CMD>!cat in && echo "----" && ./%:r.out < in<CR>', {noremap = true}) -- run code
vim.api.nvim_set_keymap('n', '<C-t>', '<CMD>NvimTreeFocus<CR>', {noremap = true}) -- open nvim tree

-- enhancements
vim.api.nvim_create_autocmd('BufNewFile', { pattern = '*.cpp', command = 'read ~/programming_team_code/library/contest/template.cpp' }) -- new cpp files default to template
vim.api.nvim_create_autocmd('BufWrite', { pattern = '*.cpp,*.hpp,*.lua', command = 'silent! execute \'%s/\\s\\+$//ge\'' }) -- remove trailing white space during writes
require('packer').startup(function() -- :PackerSync to reload (run after all changes)
	use 'wbthomason/packer.nvim' -- Packer can manage itself
	use 'karb94/neoscroll.nvim' -- smooth scroll
	use 'folke/tokyonight.nvim' -- color scheme
	use { -- better file tree than Netrw
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}
	use { -- better git integration
		'lewis6991/gitsigns.nvim',
		requires = {
			'nvim-lua/plenary.nvim'
		},
		-- use release once they fix breaking change caused by neovim version 0.8.0
		--tag = 'release' -- To use the latest release
	}
	use 'norcalli/nvim-colorizer.lua' -- show color for hex codes
end)
vim.cmd('colorscheme tokyonight')
vim.cmd('highlight Normal guibg=none') -- transparency
require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', 'zt', 'zz', 'zb'} }) -- importantly, not <C-e> and <C-y>
require('nvim-tree').setup()
require('gitsigns').setup()
require('colorizer').setup()
