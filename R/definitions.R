###########################################################################
# HuntLab: DEFINITIONS
# Luke Thorburn, 2020


# ggplot2 Themes ----------------------------------------------------------

theme_huntlab = function() {
    theme(plot.background = element_rect(fill = "#f6f6f6",
                                         linetype = 0),
          plot.margin = margin(0, 0, 0, -2, "pt"),
          panel.background = element_rect(fill = "#ffffff",
                                          size = 0),
          panel.border = element_rect(fill = NA,
                                      size = 0,
                                      colour = "#000000"),
          panel.spacing = unit(2, "pt"),
          legend.background = element_blank(),
          strip.background = element_blank(),
          strip.text = element_text(colour = "#014085")
    )
}
