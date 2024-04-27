local ft_prog_lsp = {
  "automake",
  "c",
  "config",
  "cpp",
  "h",
  "handlebars",
  "hpp",
  "html",
  "java",
  "javascript",
  "javascript.jsx",
  "javascriptreact",
  "js",
  "json",
  "json5",
  "jsonc",
  "jsonnet",
  "jsx",
  "make",
  "objc",
  "objcpp",
  "php",
  "python",
  "rust",
  "sh",
  "ts",
  "tsx",
  "typescript",
  "typescript.tsx",
  "typescriptreact",
  "typst",
  "yaml",
}
local ft_prog = { "fish", "lua", "smarty", unpack(ft_prog_lsp) }

return {
  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-cmp',
      'nvim-lspconfig',
      'nvim-treesitter',
    },
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = "initAutoGroup",
        pattern = { "*.html", "*.htm", "*.md", "*.org" },
        callback = function(ev)
          local otter = require("otter")
          otter.activate(ft_prog_lsp)
          vim.keymap.set(
            "n",
            "<leader>ld",
            otter.ask_definition,
            { silent = true, buffer = ev.buf, desc = "Lsp definition" }
          )
          vim.keymap.set(
            "n",
            "<leader>lK",
            otter.ask_hover,
            { silent = true, buffer = ev.buf, desc = "Lsp hover" }
          )
          vim.keymap.set(
            "n",
            "<leader>lt",
            otter.ask_type_definition,
            { silent = true, buffer = ev.buf, desc = "Lsp type definition" }
          )
          vim.keymap.set(
            "n",
            "<leader>ln",
            otter.ask_rename,
            { silent = true, buffer = ev.buf, desc = "Lsp rename" }
          )
          vim.keymap.set(
            "n",
            "<leader>lr",
            otter.ask_references,
            { silent = true, buffer = ev.buf, desc = "Lsp references" }
          )
          vim.keymap.set({ "n", "v" }, "<leader>lf",
            otter.ask_format,
            { silent = true, buffer = ev.buf, desc = "Lsp format" })
        end,
      })
    end,
    opts = {
      lsp = {
        diagnostic_update_events = {
          "BufWritePost",
          "InsertLeave",
          "TextChanged",
        }
      },
    }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    ft = ft_prog,
    dependencies = "tokyonight.nvim",
    config = function()
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261", bg = "none" })
        vim.api.nvim_set_hl(0, "IblWhitespace", { link = "NonText" })
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#ffba00", bg = "none" })
      end)
      require("ibl").setup({
        indent = {
          char = "▏",
        },
        whitespace = {
          remove_blankline_trail = false,
        },
        scope = {
          highlight = "IblScope",
          show_start = false,
          show_end = false,
          include = {
            node_type = {
              lua = { "table_constructor" },
            },
          },
        },
      })
      vim.keymap.set(
        "n",
        "<leader>i",
        ":IBLToggle<CR>",
        { desc = "Toggle indent blankline" }
      )
    end,
  },
  {
    "mhartington/formatter.nvim",
    cmd = { "Format", "FormatWrite", "FormatLock", "FormatWriteLock" },
    config = function()
      local filetypes = require("formatter.filetypes")
      local js_fmt = "biome"
      if vim.fn.executable("prettier-eslint") ~= 0 then
        js_fmt = "prettiereslint"
      elseif vim.fn.executable("eslint_d") ~= 0 then
        js_fmt = "eslint_d"
      end
      local function js_selector(filetype)
        local formatters = filetypes[filetype]
        if js_fmt == "biome" then
          return formatters[js_fmt]
        end
        return function()
          return formatters[find_ancestor(".eslintrc.json")
          and js_fmt or "biome"]()
        end
      end
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.ERROR,
        filetype = {
          awk = filetypes.awk.prettier,
          c = filetypes.c.clangformat,
          cmake = filetypes.cmake.cmakeformat,
          cpp = filetypes.cpp.clangformat,
          cs = filetypes.cs.clangformat,
          css = filetypes.css.eslint_d,
          dart = filetypes.dart.dartfmt,
          elixir = filetypes.elixir.mixformat,
          fish = filetypes.fish.fishindent,
          go = filetypes.go.gofmt,
          graphql = filetypes.graphql.prettier,
          haskell = filetypes.haskell.stylish_haskell,
          html = filetypes.html.prettier,
          java = filetypes.java.clangformat,
          javascript = js_selector("javascript"),
          javascriptreact = js_selector("javascriptreact"),
          json = filetypes.json.biome,
          kotlin = filetypes.kotlin.ktlint,
          latex = filetypes.latex.latexindent,
          lua = filetypes.lua.stylua,
          markdown = filetypes.markdown.prettier,
          nix = filetypes.nix.nixfmt,
          ocaml = filetypes.ocaml.ocamlformat,
          php = filetypes.php.php_cs_fixer,
          python = filetypes.python.ruff,
          ruby = filetypes.ruby.rubocop,
          rust = filetypes.rust.rustfmt,
          sh = filetypes.sh.shfmt,
          sql = filetypes.sql.pgformat,
          svelte = filetypes.svelte.prettier,
          terraform = filetypes.terraform.terraformfmt,
          toml = filetypes.toml.taplo,
          typescript = js_selector("typescript"),
          typescriptreact = js_selector("typescriptreact"),
          vue = filetypes.vue.prettier,
          yaml = filetypes.yaml.pyaml,
          zig = filetypes.zig.zigfmt,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { 'telescope.nvim' },
      { "hrsh7th/cmp-nvim-lsp" },
      -- { 'lvimuser/lsp-inlayhints.nvim' },
      -- { 'ray-x/lsp_signature.nvim' },
      -- { "j-hui/fidget.nvim", opts = {} },
    },
    ft = ft_prog_lsp,
    config = function()
      for type, icon in pairs({
        Error = "",
        Warn = "",
        Hint = "",
        Info = "",
      }) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end

      -- Lsp config
      local lspconfig = require("lspconfig")
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

      -- Handlers
      local diagnostic_config = {
        virtual_text = {
          spacing = 0,
          prefix = "▪",
          format = function(diagnostic)
            return diagnostic.message
              :match("^[%s\u{a0}]*(.-)[%s\u{a0}]*$")
              :gsub("[%s\u{a0}][%s\u{a0}][%s\u{a0}]+", "  ")
          end,
        },
        float = { source = true },
        signs = true,
        underline = true,
        update_in_insert = false,
      }
      vim.diagnostic.config(diagnostic_config)
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        diagnostic_config
      )

      -- Mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set(
        "n",
        "<leader>e",
        vim.diagnostic.open_float,
        { silent = true, desc = "Open diagnostic" }
      )
      vim.keymap.set(
        "n",
        "[d",
        vim.diagnostic.goto_prev,
        { silent = true, desc = "Previous diagnostic" }
      )
      vim.keymap.set(
        "n",
        "]d",
        vim.diagnostic.goto_next,
        { silent = true, desc = "Next diagnostic" }
      )
      vim.keymap.set(
        "n",
        "<leader>Ce",
        vim.diagnostic.setloclist,
        { silent = true, desc = "Add diagnostics to location list" }
      )

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          vim.keymap.set(
            "n",
            "<leader>lD",
            vim.lsp.buf.declaration,
            { silent = true, buffer = ev.buf, desc = "Lsp declaration" }
          )
          vim.keymap.set(
            "n",
            "<leader>ld",
            vim.lsp.buf.definition,
            { silent = true, buffer = ev.buf, desc = "Lsp definition" }
          )
          vim.keymap.set(
            "n",
            "<leader>lK",
            vim.lsp.buf.hover,
            { silent = true, buffer = ev.buf, desc = "Lsp hover" }
          )
          vim.keymap.set(
            "n",
            "<leader>li",
            vim.lsp.buf.implementation,
            { silent = true, buffer = ev.buf, desc = "Lsp implementation" }
          )
          vim.keymap.set(
            "n",
            "<leader>lk",
            vim.lsp.buf.signature_help,
            { silent = true, buffer = ev.buf, desc = "Lsp signature help" }
          )
          vim.keymap.set("n", "<leader>lA", vim.lsp.buf.add_workspace_folder, {
            silent = true,
            buffer = ev.buf,
            desc = "Lsp add workspace folder",
          })
          vim.keymap.set("n", "<leader>lR", vim.lsp.buf.remove_workspace_folder, {
            silent = true,
            buffer = ev.buf,
            desc = "Lsp remove workspace folder",
          })
          vim.keymap.set("n", "<leader>lL", function()
            vim.notify(
              table.concat(vim.lsp.buf.list_workspace_folders(), "\n"),
              vim.log.levels.INFO
            )
          end, {
            silent = true,
            buffer = ev.buf,
            desc = "Lsp list workspace folders",
          })
          vim.keymap.set(
            "n",
            "<leader>lt",
            vim.lsp.buf.type_definition,
            { silent = true, buffer = ev.buf, desc = "Lsp type definition" }
          )
          vim.keymap.set(
            "n",
            "<leader>ln",
            vim.lsp.buf.rename,
            { silent = true, buffer = ev.buf, desc = "Lsp rename" }
          )
          vim.keymap.set(
            "n",
            "<leader>la",
            vim.lsp.buf.code_action,
            { silent = true, buffer = ev.buf, desc = "Lsp code action" }
          )
          vim.keymap.set(
            "n",
            "<leader>lr",
            vim.lsp.buf.references,
            { silent = true, buffer = ev.buf, desc = "Lsp references" }
          )
          vim.keymap.set({ "n", "v" }, "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, { silent = true, buffer = ev.buf, desc = "Lsp format" })

          vim.keymap.set("n", "<leader>lwD", function()
            vim.api.nvim_command("vsplit")
            vim.lsp.buf.declaration()
          end, {
            silent = true,
            buffer = ev.buf,
            desc = "Lsp win declaration",
          })
          vim.keymap.set("n", "<leader>lwd", function()
            vim.api.nvim_command("vsplit")
            vim.lsp.buf.definition()
          end, {
            silent = true,
            buffer = ev.buf,
            desc = "Lsp win definition",
          })
          vim.keymap.set(
            "n",
            "<leader>lwi",
            function()
              vim.api.nvim_command("vsplit")
              vim.lsp.buf.implementation()
            end,
            { silent = true, buffer = ev.buf, desc = "Lsp win implementation" }
          )
          vim.keymap.set(
            "n",
            "<leader>lwt",
            function()
              vim.api.nvim_command("vsplit")
              vim.lsp.buf.type_definition()
            end,
            { silent = true, buffer = ev.buf, desc = "Lsp win type definition" }
          )

          -- require("lsp-inlayhints").on_attach(client, ev.buf)
          require("which-key").register({
            l = {
              name = "Lsp",
              w = {
                name = "Other win",
              },
            },
          }, { mode = "n", prefix = "<leader>", buffer = ev.buf })
          require("which-key").register({
            l = {
              name = "Lsp",
            },
          }, { mode = "v", prefix = "<leader>", buffer = ev.buf })
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      local util = require("lspconfig.util")

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local base_config = {
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 1000,
        },
      }
      for lsp, config in pairs({
        autotools_ls = base_config,
        bashls = base_config,
        biome = append_to_last(base_config, {
          root_dir = util.root_pattern("biome.json", "biome.jsonc", ".git"),
        }),
        ccls = base_config,
        denols = append_to_last(base_config, {
          root_dir = util.root_pattern("deno.json", "deno.jsonc"),
        }),
        ember = append_to_last(base_config, {
          root_dir = util.root_pattern("ember-cli-build.js"),
        }),
        gitlab_ci_ls = base_config,
        html = base_config,
        intelephense = base_config,
        java_language_server = append_to_last(base_config, {
          cmd = {
            vim.env.HOME
              .. "/tmp/java-language-server/dist/lang_server_linux.sh",
          },
        }),
        pyright = base_config,
        -- <xor>
        -- pylyzer = base_config,
        ruff_lsp = {
          init_options = {
            settings = {
              args = { "--line-length", "79" },
            },
          },
        },
        rust_analyzer = append_to_last(base_config, {
          settings = {
            ["rust-analyzer"] = {
              diagnostics = {
                enable = true,
              },
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
              check = {
                command = "clippy",
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        }),
        tsserver = base_config,
        typst_lsp = append_to_last(base_config, {
          settings = {
            exportPdf = "onType",
          },
        }),
      }) do
        lspconfig[lsp].setup(config)
      end

      -- Highlights
      --vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true })
      --vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true })
      --vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true })
      --vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true })

      -- First startup
      local matching_configs = util.get_config_by_ft(vim.bo.filetype)
      for _, config in ipairs(matching_configs) do
        config.launch()
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "olimorris/neotest-phpunit",
    },
    cmd = { "Neotest", "NeotestDebug", "NeotestFile" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-jest")({
            jestCommand = "npm test --",
          }),
          require("neotest-phpunit"),
        },
      })
      vim.api.nvim_create_user_command("NeotestFile", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { bar = true, desc = "Debug the nearest test" })
      vim.api.nvim_create_user_command("NeotestDebug", function()
        require("neotest").run.run({ strategy = "dap" })
      end, { bar = true, desc = "Debug the nearest test" })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-dap-ui",
      "nvim-dap-python",
      "mxsdev/nvim-dap-vscode-js",
    },
    keys = {
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        silent = true, desc = "Toggle breakpoint",
      },
      {
        "<leader>dc",
        function() require("dap").continue() end,
        silent = true, desc = "Continue",
      },
      {
        "<leader>dn",
        function() require("dap").step_over() end,
        silent = true, desc = "Step over",
      },
      {
        "<leader>dp",
        function() require("dap").step_back() end,
        silent = true, desc = "Step back",
      },
      {
        "<leader>do",
        function() require("dap").step_out() end,
        silent = true, desc = "Step out",
      },
      {
        "<leader>di",
        function() require("dap").step_into() end,
        silent = true, desc = "Step into",
      },
      {
        "<leader>dr",
        function() require("dap").repl.toggle() end,
        silent = true, desc = "Toggle REPL",
      },
      {
        "<leader>dl",
        function() require("dap").list_breakpoints() end,
        silent = true, desc = "List breakpoints",
      },
      {
        "<leader>dd",
        function() require("dap").clear_breakpoints() end,
        silent = true, desc = "Clear breakpoints",
      },
      {
        "<leader>dR",
        function() require("dap").run_last() end,
        silent = true, desc = "Run last",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        silent = true, desc = "Set breakpoint condition",
      },
      {
        "<leader>dL",
        function()
          require("dap").set_breakpoint(
            nil,
            nil,
            vim.fn.input("Log point message: ")
          )
        end,
        silent = true, desc = "Set log point message",
      },
      {
        "<leader>dQ",
        function() require("dap").terminate() end,
        silent = true, desc = "Terminate",
      },
    },
    -- config = function()
    --   -- local dap = require("dap")
    --   -- dap.adapters.python = {
    --   --   type = 'executable',
    --   --   command = 'python3',
    --   --   args = { '-m', 'debugpy.adapter' },
    --   -- }
    --   -- dap.configurations.python = {
    --   --   {
    --   --     type = 'python';
    --   --     request = 'launch';
    --   --     name = "Launch file";
    --   --     program = "${file}";
    --   --     pythonPath = function()
    --   --       return 'python3'
    --   --     end;
    --   --   },
    --   -- }
    -- end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>dU",
        function() require("dapui").toggle() end,
        silent = true, desc = "Dap UI Toggle",
      },
    },
    config = function()
      local dapui = require("dapui")
      dapui.setup({})
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "nvim-dap" },
    keys = {
      {
        "<leader>dF",
        function() require"dap-python".test_method() end,
        noremap = true, silent = true, desc = "DAP test method",
      },
      {
        "<leader>dC",
        function() require"dap-python".test_class() end,
        noremap = true, silent = true, desc = "DAP test class",
      },
      {
        "<leader>dS",
        '<ESC>:lua require"dap-python".debug_selection()<CR>',
        mode = "v",
        noremap = true, silent = true, desc = "DAP debug selection",
      },
    },
    config = function()
      local dap_python = require("dap-python")
      if vim.fn.executable("python") == 1 then
        dap_python.setup("python")
      else
        dap_python.setup("python3")
      end
      if vim.fn.executable("pytest") == 1 then
        dap_python.test_runner = "pytest"
      end
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      {
        "microsoft/vscode-js-debug",
        -- commit = '9c9a3f3',
        build = "sh -c 'npm install --legacy-peer-deps && npm run compile;COD=$?; git checkout package-lock.json; (exit $COD)'",
      },
    },
    config = function()
      require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        debugger_path = vim.env.HOME
          .. "/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
        }, -- which adapters to register in nvim-dap
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
            processId = require("dap.utils").pick_process,
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
              "--testTimeout=100000000",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end
    end,
  },
  {
    -- 'codota/tabnine-nvim',
    -- build = './dl_binaries.sh',
    -- ft = ft_prog,
    -- config = function()
    --   require'tabnine'.setup {}
    -- end
    -- <XOR>
    "Exafunction/codeium.vim",
    ft = ft_prog,
    cmd = { "Codeium" },
    config = function()
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_filetypes = { TelescopePrompt = false }
      vim.keymap.set("i", "<A-h>", vim.fn["codeium#CycleOrComplete"])
      vim.keymap.set(
        "i",
        "<A-l>",
        vim.fn["codeium#Accept"],
        { script = true, silent = true, nowait = true, expr = true }
      )
      vim.keymap.set("i", "<A-k>", function()
        vim.fn["codeium#CycleCompletions"](-1)
      end)
      vim.keymap.set("i", "<A-j>", function()
        vim.fn["codeium#CycleCompletions"](1)
      end)
      vim.keymap.set("i", "<C-x>", vim.fn["codeium#Clear"])
      vim.api.nvim_create_user_command(
        "CodeiumStart",
        "call codeium#server#Start()",
        -- <XOR>
        -- "call timer_start(0, function('codeium#server#Start'))",
        { bar = true, desc = "Start codeium server" }
      )
    end,
    -- <XOR>
    -- "jcdickinson/codeium.nvim",
    -- dependencies = {
    --   "nvim-lua/plenary.nvim",
    --   "MunifTanjim/nui.nvim",
    --   "nvim-cmp",
    -- },
    -- cmd = { 'Codeium' },
    -- ft = ft_prog,
    -- config = function()
    --   require("codeium").setup({
    --   })
    -- end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = ft_prog,
    config = function()
      local todo_comments = require("todo-comments")
      todo_comments.setup({
        signs = false,
        highlight = {
          keyword = "bg",
          pattern = [[\s*<(KEYWORDS):]],
        },
      })
      vim.keymap.set("n", "]t", function()
        todo_comments.jump_next()
      end, { desc = "Next todo comment" })
      vim.keymap.set("n", "[t", function()
        todo_comments.jump_prev()
      end, { desc = "Previous todo comment" })
    end,
  },
}
