# GeneralSound Control for esxDOS

Play mods and control your GS with esxDOS dot-command!

## Usage

Just download binary file from releases page and put it into /BIN folder of your SD/CF card.

Remember it requires GeneralSound connected to your speccy. I've tested it with MB03+ Ultimate and ZX Spectrum +2A.

Execute `.gsc` from your basic and see command line parameters. If specified file name - it tries to load it and play.

If specified command like `pause`, `continue`, `rewind` or `init` - it will execute specified command.

Shortcuts are supported too.

Reboot can be useful if some GS program crash internal GS's firmware.

Music will play in background, so you can use it for adding mod-music for your basic programs or for games(not only basic) - just make loader that's will load music and after it game. 

## Development

To compile project all you need is [sjasmplus](https://github.com/z00m128/sjasmplus).

I'm also using GNU Make but if you call sjasmplus for main.asm - it will build `GSC` binary.

## License

I've licensed project by [Nihirash's Coffeeware License](LICENSE).