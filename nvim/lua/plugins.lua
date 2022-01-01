return require('packer').startup{function()

-- Packer can manage itself
use 'wbthomason/packer.nvim'
use 'lewis6991/impatient.nvim'
local map = vim.api.nvim_set_keymap
use 'mbbill/undotree'

use {
  'https://gitlab.com/yorickpeterse/nvim-window.git',
  event = 'VimEnter',
  config = function()
    require('nvim-window').setup {
      chars = {
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
        'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
        's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
      },
      normal_hl = 'BlackOnDarkBlue',
      hint_hl = 'Bold',
      border = 'none'
    }
  end
}
map('n', '<space>o', ":lua require('nvim-window').pick()<CR>",
  {silent = true})

use {
  "folke/which-key.nvim",
  event = 'VimEnter',
  config = function()
    require("which-key").setup {
      hidden = {
        "<silent>", "<cmd>", "<Cmd>", "<CR>", "<cr>", "call", "lua",
        "require", "nvim%-", "treesitter%.textobjects%.", "'lsp_interop'%.",
        "'swap'%.", "'move'%.",
        "^:", "^ "
      }
    }
  end
}

-- use "tversteeg/registers.nvim"

use {
  'phaazon/hop.nvim',
  branch = 'v1', -- optional but strongly recommended
  cmd = { 'HopWord', 'HopChar1' },
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    -- vim.api.nvim_command('highlight HopNextKey2 guifg=#1b9fbf')
  end
}
map('n', '<space>w', '<cmd>HopWord<cr>', {noremap = true})
map('n', '<space>c', '<cmd>HopChar1<cr>', {noremap = true})

use {
  'nanotee/zoxide.vim',
  event = 'VimEnter',
}

use {
  'TimUntersberger/neogit',
  requires = 'nvim-lua/plenary.nvim',
  cmd = 'Neogit',
}
map('n', '<space>V', '<cmd>Neogit<cr>', {noremap = true})

use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  cmd = 'Gitsigns',
  config = function()
    require('gitsigns').setup {
      signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      keymaps = {
        -- Default keymap options
        noremap = true,

        -- ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'"},
        -- ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'"},

        -- ['n <leader>hs'] = '<cmd>Gitsigns stage_hunk<CR>',
        -- ['v <leader>hs'] = ':Gitsigns stage_hunk<CR>',
        -- ['n <leader>hu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
        -- ['n <leader>hr'] = '<cmd>Gitsigns reset_hunk<CR>',
        -- ['v <leader>hr'] = '<cmd>Gitsigns reset_hunk<CR>',
        -- ['n <leader>hR'] = '<cmd>Gitsigns reset_buffer<CR>',
        -- ['n <leader>hp'] = '<cmd>Gitsigns preview_hunk<CR>',
        -- ['n <leader>hb'] = '<cmd>Gitsigns toggle_current_line_blame<CR>',
        ['n <leader>hB'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
        -- ['n <leader>hS'] = '<cmd>Gitsigns stage_buffer<CR>',
        -- ['n <leader>hU'] = '<cmd>Gitsigns reset_buffer_index<CR>',

        -- -- Text objects
        -- ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
        -- ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
      },
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter_opts = {
        relative_time = false
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm = {
        enable = false
      },
    }
  end
}
map('n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", {noremap = true, expr = true})
map('n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", {noremap = true, expr = true})

map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', {noremap = true})
map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>', {noremap = true})
map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', {noremap = true})
map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', {noremap = true})
map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>', {noremap = true})
map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>', {noremap = true})
map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', {noremap = true})
map('n', '<leader>hb', '<cmd>Gitsigns toggle_current_line_blame<CR>', {noremap = true})
map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', {noremap = true})
map('n', '<leader>hU', '<cmd>Gitsigns reset_buffer_index<CR>', {noremap = true})

map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>', {noremap = true})
map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>', {noremap = true})

use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} },
  cmd = 'Telescope',
  config = function()
    local action_layout = require "telescope.actions.layout"
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<C-e>"] = action_layout.toggle_preview,
            ["<C-o>"] = action_layout.cycle_layout_prev,
            ["<C-i>"] = action_layout.cycle_layout_next,
          },
          n = {
            ["<C-e>"] = action_layout.toggle_preview,
            ["<C-o>"] = action_layout.cycle_layout_prev,
            ["<C-i>"] = action_layout.cycle_layout_next,
          },
        },
        path_display = {
          truncate = 1,
        },
        cycle_layout_list = {"horizontal", "vertical"},
        layout_config = {
          horizontal = {
            height = 0.9,
            width = 0.9,
            preview_width = 0.7,
            preview_cutoff = 60
          }
        },
      },
    })

    local previewers = require('telescope.previewers')
--    local Job = require('plenary.job')
    local new_maker = function(filepath, bufnr, opts)
      filepath = vim.fn.expand(filepath)
      vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then return end
        if stat.size > 100000 then
          return
        else
--          Job:new({
--            command = 'file',
--            args = { '--mime-type', '-b', filepath },
--            on_exit = function(j)
--              local mime_type = vim.split(j:result()[1], '/')[1]
--              if mime_type == "text" then
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
--              else
--                -- maybe we want to write something to the buffer here
--                vim.schedule(function()
--                  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {'BINARY'})
--                end)
--              end
--            end
--          }):sync()
        end
      end)
    end

    require('telescope').setup {
      defaults = {
        buffer_previewer_maker = new_maker,
      }
    }
  end
}
map('n', '<space>ff', '<cmd>Telescope find_files<cr>', {noremap = true})
map('n', '<space>fg', '<cmd>Telescope live_grep<cr>', {noremap = true})
map('n', '<space>fb', '<cmd>Telescope buffers<cr>', {noremap = true})
map('n', '<space>fh', '<cmd>Telescope help_tags<cr>', {noremap = true})
map('n', '<space>fo', '<cmd>Telescope oldfiles<cr>', {noremap = true})

use {
  'machakann/vim-sandwich',
  event = "BufRead",
}

use {
  'nvim-treesitter/nvim-treesitter',
  event = "BufRead",
  requires = { 'p00f/nvim-ts-rainbow' },
  config = function()
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.org = {
      install_info = {
        url = 'https://github.com/milisims/tree-sitter-org',
        revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
        files = {'src/parser.c', 'src/scanner.cc'},
      },
      filetype = 'org',
    }

    require'nvim-treesitter.configs'.setup {
      ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
      highlight = {
        enable = true,              -- false will disable the whole extension
        disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
        additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
        -- disable = { "c", "rust" },  -- list of language that will be disabled
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        -- additional_vim_regex_highlighting = false,
      },
      rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 20000, -- Do not enable for files with more than n lines, int
        colors = {
          "#88fbff",
          "#f4ff88",
          "#ff88d6",
          "#8cff88",
          "#c088ff",
          "#ffd488",
          "#b388ff"
        }, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      }
    }

    -- vim.treesitter.set_query("python", "folds", [[
    --   (function_definition (block) @fold)
    --   (class_definition (block) @fold)
    -- ]])
    -- vim.treesitter.set_query("c", "folds", [[
    --   (function_definition)
    --   (struct_specifier)
    -- ]])
    -- vim.treesitter.set_query("cpp", "folds", [[
    --   (function_definition)
    --   (struct_specifier)
    --   (class_specifier)
    -- ]])
    -- vim.treesitter.set_query("javascript", "folds", [[
    --   (function)
    --   (function_declaration)
    --   (class_declaration)
    --   (method_definition)
    -- ]])
    -- vim.treesitter.set_query("typescript", "folds", [[
    --   (function)
    --   (function_declaration)
    --   (class_declaration)
    --   (method_definition)
    -- ]])
  end
}
use {
  'nvim-treesitter/nvim-treesitter-textobjects',
  after = "nvim-treesitter",
  config = function()
    require'nvim-treesitter.configs'.setup {
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim 
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<space>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<space>A"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_next_end = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_previous_start = {
            ["[M"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[m"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        lsp_interop = {
          enable = true,
          border = 'none',
          peek_definition_code = {
            ["<space>df"] = "@function.outer",
            ["<space>dF"] = "@class.outer",
            ["<space>dt"] = "@function.inner",
            ["<space>dT"] = "@class.inner",
          },
        },
      },
    }
  end
}
use {
  'nvim-orgmode/orgmode',
  -- ft = {'org'},
  after = "nvim-treesitter",
  config = function()
    require('orgmode').setup {
      org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
      org_default_notes_file = '~/Dropbox/org/refile.org',
    }
  end
}
-- use 'shaeinst/roshnivim-cs'
use {
  'folke/tokyonight.nvim',
}
use {
  'nvim-lualine/lualine.nvim',
  requires = {'kyazdani42/nvim-web-devicons', opt = true},
  after = 'tokyonight.nvim',
  config = function()
    require("lualine").setup {
      options = {
        theme = 'tokyonight', -- powerline
        component_separators = {left='', right=''}
      },
      sections = {
        lualine_a = {
          {'mode', fmt=function(s) return s:sub(1,3) end}
        },
        lualine_b = {'branch',
          {'diff', -- symbols = {added = '', modified = '', removed = ''}
            },
          {'diagnostics', sources={'nvim_diagnostic'},
            symbols = {error = '', warn = '', info = '', hint = '♲'}}
        },
        lualine_c = {
          {'filename', path=1, shorting_target=0,
            symbols = {modified='✎', readonly='⛒'}}
        },
        lualine_x = {
          {'encoding', fmt=function(s)
            return s:sub(1, 1) .. s:gsub("^[^0-9]*", "")
          end},
          'fileformat'
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', path=1, shorting_target=0}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      }
    }
  end
}

use {
  'windwp/nvim-autopairs',
  event = "BufRead",
  config = function()
    require('nvim-autopairs').setup({
      disable_filetype = { "TelescopePrompt" , "vim" },
      disable_in_macro = true,
      enable_moveright = false,
      check_ts = true,
      map_bs = false,
    })
  end
}

use {
  'hrsh7th/nvim-cmp',
  requires = {
    {
      'hrsh7th/cmp-nvim-lsp',
      after = 'nvim-cmp',
    },
    {
      'hrsh7th/cmp-buffer',
      after = 'nvim-cmp',
    },
    {
      'hrsh7th/cmp-path',
      after = 'nvim-cmp',
    },
    {
      'hrsh7th/cmp-cmdline',
      after = 'nvim-cmp',
    },
    {
      'hrsh7th/cmp-vsnip',
      after = 'nvim-cmp',
    },
    { 'hrsh7th/vim-vsnip' },
    { 'rafamadriz/friendly-snippets' },
  },
  event = "BufRead",
  config = function()
    -- Setup nvim-cmp.
    local cmp = require'cmp'

    cmp.setup({
      completion = {
          autocomplete = false,
      },
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
        end,
      },
      mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-u>'] = cmp.config.disable,
        ['<C-d>'] = cmp.config.disable,
        ['<C-a>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<C-e>'] = cmp.mapping(cmp.mapping.close(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'treesitter' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
        { name = 'orgmode' },
        { name = 'path' },
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })
    cmp.setup.cmdline('?', {
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
    -- nvim-autopairs
    -- If you want insert `(` after select function or method item
    --local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    --cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
  end
}

use {
  'neovim/nvim-lspconfig',
  --require = 'hrsh7th/cmp-nvim-lsp',
  --ft = {'rs', 'py', 'php', 'lua', 'c', 'cpp', 'h', 'hpp'},
  after = 'nvim-cmp',
  config = function()
    -- vim.diagnostic.config({
    --   virtual_text = true,
    --   signs = true,
    --   underline = true,
    --   update_in_insert = false,
    --   severity_sort = false,
    -- })
    -- local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
    -- for type, icon in pairs(signs) do
    --   local hl = "DiagnosticSign" .. type
    --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    -- end

    local nvim_lsp = require('lspconfig')

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      -- Enable completion triggered by <c-x><c-o>
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      local opts = { noremap=true, silent=true }

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<space>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<space>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<space>Ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
      buf_set_keymap('n', '<space>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      buf_set_keymap('v', '<space>F', ':lua vim.lsp.buf.range_formatting()<CR>', opts)
    end

    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { 'pylsp', 'rust_analyzer', 'tsserver', 'intelephense' }
    for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
    end
    -- Linters
    nvim_lsp.eslint.setup{}
    nvim_lsp.pyright.setup{}
  end
}

use {
  'chipsenkbeil/distant.nvim',
  event = 'VimEnter',
  config = function()
    require('distant').setup {
      -- Applies Chip's personal settings to every machine you connect to
      --
      -- 1. Ensures that distant servers terminate with no connections
      -- 2. Provides navigation bindings for remote directories
      -- 3. Provides keybinding to jump into a remote file's parent directory
      ['*'] = require('distant.settings').chip_default()
    }
  end
}

end,
config = {
  -- Move to lua dir so impatient.nvim can cache it
  compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
}}
