return {
  {
    "nvimtools/hydra.nvim",
    dependencies = {
      "anuvyklack/keymap-layer.nvim",
    },
    keys = {
      { "<C-w>m", desc = "Window menu" },
      { "<leader>hm", desc = "Hydra menu" },
      { "<leader>dm", desc = "DAP menu" },
    },
    config = function()
      local Hydra = require("hydra")
      local gitsigns = require("gitsigns")
      local dap = require("dap")
      local dapui = require("dapui")

      Hydra({
        hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^ ^              _<Enter>_: Neogit      _<Esc>_ or _q_: exit]],
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            position = "bottom",
            border = "rounded",
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
          end,
        },
        mode = { "n", "x" },
        body = "<leader>hm",
        heads = {
          {
            "J",
            function()
              if vim.wo.diff then
                return "]c"
              end
              vim.schedule(function()
                gitsigns.next_hunk()
              end)
              return "<Ignore>"
            end,
            { expr = true },
          },
          {
            "K",
            function()
              if vim.wo.diff then
                return "[c"
              end
              vim.schedule(function()
                gitsigns.prev_hunk()
              end)
              return "<Ignore>"
            end,
            { expr = true },
          },
          { "s", ":Gitsigns stage_hunk<CR>", { silent = true } },
          { "u", gitsigns.undo_stage_hunk },
          { "S", gitsigns.stage_buffer },
          { "p", gitsigns.preview_hunk },
          { "d", gitsigns.toggle_deleted, { nowait = true } },
          { "b", gitsigns.blame_line },
          {
            "B",
            function()
              gitsigns.blame_line({ full = true })
            end,
          },
          { "/", gitsigns.show, { exit = true } }, -- show the base of the file
          { "<Enter>", "<cmd>Neogit<CR>", { exit = true } },
          { "q", nil, { exit = true, nowait = true } },
          { "<Esc>", nil, { exit = true, nowait = true } },
        },
      })

      Hydra({
        name = "DAP",
        hint = [[
^^ _n_: step over  _b_: toggle breakpoint     _c_: continue
^^ _p_: step back  _l_: list breakpoints      _r_: toggle repl
^^ _o_: step out   _d_: clear breakpoints     _L_: log point msg 
^^ _i_: step into  _B_: breakpoint condition  _R_: run last
_<Esc>_/_q_: exit  _U_: User interface        _Q_: terminate]],
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            position = "bottom",
            border = "rounded",
          },
        },
        mode = "n",
        body = "<leader>dm",
        heads = {
          { "b", dap.toggle_breakpoint },
          { "c", dap.continue },
          { "n", dap.step_over },
          { "p", dap.step_back },
          { "o", dap.step_out },
          { "i", dap.step_into },
          { "r", dap.repl.toggle },
          { "l", dap.list_breakpoints },
          { "d", dap.clear_breakpoints },
          { "R", dap.run_last },
          { "U", dapui.toggle },
          {
            "B",
            function()
              dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
          },
          {
            "L",
            function()
              dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end,
          },
          { "Q", dap.terminate },
          { "q", nil, { exit = true, nowait = true } },
          { "<Esc>", nil, { exit = true, nowait = true } },
        },
      })

      Hydra({
        name = "WINDOWS",
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
            border = "rounded",
            position = "middle",
          },
        },
        mode = "n",
        body = "<C-w>m",
        heads = {
          { "h", "<C-w>h", { private = true } },
          { "j", "<C-w>j", { private = true } },
          {
            "k",
            [[<CMD>try | wincmd k | catch /^Vim\%((\a\+)\)\=:E11:/ | close | endtry<CR>]],
            { private = true },
          },
          { "l", "<C-w>l", { private = true } },

          { "<", "<C-w><" },
          { "-", "<C-w>-" },
          { "+", "<C-w>+" },
          { ">", "<C-w>>" },

          { "=", "<C-w>=", { desc = "equalize", private = true } },

          { "s", "<C-w>s", { private = true } },
          { "v", "<C-w>v", { private = true } },
          {
            "q",
            [[<CMD>try | close | catch /^Vim\%((\a\+)\)\=:E444:/ | endtry<CR>]],
            { private = true },
          },
          { "<Esc>", nil, { exit = true, desc = false } },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer local keymaps (which-key)",
      },
    },
    event = "VeryLazy",
    config = function()
      local which_key = require("which-key")
      which_key.setup({
        replace = {
          key = {
            { "<Space>", "␣" },
            { "<Cr>", "↲" },
            { "<Tab>", "⭾" },
          },
        },
        win = {
          padding = { 1, 1, 1, 1 },
        },
        layout = {
          height = { min = 3, max = 17 },
          width = { min = 20, max = 1000 },
          spacing = 2,
          align = "center",
        },
        spec = {
          { "<leader>C", group = "Quickfix" },
          { "<leader>E", group = "Diagnostic" },
          { "<leader>Eh", desc = "Hide" },
          { "<leader>Es", desc = "Show" },
          { "<leader>F", group = "Yank filename" },
          { "<leader>G", group = "Neogit" },
          { "<leader>I", group = "Info" },
          { "<leader>Ic", desc = "Display theme colors" },
          { "<leader>Id", desc = "Notify dismiss" },
          { "<leader>Is", desc = "Treesitter status" },
          { "<leader>P", group = "Put exec" },
          { "<leader>R", group = "Snip run" },
          { "<leader>S", group = "Sessions" },
          { "<leader>SW", desc = "Working dir" },
          { "<leader>T", group = "Terminal" },
          { "<leader>W", group = "Working dir" },
          { "<leader>[", group = "Swap prev" },
          { "<leader>]", group = "Swap next" },
          { "<leader>d", group = "Dap" },
          { "<leader>f", group = "Telescope", mode = { "n", "x" } },
          { "<leader>fg", desc = "Git" },
          { "<leader>fl", desc = "Lsp" },
          { "<leader>s", group = "Treesitter" },
          { "<leader>t", group = "Table mode" },
          { "<leader>tf", desc = "Formula" },
          { "zd", group = "Fold all" },
          { "zx", desc = "Fold except region", mode = "x" },
          {
            mode = { "n", "x" },
            { "<c-w>H", desc = "Rearrange to vertical split" },
            { "<c-w>J", desc = "Rearrange to horizontal split" },
            { "<c-w>y", group = "Yode" },
          },
          {
            mode = { "i" },
            { "<c-x><c-]>", desc = "Complete tags" },
            { "<c-x><c-d>", desc = "Complete defined identifiers" },
            { "<c-x><c-e>", desc = "Scroll up" },
            { "<c-x><c-f>", desc = "Complete file names" },
            { "<c-x><c-i>", desc = "Complete identifiers" },
            { "<c-x><c-k>", desc = "Complete identifiers from dictionary" },
            { "<c-x><c-l>", desc = "Complete whole lines" },
            { "<c-x><c-n>", desc = "Next completion" },
            { "<c-x><c-o>", desc = "Omni completion" },
            { "<c-x><c-p>", desc = "Previous completion" },
            { "<c-x><c-s>", desc = "Spelling suggestions" },
            { "<c-x><c-t>", desc = "Complete identifiers from thesaurus" },
            { "<c-x><c-u>", desc = "Complete with 'completefunc'" },
            { "<c-x><c-v>", desc = "Complete like in : command line" },
            { "<c-x><c-y>", desc = "Scroll down" },
            { "<c-x><c-z>", desc = "Stop completion, keeping the text as-is" },
            { "<c-x>s", desc = "spelling suggestions" },
          },
        },
      })
    end,
  },
}
