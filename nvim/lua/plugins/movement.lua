return {
  {
    "folke/flash.nvim",
    keys = {
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
      {
        "<A-f>",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<A-b>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<A-r>",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<A-s>",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<C-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
    config = function()
      require("flash").setup({
        label = {
          uppercase = false,
        },
        modes = {
          search = {
            enabled = false,
          },
        },
      })
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#000000", bg = "#ea4335" })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      { "debugloop/telescope-undo.nvim" },
      { "johmsalas/text-case.nvim", opts = {
        default_keymappings_enabled = false,
      } },
    },
    keys = {
      {
        "<leader>f,",
        ":Telescope grep_string initial_mode=insert search=",
        desc = "Telescope grep_string search",
      },
      {
        "<leader>f-",
        "<cmd>Telescope resume initial_mode=normal<cr>",
        desc = "Telescope resume",
      },
      {
        "<leader>f.",
        "<cmd>Telescope grep_string<cr>",
        mode = { "x", "n" },
        desc = "Telescope grep_string",
      },
      {
        "<leader>f:",
        "<cmd>Telescope grep_string ft=true<cr>",
        mode = { "x", "n" },
        desc = "Telescope grep_string ft",
      },
      {
        "<leader>f;",
        ":Telescope grep_string ft=true initial_mode=insert search=",
        desc = "Telescope grep_string ft search",
      },
      {
        "<leader>fb",
        "<cmd>Telescope buffers initial_mode=insert<cr>",
        desc = "Telescope buffers",
      },
      {
        "<leader>fB",
        function()
          require("telescope.builtin").buffers(
            { initial_mode = "insert", show_all_buffers = true }
          )
        end,
        desc = "Telescope buffers show all",
      },
      {
        "<leader>fc",
        "<cmd>Telescope textcase normal_mode initial_mode=insert<cr>",
        desc = "Telescope textcase",
      },
      {
        "<leader>fc",
        "<cmd>Telescope textcase visual_mode initial_mode=insert<cr>",
        mode = "v",
        desc = "Telescope textcase",
      },
      {
        "<leader>fd",
        "<cmd>Telescope diagnostics<cr>",
        desc = "Telescope diagnostic",
      },
      {
        "<leader>fW",
        "<cmd>Telescope find_files cwd=%:p:h initial_mode=insert<cr>",
        desc = "Telescope find_files cwd",
      },
      {
        "<leader>fF",
        "<cmd>Telescope find_files ft=true initial_mode=insert<cr>",
        desc = "Telescope find_files ft",
      },
      {
        "<leader>ff",
        "<cmd>Telescope find_files initial_mode=insert<cr>",
        desc = "Telescope find_files",
      },
      {
        "<leader>fgb",
        "<cmd>Telescope git_branches<cr>",
        desc = "Telescope git_branches",
      },
      {
        "<leader>fgc",
        "<cmd>Telescope git_bcommits<cr>",
        desc = "Telescope git_bcommits",
      },
      {
        "<leader>fgC",
        "<cmd>Telescope git_commits<cr>",
        desc = "Telescope git_commits",
      },
      {
        "<leader>fgf",
        "<cmd>Telescope git_files<cr>",
        desc = "Telescope git_files",
      },
      {
        "<leader>fgS",
        "<cmd>Telescope git_stash<cr>",
        desc = "Telescope git_stash",
      },
      {
        "<leader>fgs",
        "<cmd>Telescope git_status<cr>",
        desc = "Telescope git_status",
      },
      {
        "<leader>fh",
        "<cmd>Telescope help_tags initial_mode=insert<cr>",
        desc = "Telescope help_tags",
      },
      {
        "<leader>fla",
        "<cmd>Telescope lsp_code_actions<cr>",
        desc = "Telescope lsp_code_actions",
      },
      {
        "<leader>flA",
        "<cmd>Telescope lsp_range_code_actions<cr>",
        desc = "Telescope lsp_range_code_actions",
      },
      {
        "<leader>fld",
        "<cmd>Telescope lsp_definitions<cr>",
        desc = "Telescope lsp_definitions",
      },
      {
        "<leader>fli",
        "<cmd>Telescope lsp_implementations<cr>",
        desc = "Telescope lsp_implementations",
      },
      {
        "<leader>flr",
        "<cmd>Telescope lsp_references<cr>",
        desc = "Telescope lsp_references",
      },
      {
        "<leader>fls",
        "<cmd>Telescope lsp_workspace_symbols<cr>",
        desc = "Telescope lsp_workspace_symbols",
      },
      {
        "<leader>fo",
        "<cmd>Telescope oldfiles initial_mode=insert<cr>",
        desc = "Telescope oldfiles",
      },
      {
        "<leader>fR",
        "<cmd>Telescope live_grep ft=true initial_mode=insert<cr>",
        desc = "Telescope live_grep ft",
      },
      {
        "<leader>fr",
        "<cmd>Telescope live_grep initial_mode=insert<cr>",
        desc = "Telescope live_grep",
      },
      {
        "<leader>fs",
        "<cmd>Telescope treesitter<cr>",
        desc = "Telescope treesitter",
      },
      {
        "<leader>f@",
        "<cmd>Telescope registers<cr>",
        desc = "Telescope registers",
      },
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Telescope undo" },
    },
    cmd = "Telescope",
    config = function()
      local rg_filetype_args = {
        c = "-tcpp",
        handlebars = "-thbs",
        htmldjango = "-thtml",
        javascript = "-tjs",
        javascriptreact = "-tjs",
        python = "-tpy",
        rust = "-trust",
        typescript = "-tts",
        typescriptreact = "-tts",
      }
      local function rg_args_filetype(opts)
        local args = {}
        if opts.args then
          opts.args:gsub("[^,]*", function(s)
            args[#args + 1] = s
          end)
        end
        if opts.ft == true then
          table.insert(
            args,
            rg_filetype_args[vim.bo.filetype] or ("-t" .. vim.bo.filetype)
          )
        end
        return args
      end
      local fd_filetype_args = {
        c = { "c", "h", "cpp", "hpp", "cxx", "hxx", "hh", "cc" },
        handlebars = { "hbs" },
        htmldjango = { "ejs", "htm", "html" },
        javascript = { "cjs", "js", "jsx", "mjs", "vue" },
        javascriptreact = { "cjs", "js", "jsx", "mjs", "vue" },
        python = { "py", "pyi" },
        rust = { "rs" },
        typescript = { "cts", "ts", "tsx", "mts" },
        typescriptreact = { "cts", "ts", "tsx", "mts" },
      }
      local function fd_args_filetype(opts)
        local args = {
          "fd",
          "--type",
          "f",
          "--color",
          "never",
          "-H",
          "-E",
          ".git",
          "-E",
          "[._]*cache*",
          "-E",
          ".log",
        }
        if opts.args then
          opts.args:gsub("[^,]*", function(s)
            args[#args + 1] = s
          end)
        end
        if opts.ft then
          for _, v in
            pairs(fd_filetype_args[vim.bo.filetype] or { vim.bo.filetype })
          do
            table.insert(args, "-e")
            table.insert(args, v)
          end
        end
        return args
      end

      local telescope = require("telescope")
      local action_layout = require("telescope.actions.layout")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              initial_mode = "normal",
              layout_config = {
                prompt_position = "bottom",
                width = 0.7,
                height = 0.7,
              },
            }),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          undo = {
            use_delta = true, -- this is the default
            side_by_side = false, -- this is the default
            mappings = { -- this whole table is the default
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
        },
        defaults = {
          initial_mode = "normal",
          mappings = {
            i = {
              ["<A-e>"] = action_layout.toggle_preview,
              ["<A-o>"] = action_layout.cycle_layout_prev,
              ["<A-i>"] = action_layout.cycle_layout_next,
            },
            n = {
              ["<A-e>"] = action_layout.toggle_preview,
              ["<A-o>"] = action_layout.cycle_layout_prev,
              ["<A-i>"] = action_layout.cycle_layout_next,
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
              preview_cutoff = 60,
            },
          },
          preview = {
            filesize_limit = 2.5,
            timeout = 500,
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
          },
          find_files = {
            find_command = fd_args_filetype,
          },
          grep_string = {
            additional_args = rg_args_filetype,
          },
          live_grep = {
            additional_args = rg_args_filetype,
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
      telescope.load_extension("undo")
      telescope.load_extension("textcase")
      telescope.load_extension("notify")
      telescope.load_extension("noice")
      telescope.load_extension("distant")
    end,
  },
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<a-o>", "<cmd>WindowPick<cr>" },
      { "<a-o>", "<cmd>WindowPick<cr>", mode = "t" },
    },
    cmd = "WindowPick",
    config = function()
      vim.api.nvim_command(
        "command! WindowPick lua require'nvim-window'.pick()"
      )
      require("nvim-window").setup({
        chars = {
          "f",
          "d",
          "s",
          "a",
          "g",
          "j",
          "k",
          "l",
          "h",
          "r",
          "e",
          "w",
          "q",
          "t",
          "u",
          "i",
          "o",
          "p",
          "y",
          "v",
          "c",
          "x",
          "z",
          "b",
          "m",
          "n",
        },
        normal_hl = "Cursor",
        hint_hl = "Normal",
        border = "none",
      })
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    dependencies = { "nvim-treesitter", "which-key.nvim" },
    keys = {
      -- Normal Mode Swapping
      {
        "vd",
        function()
          require("syntax-tree-surfer").move("n", false)
        end,
        desc = "Surfer move down",
      },
      {
        "vu",
        function()
          require("syntax-tree-surfer").move("n", true)
        end,
        desc = "Surfer move up",
      },
      -- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
      {
        "vx",
        function()
          require("syntax-tree-surfer").select()
        end,
        desc = "Surfer select",
      },
      -- .select_current_node() will select the current node at your cursor
      {
        "vn",
        function()
          require("syntax-tree-surfer").select_current_node()
        end,
        desc = "Surfer select current",
      },
      -- NAVIGATION: Only change the keymap to your liking. I would not recommend changing anything about the .surf() parameters!
      {
        "J",
        function()
          require("syntax-tree-surfer").surf("next", "visual")
        end,
        mode = "x",
      },
      {
        "K",
        function()
          require("syntax-tree-surfer").surf("prev", "visual")
        end,
        mode = "x",
      },
      {
        "H",
        function()
          require("syntax-tree-surfer").surf("parent", "visual")
        end,
        mode = "x",
      },
      {
        "L",
        function()
          require("syntax-tree-surfer").surf("child", "visual")
        end,
        mode = "x",
      },
      -- SWAPPING WITH VISUAL SELECTION: Only change the keymap to your liking. Don't change the .surf() parameters!
      {
        "<A-j>",
        function()
          require("syntax-tree-surfer").surf("next", "visual", true)
        end,
        mode = "x",
      },
      {
        "<A-k>",
        function()
          require("syntax-tree-surfer").surf("prev", "visual", true)
        end,
        mode = "x",
      },
    },
    config = function()
      local stf = require("syntax-tree-surfer")

      vim.keymap.set("n", "glv", function()
        stf.targeted_jump({ "variable_declaration", "assignment" })
      end, { desc = "Assignments" })
      vim.keymap.set("n", "glf", function()
        stf.targeted_jump({ "function", "function_definition" })
      end, { desc = "Functions" })
      vim.keymap.set("n", "glc", function()
        stf.targeted_jump({ "class", "class_definition" })
      end, { desc = "Classes" })
      vim.keymap.set("n", "gli", function()
        stf.targeted_jump({
          "if_statement",
          "else_statement",
          "elseif_statement",
        })
      end, { desc = "If statements" })
      vim.keymap.set("n", "glp", function()
        stf.targeted_jump({ "import_from_statement" })
      end, { desc = "Imports" })
      vim.keymap.set("n", "glm", function()
        stf.targeted_jump({ "match_statement" })
      end, { desc = "Matchs" })
      vim.keymap.set("n", "glt", function()
        stf.targeted_jump({ "try_statement", "with_statement" })
      end, { desc = "Try-Withs" })
      vim.keymap.set("n", "gll", function()
        stf.targeted_jump({ "for_statement", "while_statement" })
      end, { desc = "Loops" })
      vim.keymap.set("n", "glj", function()
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
      end, { desc = "All" })
      -- filtered_jump --
      -- "default" means that you jump to the default_desired_types or your lastest jump types
      vim.keymap.set("n", "<A-n>", function()
        stf.filtered_jump("default", true) --> true means jump forward
      end, { desc = "Jump lastest type forward" })
      vim.keymap.set("n", "<A-p>", function()
        stf.filtered_jump("default", false) --> false means jump backwards
      end, { desc = "Jump lastest type backwards" })

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
    end,
  },
  {
    "atusy/treemonkey.nvim",
    dependencies = { "nvim-treesitter" },
    keys = {
      {
        "m",
        function()
          require("treemonkey").select({
            ignore_injections = false,
            highlight = { label = "Substitute" },
          })
        end,
        mode = {"x", "o"},
        desc = "TS nodes",
      },
    },
  },
}
