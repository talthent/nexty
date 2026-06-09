---
description: Add one or more image wallpapers (imageset + Wallpaper enum + localization)
argument-hint: <image-path> [CamelCaseName] [more paths/names...]
---

Add new wallpaper(s) to the app from the image file(s) the user provided: $ARGUMENTS

If no image path is given, ask the user for the file path(s). For each wallpaper, the user may supply a `CamelCaseName` — if not, derive a sensible one from the image content/filename and confirm it.

For EACH image, do all of the following:

## 1. Process the image to 1920×1080 (center crop-to-fill)
The existing wallpaper set is 1920×1080. Crop-to-fill (cover), never distort:
```bash
src="<source path>"; name="<CamelCaseName>"
cp "$src" /tmp/"$name".jpg
w=$(sips -g pixelWidth /tmp/"$name".jpg | awk '/pixelWidth/{print $2}')
h=$(sips -g pixelHeight /tmp/"$name".jpg | awk '/pixelHeight/{print $2}')
sw=$(python3 -c "print(int(round($w*max(1920/$w,1080/$h))))")
sh=$(python3 -c "print(int(round($h*max(1920/$w,1080/$h))))")
sips -z $sh $sw /tmp/"$name".jpg >/dev/null   # note: sips -z is HEIGHT then WIDTH
sips -c 1080 1920 /tmp/"$name".jpg >/dev/null  # note: sips -c is HEIGHT then WIDTH
```

### Copyright blur
If the image contains **copyrighted characters** (cartoons, mascots, branded IP — like the Minions/Bluey/etc. wallpapers), apply a heavy blur to obscure them (see commit `300ceaf` for precedent), then note it. Generic stock photos and the user's own photos do NOT get blurred — confirm with the user if unsure.

## 2. Create the imageset
At `nexty/Assets.xcassets/Wallpapers/<Name>.imageset/`:
- Copy the processed jpg in as `<Name>.jpg`
- Write a `Contents.json` matching the existing imagesets (single `universal` idiom image, `"author": "xcode"`, `"version": 1`).

## 3. Update `nexty/Models/Wallpaper.swift`
- Add an `enum` case `lowerCamelName = "lowerCamelName"` (group it with a `// Category` comment).
- Add the matching entry in `imageName`: `case .lowerCamelName: "Name"`.
- Add a `gradient` case with colors sampled from the image (used as a fallback before the image loads).

## 4. Update `nexty/Localizable.xcstrings`
Add a `"wallpaper.<lowerCamelName>"` key with `en` and `he` translations (`"extractionState": "manual"`, both `state: "translated"`). Pick a short, friendly title.

## 5. Verify
- `python3 -m json.tool nexty/Localizable.xcstrings > /dev/null` to confirm valid JSON.
- Build: `xcodebuild -scheme nexty -destination 'id=fdeb003c5524d1039bab0f27e4fddb3e5973f852' build` and confirm `BUILD SUCCEEDED`.

The wallpaper picker (`WallpaperPickerView`) iterates `Wallpaper.allCases` automatically, so no UI changes are needed. Report the names added and whether any were blurred.
