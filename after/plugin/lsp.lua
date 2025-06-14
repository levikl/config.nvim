vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('user_lsp_attach', {clear = true}),
	callback = function(event)
		local opts = {buffer = event.buf}

		vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
		vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
		vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
		vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
		vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
		vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
	end,
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {'ts_ls', 'rust_analyzer'},
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({
				capabilities = lsp_capabilities,
			})
		end,
		lua_ls = function()
			require('lspconfig').lua_ls.setup({
				capabilities = lsp_capabilities,
				settings = {
					Lua = {
						telemetry = {
							enable = false
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {'vim'}
						},
					},
				},
				on_init = function(client)
					local join = vim.fs.joinpath
					local path = client.workspace_folders[1].name

					-- Don't do anything if there is project local config
					if vim.uv.fs_stat(join(path, '.luarc.json'))
						or vim.uv.fs_stat(join(path, '.luarc.jsonc'))
					then
						return
					end

					local nvim_settings = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							version = 'LuaJIT',
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {'vim'}
						},
						workspace = {
							checkThirdParty = false,
							library = {
								-- Make the server aware of Neovim runtime files
								vim.env.VIMRUNTIME,
								vim.fn.stdpath('config'),
							},
						},
					}

					client.config.settings.Lua = vim.tbl_deep_extend(
						'force',
						client.config.settings.Lua,
						nvim_settings
					)
				end,
			})
		end,
	}
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
	sources = cmp.config.sources({
		{name = 'nvim_lsp'},
		{name = 'luasnip'},
	}, {
		{name = 'buffer'},
	}),
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({select = true}),
		['<C-Space>'] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
})
