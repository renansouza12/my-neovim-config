return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        -- Performance optimizations
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        
        -- Reduce the number of results shown initially
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
          },
        },
        
        -- Set path display to be more readable
        path_display = { "truncate" },
        
        -- Reduce file preview for better performance
        preview = {
          filesize_limit = 0.1, -- MB
          timeout = 250,
        },
        
        mappings = {
          i = {
            ['<C-k>'] = require('telescope.actions').move_selection_previous,
            ['<C-j>'] = require('telescope.actions').move_selection_next,
            ['<C-l>'] = require('telescope.actions').select_default,
            -- Add escape to close telescope faster
            ['<ESC>'] = require('telescope.actions').close,
          },
        },
      },
      pickers = {
        find_files = {
          -- More comprehensive ignore patterns for Angular projects
          file_ignore_patterns = { 
            'node_modules', 
            '%.git', 
            '%.venv',
            '%.git/',  
            '%.angular[/\\]cache',
            -- Additional Angular-specific ignores
            'dist/',
            'dist\\',
            '.angular/',
            '.angular\\',
            'coverage/',
            'coverage\\',
            '%.log',
            'tmp/',
            'temp/',
            '.nyc_output/',
            'e2e/.*%.js',
            '%.tsbuildinfo',
          },
          hidden = true,
          -- Use fd if available (much faster than find)
          find_command = vim.fn.executable("fd") == 1 and {
            "fd",
            "--type",
            "f",
            "--hidden",
            "--follow",
            "--exclude",
            "node_modules",
            "--exclude",
            ".git",
            "--exclude",
            "dist",
            "--exclude",
            ".angular",
            "--exclude",
            "coverage",
          } or nil,
          -- Limit results for large projects
          max_results = 1000,
        },
        live_grep = {
          file_ignore_patterns = { 
            'node_modules', 
            '%.git', 
            '%.venv',
            'dist/',
            'dist\\',
            '.angular/',
            '.angular\\',
            'coverage/',
            'coverage\\',
            '%.log',
          },
          additional_args = function(_)
            return { '--hidden' }
          end,
          -- Use ripgrep with optimized flags
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/',
            '--glob=!node_modules/',
            '--glob=!dist/',
            '--glob=!.angular/',
            '--glob=!coverage/',
          },
          max_results = 1000,
        },
        buffers = {
          show_all_buffers = true,
          sort_lastused = true,
          previewer = false,
          mappings = {
            i = {
              ["<c-d>"] = require("telescope.actions").delete_buffer,
            }
          }
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      },
    }

    -- Enable extensions
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Keymaps
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        }
    end, { desc = '[S]earch [/] in Open Files' })


  end,
}
