-- disable netrw because nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- snippets
vim.cmd('let @f="diwafor (int pa = 0; pa <; pa++) {o}k$F;i"') -- need to type out loop variable name, and have cursor over it in command mode
vim.cmd('let @i="ainput.token::<>()hhi"')
vim.cmd('let @o="awrite!(writer, \\"{}\\\\n\\", ).unwrap();10hi"')

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
vim.opt.cursorline = true -- change background color of cursor line
vim.api.nvim_set_hl(0, 'CursorLine', { background = '#000050' })
vim.opt.list = true -- show '>' for tabs and '-' for trailing spaces
vim.opt.wildmode = 'list:longest' -- bash-like tab completion
vim.opt.matchpairs = '(:),{:},[:],<:>' -- <> is not included by default; useful for c++ templates
vim.opt.clipboard = 'unnamedplus' -- sync nvim and OS clipboard
vim.opt.ch = 0 -- hide command prompt when unused; keep bottom panel to show command when using `:terminal ..`
vim.opt.termguicolors = true
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]
vim.g.loaded_matchparen = false -- don't highlight matching paren as in light mode the cursor disappears

-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true}) -- the OG keymap!
vim.keymap.set({'n', 'v'}, '<C-j>', '6j', {noremap = true}) -- faster vertical navigation
vim.keymap.set({'n', 'v'}, '<C-k>', '6k', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', '<CMD>nohlsearch<CR>', {noremap = true}) -- unhighlight search results
vim.api.nvim_set_keymap('n', '<C-t>', '<CMD>NvimTreeToggle<CR>', {noremap = true}) -- open nvim tree

-- CP key maps
exec = 'cat input && echo "----" && ./%:r.out < input'

vim.api.nvim_set_keymap('n', '<F1>', '<CMD>w!<CR><CMD>terminal rustc %:r.rs -o %:r.out && ' .. exec .. '<CR>', {noremap = true})

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
             .. ' -g'
             .. ' -std=c++20'
             --.. ' -fsanitize=address,undefined' -- temporatily removing because on arch there's some bug with this
             .. ' -fstack-protector'
             .. ' -D_GLIBCXX_DEBUG'
             .. ' -D_GLIBCXX_SANITIZE_VECTOR'
             .. ' -D_GLIBCXX_DEBUG_PEDANTIC'
             .. ' -D_GLIBCXX_ASSERTIONS'
             .. ' -D_FORTIFY_SOURCE=2'
vim.api.nvim_set_keymap('n', '<F5>', '<CMD>w!<CR><CMD>terminal g++ -std=c++20 %:r.cpp -o %:r.out && ' .. exec .. '<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F6>', '<CMD>w!<CR><CMD>terminal g++ ' .. compile_flags .. ' %:r.cpp -o %:r.out && ' .. exec .. '<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F7>', '<CMD>tab split input<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F8>', '<CMD>terminal wl-paste > input && cat input<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F9>', '<CMD>terminal ' .. exec .. '<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F10>', '<CMD>w!<CR><CMD>terminal oj-verify run %:r.cpp<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F11>', '<CMD>w!<CR><CMD>terminal oj-verify run %:r.rs<CR>', {noremap = true})

-- enhancements
vim.api.nvim_create_autocmd('BufNewFile', { pattern = '*.cpp', command = 'read ~/github_repos/ptc_inclusive_inclusive/template.cpp' }) -- new cpp files default to template
vim.api.nvim_create_autocmd('BufWrite', { pattern = '*.cpp,*.hpp,*.lua,*.html,*.css,*.rs', command = 'silent! execute \'%s/\\s\\+$//ge\'' }) -- remove trailing white space during writes

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
	lazypath,
})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	'neovim/nvim-lspconfig', -- language server protocol
	'rhysd/vim-clang-format',
	'rust-lang/rust.vim',
	'simrat39/rust-tools.nvim',
	'karb94/neoscroll.nvim', -- smooth scroll
	'kyazdani42/nvim-tree.lua', -- better file tree than Netrw
	{ -- better git integration
		'lewis6991/gitsigns.nvim',
		requires = {
			'nvim-lua/plenary.nvim'
		},
	},
	'norcalli/nvim-colorizer.lua', -- show color for hex codes
})

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

local lspconfig = require('lspconfig')
lspconfig.clangd.setup{} -- c++
lspconfig.rust_analyzer.setup {
  -- server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = 'clippy',
      },
    },
  },
} -- rust

local rt = require('rust-tools')
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- hover actions
      vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
    end,
  },
})

local format_sync_grp = vim.api.nvim_create_augroup('Format', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rs',
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 200 })
  end,
  group = format_sync_grp,
})

-- autoformat on save
vim.cmd('autocmd FileType cpp ClangFormatAutoEnable')

vim.cmd('colorscheme retrobox')
--vim.cmd('colorscheme morning')
