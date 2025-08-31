-- Set shell
vim.o.shell = vim.fn.exepath("zsh")
vim.env.PATH = vim.env.HOME .. "/.mise/plugins-and-tool-installs/shims:" .. vim.env.PATH

-- Python host program
-- NOTE: this is required for python to work
-- python3 -m pip install --user --upgrade pynvim
vim.g.python3_host_prog = vim.fn.exepath("python3") or vim.fn.exepath("python")

-- Disable polyglot for jsx
vim.g.polyglot_disabled = { "jsx" }

-- Plugin configuration with vim-plug
local data_dir = vim.fn.stdpath("data") .. "/site"
-- ~/.local/share/nvim/site/autoload
local plug_path = data_dir .. "/autoload/plug.vim"

-- Auto-install vim-plug if not present
if vim.fn.empty(vim.fn.glob(plug_path)) == 1 then
  vim.fn.system({
    "curl",
    "-fLo",
    plug_path,
    "--create-dirs",
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  })

  -- TODO: this doesn't work
  -- Create autocommand to install plugins and source config after VimEnter
  -- vim.api.nvim_create_autocmd("VimEnter", {
  --   callback = function()
  --     vim.cmd("PlugInstall --sync")
  --     vim.cmd("source $MYVIMRC")
  --   end,
  --   once = true,
  -- })
end

local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugged")

-- Plugins
Plug("airblade/vim-gitgutter")
Plug("christoomey/vim-tmux-navigator")
Plug("editorconfig/editorconfig-vim")
Plug("fatih/vim-go", { ["do"] = ":GoUpdateBinaries" })
Plug("gcmt/taboo.vim")
Plug("haya14busa/incsearch.vim")
Plug("junegunn/fzf", {
  ["do"] = function()
    vim.fn["fzf#install"]()
  end,
})
Plug("junegunn/fzf.vim")
Plug("junegunn/vim-peekaboo")
Plug("majutsushi/tagbar")
Plug("rust-lang/rust.vim")
Plug("ryanoasis/vim-devicons")
Plug("scrooloose/nerdtree")
Plug("maxmellon/vim-jsx-pretty")
Plug("sheerun/vim-polyglot")
Plug("chrisbra/Colorizer")
Plug("dense-analysis/ale")
Plug("easymotion/vim-easymotion")
Plug("jpalardy/vim-slime")
Plug("leafgarland/typescript-vim")
Plug("lepture/vim-jinja")
Plug("neoclide/coc.nvim", { branch = "release" })
Plug("pangloss/vim-javascript")
Plug("peitalin/vim-jsx-typescript")
Plug("prisma/vim-prisma")
Plug("styled-components/vim-styled-components", { branch = "main" })
Plug("sukima/vim-javascript-imports")
Plug("terryma/vim-expand-region")
Plug("terryma/vim-multiple-cursors")
Plug("tpope/vim-commentary")
Plug("tpope/vim-endwise")
Plug("tpope/vim-fugitive")
Plug("tpope/vim-obsession")
Plug("tpope/vim-rails")
Plug("tpope/vim-repeat")
Plug("tpope/vim-surround")
Plug("tpope/vim-unimpaired")
Plug("vim-airline/vim-airline")
Plug("vim-airline/vim-airline-themes")
Plug("wesQ3/vim-windowswap")
Plug("z0mbix/vim-shfmt", { ["for"] = "sh" })
Plug("catppuccin/vim", { as = "catppuccin" })

-- Snippets
Plug("SirVer/ultisnips")
Plug("honza/vim-snippets")
Plug("mlaursen/vim-react-snippets")

-- SQL
Plug("lighttiger2505/sqls.vim")
-- Plug("prabirshrestha/vim-lsp")

-- Additional
Plug("inkarkat/vim-SyntaxRange")
Plug("wuelnerdotexe/vim-astro")

-- Lua
-- Plug("williamboman/mason.nvim")
-- Plug("williamboman/mason-lspconfig.nvim")
-- Plug("neovim/nvim-lspconfig")

vim.call("plug#end")

-- CoC global extensions
vim.g.coc_global_extensions = {
  "@yaegassy/coc-nginx",
  "@yaegassy/coc-ruff",
  "coc-go",
  "coc-html",
  "coc-htmlhint",
  "coc-json",
  "coc-prisma",
  "coc-sh",
  "coc-snippets",
  "coc-solargraph",
  "coc-sqlfluff",
  "coc-tailwindcss",
  "coc-tsserver",
}

-- Basic settings
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.o.signcolumn = "yes"
vim.o.title = true
vim.o.showtabline = 2
vim.o.number = true
vim.o.autoread = true
vim.o.autoindent = true
vim.o.backspace = "2"
vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.encoding = "utf-8"
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.list = true
vim.o.listchars = "tab:▸ ,trail:▫"
vim.o.ruler = true
vim.o.scrolloff = 3
vim.o.showcmd = true
vim.o.smartcase = true
vim.o.spell = false
vim.o.mouse = "a"
vim.o.foldmethod = "indent"
vim.o.foldlevel = 1
vim.o.foldclose = "all"
vim.o.tags = "./.ide/ctags"

-- Directory settings
vim.o.directory = vim.fn.stdpath("data") .. "/swap//"
vim.fn.mkdir(vim.fn.stdpath("data") .. "/swap", "p")

-- Wildignore
vim.o.wildignore = "log/**,node_modules/**,target/**,tmp/**,*.rbc"

-- Viminfo equivalent in Neovim (shada)
vim.o.shada = "%,<800,'100,/10000000,:10000000,h,f0,n" .. vim.fn.stdpath("data") .. "/shada/main.shada"

-- Leader key
vim.g.mapleader = ","

-- Plugin configurations
vim.g.taboo_tab_format = " %m %r "
vim.g.taboo_modified_tab_flag = "🚩"

vim.g.airline_powerline_fonts = 1
vim.g.airline_left_sep = "\u{E0B4}"
vim.g.airline_right_sep = "\u{E0B6}"
vim.g.airline_section_z =
  vim.fn["airline#section#create"]({ "\u{E0A1}" .. '%{line(".")}' .. "\u{E0A3}" .. '%{col(".")}' })

vim.g.gitgutter_enabled = 1
vim.g.jsx_ext_required = 0
vim.g.LanguageClient_useVirtualText = 0
vim.g.NERDSpaceDelims = 1
vim.g.NERDTreeShowHidden = 1
vim.g.multi_cursor_next_key = "<C-n>"
vim.g.multi_cursor_prev_key = "<C-p>"
vim.g.multi_cursor_quit_key = "<Esc>"
vim.g.multi_cursor_skip_key = "<C-x>"
vim.g.shfmt_fmt_on_save = 0
vim.g.slime_dont_ask_default = 1
vim.g.slime_target = "tmux"
vim.g.coc_data_home = vim.fn.stdpath("data") .. "/coc"

-- IDE tmux socket
vim.g.ide_tmux_socket = os.getenv("HOME") .. "/.host_tmux_socket"
vim.g.slime_default_config = {
  socket_name = vim.g.ide_tmux_socket,
  target_pane = "{last}",
}

-- Vim JavaScript imports
vim.g.vim_javascript_imports_map = "<leader>e"

-- ALE configuration
vim.g.ale_enable_lsp = 0
vim.g.ale_enabled = 1
vim.g.ale_fix_on_save = 0
vim.g.ale_lint_on_enter = 1
vim.g.ale_lint_on_text_changed = "always"
vim.g.ale_linters_explicit = 1
vim.g.ale_ruby_rubocop_executable = "rubocop"
vim.g.ale_ruby_rubocop_options = "-A"
vim.g.ale_ruby_rubocop_auto_correct_all = 1
vim.g.ale_set_balloons = 1
vim.g.ale_set_highlights = 0
vim.g.ale_set_loclist = 1
vim.g.ale_sign_column_always = 1
vim.g.ale_sign_error = "X"
vim.g.ale_virtualtext_cursor = 0
vim.g.ale_warn_about_trailing_whitespace = 0

-- ALE fixers
vim.g.ale_fixers = {
  ["*"] = { "remove_trailing_lines", "trim_whitespace" },
  angular = { "prettier" },
  astro = { "prettier" },
  css = { "prettier" },
  dockerfile = { "prettier" },
  eruby = { "prettier" },
  go = { "gofmt" },
  graphql = { "prettier" },
  html = { "prettier" },
  javascript = { "prettier" },
  ["javascript.jsx"] = { "prettier" },
  jinja = { "prettier" },
  json = { "prettier" },
  jsx = { "prettier" },
  less = { "prettier" },
  lua = { "stylua" },
  markdown = { "prettier" },
  python = { "ruff_format" },
  ruby = { "rubocop" },
  rust = { "rustfmt" },
  scss = { "prettier" },
  sh = { "shfmt" },
  sql = { "prettier" },
  typescript = { "prettier" },
  typescriptreact = { "prettier" },
  vue = { "prettier" },
  yaml = { "prettier" },
}

-- ALE linters
vim.g.ale_linters = {
  astro = { "eslint" },
  python = { "ruff" },
  ruby = { "rubocop" },
  sh = { "shellcheck" },
}

-- FZF colors
vim.g.fzf_colors = {
  fg = { "fg", "Normal" },
  bg = { "bg", "Normal" },
  ["preview-bg"] = { "bg", "NormalFloat" },
  hl = { "fg", "Comment" },
  ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
  ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
  ["hl+"] = { "fg", "Statement" },
  info = { "fg", "PreProc" },
  border = { "fg", "Ignore" },
  prompt = { "fg", "Conditional" },
  pointer = { "fg", "Exception" },
  marker = { "fg", "Keyword" },
  spinner = { "fg", "Label" },
  header = { "fg", "Comment" },
}

vim.g.fzf_layout = { down = "50%" }

-- Key mappings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Custom keymaps
map("i", "jk", "<Esc>")
map("t", "jk", "<C-\\><C-n>")
map("n", "/", "<Plug>(incsearch-forward)")
map("v", ".", ":norm.<CR>")

-- Tab navigation
map("n", "<leader>1", "1gt")
map("n", "<leader>2", "2gt")
map("n", "<leader>3", "3gt")
map("n", "<leader>4", "4gt")
map("n", "<leader>5", "5gt")
map("n", "<leader>6", "6gt")
map("n", "<leader>7", "7gt")
map("n", "<leader>8", "8gt")
map("n", "<leader>9", "9gt")
map("n", "<leader>0", ":tablast<cr>")

-- Prevent clobbering yanked content
map("x", "p", '"_dP')

-- Leader hotkeys
map("n", "<leader>V", ':source ~/.config/nvim/init.lua<CR>:filetype detect<CR>:lua print("init.lua reloaded")<CR>')
map("n", "<leader>rr", ":TabooRename<Space>")
map("n", "<leader>c", ":tabnew<CR>")
map("n", "<leader>f", ":ALEFix<CR>")
map("n", "<leader>rm", ':call delete(expand("%")) | bdelete!<CR>')
map("n", "<leader>d", ":NERDTreeToggle<CR>")
map("n", "<leader>g", ":GitGutterToggle<CR>")
map("n", "<leader>.", ":TagbarToggle<CR>")
map("n", "<leader>b", ":Buffers<CR>")
-- If this were :Files! it would be fullscreen
map("n", "<leader>t", ":Files<CR>")
map("n", "<leader>r", ":Tags<CR>")
map("n", "<leader>h", ":History<CR>")
map("n", "<leader>hc", ":History:<CR>")
map("n", "<leader>hs", ":History/<CR>")
map("n", "<leader>w", ":Windows<CR>")
map("n", "<leader>rg", ":Rg<CR>")
map("n", "<leader>gu", ":RgUnique<CR>")
map("n", "<leader>sl", ':call SyntaxRange#Include("#@begin=slim@", "#@end=slim@", "slim", "NonText")<CR>')
map("n", "<leader>v", ":split<CR>")
map("n", "<leader>h", ":vsplit<CR>")
map("n", "<leader>nf", ":NERDTreeFind<CR>")

-- CoC keybindings
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "<TAB>" : coc#refresh()', opts)
map("i", "<S-TAB>", 'coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"', opts)
map("i", "<CR>", 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR><c-r>=coc#on_enter()<CR>"', opts)
map("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- CoC navigation
map("n", "[g", "<Plug>(coc-diagnostic-prev)")
map("n", "]g", "<Plug>(coc-diagnostic-next)")
map("n", "gd", "<Plug>(coc-definition)")
map("n", "gy", "<Plug>(coc-type-definition)")
map("n", "gi", "<Plug>(coc-implementation)")
map("n", "gr", "<Plug>(coc-references)")

-- CoC actions
map("n", "<space>d", ":<C-u>CocList diagnostics<cr>")
map("n", "<space>s", ":<C-u>CocList -I symbols<cr>")
map("n", "K", "<CMD>lua _G.show_docs()<CR>")
map("n", "<leader>rn", "<Plug>(coc-rename)")
map("x", "<leader>a", "<Plug>(coc-codeaction-selected)")
map("n", "<leader>a", "<Plug>(coc-codeaction-selected)")
map("n", "<leader>ac", "<Plug>(coc-codeaction)")
map("n", "<leader>qf", "<Plug>(coc-fix-current)")
map("n", "<leader>acl", "<Plug>(coc-codelens-action)")

-- CoC text objects
map("x", "if", "<Plug>(coc-funcobj-i)")
map("o", "if", "<Plug>(coc-funcobj-i)")
map("x", "af", "<Plug>(coc-funcobj-a)")
map("o", "af", "<Plug>(coc-funcobj-a)")
map("x", "ic", "<Plug>(coc-classobj-i)")
map("o", "ic", "<Plug>(coc-classobj-i)")
map("x", "ac", "<Plug>(coc-classobj-a)")
map("o", "ac", "<Plug>(coc-classobj-a)")

-- CoC scroll
map(
  "n",
  "<C-f>",
  'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
  { silent = true, nowait = true, expr = true }
)
map(
  "n",
  "<C-b>",
  'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
  { silent = true, nowait = true, expr = true }
)
map(
  "i",
  "<C-f>",
  'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
  { silent = true, nowait = true, expr = true }
)
map(
  "i",
  "<C-b>",
  'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
  { silent = true, nowait = true, expr = true }
)
map(
  "v",
  "<C-f>",
  'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
  { silent = true, nowait = true, expr = true }
)
map(
  "v",
  "<C-b>",
  'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
  { silent = true, nowait = true, expr = true }
)

-- CoC selection ranges
map("n", "<C-s>", "<Plug>(coc-range-select)")
map("x", "<C-s>", "<Plug>(coc-range-select)")

-- CoC list mappings
map("n", "<space>a", ":<C-u>CocList diagnostics<cr>")
map("n", "<space>e", ":<C-u>CocList extensions<cr>")
map("n", "<space>c", ":<C-u>CocList commands<cr>")
map("n", "<space>o", ":<C-u>CocList outline<cr>")
map("n", "<space>s", ":<C-u>CocList -I symbols<cr>")
map("n", "<space>j", ":<C-u>CocNext<CR>")
map("n", "<space>k", ":<C-u>CocPrev<CR>")
map("n", "<space>p", ":<C-u>CocListResume<CR>")

-- Lua functions
function _G.show_docs()
  local cw = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command("h " .. cw)
  elseif vim.fn["coc#rpc#ready"]() then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
  end
end

function _G.CheckBackspace()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- CoC highlight
autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    vim.fn.CocActionAsync("highlight")
  end,
})

-- Format options
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Auto rebalance windows
autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
})

-- CoC augroup
local coc_group = augroup("CocGroup", {})
autocmd("FileType", {
  group = coc_group,
  pattern = { "typescript", "json" },
  callback = function()
    vim.opt_local.formatexpr = "CocAction('formatSelected')"
  end,
})

autocmd("User", {
  group = coc_group,
  pattern = "CocJumpPlaceholder",
  callback = function()
    vim.fn.CocActionAsync("showSignatureHelp")
  end,
})

-- Commands
vim.api.nvim_create_user_command("Format", function()
  vim.fn.CocActionAsync("format")
end, {})

vim.api.nvim_create_user_command("Fold", function(opts)
  vim.fn.CocAction("fold", opts.fargs)
end, { nargs = "?" })

vim.api.nvim_create_user_command("OR", function()
  vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport")
end, {})

-- RgUnique command
-- If search matches in more than one spot the results will only show one filename
vim.api.nvim_create_user_command("RgUnique", function(opts)
  local function open_files(files)
    for _, file in ipairs(files) do
      vim.cmd("tabedit " .. vim.fn.fnameescape(file))
    end
  end

  vim.fn["fzf#run"]({
    source = "true", -- dummy source since we're using --phony
    ["sink*"] = open_files,
    options = {
      "--multi",
      "--phony",
      "--bind",
      "change:reload:rg --files-with-matches --no-messages --hidden --glob '!.git/*' -- {q} || true",
      "--preview",
      "rg --color=always --line-number --context=3 -- {q} {} 2>/dev/null || echo 'No matches'",
      "--preview-window",
      "right:50%:wrap",
      "--prompt",
      "Search> ",
    },
    down = "50%",
  })
end, { nargs = "*", bang = true })

vim.g.coc_borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

-- Colorscheme

vim.o.termguicolors = true
vim.g.base16_shell_path = "~/.base16-shell/scripts"

local base16_theme = vim.env.BASE16_THEME
if base16_theme and (not vim.g.colors_name or vim.g.colors_name ~= "base16-" .. base16_theme) then
  vim.g.base16colorspace = 256
  vim.cmd("colorscheme base16-" .. base16_theme)
end
