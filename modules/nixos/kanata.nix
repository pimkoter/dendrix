{
  flake.nixosModules.kanata = {
    services.kanata = {
      enable = true;

      keyboards.laptop = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];

        config = ''
          (defcfg
            process-unmapped-keys yes
          )

          (defvar
            tap-time 200
            hold-time 250
          )

          (defalias
            a (tap-hold-release $tap-time $hold-time a lmet)
            s (tap-hold-release $tap-time $hold-time r lalt)
            d (tap-hold-release $tap-time $hold-time s lctl)
            f (tap-hold-release $tap-time $hold-time t lsft)

            j (tap-hold-release $tap-time $hold-time n rsft)
            k (tap-hold-release $tap-time $hold-time e rctl)
            l (tap-hold-release $tap-time $hold-time i ralt)
            ; (tap-hold-release $tap-time $hold-time o rmet)
          )

          (defsrc
            esc

            grv  1 2 3 4 5 6 7 8 9 0 - = bspc

            tab  q w e r t y u i o p [ ] \

            caps a s d f g h j k l ; ' ret

            lsft 102d z x c v b n m , . / rsft

            lctl lmet lalt spc ralt rmet rctl
          )

          (deflayer colemak-dh
            grv

            caps  1 2 3 4 5 6 7 8 9 0 - = bspc

            tab  q w f p b j l u y ; [ ] \

            esc @a @s @d @f g m @j @k @l @; ' ret

            lsft 102d x c d v z k h , . / rsft

            lctl lmet lalt spc ralt rmet rctl
          )
        '';
      };
    };
  };
}
