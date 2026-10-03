{
  flake.nixosModules.kanata = {
    boot.kernelModules = [ "uinput" ];
    users.groups.uinput = { };

    services.kanata = {
      enable = true;

      keyboards.desktop = {
        devices = [
          "/dev/input/by-path/pci-0000:00:14.0-usb-0:9:1.0-event-kbd"
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];

        config = ''
          (defvar
            tap-time 200
            hold-time 250
          )

          (defhands
            (left
              q w e r t
              a s d f g
              z x c v b
            )

            (right
              y u i o p
              h j k l ;
              n m , . /
            )
          )

          (defalias
            norepeat kana

            meh
              (multi
                lctl
                lalt
                lsft
              )

            esc
              (multi
                @norepeat
                (tap-hold-release
                  $tap-time
                  $hold-time
                  esc
                  (multi
                    @meh
                    (layer-while-held esc-navigation)
                  )
                )
              )

            a
              (multi
                @norepeat
                (tap-hold-release
                  $tap-time
                  $hold-time
                  a
                  (layer-while-held navigation)
                )
              )

            s-alt
              (multi
                @norepeat
                (tap-hold-opposite-hand-release
                  $hold-time
                  s
                  lalt
                  (same-hand tap)
                  (timeout hold)
                )
              )

            d-ctrl
              (multi
                @norepeat
                (tap-hold-opposite-hand-release
                  $hold-time
                  d
                  lctl
                  (same-hand tap)
                  (timeout hold)
                )
              )

            f-super
              (multi
                @norepeat
                (tap-hold-opposite-hand-release
                  $hold-time
                  f
                  lmet
                  (same-hand tap)
                  (timeout hold)
                )
              )

            j-super
              (multi
                @norepeat
                (tap-hold-opposite-hand-release
                  $hold-time
                  j
                  rmet
                  (same-hand tap)
                  (timeout hold)
                )
              )

            k-ctrl
              (multi
                @norepeat
                (tap-hold-opposite-hand-release
                  $hold-time
                  k
                  rctl
                  (same-hand tap)
                  (timeout hold)
                )
              )

            l-alt
              (multi
                @norepeat
                (tap-hold-opposite-hand-release
                  $hold-time
                  l
                  ralt
                  (same-hand tap)
                  (timeout hold)
                )
              )
          )

          (defsrc
            esc

            grv  1 2 3 4 5 6 7 8 9 0 - = bspc

            tab  q w e r t y u i o p [ ] \

            caps a s d f g h j k l ; ' ret

            lsft 102d z x c v b n m , . / rsft

            lctl lmet lalt spc ralt rmet rctl
          )

          (deflayer qwerty
            caps

            grv  1 2 3 4 5 6 7 8 9 0 - = bspc

            tab  q w e r t y u i o p [ ] \

            @esc @a @s-alt @d-ctrl @f-super g h @j-super @k-ctrl @l-alt ; ' ret

            lsft 102d z x c v b n m , . / rsft

            lctl lmet lalt spc ralt rmet rctl
          )

          (deflayer navigation
            _

            _ _ _ _ _ _ _ _ _ _ _ _ _ _

            _ _ _ _ _ _ _ _ _ _ _ _ _ _

            _ _ _ _ _ _ left down up right _ _ _

            _ _ _ _ _ _ _ _ _ _ _ _ _

            _ _ _ _ _ _ _
          )

          (deflayer esc-navigation
            _

            _ _ _ _ _ _ _ _ _ _ _ _ _ _

            _ _ _ _ _ _ _ _ _ _ _ _ _ _

            _ _ _ _ _ _ m n e i _ _ _

            _ _ _ _ _ _ _ _ _ _ _ _ _

            _ _ _ _ _ _ _
          )
        '';
      };
    };
  };
}
