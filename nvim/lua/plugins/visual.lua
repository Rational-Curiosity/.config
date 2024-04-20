return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local util = require("notify.stages.util")
      local notify = require("notify")
      notify.setup({
        render = "compact",
        stages = "no_animation",
        animate = false,
        level = 0,
        timeout = 10000,
        top_down = false,
      })
      vim.notify = notify
      vim.keymap.set(
        "n", "<leader>Id", notify.dismiss,
        { desc = "Dismiss all notifications" }
      )
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-notify",
    },
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          vert_help = {
            pattern = "^:%s*vert%s*he?l?p?%s+",
            icon = "¿",
            icon_hl_group = "NoiceCmdlinePrompt",
          },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      views = {
        cmdline = {
          position = {
            row = -1,
          },
        },
      },
    },
  },
  {
    -- Diffs on blocks in the same file
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff" },
  },
  {
    "hoschi/yode-nvim",
    keys = {
      { "<C-W>yc", ":YodeCreateSeditorFloating<CR>", mode = "x" },
      { "<C-W>yr", ":YodeCreateSeditorReplace<CR>", mode = "x" },
      { "<C-W>yd", ":YodeBufferDelete<CR>" },
      { "<C-W>yd", "<ESC>:YodeBufferDelete<CR>", mode = "i" },
      { "<C-W>yj", ":YodeLayoutShiftWinDown<CR>" },
      { "<C-W>yk", ":YodeLayoutShiftWinUp<CR>" },
      { "<C-W>yb", ":YodeLayoutShiftWinBottom<CR>" },
      { "<C-W>yt", ":YodeLayoutShiftWinTop<CR>" },
    },
    cmd = {
      "YodeCreateSeditorFloating",
      "YodeCreateSeditorReplace",
      "YodeCloneCurrentIntoFloat",
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("yode-nvim").setup({})
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  󰁂 %d "):format(endLnum - lnum)
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
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      -- global handler
      local ufo = require("ufo")
      ufo.setup({
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
          if vim.treesitter.language.get_lang(filetype) then
            return { "treesitter", "indent" }
          end
        end,
      })

      -- buffer scope handler
      -- will override global handler if it is existed
      local bufnr = vim.api.nvim_get_current_buf()
      ufo.setFoldVirtTextHandler(bufnr, handler)

      vim.keymap.set("n", "zR", ufo.openAllFolds)
      vim.keymap.set("n", "zM", ufo.closeAllFolds)
      vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
      vim.keymap.set("n", "zm", ufo.closeFoldsWith)
    end,
  },
  {
    "ziontee113/icon-picker.nvim",
    cmd = { "IconPickerNormal", "IconPickerYank", "IconPickerInsert" },
    dependencies = {
      "telescope.nvim",
    },
    config = function()
        require("icon-picker").setup({ disable_legacy_commands = true })
    end,
  },
}
