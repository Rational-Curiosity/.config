return {
  {
    'stevearc/overseer.nvim',
    dependencies = { 'telescope.nvim' },
    cmd = { 'OverseerRun', 'OverseerToggle' },
    keys = {
      { "<leader>ft", "<cmd>OverseerRun<cr>", desc = "Telescope overseer" },
    },
    config = function()
      local overseer = require('overseer')
      overseer.setup({
        task_list = {
          default_detail = 2,
        },
        component_aliases = {
          default = {
            { "display_duration", detail_level = 2 },
            { "on_output_summarize", max_lines = 7 },
            "on_exit_set_status",
            "on_complete_notify",
            { "on_complete_open", enter = true, direction = "left" },
            { "on_complete_dispose", timeout = 600 },
          },
        },
        log = {
          {
            type = "notify",
            level = vim.log.levels.WARN,
          },
          {
            type = "file",
            filename = "overseer.log",
            level = vim.log.levels.WARN,
          },
        },
      })
      overseer.add_template_hook({ module = "^make$" }, function(task_defn, util)
        vim.api.nvim_command("wall")
      end)
      local compose_file = vim.env.HOME
        .. "/Prog/gigas/gigas_devenv/docker-compose.yml"
      local containers_core = {
        "db_maria",
        "db_mysql",
        "db_redis",
        "rabbitmq",
        "websockifier",
        "id-provider",
      }
      overseer.register_template({
        name = "Docker Compose gigas CORE up",
        builder = function(params)
          return {
            cmd = "docker",
            args = {
              "compose",
              "--ansi",
              "never",
              "up",
              "-d",
              unpack(containers_core),
            },
            env = {
              COMPOSE_FILE = compose_file,
            },
          }
        end,
      })
      overseer.register_template({
        name = "Docker Compose gigas CORE stop",
        builder = function(params)
          return {
            cmd = "docker",
            args = {
              "compose",
              "--ansi",
              "never",
              "stop",
              unpack(containers_core),
            },
            env = {
              COMPOSE_FILE = compose_file,
            },
          }
        end,
      })
      local containers_kvm = {
        "apiproxy",
        "api-kvm",
        "executor-kvm",
        "kudeiro-kvm",
        "controlpanel",
        "gopanel",
        "hapi",
        "hostbill",
        "mapp",
        "router",
      }
      overseer.register_template({
        name = "Docker Compose gigas KVM up",
        builder = function(params)
          return {
            cmd = "docker",
            args = {
              "compose",
              "--ansi",
              "never",
              "up",
              "-d",
              unpack(containers_kvm),
            },
            env = {
              COMPOSE_FILE = compose_file,
            },
          }
        end,
      })
      overseer.register_template({
        name = "Docker Compose gigas KVM stop",
        builder = function(params)
          return {
            cmd = "docker",
            args = {
              "compose",
              "--ansi",
              "never",
              "stop",
              unpack(containers_kvm),
            },
            env = {
              COMPOSE_FILE = compose_file,
            },
          }
        end,
      })
    end
  },
  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
    keys = {
      { "<leader>Rr", ":SnipReplMemoryClean<CR>:SnipRun<CR>", mode = "v" },
      { "<leader>Rr", "<cmd>SnipReplMemoryClean<CR>:SnipRun<CR>" },
      { "<leader>Rc", "<cmd>SnipReplMemoryClean<CR>" },
      { "<leader>Rs", "<cmd>SnipReset<CR>" },
      { "<leader>Rc", "<cmd>SnipClose<CR>" },
      { "<leader>Ri", "<cmd>SnipInfo<CR>" },
      { "<leader>Rt", "<cmd>SnipTerminate<CR>" },
    },
    cmd = {
      "SnipRun",
      "SnipReset",
      "SnipClose",
      "SnipReplMemoryClean",
      "SnipInfo",
      "SnipTerminate",
    },
    config = function()
      require("sniprun").setup({
        selected_interpreters = {}, --# use those instead of the default for the current filetype
        repl_enable = {}, --# enable REPL-like behavior for the given interpreters
        repl_disable = {}, --# disable REPL-like behavior for the given interpreters

        interpreter_options = { --# intepreter-specific options, see docs / :SnipInfo <name>
          GFM_original = {
            use_on_filetypes = { "markdown.pandoc" }, --# the 'use_on_filetypes' configuration key is
            --# available for every interpreter
          },
        },

        --# you can combo different display modes as desired
        display = {
          -- "Classic",                    --# display results in the command-line  area
          -- "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)

          -- "VirtualTextErr",          --# display error results as virtual text
          -- "TempFloatingWindow",      --# display results in a floating window
          -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
          -- "Terminal",                --# display results in a vertical split
          "TerminalWithCode", --# display results and code history in a vertical split
          -- "NvimNotify",              --# display with the nvim-notify plugin
          -- "Api"                      --# return output to a programming interface
        },

        display_options = {
          terminal_width = 45, --# change the terminal display option width
          notification_timeout = 5, --# timeout for nvim_notify output
        },

        --# You can use the same keys to customize whether a sniprun producing
        --# no output should display nothing or '(no output)'
        show_no_output = {
          "Classic",
          -- "TempFloatingWindow",      --# implies LongTempFloatingWindow, which has no effect on its own
        },

        --# customize highlight groups (setting this overrides colorscheme)
        snipruncolors = {
          SniprunVirtualTextOk = {
            bg = "#66eeff",
            fg = "#000000",
            ctermbg = "Cyan",
            cterfg = "Black",
          },
          SniprunFloatingWinOk = { fg = "#66eeff", ctermfg = "Cyan" },
          SniprunVirtualTextErr = {
            bg = "#881515",
            fg = "#000000",
            ctermbg = "DarkRed",
            cterfg = "Black",
          },
          SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" },
        },

        --# miscellaneous compatibility/adjustement settings
        inline_messages = 0, --# inline_message (0/1) is a one-line way to display messages
        --# to workaround sniprun not being able to display anything

        borders = "single", --# display borders around floating windows
        --# possible values are 'none', 'single', 'double', or 'shadow'
      })
    end,
  },
  {
    "skanehira/denops-docker.vim",
    dependencies = { "vim-denops/denops.vim" },
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
        autocmd FileType docker-containers nnoremap <buffer> <silent> K <CMD>help docker-default-key-mappings<CR>5j023<C-w>_zt<C-w><C-p>|
          \nmap <buffer> R <Nop>|
          \nnoremap <buffer> <silent> Rc :<C-u>call docker#command("docker compose up -d db_maria db_mysql rabbitmq db_redis websockifier")<CR>|
          \nnoremap <buffer> <silent> Rk :<C-u>call docker#command("docker compose up -d keycloak-provider-hostbill apiproxy api-kvm executor-kvm kudeiro-kvm controlpanel gopanel hapi hostbill router")<CR>|
          \lua require'which-key'.register({c='core',k='kvm'},{mode='n',prefix='R',buffer=0})
        augroup END
      ]])
    end,
  },
  {
    "miversen33/netman.nvim",
    cmd = { "NmloadProvider", "Nmlogs", "Nmdelete", "Nmread", "Nmwrite" },
    config = function()
      require("netman")
    end,
  },
  {
    "chipsenkbeil/distant.nvim",
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
      "DistantSystemInfo",
    },
    config = function()
      require("distant").setup({
        -- Applies Chip's personal settings to every machine you connect to
        --
        -- 1. Ensures that distant servers terminate with no connections
        -- 2. Provides navigation bindings for remote directories
        -- 3. Provides keybinding to jump into a remote file's parent directory
        ["*"] = require("distant.settings").chip_default(),
      })
    end,
  },
}
