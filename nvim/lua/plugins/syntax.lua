return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-refactor" },
      --   { 'p00f/nvim-ts-rainbow', lazy = true },
      --   { 'nvim-treesitter/playground', lazy = true },
      { "tokyonight.nvim" },
    },
    event = "VeryLazy",
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
      vim.filetype.add({ extension = { rasi = "rasi" } })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
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
          "csv",
          "dart",
          "diff",
          "dockerfile",
          "dot",
          "doxygen",
          "dtd",
          "elixir",
          "elm",
          "erlang",
          "fennel",
          "fish",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "glimmer",
          "gnuplot",
          "go",
          "godot_resource",
          "gomod",
          "gosum",
          "gowork",
          "gpg",
          "graphql",
          "haskell",
          "haskell_persistent",
          "hjson",
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
          "just",
          "kdl",
          "kotlin",
          "latex",
          "llvm",
          "lua",
          "luadoc",
          "luap",
          "luau",
          "make",
          "markdown",
          "markdown_inline",
          "matlab",
          "mermaid",
          "meson",
          "ninja",
          -- "norg", "norg_meta", "norg_table",
          -- "org",
          "perl",
          "php",
          "php_only",
          "phpdoc",
          "printf",
          "properties",
          "proto",
          "pymanifest",
          "python",
          "ql",
          "query",
          "rasi",
          "regex",
          "requirements",
          "ron",
          "rst",
          "rust",
          "scala",
          "scheme",
          "scss",
          "sql",
          "ssh_config",
          "styled",
          "svelte",
          "swift",
          "sxhkdrc",
          "textproto",
          "tmux",
          "toml",
          "tsv",
          "tsx",
          "typescript",
          "typst",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
          "yang",
          "zig",
        }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
        -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          -- disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
          additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
          -- disable = { "c", "rust" },  -- list of language that will be disabled
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
        },
        indent = { enable = true },
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
      })

      vim.keymap.set(
        "",
        "<leader>Is",
        function()
          vim.notify(
            vim.fn["nvim_treesitter#statusline"](),
            vim.log.levels.INFO,
            { title = "Treesitter" }
          )
        end,
        { desc = "Treesitter statusline" }
      )
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
      vim.api.nvim_command(
        "syntax on|runtime plugin/matchparen.vim|packadd cfilter"
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter",
    },
    keys = {
      { "<leader>s", desc = "Peek definition" },
      { "<leader>[", desc = "Swap prev" },
      { "<leader>]", desc = "Swap next" },
      { "[" },
      { "]" },
      { "ca" },
      { "ci" },
      { "da" },
      { "di" },
      { "ya" },
      { "yi" },
      { "va" },
      { "vi" },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
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
            border = "none",
            peek_definition_code = {
              ["<leader>sF"] = "@function.outer",
              ["<leader>sf"] = "@function.inner",
              ["<leader>sT"] = "@class.outer",
              ["<leader>st"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      local tscontext = require("treesitter-context")
      tscontext.setup({
        max_lines = 8,
        multiline_threshold = 1,
        mode = 'topline',
      })
      vim.api.nvim_set_hl(
        0, "TreesitterContextBottom",
        { sp = "gray", underline = true }
      )
      vim.api.nvim_set_hl(
        0, "TreesitterContextLineNumberBottom",
        { sp = "gray", underline = true }
      )
      vim.keymap.set("n", "[x", function()
        tscontext.go_to_context(vim.v.count1)
      end, { silent = true })
    end
  },
  {
    -- "echasnovski/mini.hipatterns",
    -- event = "VeryLazy",
    -- config = function()
    --   local hipatterns = require("mini.hipatterns")
    --   hipatterns.setup({
    --     highlighters = {
    --       htm_color = {
    --         pattern = '#%x%x%x%x%x%x%x?%x?%f[%X]',
    --         group = function(_, _, data)
    --           local match = data.full_match
    --           return hipatterns.compute_hex_color_group(
    --             #match > 7 and match:sub(1, 7) or match,
    --             'bg'
    --           )
    --         end,
    --         extmark_opts = { priority = 200 },
    --       },
    --       hex_color = {
    --         pattern = '0x%x%x%x%x%x%x%x?%x?%f[%X]',
    --         group = function(_, _, data)
    --           local match = data.full_match:sub(3)
    --           return hipatterns.compute_hex_color_group(
    --             '#' .. (#match > 6 and match:sub(3) or match),
    --             'bg'
    --           )
    --         end,
    --         extmark_opts = { priority = 200 },
    --       },
    --     },
    --   })
    -- end,
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      local colorizer = require("colorizer")
      colorizer.setup({
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = false,
          RRGGBBAA = true,
          AARRGGBB = true,
        }
      })
      colorizer.attach_to_buffer(0)
    end,
  },
  {
    "chrisbra/Colorizer",
    init = function()
      vim.cmd([[
      " Conflict with vim.g.loaded_colorizer from nvim-colorizer
      command! ColorHighlight unlet g:loaded_colorizer|
        \let g:colorizer_skip_comments = 1|
        \let g:colorizer_colornames = 0|
        \let g:colorizer_hex_pattern = []|
        \let g:colorizer_textchangedi = 0|
        \let g:colorizer_vimhighl_dump_disable = 1|
        \let g:colorizer_taskwarrior_disable = 1|
        \let g:colorizer_vimhighlight_disable = 1|
        \let g:colorizer_vimcolors_disable = 1|
        \let g:colorizer_rgba_disable = 1|
        \let g:colorizer_rgb_disable = 1|
        \let g:colorizer_hsla_disable = 1|
        \let g:colorizer_colornames_disable = 1|
        \Lazy load Colorizer|ColorHighlight
      ]])
    end,
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        styles = {
          sidebars = "transparent",
        },
      })
      vim.cmd.colorscheme("tokyonight")
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#5081c0" })
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#5b6291" })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#5b6291" })
      vim.api.nvim_set_hl(0, "CursorLineNR", { fg = "#ffba00" })
      vim.api.nvim_set_hl(0, "IncSearch", { fg = "#ff9e64", bg = "#2a52be" })
      vim.api.nvim_set_hl(0, "Whitespace", { bg = "#d2042d", ctermbg = "red" })
      vim.api.nvim_set_hl(0, "Comment", { fg = "#767fa9" }) -- fg = '#565f89'
      vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#616888" }) -- fg = '#414868'
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("guess-indent").setup({})
    end,
  },
}
