
publish_theme <- function() {
	
	theme_bw() %+replace%
		theme(
			axis.text = element_text(size = 14),
			plot.title = element_text(size = 20),
			axis.text.x = element_text(angle = 90, hjust = 1),
			panel.grid.minor.y = element_blank(),
			panel.grid.major.x = element_blank(),
			panel.grid.minor.x = element_blank(),
			legend.background = element_rect(colour = "black"),
			legend.position = c(0.1,0.6),
			legend.text = element_text(size = 12),
			axis.title = element_text(size = 14)
		)
}
