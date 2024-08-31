function ONYXHUD.DrawTextShadowed(text, font, x, y, color, color_shadow, shadow_padding, x_align, y_align)
    draw.SimpleText(text, font, x + shadow_padding, y + shadow_padding, color_shadow, x_align, y_align)
    draw.SimpleText(text, font, x, y, color, x_align, y_align)
end