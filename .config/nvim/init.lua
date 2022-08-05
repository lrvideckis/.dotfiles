-- this is my secret sauce

-- general settings

vim.o.number = true -- show line numbers
vim.o.wrap = false -- don't wrap (fight me!)
vim.o.scrolloff = 2
tab_len = 4
vim.o.tabstop = tab_len -- each tab appears the same width as 4 spaces
vim.o.shiftwidth = tab_len
vim.o.cursorline = true
vim.o.list = true -- show '>' for tabs and '-' for trailing spaces
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cindent = true
vim.o.termguicolors = true -- looks cooler
vim.o.wildmode = "list:longest" -- bash-like completion
vim.o.colorcolumn = "100";
vim.g.c_no_curly_error = true -- disable curly brace error: thing[{i, j}]
vim.o.matchpairs = "(:),{:},[:],<:>"


--vim.g.colorscheme = vim.g.elflord
vim.g.ayucolor = 'elflord'





--vim.o.colorscheme = "slate"








-- key maps
vim.api.nvim_set_keymap('i', 'kj', '<esc>', {noremap = true})

-- tab completion
vim.api.nvim_set_keymap('i', '<tab>', '<c-n>', {noremap = true})
vim.api.nvim_set_keymap('i', '<s-tab>', '<c-p>', {noremap = true})

-- fix common typo
vim.api.nvim_set_keymap('c', 'W', 'w', {noremap = true})

-- faster navigation
vim.api.nvim_set_keymap('n', '<c-j>', '6j', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-k>', '6k', {noremap = true})

-- unhighlight search results
vim.api.nvim_set_keymap('n', '<cr>', ':noh<cr>', {noremap = true})

-- save and compile
vim.api.nvim_set_keymap('n', '<F5>', ':w!<cr>:!rm --force %:r.out<cr>:!g++ -Wall -Wextra -Wno-unused-result -Wshadow -g -std=c++20 %:r.cpp -o %:r.out<cr>', {noremap = true})
-- run in interactive terminal
vim.api.nvim_set_keymap('n', '<F9>', ':terminal ./%:r.out<cr>', {noremap = true})



-- better behavior when running code in a temporary terminal
vim.cmd[[autocmd TermOpen * startinsert]]
-- new cpp files default to template
vim.cmd[[autocmd BufNewFile *.cpp -r ~/programming_team_code/template.cpp]]
-- remove trailing white space during writes
vim.cmd[[autocmd BufWrite *.cpp,*.h silent! execute '%s/\s\+$//ge']]
-- colorscheme
vim.cmd[[colorscheme elflord]]



-- asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf asdfasdf asdf asdf asdf asdf asdf asdf asdf
















































-- asdfasdkfjasdkfjI



