-- https://github.com/RubixDev/mason-update-all/tree/main
-- provides commands to update packages from the command line
-- nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
return {
    'RubixDev/mason-update-all',
    config = function()
        require('mason-update-all').setup()
    end,
}
