-- settings
vim.o.number = true -- show line numbers
vim.o.wrap = false -- don't wrap (fight me!)
vim.o.scrolloff = 2
tab_len = 4 -- tabs (fight me!)
vim.o.tabstop = tab_len
vim.o.shiftwidth = tab_len
vim.o.cursorline = true
vim.o.list = true -- show '>' for tabs and '-' for trailing spaces
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cindent = true
vim.o.termguicolors = true -- looks cooler
vim.o.wildmode = "list:longest" -- bash-like completion
vim.o.colorcolumn = "100";
vim.o.matchpairs = "(:),{:},[:],<:>"
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]

-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true})
vim.api.nvim_set_keymap('i', '<TAB>', '<C-N>', {noremap = true}) -- tab completion
vim.api.nvim_set_keymap('i', '<S-TAB>', '<C-P>', {noremap = true})
vim.api.nvim_set_keymap('c', 'W', 'w', {noremap = true}) -- :W now writes
vim.api.nvim_set_keymap('n', '<C-J>', '6j', {noremap = true}) -- faster navigation
vim.api.nvim_set_keymap('n', '<C-K>', '6k', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', ':nohlsearch<CR>', {noremap = true}) -- unhighlight search results
vim.api.nvim_set_keymap('n', '<F5>',
	'<CMD>w!<CR>' .. -- save, remove old executable, and compile
	'<CMD>!rm --force %:r.out<CR>' ..
	'<CMD>!g++ -Wall -Wextra -Wno-unused-result -Wshadow -g -std=c++20 %:r.cpp -o %:r.out<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F9>', '<CMD>terminal ./%:r.out<CR>', {noremap = true}) -- run in interactive terminal

-- enhancements
vim.cmd([[autocmd TermOpen * startinsert]]) -- you can now paste stuff when running with F9
vim.cmd([[autocmd BufNewFile *.cpp -r ~/programming_team_code/template.cpp]]) -- new cpp files default to template
vim.cmd([[autocmd BufWrite *.cpp,*.h,*.lua silent! execute '%s/\s\+$//ge']]) -- remove trailing white space during writes
vim.cmd([[autocmd BufWrite init.lua source init.lua | PackerSync]]) -- update Packer on writes (or :PackerSync)
vim.cmd([[colorscheme dracula]])
require('neoscroll').setup()
require('packer').startup(function() --plugins
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  use 'karb94/neoscroll.nvim' -- smooth scroll
  use 'Mofiqul/dracula.nvim' -- better color scheme
end)
