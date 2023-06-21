if [ -d /etc/nixos ]; then
    nix-shell -p '(python3.withPackages(p: with p; [ i3ipc ] ))' --command ~/.config/sway/helpers/autotiling.py
else 
    ~/.config/sway/helpers/autotiling.py
fi
