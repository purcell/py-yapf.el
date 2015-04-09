#!/bin/bash -e


install_emacs24() {
    sudo add-apt-repository ppa:cassou/emacs -y
    sudo apt-get update -y

    sudo apt-get install emacs24 -y
}


test_install_package() {
    emacs --no-init-file \
          -nw py-yapf.el \
          -f package-install-from-buffer \
          -f kill-emacs
}


test_01() {
    emacs --no-init-file -nw \
          --load /tmp/buftra.el \
          --load py-yapf.el \
          ./tests/01/before.py \
          -f py-yapf-buffer \
          -f save-buffer \
          -f save-buffers-kill-terminal

    diff ./tests/01/before.py ./tests/01/after.py
}


main() {
    wget -nc https://raw.githubusercontent.com/paetzke/buftra.el/master/buftra.el -O /tmp/buftra.el || true

    if [ "$TRAVIS" = "true" ]; then
        install_emacs24
        test_install_package
    fi

    test_01
}


main
