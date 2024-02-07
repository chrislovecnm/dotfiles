-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require("lazy").setup({
    "kylechui/nvim-surround",
    "tpope/vim-repeat",
    "tpope/vim-sleuth",
    "linrongbin16/gitlinker.nvim",
    "numToStr/Comment.nvim",
    "stevearc/oil.nvim",
    "ojroques/nvim-osc52",
    "numToStr/Navigator.nvim",
    "sourcegraph/sg.nvim",
    -- UI to select things (files, grep results, open buffers...)
    "nvim-lualine/lualine.nvim",
    -- use 'arkav/lualine-lsp-progress'
    "j-hui/fidget.nvim",
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Add git related info in the signs columns and popups
    "lewis6991/gitsigns.nvim",
    "neovim/nvim-lspconfig",
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "nvim-telescope/telescope.nvim", -- optional
            "sindrets/diffview.nvim", -- optional
        },
        config = true,
    },
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    },
    {
        -- Theme inspired by Atom
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("onedark")
        end,
    },
    -- use '/home/michael/Repositories/neovim_development/nvim-lspconfig-worktrees/nvim-lspconfig'
    -- use '/home/michael/Repositories/neovim_development/onedark.nvim'
    -- use '$HOME/Repositories/neovim_development/projects.nvim'
    "stevearc/conform.nvim",
    "mfussenegger/nvim-lint",
    "IndianBoy42/tree-sitter-just",
    -- Fuzzy Finder (files, lsp, etc)
    { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
    },
    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
    },
    -- {
    --     "robitx/gp.nvim",
    --     config = function()
    --         require("gp").setup()
    --     end,
    -- },
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "ray-x/go.nvim",
        dependencies = {  -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },

}, {})

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 1000

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

--Set colorscheme (order is important here)
vim.o.termguicolors = true

local onedark = require("lualine.themes.onedark")
for _, mode in pairs(onedark) do
    mode.a.gui = nil
end

--Set statusbar
require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = onedark,
        component_separators = "|",
        section_separators = "",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "filename" },
        lualine_c = { "lsp_progress" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})

-- Enable fidget for lsp progress
require("fidget").setup()

-- Enable nvim surround
require("nvim-surround").setup({})

-- Enable commentary.nvim
require("Comment").setup()

-- Enable neogit
require("neogit").setup({
    integrations = {
        diffview = true,
    },
})

vim.cmd([[ command! DiffviewFile execute("DiffviewOpen -- " . expand("%")) | DiffviewToggleFiles]])

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--Add move line shortcuts
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

--Remap escape to leave terminal mode
vim.keymap.set("t", "<Esc>", [[<c-\><c-n>]])

--Disable numbers in terminal mode
local terminal_group = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", { command = "set nonu", group = terminal_group })

require("ibl").setup({
    indent = { char = "┊" },
    -- filetype_exclude = { 'help' },
    -- buftype_exclude = { 'terminal', 'nofile' },
    whitespace = {
        remove_blankline_trail = false,
    },
})

-- Gitsigns
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
        vim.keymap.set("n", "[c", require("gitsigns").prev_hunk, { buffer = bufnr })
        vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr })
    end,
})

-- Better netrw replacement
require("oil").setup({
    view_options = {
        show_hidden = true,
    },
})

-- Better splitjoin replacement
require("treesj").setup({})
vim.keymap.set("n", "U", require("treesj").toggle)

-- Navigator
require("Navigator").setup()
vim.keymap.set({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
vim.keymap.set({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
vim.keymap.set({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
vim.keymap.set({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
vim.keymap.set({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")

-- Prompt commands
local function keymapOptions(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
end

vim.keymap.set({"n", "i"}, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
vim.keymap.set({"n", "i"}, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set({"n", "i"}, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

-- Telescope
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
})
require("telescope").load_extension("fzf")
vim.keymap.set("n", "-", function()
    require("oil").open()
end, { desc = "Open parent directory" })

--Add leader shortcuts
-- function TelescopeFiles()
--   local telescope_opts = { previewer = false }
--   local ok = pcall(require('telescope.builtin').git_files, telescope_opts)
--   if not ok then
--     require('telescope.builtin').find_files(telescope_opts)
--   end
-- end

-- vim.keymap.set('n', '<leader>f', TelescopeFiles)
vim.keymap.set("n", "<leader>f", function()
    require("telescope.builtin").find_files({ previewer = false })
end)
vim.keymap.set("n", "<leader><space>", function()
    require("telescope.builtin").buffers({ sort_lastused = true })
end)

vim.keymap.set("n", "<leader>sb", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
end)

vim.keymap.set("n", "<leader>c", function()
    require("telescope.builtin").commands()
end)

vim.keymap.set("n", "<leader>h", function()
    require("telescope.builtin").help_tags()
end)
vim.keymap.set("n", "<leader>st", function()
    require("telescope.builtin").tags()
end)

vim.keymap.set("n", "<leader>?", function()
    require("telescope.builtin").oldfiles()
end)
vim.keymap.set("n", "<leader>sd", function()
    require("telescope.builtin").grep_string()
end)
vim.keymap.set("n", "<leader>sp", function()
    require("telescope.builtin").live_grep()
end)

vim.keymap.set("n", "<leader>so", function()
    require("telescope.builtin").tags({ only_current_buffer = true })
end)

vim.keymap.set("n", "<leader>gc", function()
    require("telescope.builtin").git_commits()
end)
vim.keymap.set("n", "<leader>gb", function()
    require("telescope.builtin").git_branches()
end)
vim.keymap.set("n", "<leader>gs", function()
    require("telescope.builtin").git_status()
end)
vim.keymap.set("n", "<leader>gp", function()
    require("telescope.builtin").git_bcommits()
end)
vim.keymap.set("n", "<leader>wo", function()
    require("telescope.builtin").lsp_document_symbols()
end)

-- Managing quickfix list
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { silent = true })
vim.keymap.set("n", "<leader>qq", ":cclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>Qo", ":lopen<CR>", { silent = true })
vim.keymap.set("n", "<leader>Qq", ":lclose<CR>", { silent = true })

local quickfix_group = vim.api.nvim_create_augroup("QuickfixGroup", { clear = true })
vim.api.nvim_create_autocmd(
    "FileType",
    { command = "nnoremap <buffer> q :lclose <bar> cclose <CR>", group = quickfix_group, pattern = "qf" }
)

-- Managing buffers
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { silent = true })

-- Random
vim.keymap.set("n", "<leader>;", ":")

-- LSP management
vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", { silent = true })

-- remove conceal on markdown files
vim.g.markdown_syntax_conceal = 0

-- Change preview window location
vim.g.splitbelow = true

-- Remap number increment to alt
vim.keymap.set("n", "<A-a>", "<C-a>")
vim.keymap.set("v", "<A-a>", "<C-a>")
vim.keymap.set("n", "<A-x>", "<C-x>")
vim.keymap.set("v", "<A-x>", "<C-x>")

-- n always goes forward
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true })

-- map :W to :w (helps which-key issue)
vim.cmd([[ command! W  execute ':w' ]])

-- Neovim python support
vim.g.loaded_python_provider = 0

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Clear white space on empty lines and end of line
vim.keymap.set(
    "n",
    "<F6>",
    [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]],
    { silent = true }
)

-- Set up just
require("tree-sitter-just").setup({})

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "tsx", "typescript", "vim", "org" },
    auto_install = false,
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "org" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
        additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<M-space>",
        },
    },
    indent = {
        enable = true,
        disable = { "org" },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
})

-- Diagnostic settings
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
})

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setqflist)

-- Formatter configuration
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" } },
        go = { "goimports", "gofmt" },
    },
})

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

require("lint").linters_by_ft = {
    python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

-- LSP settings
-- log file location: $HOME/.cache/nvim/lsp.log
-- vim.lsp.set_log_level 'debug'
-- require('vim.lsp.log').set_format_func(vim.inspect)
require("mason").setup({})
require("mason-lspconfig").setup()

-- Add nvim-lspconfig plugin
local lspconfig = require("lspconfig")
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local attach_opts = { silent = true, buffer = bufnr }
    -- Mappings.
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, attach_opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, attach_opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, attach_opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, attach_opts)
    vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, attach_opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, attach_opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, attach_opts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, attach_opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, attach_opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, attach_opts)
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, attach_opts)
    vim.keymap.set("n", "<leader>bc", vim.lsp.buf.code_action, attach_opts)

    if client.server_capabilities.documentFormattingProvider then
        vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, attach_opts)
    else
    end
end

local handlers = {
    ["textDocument/hover"] = function(...)
        local bufnr, _ = vim.lsp.handlers.hover(...)
        if bufnr then
            vim.keymap.set("n", "K", "<Cmd>wincmd p<CR>", { silent = true, buffer = bufnr })
        end
    end,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
    "clangd",
    "gopls",
    "tsserver",
    "ltex",
    "hls",
    "pyright",
    "yamlls",
    "jsonls",
    "julials",
    "nil_ls",
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
    })
end
-- Sourcegraph configuration. All keys are optional
require("sg").setup {
  on_attach = on_attach
}
-- nnoremap <space>ss <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>


-- lspconfig.ruff_lsp.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     handlers = handlers,
-- }

lspconfig.rust_analyzer.setup({
--    cmd = { "rustup", "run", "nightly", "rust-analyzer" },
    on_attach = on_attach,
    handlers = handlers,
})

lspconfig.html.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { "html", "css", "javascript" },
    },
})

-- require("neodev").setup({})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
        },
    },
})

lspconfig.texlab.setup({
    on_attach = on_attach,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        texlab = {
            build = {
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-pvc" },
                forwardSearchAfter = true,
                onSave = true,
            },
            forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
                onSave = true,
            },
        },
    },
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
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
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})

require('osc52').setup {
  max_length = 0,           -- Maximum length of selection (0 for no limit)
  silent = false,           -- Disable message on successful copy
  trim = false,             -- Trim surrounding whitespaces before copy
  tmux_passthrough = false, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
}

local function copy(lines, _)
    require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

vim.g.clipboard = {
    name = "osc52",
    copy = { ["+"] = copy, ["*"] = copy },
    paste = { ["+"] = paste, ["*"] = paste },
}

require("toggleterm").setup{}
