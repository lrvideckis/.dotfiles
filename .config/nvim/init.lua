-- this is my secret sauce

-- general settings

vim.o.number = true -- show line numbers
vim.o.wrap = false -- don't wrap (fight me!)
vim.o.scrolloff = 2
--TODO: set variable as 4
vim.o.tabstop = 4 -- each tab appears the same width as 4 spaces
vim.o.shiftwidth = 4
vim.o.cursorline = true
vim.o.list = true -- show '>' for tabs and '-' for trailing spaces
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cindent = true
--vim.o.termguicolors = true -- looks cooler
vim.o.wildmode = "list:longest" -- bash-like completion
vim.o.colorcolumn = "100";
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]
vim.o.matchpairs = "(:),{:},[:],<:>"



--vim.o.colorscheme = "slate"



--vim.o.matchpairs = vim.o.matchpairs .. "<:>"
--:set matchpairs+=<:>



--test: vector<int> arr(n);




-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<esc>', {noremap = true})
vim.api.nvim_set_keymap('i', '<tab>', '<c-n>', {noremap = true})
vim.api.nvim_set_keymap('i', '<s-tab>', '<c-p>', {noremap = true})

vim.api.nvim_set_keymap('c', 'W', 'w', {noremap = true})

vim.api.nvim_set_keymap('n', '<c-j>', '6j', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-k>', '6k', {noremap = true})

vim.api.nvim_set_keymap('n', '<cr>', ':noh<cr>', {noremap = true})





-- asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf
















































-- asdfasdkfjasdkfjI



