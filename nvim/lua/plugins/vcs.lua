return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "telescope.nvim" },
    },
    keys = {
      { "<leader>Gt", "<cmd>Neogit kind=tab<cr>", desc = "Neogit tab" },
      { "<leader>Gs", "<cmd>Neogit kind=split<cr>", desc = "Neogit split" },
      { "<leader>Gv", "<cmd>Neogit kind=vsplit<cr>", desc = "Neogit vsplit" },
      { "<leader>Gr", "<cmd>Neogit kind=replace<cr>", desc = "Neogit replace" },
    },
    cmd = "Neogit",
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        disable_insert_on_commit = false,
        integrations = {
          telescope = true,
        },
        mappings = {
          popup = {
            l = false,
            L = "LogPopup",
          },
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    -- event = "VeryLazy",
    config = function()
      vim.api.nvim_set_hl(0, "GitSignsAddLnInline", { bg = "#004d00" })
      vim.api.nvim_set_hl(0, "GitSignsChangeLnInline", { bg = "#3d004d" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteLnInline", { bg = "#391313" })
      vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#004d00" })
      vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#3d004d" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#391313" })
      vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "#004d00" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "#3d004d" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "#391313" })
      vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#80ff80" })
      vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#e580ff" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#df9f9f" })
      vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#004d00" })
      vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#3d004d" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = "#391313" })
      require("gitsigns").setup({
        signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local opts = { buffer = bufnr }

          vim.keymap.set(
            "n",
            "]h",
            gs.next_hunk,
            { buffer = bufnr, desc = "Next hunk" }
          )
          vim.keymap.set(
            "n",
            "[h",
            gs.prev_hunk,
            { buffer = bufnr, desc = "Prev hunk" }
          )
          vim.keymap.set(
            { "n", "v" },
            "<leader>hs",
            ":Gitsigns stage_hunk<CR>",
            { buffer = bufnr, desc = "Stage hunk" }
          )
          vim.keymap.set(
            { "n", "v" },
            "<leader>hr",
            ":Gitsigns reset_hunk<CR>",
            { buffer = bufnr, desc = "Reset hunk" }
          )
          vim.keymap.set(
            "n",
            "<leader>hS",
            gs.stage_buffer,
            { buffer = bufnr, desc = "Stage buffer" }
          )
          vim.keymap.set(
            "n",
            "<leader>hu",
            gs.undo_stage_hunk,
            { buffer = bufnr, desc = "Undo stage hunk" }
          )
          vim.keymap.set(
            "n",
            "<leader>hU",
            gs.reset_buffer_index,
            { buffer = bufnr, desc = "Reset buffer index" }
          )
          vim.keymap.set(
            "n",
            "<leader>hR",
            gs.reset_buffer,
            { buffer = bufnr, desc = "Reset buffer" }
          )
          vim.keymap.set(
            "n",
            "<leader>hp",
            gs.preview_hunk,
            { buffer = bufnr, desc = "Preview hunk" }
          )
          vim.keymap.set("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { buffer = bufnr, desc = "Blame line" })
          vim.keymap.set(
            "n",
            "<leader>hd",
            gs.diffthis,
            { buffer = bufnr, desc = "Diff this" }
          )
          vim.keymap.set("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { buffer = bufnr, desc = "Diff this ~" })
          vim.keymap.set(
            "n",
            "<leader>htb",
            gs.toggle_current_line_blame,
            { buffer = bufnr, desc = "Toggle current line blame" }
          )
          vim.keymap.set(
            "n",
            "<leader>htd",
            gs.toggle_deleted,
            { buffer = bufnr, desc = "Toggle deleted" }
          )
          vim.keymap.set(
            "n",
            "<leader>hts",
            gs.toggle_signs,
            { buffer = bufnr, desc = "Toggle signs" }
          )
          vim.keymap.set(
            "n",
            "<leader>htn",
            gs.toggle_numhl,
            { buffer = bufnr, desc = "Toggle number highlight" }
          )
          vim.keymap.set(
            "n",
            "<leader>htl",
            gs.toggle_linehl,
            { buffer = bufnr, desc = "Toggle line highlight" }
          )
          vim.keymap.set(
            "n",
            "<leader>htw",
            gs.toggle_word_diff,
            { buffer = bufnr, desc = "Toggle word diff" }
          )

          vim.keymap.set(
            { "o", "x" },
            "ih",
            ":<C-U>Gitsigns select_hunk<CR>",
            { buffer = bufnr, desc = "Select hunk" }
          )
          require("which-key").register({
            h = {
              name = "Gitsigns",
              t = {
                name = "Toggle gitsigns",
              },
            },
          }, { mode = "n", prefix = "<leader>", buffer = bufnr })
          require("which-key").register({
            h = {
              name = "Gitsigns",
            },
          }, { mode = "v", prefix = "<leader>", buffer = bufnr })
        end,
      })
    end,
  },
}
