-- disable netrw because nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- settings
vim.opt.number = true -- show line numbers
len = 2
vim.opt.tabstop = len
vim.opt.shiftwidth = len
vim.opt.softtabstop = len
vim.opt.expandtab = true
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
vim.opt.ch = 0 -- hide command prompt when unused; keep bottom panel to show command when using `:terminal ..`
vim.opt.termguicolors = true
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]
vim.api.nvim_set_hl(0, 'CursorLine', { underline = true }) -- line with cursor is underlined

-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true}) -- the OG keymap!
vim.api.nvim_set_keymap('i', '<TAB>', '<C-n>', {noremap = true}) -- tab completion
vim.api.nvim_set_keymap('i', '<S-TAB>', '<C-p>', {noremap = true})
vim.api.nvim_set_keymap('c', 'W', 'w', {noremap = true}) -- :W now writes
vim.keymap.set({'n', 'v'}, '<C-j>', '6j', {noremap = true}) -- faster vertical navigation
vim.keymap.set({'n', 'v'}, '<C-k>', '6k', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', '<CMD>nohlsearch<CR>', {noremap = true}) -- unhighlight search results
vim.api.nvim_set_keymap('n', '<C-t>', '<CMD>NvimTreeToggle<CR>', {noremap = true}) -- open nvim tree

-- CP key maps
exec = 'cat input && echo "----" && ./%:r.out < input'
compile_flags = ' -Wall'
             .. ' -Wextra'
             .. ' -Wunused'
             .. ' -Wpedantic'
             .. ' -Wshadow'
             .. ' -Wlogical-op'
             .. ' -Wformat=2'
             .. ' -Wfloat-equal'
             .. ' -Wcast-qual'
             .. ' -Wcast-align'
             .. ' -Wshift-overflow=2'
             .. ' -Wduplicated-cond'
             .. ' -O2'
             .. ' -std=c++17'
             .. ' -fsanitize=address,undefined'
             .. ' -fstack-protector'
             .. ' -D_GLIBCXX_DEBUG'
             .. ' -D_GLIBCXX_SANITIZE_VECTOR'
             .. ' -D_GLIBCXX_DEBUG_PEDANTIC'
             .. ' -D_GLIBCXX_ASSERTIONS'
             .. ' -D_FORTIFY_SOURCE=2'
vim.api.nvim_set_keymap('n', '<F5>', '<CMD>w!<CR><CMD>terminal g++ -std=c++17 %:r.cpp -o %:r.out && ' .. exec .. '<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F6>', '<CMD>w!<CR><CMD>terminal g++ ' .. compile_flags .. ' %:r.cpp -o %:r.out && ' .. exec .. '<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F7>', '<CMD>tab split input<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F8>', '<CMD>terminal wl-paste > input && cat input<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F9>', '<CMD>terminal ' .. exec .. '<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F10>', '<CMD>w!<CR><CMD>terminal oj-verify run %:r.cpp<CR>', {noremap = true})

-- enhancements
vim.api.nvim_create_autocmd('BufNewFile', { pattern = '*.cpp', command = 'read ~/programming_team_code/contest/template.cpp' }) -- new cpp files default to template
vim.api.nvim_create_autocmd('BufWrite', { pattern = '*.cpp,*.hpp,*.lua,*.html,*.css', command = 'silent! execute \'%s/\\s\\+$//ge\'' }) -- remove trailing white space during writes
require('packer').startup(function() -- :PackerSync to reload (run after all changes)
	use 'wbthomason/packer.nvim' -- Packer can manage itself
	use 'neovim/nvim-lspconfig' -- language server protocol
	use 'karb94/neoscroll.nvim' -- smooth scroll
	use 'kyazdani42/nvim-tree.lua' -- better file tree than Netrw
	use { -- better git integration
		'lewis6991/gitsigns.nvim',
		requires = {
			'nvim-lua/plenary.nvim'
		},
	}
	use 'norcalli/nvim-colorizer.lua' -- show color for hex codes
end)
require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', 'zt', 'zz', 'zb'} }) -- importantly, not <C-e> and <C-y>
-- delete ctrl-k so it uses my 6j keymap instead
-- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')
    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del('n', '<C-k>', { buffer = bufnr }) -- I want C-k to do 6k
    vim.keymap.del('n', '<C-t>', { buffer = bufnr }) -- I want C-t to close nvim tree (via toggle keybinding)
    vim.keymap.del('n', '<C-e>', { buffer = bufnr }) -- I want default behavior for C-e
end
require("nvim-tree").setup({
    on_attach = my_on_attach,
})
require('gitsigns').setup()
require('colorizer').setup()
require('lspconfig').clangd.setup{}
