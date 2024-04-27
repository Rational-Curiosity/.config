-- > a = { "a", [2] = "b", c = "d", "e", [0] = "f", [3] = "g", [5] = "h" }
-- > for k, v in pairs(a) do print(k, v) end
-- 1       a
-- 2       e
-- 0       f
-- c       d
-- 3       g
-- 5       h
-- > for k, v in ipairs(a) do print(k, v) end
-- 1       a
-- 2       e
-- 3       g

return {
  {
    "nanotee/zoxide.vim",
    cmd = { "Z", "Zi" },
  },
  {
    "dhruvasagar/vim-table-mode",
    keys = {
      { "<leader>tm", "<cmd>TableModeToggle<cr>" },
      { "<leader>tr", "<cmd>TableModeRealign<cr>" },
      { "<leader>tt", "<cmd>Tableize<cr>" },
      { "<leader>tfa", "<cmd>TableAddFormula<cr>" },
      { "<leader>tfe", "<cmd>TableEvalFormulaLine<cr>" },
    },
    cmd = {
      "TableModeToggle",
      "TableModeRealign",
      "Tableize",
      "TableAddFormula",
      "TableEvalFormulaLine",
    },
  },
  {
    "LunarVim/bigfile.nvim",
    lazy = false,
    config = function()
      require("bigfile").setup({
        filesize = 4, -- in MiB
      })
    end,
  },
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = {
      "tokyonight.nvim",
      "gitsigns.nvim",
    },
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local colors = require("tokyonight.colors").setup()
      for k1, v1 in pairs(colors) do
        if type(v1) == "table" then
          for k2, v2 in pairs(v1) do
            colors[k1 .. "_" .. k2] = v2
          end
        end
      end
      heirline.load_colors(colors)
      vim.keymap.set(
        "n", "<leader>Ic", function()
          vim.notify(vim.inspect(colors), vim.log.levels.INFO)
        end,
        { desc = "Display tokyonight colors" }
      )

      local mode_colors = {
        ["n"] = "MiniStatuslineModeNormal",
        ["v"] = "MiniStatuslineModeVisual",
        ["V"] = "MiniStatuslineModeVisual",
        [""] = "MiniStatuslineModeVisual",
        ["s"] = "MiniStatuslineModeOther",
        ["S"] = "MiniStatuslineModeOther",
        [""] = "MiniStatuslineModeOther",
        ["i"] = "MiniStatuslineModeInsert",
        ["R"] = "MiniStatuslineModeReplace",
        ["c"] = "MiniStatuslineModeCommand",
        ["r"] = "MiniStatuslineModeCommand",
        ["!"] = "MiniStatuslineModeCommand",
        ["t"] = "MiniStatuslineModeCommand",
      }
      local mode_init = function(self)
        self.mode = vim.fn.mode(1)
      end
      local mode_hl = function(self)
        return mode_colors[self.mode:sub(1, 1)] or "Error"
      end
      local ViMode = {
        init = mode_init,
        static = {
          mode_map = {
            -- neovim/runtime/doc/builtin.txt
            ["n"] = "N", -- Normal
            ["no"] = "⊙", -- Operator-pending
            ["nov"] = "⊙", -- Operator-pending (forced charwise |o_v|)
            ["noV"] = "⊙", -- Operator-pending (forced linewise |o_V|)
            ["no"] = "⊙", -- Operator-pending (forced blockwise |o_CTRL-V|)
            ["niI"] = "N", -- Normal using |i_CTRL-O| in |Insert-mode|
            ["niR"] = "N", -- Normal using |i_CTRL-O| in |Replace-mode|
            ["niV"] = "N", -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
            ["nt"] = "N", -- Normal in |terminal-emulator| (insert goes to Terminal mode)
            ["ntT"] = "N", -- Normal using |t_CTRL-\_CTRL-O| in |Terminal-mode|
            ["v"] = "☱", -- Visual by character
            ["vs"] = "☲", -- Visual by character using |v_CTRL-O| in Select mode
            ["V"] = "☰", -- Visual by line
            ["Vs"] = "☴", -- Visual by line using |v_CTRL-O| in Select mode
            [""] = "☳", -- Visual blockwise
            ["s"] = "☶", -- Visual blockwise using |v_CTRL-O| in Select mode
            ["s"] = "⚌", -- Select by character
            ["S"] = "⚍", -- Select by line
            [""] = "⚏", -- Select blockwise
            ["i"] = "󰏫", -- Insert
            ["ic"] = "󰏫", -- Insert mode completion |compl-generic|
            ["ix"] = "󰏫", -- Insert mode |i_CTRL-X| completion
            ["R"] = "→", -- Replace |R|
            ["Rc"] = "→", -- Replace mode completion |compl-generic|
            ["Rx"] = "→", -- Replace mode |i_CTRL-X| completion
            ["Rv"] = "⇒", -- Virtual Replace |gR|
            ["Rvc"] = "⇒", -- Virtual Replace mode completion |compl-generic|
            ["Rvx"] = "⇒", -- Virtual Replace mode |i_CTRL-X| completion
            ["c"] = "∵", -- Command-line editing
            ["cr"] = "∵", -- Command-line editing overstrike mode |c_<Insert>|
            ["cv"] = "⌘", -- Vim Ex mode |gQ|
            ["cvr"] = "⌘", -- Vim Ex mode while in overstrike mode |c_<Insert>|
            ["r"] = "↲", -- Hit-enter prompt
            ["rm"] = "…", -- The -- more -- prompt
            ["r?"] = "?", -- A |:confirm| query of some sort
            ["!"] = "$", -- Shell or external command is executing
            ["t"] = "❯", -- Terminal mode: keys go to the job
          },
        },
        provider = function(self)
          return (self.mode_map[self.mode] or self.mode) .. ""
        end,
        hl = mode_hl,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.api.nvim_command("redrawstatus")
          end),
        },
      }

      local Space = {
        provider = " ",
      }

      local Git = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
        end,
        hl = { bg = "bg_statusline" },
        update = { "User", pattern = "GitSignsUpdate" },
        {
          provider = "",
          hl = { fg = "green2", bold = true },
        },
        {
          provider = function(self)
            return self.status_dict.head
          end,
          hl = { fg = "green1", bold = true },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = " ",
        },
        {
            provider = function(self)
              return self.status_dict.added and self.status_dict.added > 0
                and ("+" .. self.status_dict.added)
            end,
            hl = { fg = "git_add" },
        },
        {
            provider = function(self)
              return self.status_dict.removed and self.status_dict.removed > 0
                and ("-" .. self.status_dict.removed)
            end,
            hl = { fg = "git_delete" },
        },
        {
            provider = function(self)
              return self.status_dict.changed and self.status_dict.changed > 0
                and ("~" .. self.status_dict.changed)
            end,
            hl = { fg = "git_change" },
        },
        Space,
      }

      local Diagnostics = {
        condition = conditions.has_diagnostics,
        static = {
          error_icon = "",
          warn_icon = "",
          info_icon = "",
          hint_icon = "",
        },
        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        hl = { bg = "bg_statusline" },
        update = { "DiagnosticChanged", "BufEnter" },
        {
          provider = function(self)
            return self.errors > 0 and (self.error_icon .. self.errors)
          end,
          hl = "DiagnosticSignError",
        },
        {
          provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings)
          end,
          hl = "DiagnosticSignWarn",
        },
        {
          provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info)
          end,
          hl = "DiagnosticSignInfo",
        },
        {
          provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
          end,
          hl = "DiagnosticSignHint",
        },
        Space,
      }

      local VirtualEnv = {
        condition = function() return vim.env.VIRTUAL_ENV ~= nil end,
        hl = { bg = "bg_statusline" },
        {
          provider = "👾",
          hl = { fg = "orange", bold = true },
        },
        {
          provider = function()
            return vim.env.VIRTUAL_ENV:match("[^/]+$") .. " "
          end,
          hl = { fg = "yellow", bold = true },
        },
      }

      local WorkDir = {
        init = function(self)
          self.icon = (vim.fn.haslocaldir(0) == 1 and "󰜛" or "")
          self.cwd = vim.fn.fnamemodify(vim.fn.getcwd(0), ":~")
        end,
        hl = { fg = "blue", bg = "bg_statusline" },
        flexible = 1,
        {
          -- evaluates to the full-lenth path
          provider = function(self)
            return self.icon .. self.cwd .. "/"
          end,
        },
        {
          -- evaluates to the shortened path
          provider = function(self)
            local cwd = vim.fn.pathshorten(self.cwd)
            return self.icon .. cwd .. "/"
          end,
        },
        {
          -- evaluates to "", hiding the component
          provider = "",
        }
      }

      local FileFlags = {
        Space,
        {
          condition = function(self)
            return self.filename ~= '' and vim.bo.buftype == ''
              and vim.fn.filereadable(self.filename) == 0
          end,
          provider = "",
          hl = { fg = "green", bg = "bg_statusline", bold = true },
        },
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "",
          hl = { fg = "orange", bg = "bg_statusline", bold = true },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "",
          hl = { fg = "error", bg = "bg_statusline", bold = true },
        },
      }
      local FileName = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
          self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
          if self.lfilename == "" then self.lfilename = "" end
        end,
        flexible = 2,
        {
          {
            provider = function(self)
              return self.lfilename
            end,
          },
          unpack(FileFlags),
        },
        {
          {
            provider = function(self)
              return vim.fn.pathshorten(self.lfilename, 2)
            end,
          },
          unpack(FileFlags),
        },
      }

      local SearchCount = {
        condition = function()
          return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
        end,
        init = function(self)
          local ok, search = pcall(vim.fn.searchcount)
          if ok and search.total then
            self.search = search
          end
        end,
        hl = { fg = "orange", bold = true },
        utils.surround({ "[", "]" }, nil, {
          provider = function(self)
            return self.search.current .. "/"
              .. math.min(self.search.total, self.search.maxcount)
          end,
          hl = { fg = "green", bold = true },
        }),
        provider = function(self)
        end,
      }

      local MacroRec = {
        condition = function()
          return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
        end,
        provider = "",
        hl = { fg = "orange", bold = true },
        utils.surround({ "[", "]" }, nil, {
          provider = function()
            return vim.fn.reg_recording()
          end,
          hl = { fg = "green", bold = true },
        }),
        update = { "RecordingEnter", "RecordingLeave" },
      }

      local ShowCmd = {
        condition = function()
          return vim.o.cmdheight == 0
        end,
        provider = "%S",
      }

      local InactiveFileFormat = {
        static = {
          symbols = {
            unix = '', -- e712
            dos = '', -- e70f
            mac = '', -- e711
          }
        },
        init = function(self)
          self.eol = vim.bo.eol and "↲" or ""
          self.encoding = vim.opt.fileencoding:get():gsub("^(.)[^0-9]*", "%1", 1)
          self.symbol = self.symbols[vim.bo.fileformat]
            or vim.bo.fileformat
        end,
        provider = function(self)
          return self.symbol .. self.encoding .. self.eol
        end,
      }
      local FileFormat = vim.tbl_extend("force", InactiveFileFormat, {
        hl = { fg = "blue", bg = "bg_statusline", bold = true },
        update = { "BufReadPost", "BufWritePre" },
      })

      local Ruler = {
        static = {
          bar = { "▀", "🭶", "🭷", "🭸", "🭹", "🭺", "🭻", "▄" },
        },
        init = mode_init,
        provider = function(self)
          local line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          if line == lines then
            return "%l:%c"..self.bar[#self.bar]
          elseif line == 1 then
            return "%l:%c"..self.bar[1]
          else
            return "%l:%c"..self.bar[math.floor((#self.bar-2)*(line-1)/(lines-1))+2]
          end
        end,
        hl = mode_hl,
        update = {
          "CursorMoved", "ModeChanged",
          -- pattern = "*:*",
          -- callback = vim.schedule_wrap(function()
          --   vim.api.nvim_command("redrawstatus")
          -- end),
        },
      }

      local Codeium = {
        condition = function() return vim.g.codeium_disable_bindings == 1 end,
        static = {
          status_map = {
            [" ON"] = "",
            OFF = "",
          }
        },
        provider = function(self)
          local status = vim.fn["codeium#GetStatusString"]()
          return self.status_map[status] or status
        end,
      }

      local Align = { provider = "%=" }

      local FileType = {
        provider = function()
          return string.upper(vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg, bg = "bg_statusline", bold = true },
      }

      local TerminalName = {
        provider = function()
          return "" .. vim.api.nvim_buf_get_name(0):gsub("^.*//([0-9]+:)", "%1", 1)
        end,
        hl = { fg = "blue", bg = "bg_statusline", bold = true },
      }

      local HelpFileName = {
        condition = function()
          return vim.bo.filetype == "help"
        end,
        provider = function()
          local filename = vim.api.nvim_buf_get_name(0)
          return vim.fn.fnamemodify(filename, ":t")
        end,
        hl = { fg = colors.blue },
      }

      local ActiveStatusline = {
        ViMode,
        Git,
        Diagnostics,
        VirtualEnv,
        WorkDir,
        FileName,
        Align,
        ShowCmd,
        MacroRec,
        SearchCount,
        Codeium,
        FileFormat,
        Ruler,
      }
      local InactiveStatusline = {
        condition = conditions.is_not_active,
        FileName,
        Align,
        InactiveFileFormat,
        { provider = " %l/%L:%c" },
      }
      local QuickfixStatusline = {
        condition = function()
          return vim.bo.buftype == "quickfix"
        end,
        FileType, Space,
        { provider = "<A-CR>: Select & close  <leader><CR>: Split & select" },
        Align, HelpFileName
      }
      local SpecialStatusline = {
        condition = function()
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help" },
            filetype = { "^git.*", "fugitive" },
          })
        end,
        FileType, Align, HelpFileName
      }
      local TerminalStatusline = {
        condition = function()
          return conditions.buffer_matches({ buftype = { "terminal" } })
        end,
        { condition = conditions.is_active, ViMode }, TerminalName, Align, FileType,
      }
      heirline.setup({
        statusline = {
          fallthrough = false,
          QuickfixStatusline,
          SpecialStatusline,
          TerminalStatusline,
          InactiveStatusline,
          ActiveStatusline,
        }
      })
    end,
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --     "tokyonight.nvim",
  --     -- 'arkav/lualine-lsp-progress',
  --   },
  --   config = function()
  --     local home_path = vim.env.HOME
  --     -- local function spellstatus()
  --     --   if (vim.opt.spell:get()) then
  --     --     return [[spell]]
  --     --   else
  --     --     return ''
  --     --   end
  --     -- end
  --     local abbrev_term_memoizes = 0
  --     local abbrev_term_memoize = {}
  --     local function abbrev_term(name, space)
  --       local m_key = name .. "," .. space
  --       local m_value = abbrev_term_memoize[m_key]
  --       if m_value ~= nil then
  --         return m_value
  --       end
  --       name = name:gsub("//", "", 1):gsub("//", ":", 1):gsub(":/.*/", ":", 1)
  --       local name_len = name:len()
  --       local subs
  --       while name_len > space do
  --         name, subs = name:gsub("[a-zA-Z][a-zA-Z][a-zA-Z]+", function(a)
  --           return a:sub(1, 2)
  --         end, 1)
  --         if subs == 0 then
  --           break
  --         end
  --         name_len = name:len()
  --       end
  --       if abbrev_term_memoizes > 512 then
  --         abbrev_term_memoize[next(abbrev_term_memoize)] = nil
  --       else
  --         abbrev_term_memoizes = abbrev_term_memoizes + 1
  --       end
  --       abbrev_term_memoize[m_key] = name
  --       return name
  --     end
  --
  --     local function abbrev_rel_path(rel, space, len)
  --       local dir, base = string.match(rel, "(.*/)([^/]*)")
  --       if dir == nil then
  --         return rel
  --       end
  --       space = space - base:len()
  --       local subs
  --       local dir_len = dir:len()
  --       local pattern = "(" .. string.rep("[^/_-]", len) .. "[^/_-]+)([/_-]%.?)"
  --       while dir_len > space do
  --         dir, subs = dir:gsub(pattern, function(a, b)
  --           return a:sub(1, len) .. b
  --         end, 1)
  --         if subs == 0 then
  --           break
  --         end
  --         dir_len = dir:len()
  --       end
  --       return dir .. base
  --     end
  --
  --     vim.api.nvim_set_hl(0, "StatusDirectory", {
  --       fg = "#7aa2f7",
  --       bg = "#191919",
  --       ctermfg = "blue",
  --       ctermbg = "black",
  --     })
  --     local abbrev_path_memoizes = 0
  --     local abbrev_path_memoize = {}
  --     local function abbrev_path(dir, file, space)
  --       local m_key = dir .. "//" .. file .. "," .. space
  --       local m_value = abbrev_path_memoize[m_key]
  --       if m_value ~= nil then
  --         return m_value
  --       end
  --       dir = dir:gsub("^" .. home_path, "~")
  --       local dir_len = dir:len()
  --       local file_len = file:len()
  --       local dir_space = space - file_len - 4
  --       if dir_len > dir_space then
  --         dir = abbrev_rel_path(dir, dir_space, 1)
  --         dir_len = dir:len()
  --         if dir_len > dir_space then
  --           file = abbrev_rel_path(file, space - dir_len - 4, 2)
  --         end
  --       end
  --       local result = "%#StatusDirectory#" .. dir .. "/%*" .. file
  --       if abbrev_path_memoizes > 512 then
  --         abbrev_path_memoize[next(abbrev_path_memoize)] = nil
  --       else
  --         abbrev_path_memoizes = abbrev_path_memoizes + 1
  --       end
  --       abbrev_path_memoize[m_key] = result
  --       return result
  --     end
  --     local len_without_hl_memoizes = 0
  --     local len_without_hl_memoize = {}
  --     local function len_without_hl(s)
  --       local m_value = len_without_hl_memoize[s]
  --       if m_value ~= nil then
  --         return m_value
  --       end
  --       local result = vim.fn.strdisplaywidth(s:gsub("%%#[^#]+#", "")) + 1
  --       if len_without_hl_memoizes > 128 then
  --         len_without_hl_memoize[next(len_without_hl_memoize)] = nil
  --       else
  --         len_without_hl_memoizes = len_without_hl_memoizes + 1
  --       end
  --       len_without_hl_memoize[s] = result
  --       return result
  --     end
  --     local fix_space = 16
  --     local env_space = 0
  --     local branch_space = 0
  --     local diff_space = 0
  --     local diag_space = 0
  --
  --     local filename_symbols = {
  --       modified = "󰏫",
  --       readonly = "",
  --       unnamed = "",
  --       newfile = "",
  --     }
  --     local codeium_status = {
  --       [" ON"] = "",
  --       OFF = "",
  --     }
  --     local codeium_component = {
  --       function()
  --         local status = vim.fn["codeium#GetStatusString"]()
  --         return codeium_status[status] or status
  --       end,
  --       cond = function()
  --         return vim.g.codeium_disable_bindings == 1
  --       end,
  --       color = { fg = "#3b4261" },
  --       padding = 0,
  --     }
  --     local mode_map = {
  --       -- neovim/runtime/doc/builtin.txt
  --       ["n"] = "N", -- Normal
  --       ["no"] = "⊙", -- Operator-pending
  --       ["nov"] = "⊙", -- Operator-pending (forced charwise |o_v|)
  --       ["noV"] = "⊙", -- Operator-pending (forced linewise |o_V|)
  --       ["no"] = "⊙", -- Operator-pending (forced blockwise |o_CTRL-V|)
  --       ["niI"] = "N", -- Normal using |i_CTRL-O| in |Insert-mode|
  --       ["niR"] = "N", -- Normal using |i_CTRL-O| in |Replace-mode|
  --       ["niV"] = "N", -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
  --       ["nt"] = "N", -- Normal in |terminal-emulator| (insert goes to Terminal mode)
  --       ["ntT"] = "N", -- Normal using |t_CTRL-\_CTRL-O| in |Terminal-mode|
  --       ["v"] = "☱", -- Visual by character
  --       ["vs"] = "☲", -- Visual by character using |v_CTRL-O| in Select mode
  --       ["V"] = "☰", -- Visual by line
  --       ["Vs"] = "☴", -- Visual by line using |v_CTRL-O| in Select mode
  --       [""] = "☳", -- Visual blockwise
  --       ["s"] = "☶", -- Visual blockwise using |v_CTRL-O| in Select mode
  --       ["s"] = "⚌", -- Select by character
  --       ["S"] = "⚍", -- Select by line
  --       [""] = "⚏", -- Select blockwise
  --       ["i"] = "󰏫", -- Insert
  --       ["ic"] = "󰏫", -- Insert mode completion |compl-generic|
  --       ["ix"] = "󰏫", -- Insert mode |i_CTRL-X| completion
  --       ["R"] = "→", -- Replace |R|
  --       ["Rc"] = "→", -- Replace mode completion |compl-generic|
  --       ["Rx"] = "→", -- Replace mode |i_CTRL-X| completion
  --       ["Rv"] = "⇒", -- Virtual Replace |gR|
  --       ["Rvc"] = "⇒", -- Virtual Replace mode completion |compl-generic|
  --       ["Rvx"] = "⇒", -- Virtual Replace mode |i_CTRL-X| completion
  --       ["c"] = "C", -- Command-line editing
  --       ["cr"] = "C", -- Command-line editing overstrike mode |c_<Insert>|
  --       ["cv"] = "⌘", -- Vim Ex mode |gQ|
  --       ["cvr"] = "⌘", -- Vim Ex mode while in overstrike mode |c_<Insert>|
  --       ["r"] = "↲", -- Hit-enter prompt
  --       ["rm"] = "…", -- The -- more -- prompt
  --       ["r?"] = "?", -- A |:confirm| query of some sort
  --       ["!"] = "$", -- Shell or external command is executing
  --       ["t"] = "❯", -- Terminal mode: keys go to the job
  --     }
  --     local mode_component = {
  --       function()
  --         return mode_map[vim.api.nvim_get_mode().mode] or "_"
  --       end,
  --       color = { fg = "#000000", gui = "bold" },
  --       padding = { left = 0, right = 0 },
  --     }
  --     local cmd_component = {
  --       function()
  --         local status = { '%S' }
  --         if vim.v.hlsearch ~= 0 then
  --           local search = vim.fn.searchcount()
  --           if search.total > 0 then
  --             table.insert(status, search.current .. "/" .. search.total)
  --           end
  --         end
  --         local register = vim.fn.reg_recording()
  --         if register ~= "" then
  --           table.insert(status, "rec@" .. register)
  --         end
  --         return table.concat(status, " ")
  --       end,
  --       padding = { left = 1, right = 0 },
  --     }
  --     local pos_bar =
  --       { "▀", "🭶", "🭷", "🭸", "🭹", "🭺", "🭻", "▄" }
  --     local location_bar_component = {
  --       function()
  --         local line = vim.api.nvim_win_get_cursor(0)[1]
  --         local lines = vim.api.nvim_buf_line_count(0)
  --         if line == lines then
  --           return pos_bar[#pos_bar]
  --         elseif line == 1 then
  --           return pos_bar[1]
  --         else
  --           return pos_bar[math.floor((#pos_bar - 2) * (line - 1) / (lines - 1)) + 2]
  --         end
  --       end,
  --       padding = 0,
  --     }
  --     local function quickfix_doc()
  --       return "<A-CR>: Select & close  <leader><CR>: Split & select"
  --     end
  --     require("lualine").setup({
  --       options = {
  --         theme = "tokyonight", -- powerline
  --         section_separators = { left = "", right = "" },
  --         component_separators = { left = "", right = "" },
  --       },
  --       sections = {
  --         lualine_a = {
  --           mode_component,
  --         },
  --         lualine_b = {
  --           {
  --             "branch",
  --             fmt = function(s)
  --               if s == "" then
  --                 branch_space = 0
  --                 return s
  --               end
  --               local space =
  --                 math.floor((vim.fn.winwidth(0) - fix_space) * 0.17)
  --               local s_len = s:len()
  --               if s_len > space then
  --                 branch_space = space + 3
  --                 return s:sub(1, space - 1) .. "…"
  --               else
  --                 branch_space = s_len + 3
  --                 return s
  --               end
  --             end,
  --             padding = 0,
  --           },
  --           {
  --             function()
  --               if not vim.env.VIRTUAL_ENV then
  --                 env_space = 0
  --                 return ""
  --               end
  --               local env = "👾" .. vim.env.VIRTUAL_ENV:match("[^/]+$")
  --               if branch_space == 0 then
  --                 env_space = len_without_hl(env)
  --                 return env
  --               else
  --                 env_space = len_without_hl(env) + 1
  --                 return " " .. env
  --               end
  --             end,
  --             color = { fg = "#ff9e64" },
  --             padding = 0,
  --           },
  --           {
  --             "diff", -- symbols = {added = '', modified = '', removed = ''},
  --             fmt = function(s)
  --               if s == "" then
  --                 diff_space = 0
  --                 return s
  --               end
  --               s = s:gsub("%s+", "")
  --               if branch_space == 0 and env_space == 0 then
  --                 diff_space = len_without_hl(s)
  --                 return s
  --               else
  --                 diff_space = len_without_hl(s) + 1
  --                 return " " .. s
  --               end
  --             end,
  --             padding = 0,
  --           },
  --           {
  --             "diagnostics",
  --             sources = { "nvim_diagnostic" },
  --             fmt = function(s)
  --               if s == "" then
  --                 diag_space = 0
  --                 return s
  --               end
  --               s = s:gsub("%s+", "")
  --               if branch_space == 0 and env_space == 0 and diff_space == 0 then
  --                 diag_space = len_without_hl(s)
  --                 return s
  --               else
  --                 diag_space = len_without_hl(s) + 1
  --                 return " " .. s
  --               end
  --             end,
  --             update_in_insert = false,
  --             symbols = {
  --               error = "",
  --               warn = "",
  --               info = "",
  --               hint = "",
  --             },
  --             padding = 0,
  --           },
  --           -- {spellstatus},
  --           {
  --             require("lazy.status").updates,
  --             cond = require("lazy.status").has_updates,
  --             color = { fg = "#ff9e64" },
  --           },
  --         },
  --         lualine_c = {
  --           {
  --             "filename",
  --             path = 1,
  --             shorting_target = 0,
  --             padding = 0,
  --             symbols = filename_symbols,
  --             fmt = function(s)
  --               if vim.bo.buftype == "" then
  --                 return abbrev_path(
  --                   vim.fn.getcwd(),
  --                   s,
  --                   vim.fn.winwidth(0)
  --                     - fix_space
  --                     - env_space
  --                     - branch_space
  --                     - diff_space
  --                     - diag_space
  --                     - (vim.g.codeium_disable_bindings == 1 and 3 or 0)
  --                 )
  --               elseif vim.bo.buftype == "terminal" then
  --                 return abbrev_term(
  --                   s,
  --                   vim.fn.winwidth(0)
  --                     - fix_space
  --                     - env_space
  --                     - branch_space
  --                     - diff_space
  --                     - diag_space
  --                     - (vim.g.codeium_disable_bindings == 1 and 3 or 0)
  --                 )
  --               else
  --                 return s
  --               end
  --             end,
  --           },
  --         },
  --         lualine_x = {
  --           -- {'lsp_progress',
  --           --   separators = {
  --           --     component = ' ',
  --           --     progress = ' | ',
  --           --     message = { pre = '', post = ''},
  --           --     percentage = { pre = '', post = '%% ' },
  --           --     title = { pre = '', post = ': ' },
  --           --     lsp_client_name = { pre = '', post = '' },
  --           --     spinner = { pre = '', post = '' },
  --           --   },
  --           --   message = { commenced = '⧖', completed = '⧗' },
  --           --   display_components = {{'title', 'percentage', 'message'}, 'lsp_client_name', 'spinner'},
  --           --   spinner_symbols = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }},
  --           -- { 'nvim_treesitter#statusline', max_length = 20 },
  --           cmd_component,
  --           codeium_component,
  --         },
  --         lualine_y = {
  --           {
  --             "encoding",
  --             padding = 0,
  --             fmt = function(s)
  --               if vim.bo.eol then
  --                 return "↲" .. s:sub(1, 1) .. s:gsub("^[^0-9]*", "", 1)
  --               else
  --                 return s:sub(1, 1) .. s:gsub("^[^0-9]*", "", 1)
  --               end
  --             end,
  --           },
  --           { "fileformat", padding = 0 },
  --         },
  --         lualine_z = {
  --           { "location", padding = 0 },
  --           location_bar_component,
  --         },
  --       },
  --       inactive_sections = {
  --         lualine_a = {},
  --         lualine_b = {},
  --         lualine_c = {
  --           {
  --             "filename",
  --             path = 1,
  --             shorting_target = 0,
  --             symbols = filename_symbols,
  --           },
  --         },
  --         lualine_x = { "location" },
  --         lualine_y = { "%L" },
  --         lualine_z = {},
  --       },
  --       extensions = {
  --         {
  --           filetypes = { "qf" },
  --           sections = {
  --             lualine_a = { mode_component },
  --             lualine_b = { quickfix_doc },
  --             lualine_c = {},
  --             lualine_x = { cmd_component },
  --             lualine_y = {},
  --             lualine_z = {
  --               { "location", padding = 0 },
  --               location_bar_component,
  --             },
  --           },
  --           inactive_sections = {
  --             lualine_a = {},
  --             lualine_b = {},
  --             lualine_c = { quickfix_doc },
  --             lualine_x = { "location" },
  --             lualine_y = { "%L" },
  --             lualine_z = {},
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "davidsierradz/cmp-conventionalcommits" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "dmitmel/cmp-cmdline-history" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "nvim-lua/plenary.nvim" },
      { "petertriho/cmp-git" },
      { "ray-x/cmp-treesitter" },
      { "saadparwaiz1/cmp_luasnip" },
      { "LuaSnip" },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
        Spell = "󰓆",
        OrgHeadlineLevel1 = "❶",
        OrgHeadlineLevel2 = "❷",
        OrgHeadlineLevel3 = "❸",
        OrgHeadlineLevel4 = "❹",
        OrgHeadlineLevel5 = "❺",
        OrgHeadlineLevel6 = "❻",
      }
      local source_names = {
        buffer = "Buf",
        cmdline = ":",
        cmdline_history = ":Hi",
        conventionalcommits = "CC",
        latex_symbols = "TeX",
        luasnip = "LSn",
        nvim_lsp = "LSP",
        nvim_lsp_signature_help = "Sig",
        nvim_lua = "Lua",
        orgmode = "Org",
        otter = "Ott",
        path = "/…",
        treesitter = "TS",
      }

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local luasnip = require("luasnip")

      local cmp = require("cmp")
      cmp.setup({
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
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
          end,
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = kind_icons[vim_item.kind] or vim_item.kind
            vim_item.menu = source_names[entry.source.name] or entry.source.name
            return vim_item
          end
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-a>"] = cmp.mapping.abort(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "treesitter" },
          -- { name = 'vsnip' }, -- For vsnip users.
          { name = "luasnip" }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
          { name = "orgmode" },
          -- { name = 'neorg' },
          -- { name = 'codeium' },
          { name = 'otter' },
        }, {
          { name = "buffer" },
        }),
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          -- feat: cuando se añade una nueva funcionalidad.
          -- fix: cuando se arregla un error.
          -- chore: tareas rutinarias que no sean específicas de una feature o
          --   un error como por ejemplo añadir contenido al fichero .gitignore
          --   o instalar una dependencia. test: si añadimos o arreglamos tests.
          -- docs: cuando solo se modifica documentación.
          -- build: cuando el cambio afecta al compilado del proyecto.
          -- ci: el cambio afecta a ficheros de configuración y scripts
          --   relacionados con la integración continua.
          -- style: cambios de legibilidad o formateo de código que no afecta a
          --   funcionalidad.
          -- refactor: cambio de código que no corrige errores ni añade
          --   funcionalidad, pero mejora el código.
          -- perf: usado para mejoras de rendimiento.
          -- revert: si el commit revierte un commit anterior. Debería
          --   indicarse el hash del commit que se revierte.
          { name = "conventionalcommits" },
          { name = "git" }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = "buffer" },
        }),
      })
      require("cmp_git").setup({})

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
          { name = "cmdline_history" },
        }),
      })
      -- nvim-autopairs
      -- If you want insert `(` after select function or method item
      --local cmp_autopairs = require'nvim-autopairs.completion.cmp'
      --cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end,
  },
}
