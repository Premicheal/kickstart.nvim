-- Key Mappings
vim.g.python3_host_prog = vim.env.HOME .. '/.local/venv/nvim/bin/python'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '_', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('v', '_', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<C-w>z', '<cmd>WindowsMaximize<CR>')
vim.keymap.set('n', '<C-w>_', '<cmd>WindowsMaximizeVertically<CR>')
vim.keymap.set('n', '<C-w>|', '<cmd>WindowsMaximizeHorizontally<CR>')
vim.keymap.set('n', '<C-w>=', '<cmd>WindowsEqualize<CR>')
vim.keymap.set('n', ']q', '<cmd>cnext<CR>')
vim.keymap.set('n', '[q', '<cmd>cprev<CR>')
vim.keymap.set('n', '<leader>nb', ':%bd<CR><C-O>:bd#<CR>')

-- vim.keymap.set("n", "L", "gt")
-- vim.keymap.set("n", "H", "gT")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
-- vim.keymap.set("n", "<C-b>", "<C-b>zz")
-- vim.keymap.set("n", "<C-f>", "<C-f>zz")

-- vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>')
-- vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>')
-- vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>')
-- vim.keymap.set({ 'n', 't' }, '<CMD>NavigatorDown<CR>')

-- Set initial scroll value
vim.opt.scroll = 10
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
-- Lazy.nvim Plugin Manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Install Plugins
require('lazy').setup({
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
    },
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
    end,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        '<leader>r',
        function()
          require('conform').format { async = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        sql = { 'sqlfluff' },
        javascript = { 'prettier', stop_after_first = true },
        typescript = { 'prettier', stop_after_first = true },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = 'fallback',
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    'mbbill/undotree',
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_RelativeTimestamp = 0
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_ShortIndicators = 0
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_HelpLine = 1
      vim.g.undotree_CursorLine = 1
      vim.g.undotree_HighlightChangedText = 1
      vim.g.undotree_HighlightChangedWithSign = 1
    end,
  },
  { 'akinsho/toggleterm.nvim', version = '*', config = true },
  { 'Joakker/lua-json5', build = './install.sh' },
  { 'statico/vim-javascript-sql' },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('scrollbar.handlers.search').setup()
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        lightbulb = {
          enable = false,
        },
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },
  { 'petertriho/nvim-scrollbar' },
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require('transparent').setup {
        groups = {
          'Normal',
          'NormalNC',
          'Comment',
          'Constant',
          'Special',
          'Identifier',
          'Statement',
          'PreProc',
          'Type',
          'Underlined',
          'Todo',
          'String',
          'Function',
          'Conditional',
          'Repeat',
          'Operator',
          'Structure',
          'LineNr',
          'NonText',
          'SignColumn',
          'CursorLine',
          'CursorLineNr',
          'StatusLine',
          'StatusLineNC',
          'EndOfBuffer',
        },
        extra_groups = {
          'NormalFloat',
          'NvimTreeNormal',
        },
        exclude_groups = {},
      }
    end,
  },
  'nvim-treesitter/nvim-treesitter-context',
  'tpope/vim-sleuth',
  {
    'debugloop/telescope-undo.nvim',
    dependencies = { -- note how they're inverted to above example
      {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    keys = {
      { -- lazy style key map
        '<leader>su',
        '<cmd>Telescope undo<cr>',
        desc = 'undo history',
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require('telescope').setup(opts)
      require('telescope').load_extension 'undo'
    end,
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
  -- { 'prettier/vim-prettier' },
  { 'ThePrimeagen/vim-apm' },
  { 'tpope/vim-dadbod' },
  { 'xiyaowong/telescope-emoji.nvim' },
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'folke/neodev.nvim',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets',
    },
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
  },

  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   }
  -- },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        filters = { dotfiles = false, git_ignored = false },
        view = { adaptive_size = true },
        update_focused_file = { enable = true },
      }
    end,
  },
  { 'folke/which-key.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = { follow_files = true },
      attach_to_untracked = false,
      current_line_blame = true,
      current_line_blame_opts = { virt_text = true, virt_text_pos = 'eol', delay = 1000, ignore_whitespace = false, virt_text_priority = 100 },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = { border = 'single', style = 'minimal', relative = 'cursor', row = 0, col = 1 },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        post_restore_cmds = nil,
        pre_save_cmds = nil,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'andrew-george/telescope-themes',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },
  { 'averms/black-nvim' },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
  },
  require 'kickstart.plugins.debug',
}, {})

-- Configure Noice
-- require("noice").setup({
--   lsp = {
--     override = {
--       ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--       ["vim.lsp.util.stylize_markdown"] = true,
--       ["cmp.entry.get_documentation"] = true,
--     },
--   },
--   presets = {
--     bottom_search = true,
--     command_palette = true,
--     long_message_to_split = true,
--     inc_rename = true,
--     lsp_doc_border = true,
--   },
-- })

-- Configure Lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'horizon',
    component_separators = '|',
    section_separators = '',
    inactive_sections = {
      lualine_a = {},
      lualine_b = { 'filename' },
      lualine_x = { 'filetype' },
    },
  },
}

-- Configure Toggleterm
require 'kickstart.plugins.toggleterm-config'
require 'kickstart.plugins.debug'

-- Configure Vim-APM
local apm = require 'vim-apm'
apm:setup {}
vim.keymap.set('n', '<leader>apm', function()
  apm:toggle_monitor()
end)

-- Telescope Built-in Functions
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

-- Toggle LSP Inlay Hints
vim.keymap.set('n', '<leader>m', function()
  if vim.lsp.inlay_hint then
    if vim.lsp.inlay_hint() then
      vim.lsp.inlay_hint(nil, false)
    else
      vim.lsp.inlay_hint(nil, true)
    end
  end
end)

-- Set Tmux Navigator No Wrap
vim.g.javascript_sql_dialect = 'mysql'
vim.g.tmux_navigator_no_wrap = 1

-- Rainbow Delimiters Configuration
local rainbow_delimiters = require 'rainbow-delimiters'
vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  priority = {
    [''] = 110,
    lua = 210,
  },
}

-- LSP Handlers Configuration
local _border = 'single'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = _border })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = _border })
vim.diagnostic.config { float = { border = _border } }

-- Set Colorscheme
vim.cmd.colorscheme 'catppuccin-mocha'

-- Basic Neovim Options
vim.o.hlsearch = true
vim.o.incsearch = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.backup = false
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = false
vim.o.undofile = true
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 300
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 50
vim.o.completeopt = 'menu,preview'
vim.o.termguicolors = true

-- Basic Keymaps
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<C-q>', '<cmd>call Black()<CR>')
-- Function to format selected range

-- -- Custom Window Movement Functions
-- local function move_right_or_next_tab()
--   local success, result = pcall(function()
--     local win_pos = vim.fn.win_screenpos(0)
--     local win_width = vim.fn.winwidth(0)
--     local total_width = vim.o.columns
--     if win_pos[2] + win_width - 1 == total_width then
--       vim.cmd("tabnext")
--     else
--       vim.cmd("wincmd l")
--     end
--   end)
--   if not success then
--     print("Error moving to the next tab or right window:", result)
--   end
-- end
--
-- local function move_left_or_prev_tab()
--   local success, result = pcall(function()
--     local win_pos = vim.fn.win_screenpos(0)
--     if win_pos[2] == 1 then
--       vim.cmd("tabprevious")
--     else
--       vim.cmd("wincmd h")
--     end
--   end)
--   if not success then
--     print("Error moving to the previous tab or left window:", result)
--   end
-- end
--
-- vim.api.nvim_create_user_command('MOVERIGHTORNEXTTAB', move_right_or_next_tab, {})
-- vim.api.nvim_create_user_command('MOVELEFTORPREVTAB', move_left_or_prev_tab, {})
-- vim.api.nvim_set_keymap('n', '<C-h>', ':MOVELEFTORPREVTAB<cr>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-l>', ':MOVERIGHTORNEXTTAB<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>nt', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nh', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { noremap = true, silent = true })

-- Conform Format
vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format { async = true, lsp_format = 'fallback', range = range }
end, { range = true })
-- Yank Highlight
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Restore Nvim-Tree with Auto-Session
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = 'NvimTree*',
  callback = function()
    local api = require 'nvim-tree.api'
    local view = require 'nvim-tree.view'
    if not view.is_visible() then
      api.tree.open()
    end
  end,
})

-- Scrollbar Handlers Configuration
require('scrollbar.handlers.gitsigns').setup()
-- local colors = require("catppuccin.palettes.macchiato")
require('scrollbar').setup {
  handle = { color = 'black' },
}

-- Telescope Setup
require('telescope').setup {
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

pcall(require('telescope').load_extension, 'emoji')
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'themes')

-- Custom Live Grep Function
local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  if current_file == '' then
    current_dir = cwd
  else
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep { search_dirs = { git_root } }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- Telescope Keymaps
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>se', ':Telescope emoji<cr>', { desc = '[S]earch [E]mojis' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sU', ':UndotreeShow<cr>', { desc = '[S]earch [U]ndotree' })

-- Treesitter Configuration
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    modules = {},
    ensure_installed = {
      'html',
      'markdown',
      'c',
      'cpp',
      'go',
      'lua',
      'python',
      'rust',
      'sql',
      'yaml',
      'tsx',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'bash',
    },
    auto_install = true,
    sync_install = true,
    ignore_install = {},
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- LSP Configuration
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local opts = { noremap = true, silent = true }

  -- LSPSaga key mappings
  vim.api.nvim_set_keymap('n', '<leader>Rn', '<cmd>Lspsaga rename<CR>', opts) -- Rename
  vim.api.nvim_set_keymap('n', '<leader>RN', '<cmd>Lspsaga rename<CR>', opts) -- Rename
  vim.api.nvim_set_keymap('n', '<leader>CA', '<cmd>Lspsaga code_action<CR>', opts) -- Code Action
  vim.api.nvim_set_keymap('n', '<leader>Ca', '<cmd>Lspsaga code_action<CR>', opts) -- Code Action
  vim.api.nvim_set_keymap('n', 'go', '<cmd>Lspsaga outline<CR>', opts) -- Peek Definition
  vim.api.nvim_set_keymap('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', opts) -- Peek Definition
  vim.api.nvim_set_keymap('n', 'gr', '<cmd>Lspsaga finder<CR>', opts) -- LSP Finder (includes references)
  nmap('gR', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  vim.api.nvim_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts) -- Go to Implementation
  vim.api.nvim_set_keymap('n', '<leader>D', '<cmd>Lspsaga type_definition<CR>', opts) -- Type Definition
  vim.api.nvim_set_keymap('n', '<leader>ds', '<cmd>Lspsaga document_symbol<CR>', opts) -- Document Symbols
  vim.api.nvim_set_keymap('n', '<leader>ws', '<cmd>Lspsaga workspace_symbol<CR>', opts) -- Workspace Symbols
  vim.api.nvim_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts) -- Hover Documentation
  nmap('gD', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts) -- Add Workspace Folder
  vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts) -- Remove Workspace Folder
  vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts) -- List Workspace Folders
  vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Go to previous diagnostic message', noremap = true, silent = true })
  vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Go to next diagnostic message', noremap = true, silent = true })
  vim.keymap.set('n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<CR>', { desc = 'Open floating diagnostic message', noremap = true, silent = true })
  vim.keymap.set('n', '<leader>q', function()
    vim.diagnostic.setqflist { open = false, workspace = true }
    vim.cmd 'copen'
  end, { desc = 'Open Workspace diagnostics', noremap = true, silent = true })
end

require('which-key').add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>d_', hidden = true },
  { '<leader>g', group = '[G]it' },
  { '<leader>g_', hidden = true },
  { '<leader>h', group = 'Git [H]unk' },
  { '<leader>h_', hidden = true },
  { '<leader>r', group = '[R]ename' },
  { '<leader>r_', hidden = true },
  { '<leader>s', group = '[S]earch' },
  { '<leader>s_', hidden = true },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>t_', hidden = true },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>w_', hidden = true },
  { 't', group = 'Toggle' },
  { 'tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Float' },
  { 'tg', '<cmd>lua _LAZYGIT_TOGGLE()<cr>', desc = 'LazyGit' },
  { 'th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Horizontal' },
  { 'tn', '<cmd>lua _NODE_TOGGLE()<cr>', desc = 'Node' },
  { 'tp', '<cmd>lua _PYTHON_TOGGLE()<cr>', desc = 'Python' },
  { 'tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Vertical' },
}

require('which-key').add {
  { '<leader>', group = 'VISUAL <leader>', mode = 'v' },
  { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
}

require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require 'lspconfig'
local servers = {
  clangd = {},
  ts_ls = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  -- eslint = {
  --   settings = {
  --     workingDirectory = { mode = 'auto' }
  --   },
  --   root_dir = lspconfig.util.root_pattern('.eslintrc.js', '.eslintrc.json', '.eslintrc.yaml', '.eslintrc.yml',
  --     '.eslintrc', '.git'),
  --   handlers = {
  --     ['eslint/noLibrary'] = function()
  --       return {}
  --     end,
  --   },
  -- }
}

require('neodev').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup { ensure_installed = vim.tbl_keys(servers) }

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}
-- lspconfig.eslint.setup {
--   on_attach = on_attach,
--   settings = {
--     workingDirectory = { mode = 'auto' }
--   },
--   root_dir = function(fname)
--     return lspconfig.util.root_pattern('.eslintrc.js', '.eslintrc.json', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc')(
--           fname) or
--         lspconfig.util.find_git_ancestor(fname) or
--         lspconfig.util.path.dirname(fname)
--   end,
--   handlers = {
--     ['eslint/noLibrary'] = function()
--       return {}
--     end,
--   },
-- }
--
lspconfig.ts_ls.setup {
  on_attach = function(client)
    -- Disable formatting for ESLint
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client)
  end,
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
  root_dir = function(fname)
    return lspconfig.util.root_pattern('tsconfig.json', 'package.json', 'jsconfig.json')(fname)
      or lspconfig.util.find_git_ancestor(fname)
      or lspconfig.util.path.dirname(fname)
  end,
  handlers = {
    ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
      -- Customize diagnostic handling here
      if result.diagnostics == nil then
        return
      end
      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end,
  },
}

-- Configure nvim-cmp
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local npairs = require 'nvim-autopairs'
npairs.setup {
  enable_check_bracket_line = false,
  check_ts = true,
  ts_config = {
    lua = { 'string' },
    javascript = { 'template_string' },
    java = false,
  },
}
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
}
-- -- Function to set the compiler settings for JavaScript and TypeScript
-- local function set_compiler()
--   if vim.bo.filetype == 'javascript' or vim.bo.filetype == 'typescript' then
--     vim.opt_local.makeprg = 'tsc %'
--     vim.opt_local.errorformat = '%A%f(%l\\,%c): %m,%Z'
--   elseif vim.bo.filetype == 'javascriptreact' or vim.bo.filetype == 'typescriptreact' then
--     vim.opt_local.makeprg = 'eslint %'
--     vim.opt_local.errorformat = '%f:%l:%c: %m'
--   end
-- end
--
-- -- Create an autocommand group for setting the compiler
-- vim.api.nvim_create_augroup('js_ts_compiler', { clear = true })
--
-- -- Create an autocommand to set the compiler settings on BufEnter
-- vim.api.nvim_create_autocmd('BufEnter', {
--   group = 'js_ts_compiler',
--   pattern = { '*.js', '*.ts', '*.jsx', '*.tsx' },
--   callback = set_compiler
-- })
