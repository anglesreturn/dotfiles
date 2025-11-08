return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'zbirenbaum/nvim-nio',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dap_python = require 'dap-python'

    -- Dynamically get the Python path
    local function get_python_path()
      local venv = os.getenv 'VIRTUAL_ENV'
      if venv then return venv .. '/bin/python' end
      -- Default to system Python if no virtual environment is active
      return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
    end

    -- Python adapter setup
    dap_python.setup(get_python_path())

    -- DAP UI setup
    dapui.setup()

    -- DAP UI auto-open/close on debugging events
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

    -- Keymaps for debugging
    vim.keymap.set('n', '<leader>lDs', function() dap.continue() end, { desc = 'Start/Continue Debugging' })
    vim.keymap.set('n', '<Leader>lDo', function() dap.step_over() end, { desc = 'Step Over' })
    vim.keymap.set('n', '<Leader>lDi', function() dap.step_into() end, { desc = 'Step Into' })
    vim.keymap.set('n', '<Leader>lDO', function() dap.step_out() end, { desc = 'Step Out' })
    vim.keymap.set('n', '<Leader>lDb', function() dap.toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
    vim.keymap.set(
      'n',
      '<Leader>lDB',
      function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
      { desc = 'Set Conditional Breakpoint' }
    )
    vim.keymap.set(
      'n',
      '<Leader>lDL',
      function() dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end,
      { desc = 'Set Log Point' }
    )
    vim.keymap.set('n', '<Leader>lDr', function() dap.repl.open() end, { desc = 'Open REPL' })
    vim.keymap.set('n', '<Leader>lDl', function() dap.run_last() end, { desc = 'Run Last Debugging Session' })

    -- DAP Virtual Text setup
    require('nvim-dap-virtual-text').setup()
  end,
}
