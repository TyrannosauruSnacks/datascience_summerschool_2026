## 2026-08-05
### Activate *python-cache* for Efficient Rendering
- [According Quarto Documentation](https://quarto.org/docs/computations/python.html#caching)
- Installed `jupyter-cache` via `uv` with `uv pip install jupyter-cache`
- Adding package via `uv add` failed with error:
    - >   × Failed to build `pydata-book @ file:///home/max/projects/datascience_summerschool_2026`
      >   ├─▶ The build backend returned an error
      >   ╰─▶ Call to `setuptools.build_meta.build_editable` failed (exit status: 1)
      >
      >   [stderr]
      >   error: Multiple top-level packages discovered in a flat-layout: ['chapter_2_files',
      >   'chapter_3_files'].

### Activate Visual Line Length Guide
- From [Optimising Positron for Quarto](https://mickael.canouil.fr/posts/2025-11-20-quarto-editor-settings/index.html)
- Added to `settings.json` the following:
    - {"editor.rulers": [80]}

## 2026-08-04
Keyboard inputs were off. Was pressing ctr-j on bone layout, but got ctrl-q action in positron.
Was not the case for other apps like firefox.

Changed Setting "Keyboard - Dispatch" to "keyCode". Now working as expected.

Rendering of callouts in github flavoured markdown does not work in the preview, but It seems that github can render it.

Well it works, but the rendering of error messages is pretty ugly in gfm.

# Set Up Environment
In the book itself "conda" is recommended but in the github repo it is "uv". So
I will use the "uv" installation.

`uv` wants `setuptools` to install `panda` and such.
Tried it with nix, did stuff, but lots of errors.
Will do it from system.
Installed `python3-setuptools` still error.

Next proposal - install it via `pip install setuptools`
Gotta install pip first then.

Ah, had to push the following call to the top of the .toml file:
[tool.uv.extra-build-dependencies]
pandas = ["pkg_resources"]

And then it also works with the `nix-shell`.

And the import of `pandas` does not work. So will try with system.
Oh, does also not work. Something with the .toms seems off.

Ah okay, if I start a new environmen via `ev` and import `pandas` it seems to
work.

`Ipython` installation failed so far however.

Hmm.. `uv` imports, but `ipython` doesn't find it. Okay, but in positron jupyter
notebook it works, as well as quarto. Ah, `uv` still uses the systems version.

Weird, had to import `matplotlib` again.

Okay, so `uv` runs from nix. That's good to know.

Good, positron does not accept the nix instance of python, but I now removed the
default python version, with that of `uv`. Seems fine.

Well, I've got it going now.
