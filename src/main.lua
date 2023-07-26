local textService = game:GetService("TextService")
local rect = script.Parent:WaitForChild("ScrollingClipRect")
local displayText = script.Parent:WaitForChild("DisplayText")
local scrollTextInstance = rect:WaitForChild("ScrollingText")
local staticPrefix = script.Parent:WaitForChild("StaticPrefix")

local enableWrap = true
local wrapDistance = 0.2
local wrapInstance = enableWrap and scrollTextInstance:Clone() or nil
local rotateSpeed = 1

local textWidthScale = 1

local pos = 1
local lastWrapPos = 1

local function setDisplayText()
	scrollTextInstance.Text = displayText.Value
	textWidthScale = scrollTextInstance.AbsoluteSize.X / rect.AbsoluteSize.X
	if wrapInstance then
		wrapInstance.Text = displayText.Value
	end
end

local function init()
	local staticTextWidth = staticPrefix.AbsoluteSize.X
	rect.Size = UDim2.new(1, -staticTextWidth,1, 0)

	scrollTextInstance.Position = UDim2.fromScale(0, 0)
	if wrapInstance then
		wrapInstance.Parent = rect
		wrapInstance.Position = UDim2.fromScale(1, 0)
	end
	setDisplayText()
end

local function scrollText(dt)
	pos -= dt * rotateSpeed
	if pos < -textWidthScale then
		pos = enableWrap and lastWrapPos or 1
	end

	if enableWrap then
		local minDist = 1 - textWidthScale
		local d = math.max(minDist, wrapDistance)
		local wrapPos = pos > d and pos - d - textWidthScale or pos + d + textWidthScale > 0 and pos + d + textWidthScale or 1
		wrapInstance.Position = UDim2.fromScale(wrapPos, 0)
		lastWrapPos = wrapPos + d + textWidthScale
	end

	scrollTextInstance.Position = UDim2.fromScale(pos, 0)
end

init()
displayText.Changed:Connect(function()
	setDisplayText()
end)

staticPrefix:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	rect.Size = UDim2.new(1, -staticPrefix.AbsoluteSize.X, 1, 0)
	textWidthScale = scrollTextInstance.AbsoluteSize.X / rect.AbsoluteSize.X
end)

game:GetService("RunService").Heartbeat:Connect(scrollText)
