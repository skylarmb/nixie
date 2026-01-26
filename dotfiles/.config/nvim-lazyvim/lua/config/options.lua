-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local HOME = os.getenv("HOME")

------------ Display Settings ------------
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.pumblend = 0
vim.opt.winblend = 0

------------ History & Session Settings ------------
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.opt.shada = [['50,f1,<100,s50,:50,/50,@50,h]]
vim.opt.history = 9001 -- its over 9000!

------------ Backup & Undo Settings ------------
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup/"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.writebackup = false

------------ Clipboard & Encoding Settings ------------
vim.opt.clipboard = "unnamedplus"
vim.opt.fileencoding = "utf-8"

------------ Completion & UI Settings ------------
vim.opt.completeopt = { "menuone", "noselect", "preview" }
vim.opt.conceallevel = 0
vim.opt.cmdheight = 1
vim.opt.pumheight = 10
vim.opt.showmode = false
vim.opt.showcmd = false

------------ Search & Replace Settings ------------
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.dictionary = "/usr/share/dict/words"

------------ Split Behavior Settings ------------
vim.opt.splitbelow = true
vim.opt.splitright = true

------------ Mouse & Interaction Settings ------------
vim.opt.mouse = "a"
vim.opt.timeoutlen = 1000
vim.opt.updatetime = 300
vim.opt.scrolloff = 10

------------ Indentation Settings ------------
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

------------ Line Display Settings ------------
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.laststatus = 3
vim.opt.numberwidth = 1
vim.opt.signcolumn = "yes:1"
vim.opt.colorcolumn = "80"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = " ↳ "

------------ Whitespace & List Settings ------------
vim.opt.list = true
vim.opt.listchars = "tab:▸\\ ,trail:·,extends:»,precedes:«,nbsp:␣"
vim.opt.fillchars.eob = " "

------------ Edit Behavior Settings ------------
vim.opt.backspace = "start,eol,indent"
vim.opt.showmatch = true
vim.opt.virtualedit = "onemore"
vim.opt.startofline = false
vim.opt.autoread = true
vim.opt.ruler = true
vim.opt.title = true

------------ Completion & Command Settings ------------
vim.opt.wildmode = "list:longest,list:full"
vim.opt.wildmenu = true
vim.opt.shortmess:append("c")
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })

------------ Wildignore Patterns (ignore files in completion) ------------
vim.opt.wildignore:append("*.o,*.obj,*.rbc,*.class,vendor/gems/*,*.pb.go")
vim.opt.wildignore:append(",*.jpg,*.jpeg,*.gif,*.png,*.xpm,*.webp")
vim.opt.wildignore:append(",*.zip,*.apk,*.gz,.DS_Store")
vim.opt.wildignore:append(",.svn,CVS,.git,.hg")
vim.opt.wildignore:append(",node_modules,deps,build,bin,tmp")
vim.opt.wildignore:append(",.cache,.pnpm,.idea,.vscode,.terraform,__pycache__")
vim.opt.wildignore:append(
  "deps,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc"
)

------------ GUI Font & Cursor Settings (Neovide) ------------
vim.o.guifont = "DankMono Nerd Font Mono:h16"
vim.opt.guicursor:append("a:blinkon0")
vim.opt.linespace = 0
vim.g.neovide_scale_factor = 1.2

------------ Neovide-Specific Settings ------------
if vim.g.neovide then
  vim.g.neovide_transparency = 1.0
  vim.g.neovide_background_color = "#131312"
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_refresh_rate_idle = 1
  vim.g.neovide_cursor_trail_size = 0.1
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_corner_radius = 0.5
  vim.g.neovide_fullscreen = true
end

------------ Plugin-Specific Settings (ag, mergetool) ------------
vim.g.ag_working_path_mode = "r"
vim.g.mergetool_layout = "bmr"
