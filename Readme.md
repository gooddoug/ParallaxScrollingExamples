ParallaxScrollingBackground is a simple demonstration of a scrolling background using parallax as seen in many sidescrolling games. It comes with targets for iOS, macOS, and tvOS that add a simple scrolling background to the example SpriteKit project.

The example apps give a good idea of how to use the SimpleParallaxBackground, but here is the simple tour.
SimpleParallaxBackground has a foreground image that moves faster than the background image. You must first call `setup(inScene:)` on the background which will place it into the scene for you. You move the background by calling `xOffset`. To move continuously, you can set a SKAction with a block that updates the `xOffset`. To move in response to player action (say you want to keep the player sprite in the same x position but make it seem like the world is moving under the player) you set the `xOffset` relative to the movement you want to have. If you want the foreground to move faster or the background to move slower to increase the parallax effect, you can adjust the `backgroundOffsetFactor` or the `foregroundOffsetFactor`

If `SimpleParallaxBackground` doesn't do what you need, you can subclass `SimpleParallaxBackground` and add what you need (maybe you want a midground as well as the foreground and background.) Alternatively, you can create your own class using the `BackgroundType` protocol... useful for doing a `SceneKit` related 3d scrolling background. 

## Contributing
Please use pull requests if you know how to fix the issue you are having. If you can't fix the issue, please file a ticket.

## License
MIT License, see the 'LICENSE' file for details
