local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

lspconfig.delphi_ls.setup({
  -- capabilities = capabilities,

  on_attach = function(client)
    local lsp_config = vim.fs.find(function(name)
      return name:match(".*%.delphilsp.json$")
    end, { type = "file", path = client.config.root_dir, upward = false })[1]

    if lsp_config then
      client.config.settings = { settingsFile = lsp_config }
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    else
      vim.notify_once("delphi_ls: '*.delphilsp.json' config file not found")
    end
  end,
})

vim.api.nvim_create_autocmd('LspRequest', {
  callback = function(args)
    local bufnr = args.buf
    local client_id = args.data.client_id
    local request_id = args.data.request_id
    local request = args.data.request

      -- print(vim.fn.string(request))

    -- if request.type == 'pending' then
    --   track_pending(client_id, bufnr, request_id, request)
    -- elseif request.type == 'cancel' then
    --   -- do something with pending cancel requests
    --   track_canceling(client_id, bufnr, request_id, request)
    -- elseif request.type == 'complete' then
    --   -- do something with finished requests. this pending
    --   -- request entry is about to be removed since it is complete
    --   track_finish(client_id, bufnr, request_id, request)
    -- end
  end,
})
