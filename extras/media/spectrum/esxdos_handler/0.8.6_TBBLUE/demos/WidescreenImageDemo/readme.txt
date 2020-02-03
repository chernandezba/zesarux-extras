WIDESCREEN IMAGE DEMO
=====================

320x192 image with 256 colour palette chosen from 512 colours. This uses sprites to fill the borders, bringing the image right to the left and right edges.

The image is a rendering of Daybreak by Maxfield Parrish (1922): https://en.wikipedia.org/wiki/Daybreak_(painting).

I tweaked the levels to lighten the sky, which helps avoid artifacts caused by RGB333 not having very many light shades of colour. I also added extra noise and dithering to the floor and pillars, which helps it look more natural.

Works on the Next hardware, Cspect, and ZEsarux.

Source included.

Also contains some C# code to generate the image data and palettes.

Also contains some example C# code to generate a 512-colour RGB 3/3/3 palette image.

Acknowledgements
----------------

Contains fonts stored in FZX v1.0 - a bitmap font format.
Copyright (c) 2013 Andrew Owen.

Contains FZX driver.
Copyright (c) 2013 Einar Saukas.

FZX is a royalty-free compact font file format designed primarily for storing
bitmap fonts for 8 bit computers, primarily the Sinclair ZX Spectrum, although
also adopting it for other platforms is welcome and encouraged!

SevenFFF / Robin Verhagen-Guest
June 2018
