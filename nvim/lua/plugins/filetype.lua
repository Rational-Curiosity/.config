return {
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    cmd = { "PeekOpen" },
    config = function()
      local peek = require("peek")
      peek.setup({
        auto_load = false,
      })
      vim.api.nvim_create_user_command("PeekOpen", peek.open, { bar = true })
      vim.api.nvim_create_user_command("PeekClose", peek.close, { bar = true })
      vim.api.nvim_create_user_command("PeekReopen", function()
        peek.close()
        vim.wait(3000, function()
          if not peek.is_open() then
            peek.open()
            return true
          end
        end, 500)
      end, { bar = true })
    end,
  },
  {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    dependencies = "nvim-treesitter",
    config = function()
      local orgmode = require("orgmode")
      local notes = vim.fn.expand("~/Prog/org/refile.org")
      orgmode.setup_ts_grammar()
      orgmode.setup({
        org_startup_folded = "inherit",
        org_agenda_files = { "~/var/Dropbox/Orgzly/*", "~/my-orgs/**/*" },
        org_default_notes_file = vim.fn.filereadable(notes) ~= 0 and notes
          or '',
        org_todo_keywords = {
          "TODO(t)",
          "NEXT(n)",
          "STAR(s)",
          "UNDO(u)",
          "VERI(v)",
          "PLAN(p)",
          "LINK(k)",
          "WAIT(w)",
          "FIXM(b)",
          "REOP(r)",
          "HOLD(h)",
          "|",
          "DONE(d)",
          "ENOU(e)",
          "DELE(l)",
          "FINI(f)",
          "CANC(c)",
        },
        org_todo_keyword_faces = {
          TODO = ":foreground DarkRed :weight bold",
          NEXT = ":foreground LightYellow :weight bold",
          DONE = ":foreground DarkGreen :weight bold",
          PLAN = ":foreground blue :weight bold",
          STAR = ":foreground DarkBlue :weight bold",
          REOP = ":foreground DarkRed :weight bold",
          FINI = ":foreground LightGreen :weight bold",
          ENOU = ":foreground LightGreen :weight bold",
          DELE = ":foreground LightGreen :weight bold",
          LINK = ":foreground magenta :weight bold",
          WAIT = ":foreground cyan :weight bold",
          HOLD = ":foreground cyan :weight bold :underline t",
          CANC = ":foreground DarkGreen :weight bold",
          FIXM = ":foreground DarkRed :weight bold",
          VERI = ":foreground LightBlue :weight bold",
          UNDO = ":foreground LightBlue :weight bold",
        },
        org_priority_highest = "A",
        org_priority_default = "H",
        org_priority_lowest = "O",
        org_ellipsis = "▼",
        org_startup_indented = false,
        org_adapt_indentation = false,
        org_log_into_drawer = "LOGSTATE",
      })
    end,
  },
  {
    "chrisbra/csv.vim",
    ft = { "csv" },
    init = function()
      vim.g.csv_no_conceal = 1
      vim.g.csv_bind_B = 1
    end,
  },
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    lazy = false,
  },
  {
    "MTDL9/vim-log-highlighting",
    ft = { "log" },
  },
}
