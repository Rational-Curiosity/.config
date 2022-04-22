return require'packer'.startup {function()

-- Packer can manage itself
use 'wbthomason/packer.nvim'
use 'lewis6991/impatient.nvim'
use {
  'mbbill/undotree',
  opt = true,
}

-- use {'nathom/filetype.nvim'}
local noremap = { noremap = true }
local map = vim.api.nvim_set_keymap

use {
  "folke/which-key.nvim",
  opt = true,
  config = function()
    local which_key = require'which-key'
    which_key.setup {
      popup_mappings = {
        scroll_down = '<C-d>', -- binding to scroll down inside the popup
        scroll_up = '<C-u>', -- binding to scroll up inside the popup
      },
      layout = {
        height = { min = 3, max = 16 },
        width = { min = 20, max = 40 },
        spacing = 3,
        align = "center",
      },
      hidden = {
        "<silent>", "<cmd>", "<Cmd>", "<CR>", "<cr>", "call", "lua",
        "require", "nvim%-", "vim%.", "treesitter%.textobjects%.",
        "'lsp_interop'%.", "lsp%.buf%.",
        "'select'%.select_textobject",
        "'swap'%.", "'move'%.", '%("orgmode"%)%.action',
        "keybind norg core%.norg%.qol%.todo_items%.todo%.",
        "keybind norg core%.norg%.manoeuvre%.",
        "keybind norg core%.norg%.", "keybind norg core%.",
        "^:", "^ "
      },
    }
    which_key.register({
      C = { name = 'Quickfix' },
      f = { name = 'Telescope', g = 'Git', l = 'Lsp' },
      G = { name = 'Neogit' },
      h = { name = 'Gitsigns', t = 'Toggle' },
      -- n = { name = 'Neorg', m = 'mode', n = 'note', t = 'gtd' },
      o = { name = 'Org', i = 'Insert', x = 'Clock' },
      P = { name = 'Put exec' },
      R = { name = 'Snip run' },
      S = { name = 'Sessions', W = 'Working dir' },
      s = { name = 'Treesitter' },
      t = { name = 'Table mode', f = 'Formula' },
      W = { name = 'Working dir' },
      Y = { name = 'Yank', f = 'Filename' },
    }, { mode = 'n', prefix = '<leader>' })
    which_key.register({
      f = { name = 'Telescope' },
    }, { mode = 'x', prefix = '<leader>' })
    which_key.register({
      x = 'Fold except region',
    }, { mode = 'x', prefix = 'z' })
    which_key.register({
      ['<c-d>'] = 'Complete defined identifiers',
      ['<c-e>'] = 'Scroll up',
      ['<c-f>'] = 'Complete file names',
      ['<c-i>'] = 'Complete identifiers',
      ['<c-k>'] = 'Complete identifiers from dictionary',
      ['<c-l>'] = 'Complete whole lines',
      ['<c-n>'] = 'Next completion',
      ['<c-o>'] = 'Omni completion',
      ['<c-p>'] = 'Previous completion',
      ['<c-s>'] = 'Spelling suggestions',
      ['<c-t>'] = 'Complete identifiers from thesaurus',
      ['<c-y>'] = 'Scroll down',
      ['<c-u>'] = "Complete with 'completefunc'",
      ['<c-v>'] = 'Complete like in : command line',
      ['<c-z>'] = 'Stop completion, keeping the text as-is',
      ['<c-]>'] = 'Complete tags',
      s = 'spelling suggestions',
    }, { mode = 'i', prefix = '<c-x>' })
  end
}

use {
  'anuvyklack/pretty-fold.nvim',
  opt = true,
  config = function()
    require('pretty-fold').setup {
      fill_char = '·',
      sections = {
        left = {
          'content', '   ',
        },
        right = {
          '  ', 'number_of_folded_lines', ': ', 'percentage', '  ',
          function(config) return config.fill_char:rep(3) end
        }
      },
    }
    require('pretty-fold.preview').setup()
  end
}

use {
  'phaazon/hop.nvim',
  -- branch = 'v1', -- optional but strongly recommended
  cmd = { 'HopWord', 'HopWordMW', 'HopChar1' },
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    vim.api.nvim_command('highlight HopNextKey2 guifg=#1b9fbf')
  end
}
map('n', '<space>j', '<cmd>HopWord<cr>', noremap)
map('n', '<space>J', '<cmd>HopWordMW<cr>', noremap)
map('n', '<A-z>', '<cmd>HopChar1<cr>', noremap)

use {
  'nanotee/zoxide.vim',
  cmd = {'Z', 'Zi'},
}

use {
  'jbyuki/venn.nvim',
  cmd = { 'VBox' },
}
map('x', '<leader>B', ':VBox<cr>', noremap)

use {
  'TimUntersberger/neogit',
  requires = {
    {
      'nvim-lua/plenary.nvim',
      opt = true,
    },
  },
  setup = function()
    require'packer'.loader('plenary.nvim')
  end,
  cmd = 'Neogit',
  config = function()
    local neogit = require('neogit')
    neogit.setup {
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      auto_refresh = true,
      disable_builtin_notifications = false,
      use_magit_keybindings = false,
      commit_popup = {
        kind = "split",
      },
      -- Change the default way of opening neogit
      kind = "vsplit",
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
        -- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
        --
        -- Requires you to have `sindrets/diffview.nvim` installed.
        -- use { 
        --   'TimUntersberger/neogit', 
        --   requires = { 
        --     'nvim-lua/plenary.nvim',
        --     'sindrets/diffview.nvim' 
        --   }
        -- }
        --
        diffview = false  
      },
      -- Setting any section to `false` will make the section not render at all
      sections = {
        untracked = {
          folded = false
        },
        unstaged = {
          folded = false
        },
        staged = {
          folded = false
        },
        stashes = {
          folded = true
        },
        unpulled = {
          folded = true
        },
        unmerged = {
          folded = false
        },
        recent = {
          folded = true
        },
      },
      -- override/add mappings
      mappings = {
        -- modify status buffer mappings
        status = {
          -- Adds a mapping with "B" as key that does the "BranchPopup" command
          ["B"] = "BranchPopup",
          -- Removes the default mapping of "s"
          -- ["s"] = "",
        }
      }
  }
  end
}
map('n', '<leader>Gt', '<cmd>Neogit kind=tab<cr>', noremap)
map('n', '<leader>Gs', '<cmd>Neogit kind=split<cr>', noremap)
map('n', '<leader>Gv', '<cmd>Neogit kind=vsplit<cr>', noremap)
map('n', '<leader>Gr', '<cmd>Neogit kind=replace<cr>', noremap)

use {
  'nvim-telescope/telescope.nvim',
  requires = {
    { 'nvim-lua/plenary.nvim', opt = true, },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      opt = true,
      run = 'make',
    },
  },
  opt = true,
  cmd = 'Telescope',
  config = function()
    require'packer'.loader('telescope-fzf-native.nvim')
    local action_layout = require "telescope.actions.layout"
    local filetype_args = {
      ["c"] = "-tcpp",
      ["htmldjango"] = "-thtml",
      ["javascript"] = "-tjs",
      ["python"] = "-tpy",
      ["rs"] = "-trust",
      ["typescript"] = "-tts",
    }
    local function additional_args_filetype(opts)
      local args = {}
      if opts.args then
        opts.args:gsub("[^,]*", function(s) args[#args+1]=s end)
      end
      if opts.ft == true then
        table.insert(
          args, filetype_args[vim.bo.filetype] or "-t"..vim.bo.filetype)
      end
      return args
    end

    require'telescope'.setup {
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
        },
      },
      defaults = {
        initial_mode = "insert",
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
        cycle_layout_list = { "horizontal", "vertical" },
        layout_config = {
          horizontal = {
            height = 0.9,
            width = 0.9,
            preview_width = 0.7,
            preview_cutoff = 60
          }
        },
        preview = {
          filesize_limit = 0.5,
          timeout = 500,
        },
      },
      pickers = {
        buffers = {
          ignore_current_buffer = true,
        },
        live_grep = {
          additional_args = additional_args_filetype
        },
        grep_string = {
          additional_args = additional_args_filetype
        },
      },
    }
    require'telescope'.load_extension('fzf')

--     local previewers = require'telescope.previewers'
-- --    local Job = require'plenary.job'
--     local new_maker = function(filepath, bufnr, opts)
--       filepath = vim.fn.expand(filepath)
--       vim.loop.fs_stat(filepath, function(_, stat)
--         if not stat then return end
--         if stat.size > 100000 then
--           return
--         else
-- --          Job:new({
-- --            command = 'file',
-- --            args = { '--mime-type', '-b', filepath },
-- --            on_exit = function(j)
-- --              local mime_type = vim.split(j:result()[1], '/')[1]
-- --              if mime_type == "text" then
--                 previewers.buffer_previewer_maker(filepath, bufnr, opts)
-- --              else
-- --                -- maybe we want to write something to the buffer here
-- --                vim.schedule(function()
-- --                  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {'BINARY'})
-- --                end)
-- --              end
-- --            end
-- --          }):sync()
--         end
--       end)
--     end
--
--     require'telescope'.setup {
--       defaults = {
--         buffer_previewer_maker = new_maker,
--       }
--     }
  end
}
map('n', '<leader>f-', '<cmd>Telescope resume<cr>', noremap)
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', noremap)
map('n', '<leader>fR', '<cmd>Telescope live_grep ft=true<cr>', noremap)
map('n', '<leader>fr', '<cmd>Telescope live_grep<cr>', noremap)
map('x', '<leader>f:', '"0y:Telescope grep_string ft=true search=<c-r>0<cr><esc>', noremap)
map('x', '<leader>f.', '"0y:Telescope grep_string search=<c-r>0<cr><esc>', noremap)
map('n', '<leader>f:', '<cmd>Telescope grep_string ft=true<cr><esc>', noremap)
map('n', '<leader>f.', '<cmd>Telescope grep_string<cr><esc>', noremap)
map('n', '<leader>f;', ':Telescope grep_string ft=true search=', noremap)
map('n', '<leader>f,', ':Telescope grep_string search=', noremap)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr><esc>', noremap)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', noremap)
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', noremap)
map('n', '<leader>fd', '<cmd>Telescope diagnostics<cr><esc>', noremap)
map('n', '<leader>fs', '<cmd>Telescope treesitter<cr><esc>', noremap)
map('n', '<leader>fgC', '<cmd>Telescope git_commits<cr><esc>', noremap)
map('n', '<leader>fgc', '<cmd>Telescope git_bcommits<cr><esc>', noremap)
map('n', '<leader>fgb', '<cmd>Telescope git_branches<cr><esc>', noremap)
map('n', '<leader>fgs', '<cmd>Telescope git_status<cr><esc>', noremap)
map('n', '<leader>fgf', '<cmd>Telescope git_files<cr><esc>', noremap)
map('n', '<leader>fgS', '<cmd>Telescope git_stash<cr><esc>', noremap)
map('n', '<leader>flA', '<cmd>Telescope lsp_range_code_actions<cr><esc>', noremap)
map('n', '<leader>fls', '<cmd>Telescope lsp_workspace_symbols<cr><esc>', noremap)
map('n', '<leader>fli', '<cmd>Telescope lsp_implementations<cr><esc>', noremap)
map('n', '<leader>fla', '<cmd>Telescope lsp_code_actions<cr><esc>', noremap)
map('n', '<leader>fld', '<cmd>Telescope lsp_definitions<cr><esc>', noremap)
map('n', '<leader>flr', '<cmd>Telescope lsp_references<cr><esc>', noremap)

use {
  'tpope/vim-repeat',
  opt = true,
}

use {
  'tpope/vim-surround',
  opt = true,
}

use {
  'sQVe/sort.nvim',
  cmd = 'Sort',
}

use {
  'sbdchd/neoformat',
  cmd = 'Neoformat',
}

use {
  'dhruvasagar/vim-table-mode',
  cmd = { 'TableModeToggle', 'TableModeRealign', 'Tableize', 'TableAddFormula', 'TableEvalFormulaLine' },
}
map('n', '<leader>tm', '<cmd>TableModeToggle<cr>', noremap)
map('n', '<leader>tr', '<cmd>TableModeRealign<cr>', noremap)
map('n', '<leader>tt', '<cmd>Tableize<cr>', noremap)
map('n', '<leader>tfa', '<cmd>TableAddFormula<cr>', noremap)
map('n', '<leader>tfe', '<cmd>TableEvalFormulaLine<cr>', noremap)

use {
  'lewis6991/gitsigns.nvim',
  requires = {
    {
      'nvim-lua/plenary.nvim',
      opt = true,
    },
  },
  opt = true,
  config = function()
    vim.api.nvim_exec([[
      highlight GitSignsAddLnInline     guibg=#004d00
      highlight GitSignsChangeLnInline  guibg=#3d004d
      highlight GitSignsDeleteLnInline  guibg=#391313
      highlight GitSignsAddInline       guibg=#004d00
      highlight GitSignsChangeInline    guibg=#3d004d
      highlight GitSignsDeleteInline    guibg=#391313
      highlight GitSignsAdd             guibg=#004d00
      highlight GitSignsChange          guibg=#3d004d
      highlight GitSignsDelete          guibg=#391313
      highlight GitSignsAddNr           guifg=#80ff80
      highlight GitSignsChangeNr        guifg=#e580ff
      highlight GitSignsDeleteNr        guifg=#df9f9f
      highlight GitSignsAddLn           guibg=#004d00
      highlight GitSignsChangeLn        guibg=#3d004d
      highlight GitSignsDeleteLn        guibg=#391313
    ]], false)
    require'gitsigns'.setup {
      signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
      signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
      numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`
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
map('n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", { noremap=true, expr=true })
map('n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", { noremap=true, expr=true })

map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', noremap)
map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>', noremap)
map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', noremap)
map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', noremap)
map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>', noremap)
map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>', noremap)
map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', noremap)
map('n', '<leader>hB', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', noremap)
map('n', '<leader>hb', '<cmd>Gitsigns toggle_current_line_blame<CR>', noremap)
map('n', '<leader>hts', '<cmd>Gitsigns toggle_signs<CR>', noremap)
map('n', '<leader>htn', '<cmd>Gitsigns toggle_numhl<CR>', noremap)
map('n', '<leader>htl', '<cmd>Gitsigns toggle_linehl<CR>', noremap)
map('n', '<leader>htw', '<cmd>Gitsigns toggle_word_diff<CR>', noremap)
map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', noremap)
map('n', '<leader>hU', '<cmd>Gitsigns reset_buffer_index<CR>', noremap)

map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>', noremap)
map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>', noremap)

use {
  'nvim-treesitter/nvim-treesitter',
  opt = true,
  requires = {
    { 'nvim-treesitter/nvim-treesitter-refactor', opt = true },
    { 'windwp/nvim-ts-autotag', opt = true },
  --   { 'p00f/nvim-ts-rainbow', opt = true },
  --   { 'nvim-treesitter/playground', opt = true },
  },
  config = function()
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.org = {
      install_info = {
        url = 'https://github.com/milisims/tree-sitter-org',
        files = {'src/parser.c', 'src/scanner.cc'},
      },
      filetype = 'org',
    }
    -- parser_config.norg = {
    --     install_info = {
    --         url = "https://github.com/nvim-neorg/tree-sitter-norg",
    --         files = { "src/parser.c", "src/scanner.cc" },
    --         branch = "main"
    --     },
    -- }
    -- parser_config.norg_meta = {
    --     install_info = {
    --         url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    --         files = { "src/parser.c" },
    --         branch = "main"
    --     },
    -- }
    -- parser_config.norg_table = {
    --     install_info = {
    --         url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    --         files = { "src/parser.c" },
    --         branch = "main"
    --     },
    -- }

    require'nvim-treesitter.configs'.setup {
      ensure_installed = {
        "bash",
        "bibtex",
        "c",
        "c_sharp",
        "clojure",
        "cmake",
        "comment",
        "commonlisp",
        "cpp",
        "css",
        "dart",
        "dockerfile",
        "dot",
        "elixir",
        "elm",
        "erlang",
        "glimmer",
        "go",
        "godot_resource",
        "gomod",
        "gowork",
        "graphql",
        "haskell",
        "html",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "kotlin",
        "latex",
        "lua",
        "make",
        "markdown",
        -- "norg", "norg_meta", "norg_table",
        -- "org",
        "perl",
        "php",
        "python",
        "ql",
        "query",
        "regex",
        "rst",
        "rust",
        "scala",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "yang",
        "zig",
      }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
      refactor = {
        highlight_definitions = {
          enable = false,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = false },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "<leader>sr",
          },
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = "<leader>sd",
            list_definitions = "<leader>sl",
            list_definitions_toc = "<leader>sL",
            goto_next_usage = "<leader>sn",
            goto_previous_usage = "<leader>sp",
          },
        },
      },
      autotag = {
        enable = true,
      },
      -- rainbow = {
      --   enable = true,
      --   disable = {'org'}, -- list of languages you want to disable the plugin for
      --   extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      --   max_file_lines = 20000, -- Do not enable for files with more than n lines, int
      --   colors = {
      --     "#88fbff",
      --     "#f4ff88",
      --     "#ff88d6",
      --     "#8cff88",
      --     "#c088ff",
      --     "#ffd488",
      --     "#b388ff"
      --   }, -- table of hex strings
      --   -- termcolors = {} -- table of colour name strings
      -- },
      -- playground = {
      --   enable = true,
      --   disable = { 'org' },
      --   updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      --   persist_queries = false, -- Whether the query persists across vim sessions
      --   keybindings = {
      --     toggle_query_editor = 'o',
      --     toggle_hl_groups = 'i',
      --     toggle_injected_languages = 't',
      --     toggle_anonymous_nodes = 'a',
      --     toggle_language_display = 'I',
      --     focus_language = 'f',
      --     unfocus_language = 'F',
      --     update = 'R',
      --     goto_node = '<cr>',
      --     show_help = '?',
      --   },
      -- },
    }

    vim.api.nvim_set_keymap('', '<space>I',
      '<cmd>echo nvim_treesitter#statusline()<cr>', { noremap = true })
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
    vim.api.nvim_command('syntax on')
  end
}
use {
  'nvim-treesitter/nvim-treesitter-textobjects',
  opt = true,
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
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>]a"] = "@parameter.inner",
            ["<leader>]f"] = "@function.outer",
            ["<leader>]c"] = "@class.outer",
            ["<leader>]l"] = "@loop.outer",
            ["<leader>]b"] = "@block.outer",
            ["<leader>]i"] = "@conditional.outer",
          },
          swap_previous = {
            ["<leader>[a"] = "@parameter.inner",
            ["<leader>[f"] = "@function.outer",
            ["<leader>[c"] = "@class.outer",
            ["<leader>[l"] = "@loop.outer",
            ["<leader>[b"] = "@block.outer",
            ["<leader>[i"] = "@conditional.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]A"] = "@parameter.outer",
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]L"] = "@loop.outer",
            ["]B"] = "@block.outer",
            ["]I"] = "@conditional.outer",
          },
          goto_next_end = {
            ["]a"] = "@parameter.outer",
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]l"] = "@loop.outer",
            ["]b"] = "@block.outer",
            ["]i"] = "@conditional.outer",
          },
          goto_previous_start = {
            ["[A"] = "@parameter.outer",
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[L"] = "@loop.outer",
            ["[B"] = "@block.outer",
            ["[I"] = "@conditional.outer",
          },
          goto_previous_end = {
            ["[a"] = "@parameter.outer",
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[l"] = "@loop.outer",
            ["[b"] = "@block.outer",
            ["[i"] = "@conditional.outer",
          },
        },
        lsp_interop = {
          enable = true,
          border = 'none',
          peek_definition_code = {
            ["<leader>sf"] = "@function.outer",
            ["<leader>sF"] = "@class.outer",
            ["<leader>st"] = "@function.inner",
            ["<leader>sT"] = "@class.inner",
          },
        },
      },
    }
    require'which-key'.register({
      ['['] = { name = 'Swap prev' },
      [']'] = { name = 'Swap next' },
    }, { mode = 'n', prefix = '<leader>' })
  end
}
use {
  'mfussenegger/nvim-treehopper',
  opt = true,
  after = "nvim-treesitter",
}
map('o', 'm', ':<C-U>lua require("tsht").nodes()<CR>', {silent = true})
map('v', 'm', ':lua require("tsht").nodes()<CR>', {noremap = true, silent = true})
use {
  'nvim-orgmode/orgmode',
  opt = true,
  ft = {'org'},
  after = "nvim-treesitter",
  config = function()
    require'packer'.loader('nvim-treesitter')
    local orgmode = require'orgmode'
    orgmode.setup_ts_grammar()
    orgmode.setup {
      org_agenda_files = {'~/var/Dropbox/Orgzly/*', '~/my-orgs/**/*'},
      org_default_notes_file = '~/Dropbox/org/refile.org',
      org_todo_keywords = {
        "TODO(t)", "NEXT(n)", "STAR(s)",
        "UNDO(u)", "VERI(v)",
        "PLAN(p)", "LINK(k)", "WAIT(w)",
        "FIXM(b)", "REOP(r)", "HOLD(h)",
        "|", "DONE(d)",
        "ENOU(e)", "DELE(l)",
        "FINI(f)",
        "CANC(c)",
      },
      org_todo_keyword_faces = {
        TODO = ':foreground DarkRed :weight bold',
        NEXT = ':foreground LightYellow :weight bold',
        DONE = ':foreground DarkGreen :weight bold',
        PLAN = ':foreground blue :weight bold',
        STAR = ':foreground DarkBlue :weight bold',
        REOP = ':foreground DarkRed :weight bold',
        FINI = ':foreground LightGreen :weight bold',
        ENOU = ':foreground LightGreen :weight bold',
        DELE = ':foreground LightGreen :weight bold',
        LINK = ':foreground magenta :weight bold',
        WAIT = ':foreground cyan :weight bold',
        HOLD = ':foreground cyan :weight bold :underline t',
        CANC = ':foreground DarkGreen :weight bold',
        FIXM = ':foreground DarkRed :weight bold',
        VERI = ':foreground LightBlue :weight bold',
        UNDO = ':foreground LightBlue :weight bold',
      },
      org_priority_highest = 'A',
      org_priority_default = 'H',
      org_priority_lowest = 'O',
      org_ellipsis = '▼',
      org_indent_mode = 'noindent',
    }
  end
}
use {
  'michaelb/sniprun',
  run = 'bash ./install.sh',
  cmd = { 'SnipRun', 'SnipReset', 'SnipClose', 'SnipReplMemoryClean', 'SnipInfo', 'SnipTerminate' },
  config = function()
    require'sniprun'.setup({
      selected_interpreters = {},     --# use those instead of the default for the current filetype
      repl_enable = {},               --# enable REPL-like behavior for the given interpreters
      repl_disable = {},              --# disable REPL-like behavior for the given interpreters

      interpreter_options = {         --# intepreter-specific options, see docs / :SnipInfo <name>
        GFM_original = {
          use_on_filetypes = {"markdown.pandoc"}    --# the 'use_on_filetypes' configuration key is
                                                    --# available for every interpreter
        }
      },

      --# you can combo different display modes as desired
      display = {
        -- "Classic",                    --# display results in the command-line  area
        -- "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)

        -- "VirtualTextErr",          --# display error results as virtual text
        -- "TempFloatingWindow",      --# display results in a floating window
        -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
        -- "Terminal",                --# display results in a vertical split
        "TerminalWithCode",        --# display results and code history in a vertical split
        -- "NvimNotify",              --# display with the nvim-notify plugin
        -- "Api"                      --# return output to a programming interface
      },

      display_options = {
        terminal_width = 45,       --# change the terminal display option width
        notification_timeout = 5   --# timeout for nvim_notify output
      },

      --# You can use the same keys to customize whether a sniprun producing
      --# no output should display nothing or '(no output)'
      show_no_output = {
        "Classic",
        -- "TempFloatingWindow",      --# implies LongTempFloatingWindow, which has no effect on its own
      },

      --# customize highlight groups (setting this overrides colorscheme)
      snipruncolors = {
        SniprunVirtualTextOk   =  {bg="#66eeff",fg="#000000",ctermbg="Cyan",cterfg="Black"},
        SniprunFloatingWinOk   =  {fg="#66eeff",ctermfg="Cyan"},
        SniprunVirtualTextErr  =  {bg="#881515",fg="#000000",ctermbg="DarkRed",cterfg="Black"},
        SniprunFloatingWinErr  =  {fg="#881515",ctermfg="DarkRed"},
      },

      --# miscellaneous compatibility/adjustement settings
      inline_messages = 0,             --# inline_message (0/1) is a one-line way to display messages
    				   --# to workaround sniprun not being able to display anything

      borders = 'single'               --# display borders around floating windows
                                       --# possible values are 'none', 'single', 'double', or 'shadow'
    })
  end
}
map('v', '<leader>Rr', ':SnipReplMemoryClean<CR>:SnipRun<CR>', {silent = true})
-- map('n', '<leader>Ro', '<cmd>SnipRunOperator<CR>', {silent = true})
map('n', '<leader>Rr', '<cmd>SnipReplMemoryClean<CR>:SnipRun<CR>', {silent = true})
map('n', '<leader>Rc', '<cmd>SnipReplMemoryClean<CR>', {silent = true})
map('n', '<leader>Rs', '<cmd>SnipReset<CR>', {silent = true})
map('n', '<leader>Rc', '<cmd>SnipClose<CR>', {silent = true})
map('n', '<leader>Ri', '<cmd>SnipInfo<CR>', {silent = true})
map('n', '<leader>Rt', '<cmd>SnipTerminate<CR>', {silent = true})

-- use {
--   "nvim-neorg/neorg",
--   opt = true,
--   ft = { 'norg' },
--   after = "nvim-treesitter",
--   -- setup = vim.cmd("autocmd BufRead,BufNewFile *.norg setlocal filetype=norg"),
--   requires = {
--     {
--       "nvim-lua/plenary.nvim",
--       opt = true,
--     },
--     {
--       'nvim-treesitter/nvim-treesitter',
--       opt = true,
--     },
--   },
--   config = function()
--     vim.api.nvim_command('packadd plenary.nvim')
--     vim.api.nvim_command('packadd nvim-treesitter')
--     require('neorg').setup {
--       -- Tell Neorg what modules to load
--       load = {
--         ["core.defaults"] = {}, -- Load all the default modules
--         ["core.keybinds"] = { -- Configure core.keybinds
--           config = {
--             default_keybinds = true, -- Generate the default keybinds
--             neorg_leader = "<Leader>n", -- This is the default if unspecified
--           }
--         },
--         ["core.norg.concealer"] = {}, -- Allows for use of icons
--         ["core.norg.dirman"] = { -- Manage your directories with Neorg
--           config = {
--             workspaces = {
--               gtd = vim.fn.isdirectory(vim.env.HOME.."/var/Dropbox/Orgzly"
--               ) ~= 0 and "~/var/Dropbox/Orgzly" or "~/Prog/org/gigas",
--             }
--           }
--         },
--         ["core.norg.manoeuvre"] = {},
--         ["core.norg.completion"] = {
--           config = {
--             engine = "nvim-cmp"
--           }
--         },
--         ["core.gtd.base"] = {
--           config = {
--             workspace = "gtd",
--           }
--         },
--         ["core.gtd.ui"] = {},
--         ["core.integrations.treesitter"] = {},
--         -- ["core.integrations.telescope"] = {},
--         ["core.integrations.nvim-cmp"] = {},
--       },
--     }
--     require'which-key'.register({
--       t = { name = 'Gtd' },
--     }, { mode = 'n', prefix = 'g' })
--   end,
-- }

use {
  'chrisbra/csv.vim',
  ft = {'csv'},
}

-- use 'shaeinst/roshnivim-cs'
use {
  'folke/tokyonight.nvim',
  opt = true,
  config = function()
    vim.api.nvim_command(
    'colo tokyonight | hi LineNr guifg=#5081c0 | hi CursorLineNR guifg=#ffba00 | hi Folded guifg=blue guibg=grey')
  end
}
use {
  'nvim-lualine/lualine.nvim',
  opt = true,
  after = 'tokyonight.nvim',
  requires = {
    {
      'kyazdani42/nvim-web-devicons',
      opt = true,
    },
    {
      'arkav/lualine-lsp-progress',
      opt = true,
    },
  },
  config = function()
    local home_path = os.getenv("HOME")
    -- local function spellstatus()
    --   if (vim.opt.spell:get()) then 
    --     return [[spell]] 
    --   else
    --     return ''
    --   end
    -- end
    local abbrev_path_memoize = {}
    local function abbrev_path(s, space, len)
      local m_key = s .. "," .. space .. "," .. len
      local m_value = abbrev_path_memoize[m_key] 
      if m_value ~= nil then
        return m_value
      end
      local subs
      local s_len = s:len()
      local pattern = "("..string.rep("[^/]", len).."[^/]+)(/%.?)"
      while s_len > space do
        s, subs = s:gsub(pattern, function(a, b)
          return a:sub(1, len)..b
        end, 1)
        if subs == 0 then break end
        s_len = s:len()
      end
      abbrev_path_memoize[m_key] = s
      return s
    end
    local abbrev_name_memoize = {}
    local function abbrev_name(s, space)
      local m_key = s .. "," .. space
      local m_value = abbrev_name_memoize[m_key] 
      if m_value ~= nil then
        return m_value
      end
      local subs
      local s_len = s:len()
      while s_len > space do
        s, subs = s:gsub("[a-zA-Z][a-zA-Z][a-zA-Z]+", function(a)
          return a:sub(1, 2)
        end, 1)
        if subs == 0 then break end
        s_len = s:len()
      end
      abbrev_name_memoize[m_key] = s
      return s
    end
    local fix_space = 16
    require"lualine".setup {
      options = {
        theme = 'tokyonight', -- powerline
        section_separators = {left='', right=''},
        component_separators = {left='', right=''}
      },
      sections = {
        lualine_a = {
          {'mode', fmt=function(s) return s:sub(1,3) end,
            padding = {left=0, right=0}}
        },
        lualine_b = {
          {'branch', fmt=function(s)
              local space = (vim.fn.winwidth(0) - fix_space) * 0.2 -- %
              return abbrev_name(s, space)
            end,
            padding = 0},
          {'diff', -- symbols = {added = '', modified = '', removed = ''},
            padding = {left=1, right=0}},
          {'diagnostics', sources={'nvim_diagnostic'},
            symbols = {error = '', warn = '', info = '', hint = '♲'},
            padding = {left=1, right=0}},
          -- {spellstatus},
        },
        lualine_c = {
          {function()
            -- PWD
            -- Current file type: `vim.bo.filetype`
            -- Current file name: `vim.api.nvim_buf_get_name(0)`
            if vim.bo.buftype == "" then
              local space = (vim.fn.winwidth(0) - fix_space) * 0.2 -- %
              local s = vim.fn.getcwd():gsub("^"..home_path, "~")
              return abbrev_path(s, space, 1).."/"
            else
              return ""
            end
          end, color = {fg='#0044cc'}, padding = 0},
          {'filename', path=1, shorting_target=0, padding = 0,
            symbols = {modified=' ✎', readonly=' ⛒'},
            fmt=function(s)
              if vim.bo.buftype == "" then
                local space = (vim.fn.winwidth(0) - fix_space) * 0.5 -- %
                return abbrev_path(s, space, 2)
              else
                return s
              end
            end}
        },
        lualine_x = {
          {'lsp_progress',
            separators = {
              component = ' ',
              progress = ' | ',
              message = { pre = '', post = ''},
              percentage = { pre = '', post = '%% ' },
              title = { pre = '', post = ': ' },
              lsp_client_name = { pre = '', post = '' },
              spinner = { pre = '', post = '' },
            },
            message = { commenced = '⧖', completed = '⧗' },
            display_components = {{'title', 'percentage', 'message'}, 'lsp_client_name', 'spinner'},
            spinner_symbols = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }},
          -- { 'nvim_treesitter#statusline', max_length = 20 }
        },
        lualine_y = {
          {'encoding', padding = 0,
          fmt=function(s)
            return s:sub(1, 1) .. s:gsub("^[^0-9]*", "", 1)
          end},
          {'fileformat', padding = 0},
        },
        lualine_z = {{'location', padding = 0}},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', path=1, shorting_target=0,
                     symbols = {modified=' ✎', readonly=' ⛒'}}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      }
    }
  end
}

use {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = function()
    require'nvim-autopairs'.setup {
      disable_filetype = { "TelescopePrompt" , "vim" },
      disable_in_macro = true,
      enable_moveright = false,
      enable_check_bracket_line = false,
      ignored_next_char = "",
      check_ts = true,
      map_bs = false,
      fast_wrap = {},
    }
  end
}

use {
  'hrsh7th/nvim-cmp',
  requires = {
    {
      'hrsh7th/cmp-buffer',
      opt = true,
    },
    {
      'hrsh7th/cmp-path',
      opt = true,
    },
    {
      'hrsh7th/cmp-cmdline',
      opt = true,
    },
    {
      'hrsh7th/cmp-vsnip',
      opt = true,
    },
    {
      'hrsh7th/vim-vsnip',
      opt = true,
    },
    {
      'rafamadriz/friendly-snippets',
      opt = true,
    },
  },
  opt = true,
  config = function()
    -- Setup nvim-cmp.
    local cmp = require'cmp'

    cmp.setup {
      completion = {
          autocomplete = false,
      },
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          -- require'luasnip'.lsp_expand(args.body) -- For `luasnip` users.
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
        -- { name = 'neorg' },
      }, {
        { name = 'buffer' },
      })
    }

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
    --local cmp_autopairs = require'nvim-autopairs.completion.cmp'
    --cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
  end
}

use {
  'neovim/nvim-lspconfig',
  after = 'nvim-cmp',
  requires = {
    {
      'hrsh7th/cmp-nvim-lsp',
      opt = true,
    },
  },
  opt = true,
  ft = { 'python', 'php', 'json', 'js', 'ts', 'jsx', 'tsx', 'rust', 'c', 'cpp', 'h', 'hpp' },
  setup = function()
    require'packer'.loader('cmp-nvim-lsp')
  end,
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

    -- Lsp config
    local lspconfig = require'lspconfig'

    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    local map = vim.api.nvim_set_keymap
    map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    map('n', '<leader>Ce', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local map = vim.api.nvim_buf_set_keymap
      map(bufnr, 'n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      map(bufnr, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      map(bufnr, 'n', '<leader>lK', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      map(bufnr, 'n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      map(bufnr, 'n', '<leader>lk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      map(bufnr, 'n', '<leader>lA', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      map(bufnr, 'n', '<leader>lR', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      map(bufnr, 'n', '<leader>lL', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      map(bufnr, 'n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      map(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      map(bufnr, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      map(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      map(bufnr, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

      require'which-key'.register({
        l = { name = 'Lsp' },
      }, { mode = 'n', prefix = '<leader>', buffer = bufnr })
    end

    local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { 'pyright', 'tsserver', 'intelephense', 'html', 'jsonls', 'ccls' }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
    end
    lspconfig.rust_analyzer.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        ["rust-analyzer"] = {
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true
          },
          procMacro = {
            enable = true
          },
        },
      },
    }
    -- Linters
    lspconfig.eslint.setup{}

    -- Handlers
     vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
       vim.lsp.diagnostic.on_publish_diagnostics, {
         virtual_text = false,
         sings = true,
         underline = false,
         update_in_insert = false,
       }
     )
  end
}
use {
  'mfussenegger/nvim-dap',
  opt = true,
  ft = { 'python', 'php', 'json', 'js', 'ts', 'jsx', 'tsx', 'rust', 'c', 'cpp', 'h', 'hpp' },
  config = function()
    -- local dap = require'dap'
    -- dap.adapters.python = {
    --   type = 'executable',
    --   command = 'python3',
    --   args = { '-m', 'debugpy.adapter' },
    -- }
    -- dap.configurations.python = {
    --   {
    --     type = 'python';
    --     request = 'launch';
    --     name = "Launch file";
    --     program = "${file}";
    --     pythonPath = function()
    --       return 'python3'
    --     end;
    --   },
    -- }

    local opts = { noremap=true, silent=true }
    local map = vim.api.nvim_set_keymap
    map('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', opts)
    map('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>', opts)
    map('n', '<leader>dn', '<cmd>lua require"dap".step_over()<CR>', opts)
    map('n', '<leader>dp', '<cmd>lua require"dap".step_back()<CR>', opts)
    map('n', '<leader>do', '<cmd>lua require"dap".step_out()<CR>', opts)
    map('n', '<leader>di', '<cmd>lua require"dap".step_into()<CR>', opts)
    map('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<CR>', opts)
    map('n', '<leader>dl', '<cmd>lua require"dap".list_breakpoints()<CR>', opts)
    map('n', '<leader>dd', '<cmd>lua require"dap".clear_breakpoints()<CR>', opts)

    require'which-key'.register({
      d = { name = 'Dap' },
    }, { mode = 'n', prefix = '<leader>' })
  end
}
use {
  'mfussenegger/nvim-dap-python',
  opt = true,
  after = 'nvim-dap',
  ft = { 'python' },
  config = function()
    local dap_python = require'dap-python'
    if vim.fn.executable('python') == 1 then
      dap_python.setup('python')
    else
      dap_python.setup('python3')
    end
    if vim.fn.executable('pytest') == 1 then
      dap_python.test_runner = 'pytest'
    end
    local opts = { noremap=true, silent=true }
    local map = vim.api.nvim_set_keymap
    map('n', '<leader>dF', '<cmd>lua require"dap-python".test_method()<CR>', opts)
    map('n', '<leader>dC', '<cmd>lua require"dap-python".test_class()<CR>', opts)
    map('n', '<leader>dS', '<ESC>:lua require"dap-python".debug_selection()<CR>', opts)
  end
}

use {
  'chipsenkbeil/distant.nvim',
  cmd = {
    "DistantConnect",
    "DistantCopy",
    "DistantInstall",
    "DistantLaunch",
    "DistantMetadata",
    "DistantMkdir",
    "DistantOpen",
    "DistantRemove",
    "DistantRename",
    "DistantRun",
    "DistantSessionInfo",
    "DistantSystemInfo"
  },
  config = function()
    require'distant'.setup {
      -- Applies Chip's personal settings to every machine you connect to
      --
      -- 1. Ensures that distant servers terminate with no connections
      -- 2. Provides navigation bindings for remote directories
      -- 3. Provides keybinding to jump into a remote file's parent directory
      ['*'] = require'distant.settings'.chip_default()
    }
  end
}

end,
-- config = {
--   -- Move to lua dir so impatient.nvim can cache it
--   compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
-- }
}
