# dmc-kolor

try:
	if not gSTARTED: print( gSTARTED )
except:
	MODULE = "dmc-kolor"
	include: "../DMC-Corona-Library/snakemake/Snakefile"

module_config = {
	"name": "dmc-kolor",
	"module": {
		"dir": "dmc_corona",
		"files": [
			"dmc_kolor.lua",
			"dmc_kolor/named_colors_hdr.lua",
			"dmc_kolor/named_colors_hex.lua",
			"dmc_kolor/named_colors_rgb.lua",
		],
		"requires": [
			"dmc-corona-boot",
		]
	},
	"examples": {
		"base_dir": "examples",
		"apps": [
		]
	},
	"tests": {
		"files": [],
		"requires": []
	}
}

register( "dmc-kolor", module_config )

