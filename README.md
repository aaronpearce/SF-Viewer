<p align="center">
    <img src="https://github.com/aaronpearce/SF-Viewer/blob/master/app-icon.png?raw=true" alt="Symbals App Icon"/>
</p>


SF Viewer for iOS
===============

SF Viewer is the best way to view, compare and export SF Symbols on your iOS device.

Features:
- View all SF Symbols
- Change weight and scale to see how each icon is displayed in a certain setting.
- View additional metadata for a symbol, easily copy it's unicode encoding.
- Export to SVG, PDF, PNG, Squared PNG.
- You can also export icons explicitly for use with Shortcuts on your Home Screen.


Follow me on Twitter at [@aaron_pearce](https://twitter.com/aaron_pearce).

Getting involved
----------------

Please feel free to participate in this open source project. I'd love to see Pull Requests, Bug Reports, ideas and any other positive contributions from the community!

Building the code
-----------------

1. Clone the repository:
    ```shell
    git clone https://github.com/aaronpearce/SF-Viewer.git
    ```
2. Pull in the project dependencies:
    ```shell
    cd Symbals
    sh ./bootstrap.sh
    ```
3. Open `Symbals.xcworkspace` in Xcode.
4. Find a source for the following fonts and drop them into the Fonts directory in Xcode:
    ```SF-Pro-Text-Black.otf
    SF-Pro-Text-Bold.otf
    SF-Pro-Text-Heavy.otf
    SF-Pro-Text-Light.otf
    SF-Pro-Text-Medium.otf
    SF-Pro-Text-Regular.otf
    SF-Pro-Text-Semibold.otf
    SF-Pro-Text-Thin.otf
    SF-Pro-Text-Ultralight.otf
    ```
5. Build the `Symbals` scheme in Xcode.

## Code Signing

If *bootstrap.sh* fails to correctly offer your Apple Team ID, please follow this guide to manually add it.

1. After running the *bootstrap.sh* script in the setup instructions navigate to:
<br>`Symbals/Configuration/Local/DevTeam.xcconfig`
1. Add your *Apple Team ID* in this file:
<br>`LOCAL_DEVELOPMENT_TEAM = KL8N8XSYF4`

>Team IDs look identical to provisioning profile UUIDs, so make sure this is the correct one.

The entire `Local` directory is included in the `.gitignore`, so these changes are not tracked by source control. This allows code signing without making tracked changes. Updating this file will only sign the `Symbals` target for local builds.

### Finding Team IDs

The easiest known way to find your team ID is to log into your [Apple Developer](https://developer.apple.com) account. After logging in, the team ID is currently shown at the end of the URL:
<br>`https://developer.apple.com/account/<TEAM ID>`

Use this string literal in the above, `DevTeam.xcconfig` file to code sign

## Thanks

Thanks to everyone for their support in development and throughout the initial releases and then the review that failed and a particular thanks to [@kylehickinson](https://github.com/kylehickinson) for the suggestion to use Brave's `.xcconfig` based setup for local development signing. Credit to [@jhreis](https://github.com/jhreis) for the initial implementation that I based this upon.

Thanks to [@davedelong](https://github.com/davedelog) for his [sfsymbols](https://github.com/davedelong/sfsymbols) project which helped with the exporter code within SF Viewer.

## Open Source & Copying

SF Viewer is licensed under MIT so that you can use any code in your own apps, if you choose.

However, **please do not ship this app** under your own account. Paid or free. Not that Apple will accept it.
