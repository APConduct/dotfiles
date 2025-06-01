-- Ensure Packer is installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
    end
end

ensure_packer()

-- Packer startup function to manage plugins
return require('packer').startup(function(use)
    -- Install the One Dark theme
    use {
        'navarasu/onedark.nvim',
        config = function()
            -- Apply the One Dark theme after it's installed
            vim.cmd('colorscheme onedark')
        end
    }

    -- You can add other plugins here if needed
    -- use 'neovim/nvim-lspconfig'-- Example of adding LSP config plugin
end)
