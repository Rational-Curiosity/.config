local noremap = { noremap = true }
local silent = { silent = true }
local noremap_silent = { noremap = true, silent = true }
local mapset = vim.keymap.set
local ft_prog = {
  'python', 'php', 'json',
  'js', 'ts', 'jsx', 'tsx',
  'javascript', 'typescript', 'typescriptreact',
  'rust', 'c', 'cpp', 'h', 'hpp', 'java'
}
return {
  {
    'mbbill/undotree',
    cmd = { 'UndotreeHide', 'UndotreeShow', 'UndotreeFocus', 'UndotreeToggle' },
  },
  {
    'ggandor/leap.nvim',
    keys = {
      { '<A-f>', '<Plug>(leap-forward-to)', mode = { 'n', 'x', 'o' } },
      { '<A-b>', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' } },
      { '<A-w>', '<Plug>(leap-cross-window)', mode = { 'n', 'x', 'o' } },
    },
    config = function()
      local leap = require'leap'
      leap.opts.max_phase_one_targets = 0
    end
  },
  {
    'anuvyklack/hydra.nvim', 
    dependencies = {
      'anuvyklack/keymap-layer.nvim',
    },
    keys = { '<C-w>m', '<leader>hm', '<leader>dm' },
    config = function()
      local Hydra = require('hydra')
      local gitsigns = require('gitsigns')

      Hydra({
        hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^ ^              _<Enter>_: Neogit      _<Esc>_ or _q_: exit]],
        config = {
          color = 'teal',
          invoke_on_body = true,
          hint = {
            position = 'bottom',
            border = 'rounded'
          },
          on_enter = function()
            vim.bo.modifiable = false
            gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(true)
          end,
          on_exit = function()
            gitsigns.toggle_signs(false)
            gitsigns.toggle_linehl(false)
            gitsigns.toggle_deleted(false)
          end
        },
        mode = { 'n', 'x' },
        body = '<leader>hm',
        heads = {
          { 'J', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gitsigns.next_hunk() end)
            return '<Ignore>'
          end, { expr = true } },
          { 'K', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gitsigns.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true } },
          { 's', ':Gitsigns stage_hunk<CR>', { silent = true } },
          { 'u', gitsigns.undo_stage_hunk },
          { 'S', gitsigns.stage_buffer },
          { 'p', gitsigns.preview_hunk },
          { 'd', gitsigns.toggle_deleted, { nowait = true } },
          { 'b', gitsigns.blame_line },
          { 'B', function() gitsigns.blame_line{ full = true } end },
          { '/', gitsigns.show, { exit = true } }, -- show the base of the file
          { '<Enter>', '<cmd>Neogit<CR>', { exit = true } },
          { 'q', nil, { exit = true, nowait = true } },
          { '<Esc>', nil, { exit = true, nowait = true } },
        }
      })

      Hydra({
        hint = [[
 _n_: step over  _b_: toggle breakpoint     _c_: continue
 _p_: step back  _l_: list breakpoints      _r_: toggle repl
 _o_: step out   _d_: clear breakpoints     _L_: log point msg 
 _i_: step into  _B_: breakpoint condition  _R_: run last
         _<Esc>_ or _q_: exit               _Q_: terminate]],
        config = {
          invoke_on_body = true,
          hint = {
            position = 'bottom',
            border = 'rounded'
          },
        },
        mode = 'n',
        body = '<leader>dm',
        heads = {
          { 'b', '<leader>db', { private = false } },
          { 'c', '<leader>dc' },
          { 'n', '<leader>dn' },
          { 'p', '<leader>dp' },
          { 'o', '<leader>do' },
          { 'i', '<leader>di' },
          { 'r', '<leader>dr' },
          { 'l', '<leader>dl' },
          { 'd', '<leader>dd' },
          { 'R', '<leader>dR' },
          { 'B', '<leader>dB' },
          { 'L', '<leader>dL' },
          { 'Q', '<leader>dQ' },
          { 'q', nil, { exit = true, nowait = true } },
          { '<Esc>', nil, { exit = true, nowait = true } },
        }
      })

      Hydra({
        name = 'WINDOWS',
        hint = [[
 ^ ^Move^ ^ ^  ^^^^ Size  ^^  ^^ Split
 ^-^----^-^-^  ^^^^-------^^  ^^--------
  ^ ^ _k_ ^ ^    ^ ^ _-_ ^ ^   _s_: horizontally 
  _h_ ^ ^ _l_    _<_ ^ ^ _>_   _v_: vertically
  ^ ^ _j_ ^ ^    ^ ^ _+_ ^ ^
 ^^^^^^^^^^      _=_ equalize  _q_: close]],
        config = {
          timeout = false,
          invoke_on_body = true,
          hint = {
            border = 'rounded',
            position = 'middle'
          }
        },
        mode = 'n',
        body = '<C-w>m',
        heads = {
          { 'h', '<C-w>h', { private = true } },
          { 'j', '<C-w>j', { private = true } },
          { 'k', [[<CMD>try | wincmd k | catch /^Vim\%((\a\+)\)\=:E11:/ | close | endtry<CR>]],
            { private = true } },
          { 'l', '<C-w>l', { private = true } },

          { '<', '<C-w><' },
          { '-', '<C-w>-' },
          { '+', '<C-w>+' },
          { '>', '<C-w>>' },

          { '=', '<C-w>=', { desc = 'equalize', private = true} },

          { 's', '<C-w>s', { private = true } },
          { 'v', '<C-w>v', { private = true } },
          { 'q', [[<CMD>try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry<CR>]],
            { private = true } },
          { '<Esc>', nil,  { exit = true, desc = false } }
        }
      })
    end
  },
  {
    "potamides/pantran.nvim",
    cmd = { 'Pantran' },
  },
  {
    'nanotee/zoxide.vim',
    cmd = { 'Z', 'Zi' },
  },
  {
    'AndrewRadev/linediff.vim',
    cmd = { 'Linediff' },
  },
  {
    'jbyuki/venn.nvim',
    keys = { { '<leader>B', ':VBox<cr>', mode = 'x' } },
    cmd = { 'VBox' },
  },
  {
    'TimUntersberger/neogit',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    keys = {
      { '<leader>Gt', '<cmd>Neogit kind=tab<cr>' },
      { '<leader>Gs', '<cmd>Neogit kind=split<cr>' },
      { '<leader>Gv', '<cmd>Neogit kind=vsplit<cr>' },
      { '<leader>Gr', '<cmd>Neogit kind=replace<cr>' },
    },
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
  },
  {
    'numToStr/Comment.nvim',
    keys = { 'gc', 'gb', { 'gc', mode = 'x' }, { 'gb', mode = 'x' } },
    config = function()
      require('Comment').setup()
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      { 'debugloop/telescope-undo.nvim' },
      { 'johmsalas/text-case.nvim' },
      { 'lpoto/telescope-tasks.nvim' },
    },
    keys = {
      { '<leader>f,', ':Telescope grep_string  initial_mode=insert search=', desc = 'Telescope grep_string search' },
      { '<leader>f-', '<cmd>Telescope resume initial_mode=insert<cr>', desc = 'Telescope resume' },
      { '<leader>f.', '<cmd>Telescope grep_string<cr>', desc = 'Telescope grep_string' },
      { '<leader>f:', '<cmd>Telescope grep_string ft=true<cr>', desc = 'Telescope grep_string ft' },
      { '<leader>f;', ':Telescope grep_string ft=true initial_mode=insert search=', desc = 'Telescope grep_string ft search' },
      { '<leader>fa', '<cmd>Telescope tasks initial_mode=insert<cr>', desc = 'Telescope tasks' },
      { '<leader>fb', '<cmd>Telescope buffers initial_mode=insert<cr>', desc = 'Telescope buffers' },
      { '<leader>fc', '<cmd>Telescope textcase normal_mode initial_mode=insert<cr>', desc = 'Telescope textcase' },
      { '<leader>fc', '<cmd>Telescope textcase visual_mode initial_mode=insert<cr>', mode = 'v', desc = 'Telescope textcase' },
      { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = 'Telescope diagnostic' },
      { '<leader>ff', '<cmd>Telescope find_files initial_mode=insert<cr>', desc = 'Telescope find_files' },
      { '<leader>fgC', '<cmd>Telescope git_commits<cr>', desc = 'Telescope git_commits' },
      { '<leader>fgS', '<cmd>Telescope git_stash<cr>', desc = 'Telescope git_stash' },
      { '<leader>fgb', '<cmd>Telescope git_branches<cr>', desc = 'Telescope git_branches' },
      { '<leader>fgc', '<cmd>Telescope git_bcommits<cr>', desc = 'Telescope git_bcommits' },
      { '<leader>fgf', '<cmd>Telescope git_files<cr>', desc = 'Telescope git_files' },
      { '<leader>fgs', '<cmd>Telescope git_status<cr>', desc = 'Telescope git_status' },
      { '<leader>fh', '<cmd>Telescope help_tags initial_mode=insert<cr>', desc = 'Telescope help_tags' },
      { '<leader>flA', '<cmd>Telescope lsp_range_code_actions<cr>', desc = 'Telescope lsp_range_code_actions' },
      { '<leader>fla', '<cmd>Telescope lsp_code_actions<cr>', desc = 'Telescope lsp_code_actions' },
      { '<leader>fld', '<cmd>Telescope lsp_definitions<cr>', desc = 'Telescope lsp_definitions' },
      { '<leader>fli', '<cmd>Telescope lsp_implementations<cr>', desc = 'Telescope lsp_implementations' },
      { '<leader>flr', '<cmd>Telescope lsp_references<cr>', desc = 'Telescope lsp_references' },
      { '<leader>fls', '<cmd>Telescope lsp_workspace_symbols<cr>', desc = 'Telescope lsp_workspace_symbols' },
      { '<leader>fo', '<cmd>Telescope oldfiles initial_mode=insert<cr>', desc = 'Telescope oldfiles' },
      { '<leader>fR', '<cmd>Telescope live_grep ft=true initial_mode=insert<cr>', desc = 'Telescope live_grep ft' },
      { '<leader>fr', '<cmd>Telescope live_grep initial_mode=insert<cr>', desc = 'Telescope live_grep' },
      { '<leader>fs', '<cmd>Telescope treesitter<cr>', desc = 'Telescope treesitter' },
      { '<leader>fu', '<cmd>Telescope undo<cr>', desc = 'Telescope undo' },
      { '<leader>f.', '"0y:Telescope grep_string search=<c-r>0<cr>', mode = 'x', desc = 'Telescope grep_string' },
      { '<leader>f:', '"0y:Telescope grep_string ft=true search=<c-r>0<cr>', mode = 'x', desc = 'Telescope grep_string ft' },
    },
    cmd = 'Telescope',
    config = function()
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

      local telescope = require'telescope'
      telescope.setup {
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          undo = {
            use_delta = true,     -- this is the default
            side_by_side = false, -- this is the default
            mappings = {          -- this whole table is the default
              i = {
                ["<A-cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<cr>"] = require("telescope-undo.actions").restore,
              },
              n = {
                ["<A-cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<cr>"] = require("telescope-undo.actions").restore,
              },
            },
          },
          tasks = {
            -- theme = "dropdown",
            output_window = "float",
          },
        },
        defaults = {
          initial_mode = "normal",
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
      telescope.load_extension('fzf')
      telescope.load_extension('undo')
      telescope.load_extension('textcase')
      telescope.load_extension('tasks')
      local tasks = require'telescope'.extensions.tasks
      tasks.generators.custom.add {
        generator = function(buf)
          return {
            {
              'Docker Compose gigas CORE up',
              cmd = 'docker-compose --ansi never up -d db_maria db_mysql db_redis rabbitmq websockifier id-provider',
            },
            {
              'Docker Compose gigas CORE stop',
              cmd = 'docker-compose --ansi never stop db_maria db_mysql db_redis rabbitmq websockifier id-provider',
            },
            {
              'Docker Compose gigas KVM up',
              cmd = 'docker-compose --ansi never up -d apiproxy api-kvm executor-kvm kudeiro-kvm controlpanel gopanel hapi hostbill mercury router uploader-kvm'
            },
            {
              'Docker Compose gigas KVM stop',
              cmd = 'docker-compose --ansi never stop apiproxy api-kvm executor-kvm kudeiro-kvm controlpanel gopanel hapi hostbill mercury router uploader-kvm',
            },
          }
        end,
        opts = {
          name = 'Docker Compose',
        }
      }

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
  },
  {
    'hoschi/yode-nvim',
    keys = {
      { '<C-W>yc', ':YodeCreateSeditorFloating<CR>', mode = 'x' },
      { '<C-W>yr', ':YodeCreateSeditorReplace<CR>', mode = 'x' },
      { '<C-W>yd', ':YodeBufferDelete<CR>' },
      { '<C-W>yd', '<ESC>:YodeBufferDelete<CR>', mode = 'i' },
      { '<C-W>yj', ':YodeLayoutShiftWinDown<CR>' },
      { '<C-W>yk', ':YodeLayoutShiftWinUp<CR>' },
      { '<C-W>yb', ':YodeLayoutShiftWinBottom<CR>' },
      { '<C-W>yt', ':YodeLayoutShiftWinTop<CR>' },
    },
    cmd = { 'YodeCreateSeditorFloating', 'YodeCreateSeditorReplace', 'YodeCloneCurrentIntoFloat' },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require'yode-nvim'.setup {}
    end
  },
  {
    'tpope/vim-repeat',
    keys = { '.', 'u', 'U', '<C-r>' },
  },
  {
    'mg979/vim-visual-multi',
    keys = {
      '<C-n>',
      '<C-Down>',
      '<C-Up>',
      '<S-Right>',
      '<S-Left>',
      '<leader>gS',
      '<leader>\\',
      '<leader>/',
      '<leader>A',
    }
  },
  {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign',
  },
  {
    'sbdchd/neoformat',
    cmd = 'Neoformat',
    config = function()
      vim.g.neoformat_only_msg_on_error = 1
    end
  },
  {
    'kylechui/nvim-surround',
    keys = { 'ys', 'cs', 'ds', { 'S', mode = 'v' } },
    config = function()
      require'nvim-surround'.setup {}
    end
  },
  {
    'nat-418/boole.nvim',
    keys = { '<C-a>', '<C-x>' },
    config = function()
      require'boole'.setup {
        mappings = {
          increment = '<C-a>',
          decrement = '<C-x>',
        },
        additions = {
          { "trace", "debug", "info", "warning", "warn", "error", "fatal" },
          { "&&", "||" },
          { "and", "or" },
          { "private", "public" },
          { "var", "const", "let" },
        },
      }
    end
  },
  {
    'dhruvasagar/vim-table-mode',
    keys = {
      { '<leader>tm', '<cmd>TableModeToggle<cr>' },
      { '<leader>tr', '<cmd>TableModeRealign<cr>' },
      { '<leader>tt', '<cmd>Tableize<cr>' },
      { '<leader>tfa', '<cmd>TableAddFormula<cr>' },
      { '<leader>tfe', '<cmd>TableEvalFormulaLine<cr>' },
    },
    cmd = {
      'TableModeToggle',
      'TableModeRealign',
      'Tableize',
      'TableAddFormula',
      'TableEvalFormulaLine',
    },
  },
  {
    'sQVe/sort.nvim',
    cmd = 'Sort',
  },
  {
    url = 'https://gitlab.com/yorickpeterse/nvim-window.git',
    keys = {
      { '<a-o>', '<cmd>WindowPick<cr>' },
      { '<a-o>', '<cmd>WindowPick<cr>', mode = 't' },
    },
    cmd = 'WindowPick',
    config = function()
      vim.api.nvim_command(
        "command! WindowPick lua require'nvim-window'.pick()"
      )
      require'nvim-window'.setup {
        chars = {
          'f', 'd', 's', 'a', 'g', 'j', 'k', 'l', 'h', 'r', 'e', 'w', 'q',
          't', 'u', 'i', 'o', 'p', 'y', 'v', 'c', 'x', 'z', 'b', 'm', 'n'
        },
        normal_hl = 'Cursor',
        hint_hl = 'Bold',
        border = 'none',
      }
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    event = 'VeryLazy',
    config = function()
      vim.api.nvim_set_hl(0, 'GitSignsAddLnInline',    { bg = '#004d00' })
      vim.api.nvim_set_hl(0, 'GitSignsChangeLnInline', { bg = '#3d004d' })
      vim.api.nvim_set_hl(0, 'GitSignsDeleteLnInline', { bg = '#391313' })
      vim.api.nvim_set_hl(0, 'GitSignsAddInline',      { bg = '#004d00' })
      vim.api.nvim_set_hl(0, 'GitSignsChangeInline',   { bg = '#3d004d' })
      vim.api.nvim_set_hl(0, 'GitSignsDeleteInline',   { bg = '#391313' })
      vim.api.nvim_set_hl(0, 'GitSignsAdd',            { bg = '#004d00' })
      vim.api.nvim_set_hl(0, 'GitSignsChange',         { bg = '#3d004d' })
      vim.api.nvim_set_hl(0, 'GitSignsDelete',         { bg = '#391313' })
      vim.api.nvim_set_hl(0, 'GitSignsAddNr',          { fg = '#80ff80' })
      vim.api.nvim_set_hl(0, 'GitSignsChangeNr',       { fg = '#e580ff' })
      vim.api.nvim_set_hl(0, 'GitSignsDeleteNr',       { fg = '#df9f9f' })
      vim.api.nvim_set_hl(0, 'GitSignsAddLn',          { bg = '#004d00' })
      vim.api.nvim_set_hl(0, 'GitSignsChangeLn',       { bg = '#3d004d' })
      vim.api.nvim_set_hl(0, 'GitSignsDeleteLn',       { bg = '#391313' })
      require'gitsigns'.setup {
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
      mapset('n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", { noremap=true, expr=true })
      mapset('n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", { noremap=true, expr=true })

      mapset('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', noremap)
      mapset('v', '<leader>hs', ':Gitsigns stage_hunk<CR>', noremap)
      mapset('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', noremap)
      mapset('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', noremap)
      mapset('v', '<leader>hr', ':Gitsigns reset_hunk<CR>', noremap)
      mapset('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>', noremap)
      mapset('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', noremap)
      mapset('n', '<leader>hB', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', noremap)
      mapset('n', '<leader>hb', '<cmd>Gitsigns toggle_current_line_blame<CR>', noremap)
      mapset('n', '<leader>hts', '<cmd>Gitsigns toggle_signs<CR>', noremap)
      mapset('n', '<leader>htn', '<cmd>Gitsigns toggle_numhl<CR>', noremap)
      mapset('n', '<leader>htl', '<cmd>Gitsigns toggle_linehl<CR>', noremap)
      mapset('n', '<leader>htw', '<cmd>Gitsigns toggle_word_diff<CR>', noremap)
      mapset('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', noremap)
      mapset('n', '<leader>hU', '<cmd>Gitsigns reset_buffer_index<CR>', noremap)

      mapset('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>', noremap)
      mapset('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>', noremap)
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-refactor' },
      { 'windwp/nvim-ts-autotag' },
    --   { 'p00f/nvim-ts-rainbow', opt = true },
    --   { 'nvim-treesitter/playground', opt = true },
    },
    event = 'VeryLazy',
    config = function()
      -- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      -- parser_config.org = {
      --   install_info = {
      --     url = 'https://github.com/milisims/tree-sitter-org',
      --     files = {'src/parser.c', 'src/scanner.cc'},
      --   },
      --   filetype = 'org',
      -- }
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
          "arduino",
          "awk",
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
          "diff",
          "dockerfile",
          "dot",
          "elixir",
          "elm",
          "erlang",
          "fennel",
          "fish",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "glimmer",
          "go",
          "godot_resource",
          "gomod",
          "gowork",
          "graphql",
          "haskell",
          "help",
          "html",
          "htmldjango",
          "http",
          "ini",
          "java",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "json5",
          "jsonc",
          "jsonnet",
          "julia",
          "kotlin",
          "latex",
          "llvm",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "meson",
          "ninja",
          -- "norg", "norg_meta", "norg_table",
          "org",
          "perl",
          "php",
          "phpdoc",
          "python",
          "ql",
          "query",
          "regex",
          "rst",
          "rust",
          "scala",
          "scheme",
          "scss",
          "sql",
          "svelte",
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
          -- disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
          additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
          -- disable = { "c", "rust" },  -- list of language that will be disabled
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
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

      vim.keymap.set('', '<space>I',
        '<cmd>echo nvim_treesitter#statusline()<cr>')
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
      vim.opt.spell = true
      vim.api.nvim_command('syntax on|runtime plugin/matchparen.vim')
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      "which-key.nvim", "nvim-treesitter",
    },
    event = 'VeryLazy',
    config = function()
      require'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim 
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["a,"] = "@parameter.outer",
              ["i,"] = "@parameter.inner",
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
              ["<leader>],"] = "@parameter.inner",
              ["<leader>]f"] = "@function.outer",
              ["<leader>]c"] = "@class.outer",
              ["<leader>]l"] = "@loop.outer",
              ["<leader>]b"] = "@block.outer",
              ["<leader>]i"] = "@conditional.outer",
            },
            swap_previous = {
              ["<leader>[,"] = "@parameter.inner",
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
              ["];"] = "@parameter.outer",
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]L"] = "@loop.outer",
              ["]B"] = "@block.outer",
              ["]I"] = "@conditional.outer",
            },
            goto_next_end = {
              ["],"] = "@parameter.outer",
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]l"] = "@loop.outer",
              ["]b"] = "@block.outer",
              ["]i"] = "@conditional.outer",
            },
            goto_previous_start = {
              ["[;"] = "@parameter.outer",
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[L"] = "@loop.outer",
              ["[B"] = "@block.outer",
              ["[I"] = "@conditional.outer",
            },
            goto_previous_end = {
              ["[,"] = "@parameter.outer",
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
              ["<leader>sF"] = "@function.outer",
              ["<leader>sf"] = "@function.inner",
              ["<leader>sT"] = "@class.outer",
              ["<leader>st"] = "@class.inner",
            },
          },
        },
      }
      require'which-key'.register({
        ['['] = { name = 'Swap prev' },
        [']'] = { name = 'Swap next' },
      }, { mode = 'n', prefix = '<leader>' })
    end
  },
  {
    'ziontee113/syntax-tree-surfer',
    dependencies = { 'nvim-treesitter', 'which-key.nvim' },
    keys = {
      -- Normal Mode Swapping
      { "vd", function() require("syntax-tree-surfer").move("n", false) end },
      { "vu", function() require("syntax-tree-surfer").move("n", true) end },
      -- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
      { "vx", function() require("syntax-tree-surfer").select() end },
      -- .select_current_node() will select the current node at your cursor
      { "vn", function() require("syntax-tree-surfer").select_current_node() end },
      -- NAVIGATION: Only change the keymap to your liking. I would not recommend changing anything about the .surf() parameters!
      { "J", function() require("syntax-tree-surfer").surf("next", "visual") end, mode = 'x' },
      { "K", function() require("syntax-tree-surfer").surf("prev", "visual") end, mode = 'x' },
      { "H", function() require("syntax-tree-surfer").surf("parent", "visual") end, mode = 'x' },
      { "L", function() require("syntax-tree-surfer").surf("child", "visual") end, mode = 'x' },
      -- SWAPPING WITH VISUAL SELECTION: Only change the keymap to your liking. Don't change the .surf() parameters!
      { "<A-j>", function() require("syntax-tree-surfer").surf("next", "visual", true) end, mode = 'x' },
      { "<A-k>", function() require("syntax-tree-surfer").surf("prev", "visual", true) end, mode = 'x' },
    },
    config = function()
      local stf = require("syntax-tree-surfer")
      local mapset = vim.keymap.set

      mapset("n", "glv", function()
        stf.targeted_jump({ "variable_declaration", "assignment" })
      end)
      mapset("n", "glf", function()
        stf.targeted_jump({ "function", "function_definition" })
      end)
      mapset("n", "glc", function()
        stf.targeted_jump({ "class", "class_definition" })
      end)
      mapset("n", "gli", function()
        stf.targeted_jump({ "if_statement", "else_statement", "elseif_statement" })
      end)
      mapset("n", "glp", function()
        stf.targeted_jump({"import_from_statement" })
      end)
      mapset("n", "glm", function()
        stf.targeted_jump({"match_statement" })
      end)
      mapset("n", "glt", function()
        stf.targeted_jump({ "try_statement", "with_statement" })
      end)
      mapset("n", "gll", function()
        stf.targeted_jump({ "for_statement", "while_statement" })
      end)
      mapset("n", "glj", function()
        stf.targeted_jump({
          "function",
          "if_statement",
          "else_clause",
          "else_statement",
          "elseif_statement",
          "for_statement",
          "while_statement",
          "switch_statement",
          "with_statement",
          "try_statement",
          "match_statement",
          "import_from_statement",
        })
      end)
      require'which-key'.register({
        v = 'Assignments',
        f = 'Functions',
        c = 'Classes',
        i = 'If statements',
        p = 'Imports',
        m = 'Matchs',
        t = 'Try-Withs',
        l = 'Loops',
        j = 'All',
      }, { mode = 'n', prefix = 'gl' })
      -- filtered_jump --
      -- "default" means that you jump to the default_desired_types or your lastest jump types
      mapset("n", "<A-n>", function()
        stf.filtered_jump("default", true) --> true means jump forward
      end)
      mapset("n", "<A-p>", function()
        stf.filtered_jump("default", false) --> false means jump backwards
      end)

      stf.setup({
        highlight_group = "STS_highlight",
        disable_no_instance_found_report = false,
        default_desired_types = {
          "function",
          "if_statement",
          "else_clause",
          "else_statement",
          "elseif_statement",
          "for_statement",
          "while_statement",
          "switch_statement",
        },
        left_hand_side = "fdsawervcxqtzb",
        right_hand_side = "jklñoiu.,mpy-n",
        icon_dictionary = {
          ["if_statement"] = "",
          ["else_clause"] = "",
          ["else_statement"] = "",
          ["elseif_statement"] = "",
          ["for_statement"] = "ﭜ",
          ["while_statement"] = "ﯩ",
          ["switch_statement"] = "ﳟ",
          ["function"] = "",
          ["variable_declaration"] = "",
        },
      })
      vim.cmd(":highlight STS_highlight guifg=#F4D03F")
    end
  },
  {
    'mfussenegger/nvim-treehopper',
    dependencies = { 'nvim-treesitter' },
    keys = {
      { 'm', ':<C-U>lua require("tsht").nodes()<CR>', mode = 'o' },
      { 'm', ':lua require("tsht").nodes()<CR>', mode = 'v' },
    },
  },
  {
    'Wansmer/treesj',
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    dependencies = { 'nvim-treesitter' },
    keys = {
      { '<leader>ss', '<cmd>TSJSplit<CR>', desc = 'TSJSplit' },
      { '<leader>sj', '<cmd>TSJJoin<CR>', desc = 'TSJJoin' },
    },
    config = function()
      require('treesj').setup {
        check_syntax_error = false,
        max_join_length = 150,
      }
    end,
  },
  {
    'ckolkey/ts-node-action',
    cmd = { 'NodeAction' },
    dependencies = { 'nvim-treesitter' },
    keys = {
      { '<leader>sa', '<cmd>NodeAction<cr>', desc = 'NodeAction' },
    },
    config = function()
      require'ts-node-action'.setup {}
    end,
  },
  {
    'nvim-orgmode/orgmode',
    ft = { 'org' },
    dependencies = "nvim-treesitter",
    config = function()
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
  },
  {
    'michaelb/sniprun',
    build = 'bash ./install.sh',
    keys = {
      { '<leader>Rr', ':SnipReplMemoryClean<CR>:SnipRun<CR>', mode = 'v' },
      { '<leader>Rr', '<cmd>SnipReplMemoryClean<CR>:SnipRun<CR>' },
      { '<leader>Rc', '<cmd>SnipReplMemoryClean<CR>' },
      { '<leader>Rs', '<cmd>SnipReset<CR>' },
      { '<leader>Rc', '<cmd>SnipClose<CR>' },
      { '<leader>Ri', '<cmd>SnipInfo<CR>' },
      { '<leader>Rt', '<cmd>SnipTerminate<CR>' },
    },
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
  },
  {
    'chrisbra/csv.vim',
    ft = { 'csv' },
  },
  {
    'MTDL9/vim-log-highlighting',
    ft = { 'log' },
  },
  {
    'folke/tokyonight.nvim',
    config = function()
      require("tokyonight").setup {
        style = "night",
        transparent = true,
        styles = {
          sidebars = "transparent",
        },
      }
      vim.cmd.colorscheme('tokyonight')
      vim.api.nvim_set_hl(0, 'LineNr', { fg = '#5081c0' })
      vim.api.nvim_set_hl(0, 'CursorLineNR', { fg = '#ffba00' })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'kyazdani42/nvim-web-devicons' },
      { 'tokyonight.nvim' }
      -- {
      --   'arkav/lualine-lsp-progress',
      -- },
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
      local abbrev_term_memoizes = 0
      local abbrev_term_memoize = {}
      local function abbrev_term(name, space)
        local m_key = name .. "," .. space
        local m_value = abbrev_term_memoize[m_key] 
        if m_value ~= nil then
          return m_value
        end
        name = name:gsub('//', '', 1):gsub('//', ':', 1):gsub(':/.*/', ':', 1)
        print(name)
        local name_len = name:len()
        local subs
        while name_len > space do
          name, subs = name:gsub("[a-zA-Z][a-zA-Z][a-zA-Z]+", function(a)
            return a:sub(1, 2)
          end, 1)
          if subs == 0 then break end
          name_len = name:len()
        end
        if abbrev_term_memoizes > 512 then
          abbrev_term_memoize[next(abbrev_term_memoize)] = nil
        else
          abbrev_term_memoizes = abbrev_term_memoizes + 1
        end
        abbrev_term_memoize[m_key] = name
        return name
      end

      local function abbrev_rel_path(rel, space, len)
        local dir, base = string.match(rel, "(.*/)([^/]*)")
        if dir == nil then
          return rel
        end
        space = space - base:len()
        local subs
        local dir_len = dir:len()
        local pattern = "("..string.rep("[^/_-]", len).."[^/_-]+)([/_-]%.?)"
        while dir_len > space do
          dir, subs = dir:gsub(pattern, function(a, b)
            return a:sub(1, len)..b
          end, 1)
          if subs == 0 then break end
          dir_len = dir:len()
        end
        return dir .. base
      end

      vim.api.nvim_set_hl(0, 'StatusDirectory', {
        fg = '#7aa2f7',
        bg = '#191919',
        ctermfg = 'blue',
        ctermbg = 'black',
      })
      local abbrev_path_memoizes = 0
      local abbrev_path_memoize = {}
      local function abbrev_path(dir, file, space)
        local m_key = dir .. "//" .. file .. "," .. space
        local m_value = abbrev_path_memoize[m_key] 
        if m_value ~= nil then
          return m_value
        end
        dir = dir:gsub("^"..home_path, "~")
        local dir_len = dir:len()
        local file_len = file:len()
        local dir_space = space - file_len - 4
        if dir_len > dir_space then
          dir = abbrev_rel_path(dir, dir_space, 1)
          dir_len = dir:len()
          if dir_len > dir_space then
            file = abbrev_rel_path(file, space - dir_len - 4, 2)
          end
        end
        local result = '%#StatusDirectory#' .. dir .. '/%*' .. file
        if abbrev_path_memoizes > 512 then
          abbrev_path_memoize[next(abbrev_path_memoize)] = nil
        else
          abbrev_path_memoizes = abbrev_path_memoizes + 1
        end
        abbrev_path_memoize[m_key] = result
        return result
      end
      local len_without_hl_memoizes = 0
      local len_without_hl_memoize = {}
      local function len_without_hl(s)
        local m_value = len_without_hl_memoize[s] 
        if m_value ~= nil then
          return m_value
        end
        local result = vim.fn.strdisplaywidth(s:gsub('%%#[^#]+#', '')) + 1
        if len_without_hl_memoizes > 128 then
          len_without_hl_memoize[next(len_without_hl_memoize)] = nil
        else
          len_without_hl_memoizes = len_without_hl_memoizes + 1
        end
        len_without_hl_memoize[s] = result
        return result
      end
      local fix_space = 18
      local branch_space = 0
      local diff_space = 0
      local diag_space = 0

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
            {function() if vim.env.VIRTUAL_ENV then return '👾' else return '' end end,
              color = { fg = "#ff9e64" }, padding = 0},
            {'branch', fmt=function(s)
                if s == '' then
                  branch_space = 0
                  return s
                end
                local space = math.floor((vim.fn.winwidth(0) - fix_space) * 0.2) -- %
                local s_len = s:len()
                if s_len > space then
                  branch_space = space + 3
                  return s:sub(1, space - 1)..'…'
                else
                  branch_space = s_len + 3
                  return s
                end
              end,
              padding = 0},
            {'diff', -- symbols = {added = '', modified = '', removed = ''},
              fmt=function(s)
                if s == '' then
                  diff_space = 0
                  return s
                end
                s = s:gsub('%s+', '')
                diff_space = len_without_hl(s)
                return s
              end,
              padding = {left=1, right=0}},
            {'diagnostics', sources={'nvim_diagnostic'},
              fmt=function(s)
                if s == '' then
                  diag_space = 0
                  return s
                end
                s = s:gsub('%s+', '')
                diag_space = len_without_hl(s)
                return s
              end,
              update_in_insert = false,
              symbols = {error = '', warn = '', info = '', hint = '♲'},
              padding = {left=1, right=0}},
            -- {spellstatus},
            { require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = "#ff9e64" } },
          },
          lualine_c = {
            {'filename', path=1, shorting_target=0, padding = 0,
              symbols = {modified='✎', readonly='⛒'},
              fmt=function(s)
                if vim.bo.buftype == "" then
                  return abbrev_path(
                    vim.fn.getcwd(), s,
                    vim.fn.winwidth(0) - fix_space - branch_space - diff_space - diag_space
                  )
                elseif vim.bo.buftype == "terminal" then
                  return abbrev_term(
                    s, vim.fn.winwidth(0) - fix_space - branch_space - diff_space - diag_space
                  )
                else
                  return s
                end
              end}
          },
          lualine_x = {
            -- {'lsp_progress',
            --   separators = {
            --     component = ' ',
            --     progress = ' | ',
            --     message = { pre = '', post = ''},
            --     percentage = { pre = '', post = '%% ' },
            --     title = { pre = '', post = ': ' },
            --     lsp_client_name = { pre = '', post = '' },
            --     spinner = { pre = '', post = '' },
            --   },
            --   message = { commenced = '⧖', completed = '⧗' },
            --   display_components = {{'title', 'percentage', 'message'}, 'lsp_client_name', 'spinner'},
            --   spinner_symbols = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }},
            -- { 'nvim_treesitter#statusline', max_length = 20 },
            {function()
              local status = {}
              if vim.v.hlsearch ~= 0 then
                local search = vim.fn.searchcount()
                if search.total > 0 then
                  table.insert(status, search.current.."/"..search.total)
                end
              end
              local register = vim.fn.reg_recording()
              if register ~= '' then
                table.insert(status, 'rec@'..register)
              end
              return table.concat(status, ' ')
            end, padding = {left=1, right=0}},
          },
          lualine_y = {
            {'encoding', padding = 0,
            fmt=function(s)
              if vim.bo.eol then
                return "↲" .. s:sub(1, 1) .. s:gsub("^[^0-9]*", "", 1)
              else
                return s:sub(1, 1) .. s:gsub("^[^0-9]*", "", 1)
              end
            end},
            {'fileformat', padding = 0},
          },
          lualine_z = {{'location', padding = 0}},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {{'filename', path=1, shorting_target=0,
                       symbols = {modified='✎', readonly='⛒'}}},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        }
      }
    end
  },
  {
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
  },
  {
    'nmac427/guess-indent.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('guess-indent').setup {}
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'friendly-snippets' },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'davidsierradz/cmp-conventionalcommits' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'L3MON4D3/LuaSnip' },
      { 'nvim-lua/plenary.nvim' },
      { 'petertriho/cmp-git' },
      { 'rafamadriz/friendly-snippets' },
      { 'ray-x/cmp-treesitter' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      -- Setup nvim-cmp.
      local cmp = require'cmp'

      cmp.setup {
        performance = {
          debounce = 50,
          throttle = 25,
          fetching_timeout = 150,
        },
        completion = {
          -- autocomplete = false,
          -- keyword_length = 2, -- incompatible with cmp-git and cmp-conventionalcommits
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require'luasnip'.lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-a>'] = cmp.mapping.abort(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<TAB>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'treesitter' },
          -- { name = 'vsnip' }, -- For vsnip users.
          { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
          { name = 'orgmode' },
          -- { name = 'neorg' },
        }, {
          { name = 'buffer' },
        })
      }

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'conventionalcommits' },
          { name = 'git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })
      require'cmp_git'.setup {}

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({'/', '?'}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
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
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      -- { 'lvimuser/lsp-inlayhints.nvim' },
      -- { 'ray-x/lsp_signature.nvim' },
      { 'j-hui/fidget.nvim' },
    },
    ft = ft_prog,
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
      -- require'lsp_signature'.setup {
      --   toggle_key = '<C-s>',
      -- }
      -- require'lsp-inlayhints'.setup {
      --   inlay_hints = {
      --     parameter_hints = {
      --       prefix = '',
      --       separator = ', ',
      --       remove_colon_start = true,
      --       remove_colon_end = true,
      --     },
      --     type_hints = {
      --       prefix = '',
      --       separator = ', ',
      --       remove_colon_start = true,
      --       remove_colon_end = true,
      --     },
      --     labels_separator = ' ',
      --   }
      -- }

      -- Mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      local opts = { silent=true }
      local mapset = vim.keymap.set
      mapset('n', '<leader>e', vim.diagnostic.open_float, opts)
      mapset('n', '[d', vim.diagnostic.goto_prev, opts)
      mapset('n', ']d', vim.diagnostic.goto_next, opts)
      mapset('n', '<leader>Ce', vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { silent=true, buffer=bufnr }
        local mapset = vim.keymap.set
        mapset('n', '<leader>lD', vim.lsp.buf.declaration, opts)
        mapset('n', '<leader>ld', vim.lsp.buf.definition, opts)
        mapset('n', '<leader>lK', vim.lsp.buf.hover, opts)
        mapset('n', '<leader>li', vim.lsp.buf.implementation, opts)
        mapset('n', '<leader>lk', vim.lsp.buf.signature_help, opts)
        mapset('n', '<leader>lA', vim.lsp.buf.add_workspace_folder, opts)
        mapset('n', '<leader>lR', vim.lsp.buf.remove_workspace_folder, opts)
        mapset('n', '<leader>lL', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        mapset('n', '<leader>lt', vim.lsp.buf.type_definition, opts)
        mapset('n', '<leader>ln', vim.lsp.buf.rename, opts)
        mapset('n', '<leader>la', vim.lsp.buf.code_action, opts)
        mapset('n', '<leader>lr', vim.lsp.buf.references, opts)
        --mapset({ 'n', 'v' }, '<leader>lf', vim.lsp.buf.format, opts)
        mapset({ 'n', 'v' }, '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)

        mapset('n', '<leader>lwD', function()
          vim.api.nvim_command('vsplit')
          vim.lsp.buf.declaration()
        end, opts)
        mapset('n', '<leader>lwd', function()
          vim.api.nvim_command('vsplit')
          vim.lsp.buf.definition()
        end, opts)
        mapset('n', '<leader>lwi', function()
          vim.api.nvim_command('vsplit')
          vim.lsp.buf.implementation()
        end, opts)
        mapset('n', '<leader>lwt', function()
          vim.api.nvim_command('vsplit')
          vim.lsp.buf.type_definition()
        end, opts)

        -- require("lsp-inlayhints").on_attach(client, bufnr)
        require'which-key'.register({
          l = {
            name = 'Lsp',
            D = 'declaration',
            d = 'definition',
            K = 'hover',
            i = 'implementation',
            k = 'signature help',
            A = 'add workspace folder',
            R = 'remove workspace folder',
            L = 'list workspace folders',
            t = 'type definition',
            n = 'rename',
            a = 'code action',
            r = 'references',
            f = 'format',
            w = {
              name = 'Other win',
              D = 'declaration',
              d = 'definition',
              i = 'implementation',
              t = 'type definition',
            } },
        }, { mode = 'n', prefix = '<leader>', buffer = bufnr })
        require'which-key'.register({
          l = {
            name = 'Lsp',
            f = 'format',
          },
        }, { mode = 'v', prefix = '<leader>', buffer = bufnr })
        end

      local capabilities = require'cmp_nvim_lsp'.default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      for _, lsp in ipairs({ 'pyright', 'intelephense', 'html', 'jsonls', 'ccls' }) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 1000,
          }
        }
      end
      lspconfig.tsserver.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 1000,
        },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          }
        }
      }
      lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 1000,
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
      lspconfig.java_language_server.setup {
        cmd = { os.getenv("HOME") .. '/tmp/java-language-server/dist/lang_server_linux.sh' },
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 1000,
        }
      }
      -- Linters
      lspconfig.eslint.setup {}
      lspconfig.ruff_lsp.setup {
        init_options = {
          settings = {
            args = { '--line-length', '79' }
          }
        }
      }

      -- Handlers
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = {
            spacing = 1,
            prefix = '▪',
            format = function(diagnostic)
              return diagnostic.message:match('^%s*(.-)%s*$'):gsub('%s%s+', ' ')
            end,
          },
          signs = true,
          underline = false,
          update_in_insert = false,
        }
      )
    end
  },
  {
    'j-hui/fidget.nvim',
    dependencies = { 'nvim-lspconfig' },
    config = function()
      require'fidget'.setup {}
    end
  },
  {
    'kevinhwang91/nvim-ufo', 
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'VeryLazy',
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('   %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, 'MoreMsg'})
        return newVirtText
      end

      -- global handler
      require('ufo').setup({
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype)
          return {'treesitter', 'indent'}
        end
      })

      -- buffer scope handler
      -- will override global handler if it is existed
      local bufnr = vim.api.nvim_get_current_buf()
      require('ufo').setFoldVirtTextHandler(bufnr, handler)
    end
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'which-key.nvim' },
    ft = ft_prog,
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

      local opts = { silent=true }
      local mapset = vim.keymap.set
      mapset('n', '<leader>db', require"dap".toggle_breakpoint, opts)
      mapset('n', '<leader>dc', require"dap".continue, opts)
      mapset('n', '<leader>dn', require"dap".step_over, opts)
      mapset('n', '<leader>dp', require"dap".step_back, opts)
      mapset('n', '<leader>do', require"dap".step_out, opts)
      mapset('n', '<leader>di', require"dap".step_into, opts)
      mapset('n', '<leader>dr', require"dap".repl.toggle, opts)
      mapset('n', '<leader>dl', require"dap".list_breakpoints, opts)
      mapset('n', '<leader>dd', require"dap".clear_breakpoints, opts)
      mapset('n', '<leader>dR', require"dap".run_last, opts)
      mapset('n', '<leader>dB', function()
        require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, opts)
      mapset('n', '<leader>dL', function()
        require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
      end, opts)
      mapset('n', '<leader>dQ', require"dap".terminate, opts)

      require'which-key'.register({
        d = {
          name = 'Dap',
          B = 'Breakpoint condition',
          b = 'Toggle breakpoint',
          c = 'Continue',
          n = 'Step over',
          p = 'Step back',
          o = 'Step out',
          i = 'Step into',
          R = 'Run last',
          r = 'Repl toggle',
          L = 'Log point message',
          l = 'List breakpoints',
          d = 'Clear breakpoints',
        },
      }, { mode = 'n', prefix = '<leader>' })
    end
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'nvim-dap' },
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
      local mapset = vim.keymap.set
      mapset('n', '<leader>dF', '<cmd>lua require"dap-python".test_method()<CR>', opts)
      mapset('n', '<leader>dC', '<cmd>lua require"dap-python".test_class()<CR>', opts)
      mapset('v', '<leader>dS', '<ESC>:lua require"dap-python".debug_selection()<CR>', opts)
    end
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = {
      'nvim-dap',
      {
        'microsoft/vscode-js-debug',
        build = 'npm install --legacy-peer-deps && npm run compile',
      },
    },
    ft = { 'javascript', 'typescript' },
    config = function()
      require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
      })
      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          }
        }
      end
    end
  },
  -- {
  --   'lpoto/actions.nvim',
  --   keys = { { '<leader>fa', function() require'actions.telescope'.available_actions() end } },
  --   config = function()
  --     require'actions'.setup {
  --       actions = {
  --         ['Docker Compose gigas CORE up'] = function()
  --           return {
  --             steps = {
  --               'docker-compose up -d db_maria db_mysql db_redis rabbitmq websockifier id-provider'
  --             }
  --           }
  --         end,
  --         ['Docker Compose gigas CORE stop'] = function()
  --           return {
  --             steps = {
  --               'docker-compose stop db_maria db_mysql db_redis rabbitmq websockifier id-provider'
  --             }
  --           }
  --         end,
  --         ['Docker Compose gigas KVM up'] = function()
  --           return {
  --             steps = {
  --               'docker-compose up -d apiproxy api-kvm executor-kvm kudeiro-kvm controlpanel gopanel hapi hostbill mercury router uploader-kvm'
  --             }
  --           }
  --         end,
  --         ['Docker Compose gigas KVM stop'] = function()
  --           return {
  --             steps = {
  --               'docker-compose stop apiproxy api-kvm executor-kvm kudeiro-kvm controlpanel gopanel hapi hostbill mercury router uploader-kvm'
  --             }
  --           }
  --         end,
  --       },
  --     }
  --   end
  -- },
  {
    'skanehira/denops-docker.vim',
    dependencies = { 'vim-denops/denops.vim' },
    init = function()
      vim.cmd([=[
        "command! DockerImages lua require("lazy").load({ plugins = { "denops-docker.vim" } });
        "  \vim.cmd'call denops#plugin#wait("docker") | DockerImages'
        "command! DockerContainers lua require("lazy").load({ plugins = { "denops-docker.vim" } });
        "  \vim.cmd'call denops#plugin#wait("docker") | DockerContainer'
        "command! DockerSearchImage lua require("lazy").load({ plugins = { "denops-docker.vim" } });
        "  \vim.cmd'call denops#plugin#wait("docker") | DockerSearchImage'
        "command! -nargs=+ Docker lua require("lazy").load({ plugins = { "denops-docker.vim" } });
        "  \vim.cmd'call denops#plugin#wait("docker") | call denops#notify("docker","runDockerCLI",[<f-args>])'
        command! DockerImages Lazy load denops-docker.vim|call denops#plugin#wait("docker")|DockerImages
        command! DockerContainers Lazy load denops-docker.vim|call denops#plugin#wait("docker")|DockerContainer
        command! DockerSearchImage Lazy load denops-docker.vim|call denops#plugin#wait("docker")|DockerSearchImage
        command! -nargs=+ Docker Lazy load denops-docker.vim|call denops#plugin#wait("docker")|call denops#notify("docker","runDockerCLI",[<f-args>])
        "command! -nargs=1 -complete=customlist,docker#listContainer DockerAttachContainer :call docker#attachContainer(<f-args>)
        "command! -nargs=1 -complete=customlist,docker#listContainer DockerExecContainer :call docker#execContainer(<f-args>)
        "command! -nargs=1 -complete=customlist,docker#listContainer DockerEditFile :call docker#editContainerFile(<f-args>)
        "command! -nargs=1 -complete=customlist,docker#listContainer DockerShowContainerLog :call docker#showContainerLog(<f-args>)
      ]=])
    end,
    config = function()
      vim.cmd([[
        augroup docker-custom-command
        autocmd!
        autocmd FileType docker-containers nnoremap <buffer> <silent> K <CMD>help docker-default-key-mappings<CR>5j022<C-w>_zt|
          \nmap <buffer> R <Nop>|
          \nnoremap <buffer> <silent> Rc :<C-u>call docker#command("docker-compose up -d db_maria db_mysql rabbitmq db_redis websockifier")<CR>|
          \nnoremap <buffer> <silent> Rk :<C-u>call docker#command("docker-compose up -d keycloak-provider-hostbill apiproxy api-kvm executor-kvm kudeiro-kvm controlpanel gopanel hapi hostbill router")<CR>|
          \lua require'which-key'.register({c='core',k='kvm'},{mode='n',prefix='R',buffer=0})
        augroup END
      ]])
    end
  },
  {
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
  },
  {
    "folke/which-key.nvim",
    event = 'VeryLazy',
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
          "keybind norg core%.norg%.manoeuvre%.", "org_mappings%.",
          "keybind norg core%.norg%.", "keybind norg core%.",
          '%.utils%.buffer"%)',
          '"%)$', "^:", "^ ", '^%("',
        },
      }
      which_key.register({
        C = { name = 'Quickfix' },
        E = { name = 'Diagnostic', h = 'Hide', s = 'Show' },
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
      which_key.register({
        y = { name = 'Yode' },
      }, { mode = 'n', prefix = '<c-w>' })
      which_key.register({
        y = { name = 'Yode' },
      }, { mode = 'x', prefix = '<c-w>' })
    end
  },
}
