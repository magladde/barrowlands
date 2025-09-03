tutorial taken from the following site:
	https://medium.com/@merxon22/godot-create-your-first-2d-minimap-c43dfda01802
	
# Text from tutorial
## Step 1: Capture the scene with a SubViewport
The main idea is to create a secondary camera that follows the player . It has a wider field of view and is dedicated to render minimap contents.
In you game scene, add these three nodes. Let me introduce them from bottom to top:

SubViewport, a node that captures a specific area of the game scene. Whatever is captured is not directly rendered to the main window, allowing developers to make modifications to it and display the contents somewhere else. Perfect for minimap.
SubViewport Container, a SubViewport only captures an area but does not display the content. A container is needed to display the contents.
CanvasLayer, the root node for all UI elements.

I will also turn on the Stretch option in SubViewport Container’s inspector. After enabling this, the SubViewport node will automatically resize to fit the container’s size. I will use the anchor preset to anchor the minimap to the upper-right corner and put it to a position I like.

If you run the game now, you’ll see that the SubViewport is entirely grey. This is because each SubViewport has its own 2D world. By default, it will only render its child nodes but not nodes outside of it (e.g., it will not render player node).

We need a bit of GD Script magic to connect the SubViewport’s world to the game world. Create a GD Script on our SubViewport node, and write the ready function like this:

func _ready() -> void:
	 # "world_2d" refers to this SubViewport's own 2D world.
	 # "get_tree().root" will fetch the game's main viewport.
	 world_2d = get_tree().root.world_2d
	
Now, the minimap will now display the main scene’s content! However, it is not following the player. I will add a Camera 2D node under the SubViewport. A SubViewport will find its first child Camera and use that as the viewport camera.

Inside the script, add the following lines. Once you save the script, you’ll see the “camera_node” and “player_node” variables being exposed in the SubViewport’s inspector. Drag the corresponding nodes into place.

# Reference the camera and the player
# "@export" keyword will expose these two variables in the inspector
@export var camera_node : Node2D
@export var player_node : Node2D

func _process(delta: float) -> void:
	# Let camera move with player
	camera_node.position = player_node.position
	
Now, if you run the game, you’ll see the minimap being properly setup!

## Step 2: Display icons instead of the original sprite
In most games, minimaps are not simply a zoomed-out version of the main camera. Instead of displaying the game’s original graphics, they usually replace the character sprites with simplified 2D icons.

In the file system, I’ve prepared a simplified version of the game’s original map. Drag the “island_minimap_background.png” into the scene, set its scale to 2, and move it to align with the original map.

Another Pro Tip: Make this minimap sprite half-transparent using its “self modulate” property. This helps developers more easily align it with the original map. If you don’t want this minimap to cover everything else in the scene, lower its “z-index” to decrease its render priority.

We want this minimap to be rendered by the SubViewport, but not the main viewport. Inside the sprite’s “Visibility > Visibility Layer” property, we will set it to belong to layer 2 by toggling the buttons.

And here’s the catch! If a node on layer 2 wants to be rendered, all of its parents must also belong to layer 2. So, we have to set the root node’s visibility layer to include layer 2 as well.

Lastly, we will exclude layer 1 (the original map’s layer) from the SubViewport’s “Canvas Cull Mask” to prevent it from being rendered in the minimap.

Now, a simplified version of our map will only be visible in our minimap.

We want to do the same thing for the player, NPC, and chicken coop, so I’ll add a Sprite 2D node under the player and assign its texture to use the “minimiap_icon.png” image in the file system. Enable the sprite’s region settings and select the sub-sprite corresponding to the player.

I’ll set this icon’s scale to 4 to make it look a bit bigger and set its z-index to -3 so that it doesn’t block the player’s original sprite. Don’t forget to set both this sprite and the player node’s Visibility Layer to be on layer 2. The icon should now display in the minimap. I will do the same thing to the NPC and the chicken coop to display their icon as well.