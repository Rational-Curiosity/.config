return {
  {
    "mbbill/undotree",
    cmd = { "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreeToggle" },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 24
      vim.g.undotree_DiffCommand = vim.fn.executable("delta") == 1
        and "delta" or "diff"
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    keys = { "u", "<C-r>" },
    config = function()
      require("highlight-undo").setup({
        duration = 700,
      })
    end,
  },
  {
    "tpope/vim-repeat",
    keys = { ".", "u", "U", "<C-r>" },
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sR",
        function()
          require("ssr").open()
        end,
        mode = "n",
        desc = "Structural search and replace",
      },
    },
    config = function()
      require("ssr").setup({
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        adjust_window = true,
        keymaps = {
          close = "<esc>",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      })
    end,
  },
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-n>", desc = "Select words" },
      { "<C-Down>", desc = "Create cursors down" },
      { "<C-Up>", desc = "Create cursors up" },
      { "<S-Right>", desc = "Select one character right" },
      { "<S-Left>", desc = "Select one character left" },
    },
  },
  {
    "kg8m/vim-simple-align",
    cmd = "SimpleAlign",
  },
  {
    "kylechui/nvim-surround",
    keys = {
      "ys",
      "yS",
      "cs",
      "cS",
      "ds",
      { "S", mode = "v" },
      { "gS", mode = "v" },
      { "<C-g>s", mode = "i" },
      { "<C-g>S", mode = "i" },
    },
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "nat-418/boole.nvim",
    keys = { "<A-a>", "<A-x>" },
    config = function()
      require("boole").setup({
        mappings = {
          increment = "<A-a>",
          decrement = "<A-x>",
        },
        additions = {
          { "trace", "debug", "info", "warning", "warn", "error", "fatal" },
          { "&&", "||" },
          { "and", "or" },
          { "private", "protected", "public" },
          { "var", "const", "let" },
        },
      })
    end,
  },
  {
    "sQVe/sort.nvim",
    cmd = "Sort",
  },
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    dependencies = { "nvim-treesitter" },
    keys = {
      { "<leader>ss", "<cmd>TSJSplit<CR>", desc = "TSJSplit" },
      { "<leader>sj", "<cmd>TSJJoin<CR>", desc = "TSJJoin" },
    },
    config = function()
      require("treesj").setup({
        check_syntax_error = false,
        max_join_length = 150,
      })
    end,
  },
  {
    "CKolkey/ts-node-action",
    cmd = { "NodeAction" },
    dependencies = { "nvim-treesitter" },
    keys = {
      { "<leader>sa", "<cmd>NodeAction<cr>", desc = "NodeAction" },
    },
    config = function()
      require("ts-node-action").setup({})
    end,
  },
  {
    -- 'windwp/nvim-autopairs',
    -- event = "InsertEnter",
    -- config = function()
    --   require'nvim-autopairs'.setup {
    --     disable_filetype = { "TelescopePrompt" , "vim" },
    --     disable_in_macro = true,
    --     enable_moveright = false,
    --     enable_check_bracket_line = false,
    --     ignored_next_char = "",
    --     check_ts = true,
    --     map_bs = false,
    --     fast_wrap = {},
    --   }
    -- end
    -- <XOR>
    "altermo/ultimate-autopair.nvim",
    build = "git checkout doc/tags",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter",
    },
    ft = { "xml", "html", "htmldjango" },
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "honza/vim-snippets",
      "dozken/LuaSnip-snippets.nvim",
    },
    config = function()
      local ls = require("luasnip")
      ls.snippets = require("luasnip_snippets").load_snippets()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
      ls.add_snippets("python", {
        ls.snippet(".stat", {
          ls.text_node(
            '.statement.compile(compile_kwargs={"literal_binds": True})'
          ),
        }),
      })
    end,
  },
}
