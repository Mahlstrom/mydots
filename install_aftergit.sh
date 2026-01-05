pushd ~/.config
git remote remove origin
git remote add origin git@github.com:Mahlstrom/mydots.git
ln -s ../github.com nvim_files
popd
