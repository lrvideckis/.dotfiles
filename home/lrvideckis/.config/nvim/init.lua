-- settings
vim.opt.number = true -- show line numbers
spaces_len = 4 -- spaces!
vim.opt.expandtab = true
vim.opt.tabstop = spaces_len
vim.opt.shiftwidth = spaces_len
vim.opt.wrap = false
vim.opt.ignorecase = true -- better search highlight settings
vim.opt.smartcase = true
vim.opt.cindent = true
vim.opt.cino = 'j1,(0,ws,Ws' -- handle indentation inside lambdas correctly
vim.opt.cursorline = true
vim.opt.list = true -- show '>' for tabs and '-' for trailing spaces
vim.opt.wildmode = 'list:longest' -- bash-like tab completion
vim.opt.matchpairs = '(:),{:},[:],<:>' -- <> is not included by default; useful for c++ templates
vim.opt.clipboard = 'unnamedplus' -- sync nvim and OS clipboard
vim.opt.ls = 0 -- hide bottom panel
vim.opt.ch = 0
vim.opt.termguicolors = true
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]

-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true}) -- the OG keymap!
vim.api.nvim_set_keymap('i', '<TAB>', '<C-n>', {noremap = true}) -- tab completion
vim.api.nvim_set_keymap('i', '<S-TAB>', '<C-p>', {noremap = true})
vim.api.nvim_set_keymap('c', 'W', 'w', {noremap = true}) -- :W now writes
vim.api.nvim_set_keymap('', '<C-j>', '6j', {noremap = true}) -- faster vertical navigation
vim.api.nvim_set_keymap('', '<C-k>', '6k', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', '<CMD>nohlsearch<CR>', {noremap = true}) -- unhighlight search results
vim.api.nvim_set_keymap('n', '<F5>', -- save, remove old executable, and compile
	'<CMD>w!<CR>' ..
	'<CMD>!rm --force %:r.out && g++ -std=c++17 %:r.cpp -o %:r.out<CR>', {noremap = true})
compile_flags = '-Wall -Wextra -O2 -Wunused -Wshadow -Wpedantic -Wconversion -g -fsanitize=address,undefined -fno-sanitize-recover=all -std=c++17'
vim.api.nvim_set_keymap('n', '<F6>', -- save, remove old executable, and compile
	'<CMD>w!<CR>' ..
	'<CMD>!rm --force %:r.out && g++ ' .. compile_flags .. ' %:r.cpp -o %:r.out<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F9>', '<CMD>!cat in && echo "----" && ./%:r.out < in<CR>', {noremap = true}) -- run code
vim.api.nvim_set_keymap('n', '<C-t>', '<CMD>NvimTreeFocus<CR>', {noremap = true}) -- open nvim tree
vim.api.nvim_set_keymap('n', 'Q', '^a    <ESC>', {noremap = true}) -- to help with formatting @code doxygen comments

-- enhancements
vim.api.nvim_create_autocmd('BufNewFile', { pattern = '*.cpp', command = 'read ~/programming_team_code/library/contest/template.cpp' }) -- new cpp files default to template
vim.api.nvim_create_autocmd('BufWrite', { pattern = '*.cpp,*.hpp,*.lua', command = 'silent! execute \'%s/\\s\\+$//ge\'' }) -- remove trailing white space during writes
require('packer').startup(function() -- :PackerSync to reload (run after all changes)
	use 'wbthomason/packer.nvim' -- Packer can manage itself
	use 'karb94/neoscroll.nvim' -- smooth scroll
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
vim.cmd('colorscheme pablo')
vim.cmd('highlight Normal guibg=none') -- transparency
require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', 'zt', 'zz', 'zb'} }) -- importantly, not <C-e> and <C-y>
require('nvim-tree').setup()
require('gitsigns').setup()
require('colorizer').setup()
