-- QuickMR 1.31 - 10/10/13
-- Developed by Midge Sinnaeve
-- www.themantissa.net
-- Licensed under GPL v2

macroScript QuickMR
	category:"DAZE"
	toolTip:"Quick mental ray settings"
	buttonText:"QuickMR"
	(
		rollout QuickMR "QuickMR" width:530 height:800
		(
			global mr = renderers.current
			
			button btn_unitconfig "Configure" pos:[10,7] width:75 height:20 tooltip:"Open Unit Settings Dialog"
			label lbl_units "" pos:[95,10] width:350 height:20
			
			fn unitRefresh =
			(
			local sysunit = units.SystemType
			local dispunit = units.DisplayType
			
			local unitconfig = "System Units: " + sysunit + "   -   Display Units: " + dispunit
			lbl_units.text = unitconfig
			)
			
			on btn_unitconfig pressed do
			(
				Usetup()
				unitRefresh()
			)
			
			label lbl_version "QuickMR v1.31" pos:[447,10] width:73 height:20
			
			--- COMMON PARAMS INTERFACE ---
			
			groupBox grp_scene "Common Scene Parameters" pos:[10,30] width:510 height:210
			
				label lbl_timeconfig "Time Configuration:" pos:[20,60] width:110 height:20
				spinner spn_timestart "Start: " pos:[160,60] width:60 height:16 range:[-100000,100000,0] type:#integer scale:1 tooltip:"Set Scene Time Start Frame"
				spinner spn_timeend "End: " pos:[250,60] width:60 height:16 range:[-100000,100000,0] type:#integer scale:1 tooltip:"Set Scene Time End Frame"
				spinner spn_timefps "FPS: " pos:[340,60] width:60 height:16 range:[0,4800,0] type:#integer scale:1 tooltip:"Set Scene Time Frames Per Second"
				button btn_pal "PAL" pos:[410,58] width:50 height:20 toolTip:"Set Framerate to PAL (25 fps)"
				button btn_ntsc "NTSC" pos:[460,58] width:50 height:20 toolTip:"Set Framerate to NTSC (30 fps)"
			
					label lbl_dividercommon "" pos:[20,90] width:490 height:1 enabled:false style_sunkenedge:true
			
				spinner spn_renderwidth "W:" pos:[40,110] width:70 height:16 range:[0,32768,0] type:#integer scale:1 tooltip:"Set Render Output Width"
				spinner spn_renderheight "H: " pos:[40,140] width:70 height:16 range:[0,32768,0] type:#integer scale:1 tooltip:"Set Render Output Height"
				button btn_dblrender "x2" pos:[140,110] width:40 height:20 tooltip:"Double Render Output Width & Height"
				button btn_halfrender "/2" pos:[140,140] width:40 height:20 tooltip:"Halve Render Output Width & Height"
				button btn_720 "720p" pos:[20,170] width:70 height:30 tooltip:"Set Render Output to 720p (1280x720)"
				button btn_1080 "1080p" pos:[110,170] width:70 height:30 tooltip:"Set Render Output to 1080p (1920x1080)"
			
					label lbl_dividercommon2 "" pos:[200,100] width:1 height:100 enabled:false style_sunkenedge:true
			
				radioButtons rdo_renderrange "Render Range" pos:[230,110] width:140 height:46 enabled:true labels:#("Single", "Active TS", "Range", "Frames") default:1 columns:2
				spinner spn_rendernth "Nth:" pos:[450,120] width:60 height:16 range:[1,10000,1] type:#integer scale:1 enabled:false tooltip:"Render every Nth Frame in Sequence"
				spinner spn_renderstart "" pos:[230,170] width:50 height:16 range:[-10000,10000,0] type:#integer scale:1 enabled:false tooltip:"Set Render Output Start Frame"
				spinner spn_renderend "To  " pos:[300,170] width:60 height:16 range:[-10000,10000,0] type:#integer scale:1 enabled:false tooltip:"Set Render Output End Frame"
				label lbl_renderframes "Render Frames:" pos:[432,148] width:80 height:16 enabled:false
				editText edt_renderframes "" pos:[380,168] width:131 height:16 enabled:false tooltip:"Set Render Output Individual Frames"
			
				checkbox chk_saverender "" pos:[20,210] width:10 height:20 enabled:true checked:true tooltip:"Enable Render Output (Save File)"
				edittext edt_renderdir "" pos:[40,211] width:390 height:18 tooltip:"Render Output (Save File) Directory"
				button btn_browserenderdir "Browse..." pos:[440,210] width:70 height:20 toolTip:"Set Render Output Directory"
				
			--- COMMON PARAMS INTERFACE STATES ---
			
			on btn_pal pressed do
			(
				spn_timefps.value = 25
			)
			
			on btn_ntsc pressed do
			(
				spn_timefps.value = 30
			)
			
			fn checkTimeValues =
			(
				
			)
			
			on spn_timestart entered do
			(
				if spn_timeend.value <= spn_timestart.value then
				(
					spn_timeend.value = (spn_timestart.value + 1)
				)
			)
			
			on spn_timeend entered do
			(
				if spn_timeend.value <= spn_timestart.value then
				(
					spn_timestart.value = (spn_timeend.value - 1)
				)
			)
			
			on btn_dblrender pressed do
			(
				spn_renderwidth.value *= 2
				spn_renderheight.value *= 2
			)
			
			on btn_halfrender pressed do
			(
				spn_renderwidth.value /= 2
				spn_renderheight.value /= 2
			)
			
			on btn_720 pressed do
			(
				spn_renderwidth.value = 1280
				spn_renderheight.value = 720
			)
			
			on btn_1080 pressed do
			(
				spn_renderwidth.value = 1920
				spn_renderheight.value = 1080
			)
			
			fn renderRangeState =
			(
				if rdo_renderrange.state == 4 then
					(
						spn_rendernth.enabled = false
						spn_renderstart.enabled = false
						spn_renderend.enabled = false
						lbl_renderframes.enabled = true
						edt_renderframes.enabled = true
					)
				else if rdo_renderrange.state == 3 then
					(
						spn_rendernth.enabled = true
						spn_renderstart.enabled = true
						spn_renderend.enabled = true
						lbl_renderframes.enabled = false
						edt_renderframes.enabled = false
					)
				else if rdo_renderrange.state == 2 then
					(
						spn_rendernth.enabled = true
						spn_renderstart.enabled = false
						spn_renderend.enabled = false
						lbl_renderframes.enabled = false
						edt_renderframes.enabled = false
					)
						
				else
					(
						spn_rendernth.enabled = false
						spn_renderstart.enabled = false
						spn_renderend.enabled = false
						lbl_renderframes.enabled = false
						edt_renderframes.enabled = false
					)
			)
			
			on spn_renderstart entered do
			(
				if spn_renderend.value < spn_renderstart.value then
				(
					spn_renderend.value = spn_renderstart.value
				)
			)
			
			on spn_renderend entered do
			(
				if spn_renderend.value < spn_renderstart.value then
				(
					spn_renderstart.value = spn_renderend.value
				)
			)
			
			fn saveRenderState =
			(
				if chk_saverender.checked == false then
				(
					edt_renderdir.enabled = false
					btn_browserenderdir.enabled = false
				)
				else
				(
					edt_renderdir.enabled = true
					btn_browserenderdir.enabled = true
				)
			)
				
			on rdo_renderrange changed state do
			(
				renderRangeState()
			)
			
			on chk_saverender changed state do
			(
				saveRenderState()
			)
			
			
			on btn_browserenderdir pressed do
			(
				if edt_renderdir.text == "" then
				(
					renderoutputdir = selectSaveBitMap caption:"Render Output File" filename:"$renderOutput"
				)
				else
				(
					renderoutputdir = selectSaveBitMap caption:"Render Output File" filename:edt_renderdir.text
				)
				
				if renderoutputdir != undefined then
				(
					edt_renderdir.text = renderoutputdir
				)
			)
			
			
			
			--- RENDERER / SAMPLING PARAMS INTERFACE ---
			
			groupBox grp_renderer "Renderer / Sampling Settings" pos:[10,250] width:510 height:180
			
				dropDownList ddl_samplemode "Sampling Mode:" pos:[20,270] width:270 height:40 items:#("Unified / Raytraced (Recommended)", "Classic / Raytraced (Legacy)", "Rasterizer / Scanline (!) BUGGED, Set Manually", "Fixed 1/1 sampling (No AA)") selection:1
				spinner spn_uniquality "Quality: " pos:[60,330] width:50 height:16 range:[0,20,0] type:#float scale:1
				spinner spn_unimin "Min:   " pos:[150,330] width:50 height:16 range:[0,1000,0] type:#float scale:1
				spinner spn_unimax "Max: " pos:[240,330] width:50 height:16 range:[0,1000,0] type:#integer scale:1
				label lbl_classicsamples "Samples Per Pixel:" pos:[25,363] width:90 height:20 enabled:false
				label lbl_classicsamplesmin "Min:" pos:[122,363] width:25 height:20 enabled:false
				dropDownList ddl_classicsamplesmin "" pos:[150,360] width:50 height:21 items:#("1/64", "1/16", "1/4", "1", "4", "16", "64", "256", "2048") selection:1 enabled:false
				label lbl_classicsamplesmax "Max:" pos:[210,363] width:30 height:20 enabled:false
				dropDownList ddl_classicsamplesmax "" pos:[240,360] width:50 height:21 items:#("1/64", "1/16", "1/4", "1", "4", "16", "64", "256", "2048") selection:1 enabled:false
				spinner spn_scanshading "Shading: " pos:[62,396] width:60 height:16 range:[0,20,0] type:#float scale:1 enabled:false
				label lbl_scanvis "Visibility:" pos:[150,396] width:50 height:20 enabled:false
				dropDownList ddl_scanvis "" pos:[210,393] width:80 height:21 items:#("1", "4", "9", "16", "25", "36", "49", "64", "81", "100", "121", "144", "169", "196", "255") selection:1 enabled:false
			
					label lbl_dividersampler "" pos:[300,270] width:1 height:145 enabled:false style_sunkenedge:true
				
				dropDownList ddl_filtertype "Filter Type:" pos:[310,270] width:80 height:40 items:#("Box", "Gauss", "Triangle", "Mitchell", "Lanczos") selection:1
				spinner spn_filterwidth "Width:  " pos:[460,270] width:50 height:16 range:[0,8,0] type:#float scale:1
				spinner spn_filterheight "Height: " pos:[460,290] width:50 height:16 range:[0,8,0] type:#float scale:1
				spinner spn_r "" pos:[310, 323] width:50 height:16 range:[0,1,0.01] type:#float scale:1
				spinner spn_g "" pos:[360, 323] width:50 height:16 range:[0,1,0.01] type:#float scale:1
				spinner spn_b "" pos:[410, 323] width:50 height:16 range:[0,1,0.01] type:#float scale:1
				spinner spn_a "" pos:[460, 323] width:50 height:16 range:[0,1,0.01] type:#float scale:1
				checkbox chk_locksamples "Lock Samples" pos:[311,348] width:100 height:20
				checkbox chk_jitter "Jitter" pos:[435,348] width:50 height:20
				dropDownList ddl_fbtype "Frame Buffer Type:" pos:[310,375] width:200 height:40 items:#("Integer (16 bits per channel)", "Floating Point (32 bits per channel)") selection:1
				
			--- RENDERER / SAMPLING PARAMS INTERFACE STATES ---
			
			fn samplingModeState =
			(
				if ddl_samplemode.selection == 1 then
				(
					spn_uniquality.enabled = true
					spn_unimin.enabled = true
					spn_unimax.enabled = true
					lbl_classicsamples.enabled = false
					lbl_classicsamplesmin.enabled = false
					ddl_classicsamplesmin.enabled = false
					lbl_classicsamplesmax.enabled = false
					ddl_classicsamplesmax.enabled = false
					spn_scanshading.enabled = false
					lbl_scanvis.enabled = false
					ddl_scanvis.enabled = false
				)
				else if ddl_samplemode.selection == 2 then
				(
					spn_uniquality.enabled = false
					spn_unimin.enabled = false
					spn_unimax.enabled = false
					lbl_classicsamples.enabled = true
					lbl_classicsamplesmin.enabled = true
					ddl_classicsamplesmin.enabled = true
					lbl_classicsamplesmax.enabled = true
					ddl_classicsamplesmax.enabled = true
					spn_scanshading.enabled = false
					lbl_scanvis.enabled = false
					ddl_scanvis.enabled = false
				)
				else if ddl_samplemode.selection == 3 then
				(
					spn_uniquality.enabled = false
					spn_unimin.enabled = false
					spn_unimax.enabled = false
					lbl_classicsamples.enabled = false
					lbl_classicsamplesmin.enabled = false
					ddl_classicsamplesmin.enabled = false
					lbl_classicsamplesmax.enabled = false
					ddl_classicsamplesmax.enabled = false
					spn_scanshading.enabled = true
					lbl_scanvis.enabled = true
					ddl_scanvis.enabled = true
				)
				else if ddl_samplemode.selection == 4 then
				(
					spn_uniquality.enabled = false
					spn_unimin.enabled = false
					spn_unimax.enabled = false
					lbl_classicsamples.enabled = true
					lbl_classicsamplesmin.enabled = true
					ddl_classicsamplesmin.enabled = true
					ddl_classicsamplesmin.selection = 4
					lbl_classicsamplesmax.enabled = true
					ddl_classicsamplesmax.enabled = true
					ddl_classicsamplesmax.selection = 4
					spn_scanshading.enabled = false
					lbl_scanvis.enabled = false
					ddl_scanvis.enabled = false
					ddl_filtertype.selection = 1
					spn_filterwidth.value = 1.0
					spn_filterheight.value = 1.0
				)
			
			)

			on ddl_samplemode selected i do
			(
				samplingModeState()
			)
			
			on ddl_classicsamplesmin selected i do
			(
				if ddl_classicsamplesmax.selection < ddl_classicsamplesmin.selection do
				(
					ddl_classicsamplesmax.selection = ddl_classicsamplesmin.selection
				)
			)
			
			on ddl_classicsamplesmax selected i do
			(
				if ddl_classicsamplesmin.selection > ddl_classicsamplesmax.selection do
				(
					ddl_classicsamplesmin.selection = ddl_classicsamplesmax.selection
				)
			)
			
			fn filterTypeState =
			(
				case ddl_filtertype.selection of
				(
					1: spn_filterwidth.value = mr.BoxFilterWidth
					2: spn_filterwidth.value = mr.GaussFilterWidth
					3: spn_filterwidth.value = mr.TriangleFilterWidth
					4: spn_filterwidth.value = mr.MitchellFilterWidth
					5: spn_filterwidth.value = mr.LanczosFilterWidth
				)
				
				case ddl_filtertype.selection of
				(
					1: spn_filterheight.value = mr.BoxFilterHeight
					2: spn_filterheight.value = mr.GaussFilterHeight
					3: spn_filterheight.value = mr.TriangleFilterHeight
					4: spn_filterheight.value = mr.MitchellFilterHeight
					5: spn_filterheight.value = mr.LanczosFilterHeight
				)
			)
			
			on ddl_filtertype selected i do
			(
				filterTypeState()
			)
			
			
			--- GLOBAL ILLUMINATION PARAMS INTERFACE ---
			
			groupBox grp_gi "Global Illumination Settings" pos:[10,440] width:510 height:290
			
				radioButtons rdo_gimode "Global Illumination Mode" pos:[20,460] width:490 height:30 labels:#("Skylight illumination from FG", "Skylight Illumination from IBL (HDRi)", "(!) DISABLE FG") columns:3
				label lbl_iblshadows "IBL Shadows >>>" pos:[30,500] width:90 height:20 enabled:false
				spinner spn_iblshadowquality "Quality:" pos:[170,500] width:50 height:16 range:[0,10,0] type:#float scale:1 enabled:false
				label lbl_iblshadowmode "Mode:" pos:[250,500] width:40 height:20 enabled:false
				dropDownList ddl_iblshadowmode "" pos:[290,497] width:220 height:21 items:#("Transparent (More Accurate / Slower)", "Opaque (Faster)") selection:1 enabled:false
				
				slider sld_fgpreset "FG Precision Presets:" pos:[30,530] width:130 height:44 range:[1,6,1] type:#integer ticks:5
				label lbl_fgpreset "Draft" pos:[160,550] width:60 height:20 style_sunkenedge:true
				local lblfgprestext = #("Draft", "Low", "Medium", "High", "Very High", "Custom")
				on sld_fgpreset changed val do lbl_fgpreset.text = lblfgprestext[val]
				spinner spn_diffusebounces "Diffuse Bounces:" pos:[100,590] width:50 height:16 range:[0,999,0] type:#integer scale:1
				
					label lbl_dividergi "" pos:[230,530] width:1 height:80 enabled:false style_sunkenedge:true
					
				
				dropDownList ddl_fgpointprojection "FG Point Projection" pos:[250,530] width:180 height:40 items:#("Static Camera (Stills)", "Along Camera Path (Animation)") selection:1
				dropDownList ddl_fgnumsegs "Num Segs." pos:[450,530] width:60 height:40 items:#("1", "4", "9", "16", "25", "36", "49", "64", "81", "100") selection:1 enabled:false
				label lbl_noisefiltering "Noise Filtering (Speckle Red.):" pos:[253,590] width:160 height:20
				dropDownList ddl_noisefiltering "" pos:[420,587] width:90 height:21 enabled:true items:#("None", "Standard", "High", "Very High", "Extreme") selection:1
			
					label lbl_dividergi2 "" pos:[20,625] width:490 height:1 enabled:false style_sunkenedge:true
			
				label lbl_fgmapmode "Mode:" pos:[20,643] width:40 height:20
				dropDownList ddl_fgmapmode "" pos:[60,641] width:280 height:21 items:#("(OFF) - No files will be cached", "(WRITE) - Incrementally add points to map file(s)", "(READ) - Read FG points only from existing file(s)") selection:1
				checkbox chk_fgskiprender "Skip Final Render (GI Only)" pos:[350,644] width:160 height:20 enabled:true
				label lbl_fgmaptype "Type:" pos:[20,673] width:40 height:20 enabled:false
				dropDownList ddl_fgmaptype "" pos:[60,671] width:280 height:21 items:#("Single File (Walkthrough / Stills)", "One File Per Frame (Animated Objects)") selection:1 enabled:false
				spinner spn_fgmapinterpolation "Interpolation (N Frm) " pos:[440,672] width:60 height:16 range:[0,100,0] type:#integer scale:1 enabled:false
				label lbl_fgmap "Map:" pos:[20,700] width:30 height:20 enabled:false
				editText edt_fgmapdir "" pos:[57,700] width:282 height:20 style_sunkenedge:true enabled:false
				button btn_fgmapdir "Browse..." pos:[350,700] width:70 height:20 toolTip:"Set Final Gather map directory" enabled:false
				button btn_fgmapdelete "DELETE" pos:[430,700] width:70 height:20 toolTip:"Clear (delete) current FG map" enabled:false
				
			--- GLOBAL ILLUMINATION PARAMS INTERFACE STATES ---
			
			fn giMapTypeState =
			(			
					if ddl_fgmaptype.selection == 1 then
					(
						spn_fgmapinterpolation.enabled = false
					)
					else if ddl_fgmaptype.selection == 2 then
					(
						spn_fgmapinterpolation.enabled = true
					)
			)
			
			on ddl_fgmaptype selected i do
			(
				giMapTypeState()
			)
			
			
			fn giMapModeState =
			(
				
				if ddl_fgmapmode.selection == 1 then
				(
					lbl_fgmaptype.enabled = false
					ddl_fgmaptype.enabled = false
					spn_fgmapinterpolation.enabled = false
					lbl_fgmap.enabled = false
					edt_fgmapdir.enabled = false
					btn_fgmapdir.enabled = false
					btn_fgmapdelete.enabled = false
				)
				else if ddl_fgmapmode.selection != 1 then
				(
					lbl_fgmaptype.enabled = true
					ddl_fgmaptype.enabled = true
					giMapTypeState()
					lbl_fgmap.enabled = true
					edt_fgmapdir.enabled = true
					btn_fgmapdir.enabled = true
					btn_fgmapdelete.enabled = true
				)
			)
			
			on ddl_fgmapmode selected i do
			(
				giMapModeState()
			)
				
			fn fgSegState =
			(
				if ddl_fgpointprojection.selection == 1 then
				(	
					ddl_fgnumsegs.enabled = false
				)
				else if ddl_fgpointprojection.selection == 2 then
				(
					ddl_fgnumsegs.enabled = true
				)
			)
			
			on ddl_fgpointprojection selected i do
			(
				fgSegState()
			)
			
			fn giModeState =
			(
				if rdo_gimode.state == 3 then
				(
					lbl_iblshadows.enabled = false
					spn_iblshadowquality.enabled = false
					lbl_iblshadowmode.enabled = false
					ddl_iblshadowmode.enabled = false
					sld_fgpreset.enabled = false
					lbl_fgpreset.enabled = false
					spn_diffusebounces.enabled = false
					ddl_fgpointprojection.enabled = false
					ddl_fgnumsegs.enabled = false
					lbl_noisefiltering.enabled = false
					ddl_noisefiltering.enabled = false
					lbl_fgmapmode.enabled = false
					ddl_fgmapmode.enabled = false
					chk_fgskiprender.enabled = false
					lbl_fgmaptype.enabled = false
					ddl_fgmaptype.enabled = false
					spn_fgmapinterpolation.enabled = false
					lbl_fgmap.enabled = false
					edt_fgmapdir.enabled = false
					btn_fgmapdir.enabled = false
					btn_fgmapdelete.enabled = false

				)
				if rdo_gimode.state == 2 then
				(
					lbl_iblshadows.enabled = true
					spn_iblshadowquality.enabled = true
					lbl_iblshadowmode.enabled = true
					ddl_iblshadowmode.enabled = true
					sld_fgpreset.enabled = true
					lbl_fgpreset.enabled = true
					spn_diffusebounces.enabled = true
					ddl_fgpointprojection.enabled = true
					fgSegState()
					lbl_noisefiltering.enabled = true
					ddl_noisefiltering.enabled = true
					lbl_fgmapmode.enabled = true
					ddl_fgmapmode.enabled = true
					giMapModeState()
				)
				if rdo_gimode.state == 1 then
				(
					lbl_iblshadows.enabled = false
					spn_iblshadowquality.enabled = false
					lbl_iblshadowmode.enabled = false
					ddl_iblshadowmode.enabled = false
					sld_fgpreset.enabled = true
					lbl_fgpreset.enabled = true
					spn_diffusebounces.enabled = true
					ddl_fgpointprojection.enabled = true
					fgSegState()
					lbl_noisefiltering.enabled = true
					ddl_noisefiltering.enabled = true
					lbl_fgmapmode.enabled = true
					ddl_fgmapmode.enabled = true
					giMapModeState()
				)
			)
			
			
			
			on rdo_gimode changed state do
			(
				giModeState()
			)
			
			on btn_fgmapdir pressed do
			(
				
				if edt_fgmapdir.text == "" then
				(
					fgmap = getSaveFileName caption:"Save As" types:"Final Gather Maps (*.fgm) | *.fgm" filename:"$renderAssets"
					
					if fgmap != undefined then
					(
						fgmapdir = fgmap
						if (substring fgmapdir (fgmapdir.count - 3) 4) != ".fgm" then
						(
							fgmapdir += ".fgm"
						)
					)
					else
					(
						fgmapdir = edt_fgmapdir.text
					)
					
				)
				else
				(
					fgmap = getSaveFileName caption:"Save As" types:"Final Gather Maps (*.fgm) | *.fgm" filename:edt_fgmapdir.text
					
					if fgmap != undefined then
					(
						fgmapdir = fgmap
						if (substring fgmapdir (fgmapdir.count - 3) 4) != ".fgm" then
						(
							fgmapdir += ".fgm"
						)
					)
					else
					(
						fgmapdir = edt_fgmapdir.text
					)
				)
				
				if fgmapdir != undefined then
				(
					edt_fgmapdir.text = fgmapdir
				)
			)
			
			on btn_fgmapdelete pressed do
			(
				if edt_fgmapdir != "" do
				(
					if queryBox "Are you sure you want to delete the current Final Gather Map?" title:"Warning: Delete FG Map" beep: true do
					(
						deleteFile edt_fgmapdir.text
						edt_fgmapdir.text = ""
						renderSceneDialog.close()
						mr.FinalGatherFilename = ""
					)
				)
			)
			
				
				
			--- CONTROL BUTTONS ---
		
			button btn_get "Get" pos:[10,740] width:60 height:25 tooltip:"Get Current Scene Render Settings"
			button btn_low "Low" pos:[70,740] width:60 height:25 tooltip:"Low Quality Draft Renders"
			button btn_medium "Medium" pos:[10,765] width:60 height:25 tooltip:"Medium Quality (OK For Most Scenes)"
			button btn_high "High" pos:[70,765] width:60 height:25 tooltip:"High Quality (Lots Of Blurry Reflections / Refractions)"
			button btn_set "Set Render Parameters" pos:[140,740] width:250 height:50 tooltip:"Change Scene Render Settings"
			button btn_render "Local Render" pos:[400,740] width:120 height:25 tooltip:"Set Parameters and Render Frames Locally"
			button btn_netrender "Network Render" pos:[400,765] width:120 height:25 tooltip:"Set Parameters and Render Over Network (Submit to Backburner)"
			
			
			--- MAIN GET FUNCTION ---
			
			fn getParams =
			(
				renderSceneDialog.close()
				
				mr = renderers.current
				
				-- common params --
				
				spn_timestart.value = animationRange.start
				spn_timeend.value = animationRange.end
				spn_timefps.value = frameRate
				spn_renderwidth.value = renderWidth
				spn_renderheight.value = renderHeight
				rdo_renderrange.state = rendTimeType
				spn_rendernth.value = rendNthFrame
				spn_renderstart.value = rendStart
				spn_renderend.value = rendEnd
				edt_renderframes.text = rendPickupFrames
				chk_saverender.checked = rendSaveFile
				edt_renderdir.text = rendOutputFilename
				
				
				-- renderer / sampling --
				
				if mr.UnifiedEnable == true then
				(
					ddl_samplemode.selection = 1
				)
				else
				(
					if mr.ScanlineEnable == true then
					(
						ddl_samplemode.selection = 3
					)
					else
					(
						ddl_samplemode.selection = 2
					)
				)
				
				spn_uniquality.value = mr.UnifiedQuality
				spn_unimin.value = mr.UnifiedMinSamples 
				spn_unimax.value = mr.UnifiedMaxSamples
				
				ddl_classicsamplesmin.selection = mr.MinimumSamples + 4
				ddl_classicsamplesmax.selection = mr.MaximumSamples + 4
				
				spn_scanshading.value = mr.RapidShadingSamples
				ddl_scanvis.selection = mr.RapidCollectRate
				
				ddl_filtertype.selection = mr.filter + 1
				
				case ddl_filtertype.selection of
				(
					1: spn_filterwidth.value = mr.BoxFilterWidth
					2: spn_filterwidth.value = mr.GaussFilterWidth
					3: spn_filterwidth.value = mr.TriangleFilterWidth
					4: spn_filterwidth.value = mr.MitchellFilterWidth
					5: spn_filterwidth.value = mr.LanczosFilterWidth
				)
				
				case ddl_filtertype.selection of
				(
					1: spn_filterheight.value = mr.BoxFilterHeight
					2: spn_filterheight.value = mr.GaussFilterHeight
					3: spn_filterheight.value = mr.TriangleFilterHeight
					4: spn_filterheight.value = mr.MitchellFilterHeight
					5: spn_filterheight.value = mr.LanczosFilterHeight
				)
				
				spn_r.value = mr.RedSpatialContrast
				spn_g.value = mr.GreenSpatialContrast
				spn_b.value = mr.BlueSpatialContrast
				spn_a.value = mr.AlphaSpatialContrast
				
				chk_locksamples.checked = mr.LockSamples
				chk_jitter.checked = mr.Jitter
				ddl_fbtype.selection = mr.FrameBufferType + 1
				
				-- gi params --
				
				if mr.FinalGatherEnable2 == false then
				(
					rdo_gimode.state = 3
				)
				else
				(
					if mr.IBLEnable == true then
					(
						rdo_gimode.state = 2
					)
					else if mr.IBLEnable == false then
					(
						rdo_gimode.state = 1
					)
				)
				
				spn_iblshadowquality.value = mr.IBLQuality
				ddl_iblshadowmode.selection = mr.IBLShadows + 1
				
				local fgdensity = mr.FinalGatherDensity
				local fgrays = mr.FinalGatherAccuracy
				local fginterpolation = mr.FinalGatherInterpolationSamples
				
				if fgdensity == 0.1 and fgrays == 50 and fginterpolation == 30 then
				(
					sld_fgpreset.value = 1
					lbl_fgpreset.text = "Draft"
				)
				else if fgdensity == 0.4 and fgrays == 150 and fginterpolation == 30 then
				(
					sld_fgpreset.value = 2
					lbl_fgpreset.text = "Low"
				)
				else if fgdensity == 0.8 and fgrays == 250 and fginterpolation == 30 then
				(
					sld_fgpreset.value = 3
					lbl_fgpreset.text = "Medium"
				)
				else if fgdensity == 1.5 and fgrays == 500 and fginterpolation == 30 then
				(
					sld_fgpreset.value = 4
					lbl_fgpreset.text = "High"
				)
				else if fgdensity == 4 and fgrays == 10000 and fginterpolation == 100 then
				(
					sld_fgpreset.value = 5
					lbl_fgpreset.text = "Very High"
				)
				else
				(
					sld_fgpreset.value = 6
					lbl_fgpreset.text = "Custom"
				)
				
				spn_diffusebounces.value = mr.FinalGatherBounces
				ddl_fgpointprojection.selection = mr.FGProjectionMode + 1
				
				case mr.FGProjectionModeNumSegments of
				(
					1: ddl_fgnumsegs.selection = 1
					4: ddl_fgnumsegs.selection = 2
					9: ddl_fgnumsegs.selection = 3
					16: ddl_fgnumsegs.selection = 4
					25: ddl_fgnumsegs.selection = 5
					36: ddl_fgnumsegs.selection = 6
					49: ddl_fgnumsegs.selection = 7
					64: ddl_fgnumsegs.selection = 8
					81: ddl_fgnumsegs.selection = 9
					100: ddl_fgnumsegs.selection = 10
				)
				
				ddl_noisefiltering.selection = mr.FinalGatherFilter + 1
				
				if mr.UseFinalGatherFile == true then
				(
					if mr.FinalGatherFreeze == true then
					(
						ddl_fgmapmode.selection = 3
					)
					else if mr.FinalGatherFreeze == false then
					(
						ddl_fgmapmode.selection = 2
					)
				)
				else if mr.UseFinalGatherFile == false then
				(
					ddl_fgmapmode.selection = 1
				)
				
				chk_fgskiprender.checked = mr.SkipFinalRender
				ddl_fgmaptype.selection = mr.IlluminationCacheMode + 1
				spn_fgmapinterpolation.value = mr.FGInterpolateNFrames
				edt_fgmapdir.text = mr.FinalGatherFilename
			)

			on btn_get pressed do
			(
				getParams()
				
				-- states --
				
				renderRangeState()
				saveRenderState()
				samplingModeState()
				filterTypeState()
				giModeState()
			)
			
			fn setLow =
			(
				ddl_samplemode.selection = 1
				spn_uniquality.value = 0.25
				spn_unimin.value = 1.0
				spn_unimax.value = 32
				ddl_filtertype.selection = 1
				spn_filterwidth.value = 1.0
				spn_filterheight.value = 1.0
				spn_r.value = 0.1
				spn_g.value = 0.1
				spn_b.value = 0.1
				spn_a.value = 0.1
				ddl_fbtype.selection = 2
				rdo_gimode.state = 2
				spn_iblshadowquality.value = 0.25
				sld_fgpreset.value = 1
				lbl_fgpreset.text = "Draft"
				spn_diffusebounces.value = 0
			)
			
			on btn_low pressed do
			(
				setLow()
				
				-- states --
				
				QuickMR.renderRangeState()
				QuickMR.saveRenderState()
				QuickMR.samplingModeState()
				QuickMR.filterTypeState()
				QuickMR.giModeState()
				QuickMR.unitRefresh()
			)
			
			fn setMedium =
			(
				ddl_samplemode.selection = 1
				spn_uniquality.value = 0.75
				spn_unimin.value = 1.0
				spn_unimax.value = 128
				ddl_filtertype.selection = 2
				spn_filterwidth.value = 2.0
				spn_filterheight.value = 2.0
				spn_r.value = 0.051
				spn_g.value = 0.051
				spn_b.value = 0.051
				spn_a.value = 0.051
				ddl_fbtype.selection = 2
				rdo_gimode.state = 2
				spn_iblshadowquality.value = 0.75
				sld_fgpreset.value = 1
				lbl_fgpreset.text = "Draft"
				spn_diffusebounces.value = 2
			)
			
			on btn_medium pressed do
			(
				setMedium()
				
				-- states --
				
				QuickMR.renderRangeState()
				QuickMR.saveRenderState()
				QuickMR.samplingModeState()
				QuickMR.filterTypeState()
				QuickMR.giModeState()
				QuickMR.unitRefresh()
			)
			
			fn setHigh =
			(
				ddl_samplemode.selection = 1
				spn_uniquality.value = 1.5
				spn_unimin.value = 1.0
				spn_unimax.value = 128
				ddl_filtertype.selection = 2
				spn_filterwidth.value = 2.0
				spn_filterheight.value = 2.0
				spn_r.value = 0.01
				spn_g.value = 0.01
				spn_b.value = 0.01
				spn_a.value = 0.01
				ddl_fbtype.selection = 2
				rdo_gimode.state = 2
				spn_iblshadowquality.value = 1.5
				sld_fgpreset.value = 2
				lbl_fgpreset.text = "Low"
				spn_diffusebounces.value = 3
			)
			
			on btn_high pressed do
			(
				setHigh()
				
				-- states --
				
				QuickMR.renderRangeState()
				QuickMR.saveRenderState()
				QuickMR.samplingModeState()
				QuickMR.filterTypeState()
				QuickMR.giModeState()
				QuickMR.unitRefresh()
			)
			
			-- MAIN SET FUNCTION --
			
			fn setParams =
			(
				renderSceneDialog.close()
				
				-- Common Scene Params --
				
				frameRate = spn_timefps.value
				animationRange = interval spn_timestart.value spn_timeend.value
				renderWidth = spn_renderwidth.value 
				renderHeight = spn_renderheight.value
				rendTimeType = rdo_renderrange.state
				rendNthFrame = spn_rendernth.value
				rendStart = spn_renderstart.value
				rendEnd = spn_renderend.value
				rendPickupFrames = edt_renderframes.text
				rendSaveFile = chk_saverender.checked
				rendOutputFilename = edt_renderdir.text
				
				-- Renderer / Sampling Settings --
				
				fn setUnified =
				(
					mr.UnifiedEnable = true
					mr.ScanlineEnable = false
					mr.UnifiedQuality = spn_uniquality.value
					mr.UnifiedMinSamples = spn_unimin.value
					mr.UnifiedMaxSamples = spn_unimax.value
				)
				
				fn setClassic =
				(
					mr.UnifiedEnable = false
					mr.ScanlineEnable = false
					mr.MinimumSamples = (ddl_classicsamplesmin.selection - 4)
					mr.MaximumSamples  = (ddl_classicsamplesmax.selection  - 4)
				)
				
				fn setScanline =
				(
					mr.UnifiedEnable = false
					mr.ScanlineEnable = true
					mr.RapidShadingSamples = spn_scanshading.value
					mr.RapidCollectRate = ddl_scanvis.selection
					mr.UpdateUI()
					renderSceneDialog.Update()
				)
				
				case ddl_samplemode.selection of
				(
					1: setUnified()
					2: setClassic()
					3: setScanline()
					4: setClassic()
				)
				
				mr.filter = (ddl_filtertype.selection - 1)
				
				case ddl_filtertype.selection of
				(
					1: mr.BoxFilterWidth = spn_filterwidth.value
					2: mr.GaussFilterWidth = spn_filterwidth.value
					3: mr.TriangleFilterWidth = spn_filterwidth.value
					4: mr.MitchellFilterWidth = spn_filterwidth.value
					5: mr.LanczosFilterWidth = spn_filterwidth.value
				)
				
				case ddl_filtertype.selection of
				(
					1: mr.BoxFilterHeight = spn_filterheight.value
					2: mr.GaussFilterHeight = spn_filterheight.value
					3: mr.TriangleFilterHeight = spn_filterheight.value
					4: mr.MitchellFilterHeight = spn_filterheight.value
					5: mr.LanczosFilterHeight = spn_filterheight.value
				)
				
				mr.RedSpatialContrast = spn_r.value
				mr.GreenSpatialContrast = spn_g.value
				mr.BlueSpatialContrast = spn_b.value
				mr.AlphaSpatialContrast = spn_a.value
				
				mr.LockSamples = chk_locksamples.checked
				mr.Jitter = chk_jitter.checked
				mr.FrameBufferType = (ddl_fbtype.selection - 1)
				
				-- Global Illumination Settings --
				
				
				global setGI
				fn setGI =
				(
					mr.RestoreFinalGatherPreset sld_fgpreset.value
					mr.FinalGatherBounces = spn_diffusebounces.value
					mr.FGProjectionMode = (ddl_fgpointprojection.selection - 1)
					
					case ddl_fgnumsegs.selection of
					(
						1: mr.FGProjectionModeNumSegments = 1
						2: mr.FGProjectionModeNumSegments = 4
						3: mr.FGProjectionModeNumSegments = 9
						4: mr.FGProjectionModeNumSegments = 16
						5: mr.FGProjectionModeNumSegments = 25
						6: mr.FGProjectionModeNumSegments = 36
						7: mr.FGProjectionModeNumSegments = 49
						8: mr.FGProjectionModeNumSegments = 64
						9: mr.FGProjectionModeNumSegments = 81
						10: mr.FGProjectionModeNumSegments = 100
					)
					
					mr.FinalGatherFilter = (ddl_noisefiltering.selection - 1)
					
					-----------------------------------------
					
					case ddl_fgmapmode.selection of
					(
						1: mr.UseFinalGatherFile = false
						2: mr.UseFinalGatherFile = true
						3: mr.UseFinalGatherFile = true
					)
					
					case ddl_fgmapmode.selection of
					(
						1: mr.FinalGatherFreeze = false
						2: mr.FinalGatherFreeze = false
						3: mr.FinalGatherFreeze = true
					)
				
				mr.SkipFinalRender = chk_fgskiprender.checked
				mr.IlluminationCacheMode = (ddl_fgmaptype.selection - 1)
				mr.FGInterpolateNFrames = spn_fgmapinterpolation.value
				mr.FinalGatherFilename = edt_fgmapdir.text
				)
				
				fn setFG =
				(
					mr.IBLEnable = false
					mr.FinalGatherEnable2 = true
					setGI()
				)
				
				fn setIBL =
				(
					mr.IBLEnable = true
					mr.FinalGatherEnable2 = true
					mr.IBLQuality = spn_iblshadowquality.value
					mr.IBLShadows = (ddl_iblshadowmode.selection - 1)
					setGI()
				)
				
				fn setNoGI =
				(
					mr.IBLEnable = false
					mr.FinalGatherEnable2 = false
				)
				
				case rdo_gimode.state of
				(
					1: setFG()
					2: setIBL()
					3: setNoGI()
				)
			)
			
			on btn_set pressed do
			(
				setParams()
			)
			
			on btn_render pressed do
			(
				setParams()
				max quick render
			)
			
			on btn_netrender pressed do
			(
				setParams()
				macros.run "Render" "RenderButtonMenu_Submit_to_Network_Rendering"
			)
	)
		
		on execute do
		(
		if classof renderers.current != mental_ray_renderer then
		(
			if queryBox "The current renderer is not set to mental ray, would you like to do so now? QuickMR will only run with mental ray active." title:"Warning: Render Engine" beep: true do
			(	
				renderers.current = mental_ray_renderer()
				renderSceneDialog.close()
				createDialog QuickMR pos:[50,150]
				
				QuickMR.getParams()
						
				-- states --
				
				QuickMR.renderRangeState()
				QuickMR.saveRenderState()
				QuickMR.samplingModeState()
				QuickMR.filterTypeState()
				QuickMR.giModeState()
				QuickMR.unitRefresh()
			)
		)
		else
		(
			renderSceneDialog.close()
			createDialog QuickMR pos:[50,150]
			
			QuickMR.getParams()
					
			-- states --
			
			QuickMR.renderRangeState()
			QuickMR.saveRenderState()
			QuickMR.samplingModeState()
			QuickMR.filterTypeState()
			QuickMR.giModeState()
			QuickMR.unitRefresh()
		)
	)	
)
